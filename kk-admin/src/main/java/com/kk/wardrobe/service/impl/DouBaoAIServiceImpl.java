package com.kk.wardrobe.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.kk.wardrobe.dto.AiRecommendRequest;
import com.kk.wardrobe.dto.AiRecommendResponse;
import com.kk.wardrobe.service.AiRecommendService;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@Service("douBaoAIService")
public class DouBaoAIServiceImpl implements AiRecommendService {

    private static final String API_URL = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
    private static final String API_KEY = "47d609d1-0fd9-41c4-baaf-e702e8e07dba";
    private static final String MODEL = "doubao-seed-1-6-251015";

    private final OkHttpClient client;
    private final AiRecommendService localRuleService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public DouBaoAIServiceImpl(@Qualifier("localRuleService") AiRecommendService localRuleService) {
        this.localRuleService = localRuleService;
        this.client = new OkHttpClient.Builder()
                .connectTimeout(60, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(60, TimeUnit.SECONDS)
                .build();
    }

    @Override
    public AiRecommendResponse getOutfitRecommendation(AiRecommendRequest request) {
        log.info("【豆包AI】开始处理推荐请求: {}", request);
        int maxRetries = 3;
        AtomicInteger retryCount = new AtomicInteger(0);

        while (retryCount.get() < maxRetries) {
            try {
                String prompt = buildPrompt(request);
                String aiResponseText = callDouBaoAPI(prompt, retryCount.get() + 1);
                // 执行解析并进行多级图片匹配
                AiRecommendResponse response = parseAndMatchImages(aiResponseText);
                return response;
            } catch (Exception e) {
                retryCount.incrementAndGet();
                log.warn("【豆包AI】尝试第{}次失败: {}", retryCount.get(), e.getMessage());
                if (retryCount.get() >= maxRetries) {
                    return localRuleService.getOutfitRecommendation(request);
                }
            }
        }
        return localRuleService.getOutfitRecommendation(request);
    }

    private String buildPrompt(AiRecommendRequest request) {
        return "你是一位专业的穿搭顾问。请返回JSON格式，包含字段：recommendation, reason, styleTips, temperatureAdvice, items(含name, type, color)。" +
                "注意：type务必从[T恤, 衬衫, 短裤, 开衫, 半身裙, 连衣裙, 玛丽珍, 牛奶裤, 皮鞋, 卫衣, 西装裤, 运动背心, 运动鞋]中选择。" +
                "用户需求：场合-" + request.getOccasion() + "，温度-" + request.getTemperature() + "℃。";
    }

    private String callDouBaoAPI(String prompt, int attempt) throws IOException {
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", MODEL);
        JSONArray messages = new JSONArray();
        JSONObject msg = new JSONObject();
        msg.put("role", "user");
        msg.put("content", prompt);
        messages.add(msg);
        requestBody.put("messages", messages);

        RequestBody body = RequestBody.create(MediaType.parse("application/json"), requestBody.toJSONString());
        Request apiReq = new Request.Builder()
                .url(API_URL)
                .header("Authorization", "Bearer " + API_KEY)
                .post(body)
                .build();

        try (Response response = client.newCall(apiReq).execute()) {
            if (!response.isSuccessful()) throw new IOException("API Error " + response.code());
            JSONObject resJson = JSON.parseObject(response.body().string());
            return resJson.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");
        }
    }

    private AiRecommendResponse parseAndMatchImages(String aiResponseText) {
        String cleanJson = aiResponseText.replace("```json", "").replace("```", "").trim();
        JSONObject json = JSON.parseObject(cleanJson);

        AiRecommendResponse response = new AiRecommendResponse();
        response.setRecommendation(json.getString("recommendation"));
        response.setReason(json.getString("reason"));
        response.setStyleTips(json.getString("styleTips"));
        response.setTemperatureAdvice(json.getString("temperatureAdvice"));

        JSONArray itemsArray = json.getJSONArray("items");
        List<AiRecommendResponse.ClothingItem> clothingItems = new ArrayList<>();

        if (itemsArray != null) {
            for (int i = 0; i < itemsArray.size(); i++) {
                JSONObject obj = itemsArray.getJSONObject(i);
                AiRecommendResponse.ClothingItem item = new AiRecommendResponse.ClothingItem();
                item.setName(obj.getString("name"));
                item.setType(obj.getString("type"));
                item.setColor(obj.getString("color"));

                // --- 核心改动：调用修正了字段名(category)和查询方式(queryForList)的方法 ---
                item.setMaterial(getWardrobeImage(item.getType(), item.getColor()));

                clothingItems.add(item);
            }
        }
        response.setItems(clothingItems);
        return response;
    }

    /**
     * 智能搜图算法：确保使用真实的 category 字段
     */
    private String getWardrobeImage(String type, String color) {
        String defaultPath = "/profile/upload/default.png";
        try {
            // 提取颜色核心字
            String colorKey = (color != null && color.length() > 0) ? color.substring(0, 1) : "";

            // 1. 第一级：精准匹配 (category + color)
            String sql1 = "SELECT img_url FROM sys_wardrobe_item WHERE category = ? AND color LIKE ? LIMIT 1";
            List<String> list1 = jdbcTemplate.queryForList(sql1, String.class, type, "%" + colorKey + "%");
            if (!list1.isEmpty()) return list1.get(0);

            // 2. 第二级：降级匹配 (仅 category)
            String sql2 = "SELECT img_url FROM sys_wardrobe_item WHERE category = ? LIMIT 1";
            List<String> list2 = jdbcTemplate.queryForList(sql2, String.class, type);
            if (!list2.isEmpty()) return list2.get(0);

            // 3. 第三级：保底模糊匹配 (name 包含 AI 给的关键词)
            String sql3 = "SELECT img_url FROM sys_wardrobe_item WHERE name LIKE ? LIMIT 1";
            List<String> list3 = jdbcTemplate.queryForList(sql3, String.class, "%" + type + "%");
            if (!list3.isEmpty()) return list3.get(0);

        } catch (Exception e) {
            log.error("匹配图片异常: {}", e.getMessage());
        }
        return defaultPath;
    }
}