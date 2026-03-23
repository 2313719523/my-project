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
    private JdbcTemplate jdbcTemplate; // 注入数据库操作类，用于匹配图片

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
                // 核心改动：解析的同时去数据库找图
                AiRecommendResponse response = parseAndMatchImages(aiResponseText);
                log.info("【豆包AI】推荐及图片匹配成功");
                return response;
            } catch (IOException e) {
                retryCount.incrementAndGet();
                log.warn("【豆包AI】第{}次调用失败: {}", retryCount.get(), e.getMessage());
                if (retryCount.get() >= maxRetries) {
                    return localRuleService.getOutfitRecommendation(request);
                }
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    return localRuleService.getOutfitRecommendation(request);
                }
            } catch (Exception e) {
                log.error("【豆包AI】逻辑执行异常，降级处理", e);
                return localRuleService.getOutfitRecommendation(request);
            }
        }
        return localRuleService.getOutfitRecommendation(request);
    }

    private String buildPrompt(AiRecommendRequest request) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("你是一位专业的穿搭顾问。请为用户推荐穿搭方案。\n");
        prompt.append("要求：必须返回JSON格式。包含字段：recommendation(总评), reason(理由), styleTips(技巧), temperatureAdvice(温度建议), ");
        prompt.append("items(单品列表，每个单品含name, type, color)。\n");
        prompt.append("注意：type字段请务必从以下词汇中选择：T恤, 衬衫, 短裤, 开衫, 半身裙, 连衣裙, 玛丽珍, 牛奶裤, 皮鞋, 卫衣, 西装裤, 运动背心, 运动鞋。\n");
        prompt.append("用户情况：场合-").append(request.getOccasion()).append("，温度-").append(request.getTemperature()).append("℃。");
        return prompt.toString();
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
        // 去掉可能存在的Markdown格式
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

                // --- 毕设亮点：去数据库检索图片路径 ---
                String sql = "SELECT img_url FROM sys_wardrobe_item WHERE category = ? AND color LIKE ? LIMIT 1";
                try {
                    // 1. 获取 AI 返回的颜色，并做非空处理
                    String color = item.getColor() != null ? item.getColor() : "";

                    // 2. 取颜色的关键字进行模糊查询（比如“深蓝色”取“蓝”，“白色”取“白”）
                    // 建议取 1 到 2 个字，这样匹配率最高
                    String colorKey = color.length() >= 1 ? color.substring(0, Math.min(2, color.length())) : "";

                    // 3. 执行 SQL 查询
                    // 注意：这里的 sql 应该是 SELECT img_url FROM sys_wardrobe_item WHERE category = ? AND color LIKE ? LIMIT 1
                    String dbImgUrl = jdbcTemplate.queryForObject(sql, String.class, item.getType(), "%" + colorKey + "%");

                    // 4. 直接设置路径（因为你数据库里已经存了 /profile/upload/T恤1.jpg）
                    item.setMaterial(dbImgUrl);

                    log.info("成功匹配图片: 类别={}, 颜色={}, 路径={}", item.getType(), color, dbImgUrl);
                } catch (Exception e) {
                    // 如果数据库没搜到，或者报错了，给一个默认图，防止前端图片碎裂
                    log.warn("未能匹配到图片: 类别={}, 颜色={}", item.getType(), item.getColor());
                    item.setMaterial("/profile/upload/default.png");
                }
                clothingItems.add(item);
            }
        }
        response.setItems(clothingItems);
        return response;
    }
}