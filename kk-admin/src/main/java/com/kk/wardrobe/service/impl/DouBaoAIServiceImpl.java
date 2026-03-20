package com.kk.wardrobe.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.kk.wardrobe.dto.AiRecommendRequest;
import com.kk.wardrobe.dto.AiRecommendResponse;
import com.kk.wardrobe.service.AiRecommendService;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.io.IOException;
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

    public DouBaoAIServiceImpl(@Qualifier("localRuleService") AiRecommendService localRuleService) {
        this.localRuleService = localRuleService;
        this.client = new OkHttpClient.Builder()
                .connectTimeout(11000, TimeUnit.SECONDS)
                .readTimeout(2000, TimeUnit.SECONDS)
                .writeTimeout(1000, TimeUnit.SECONDS)
                .callTimeout(3000, TimeUnit.SECONDS)
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
                AiRecommendResponse response = parseAIResponse(aiResponseText);
                log.info("【豆包AI】推荐生成成功");
                return response;
            } catch (IOException e) {
                retryCount.incrementAndGet();
                log.warn("【豆包AI】第{}次调用失败: {}", retryCount.get(), e.getMessage());

                if (retryCount.get() >= maxRetries) {
                    log.error("【豆包AI】已达最大重试次数({})，降级使用本地规则", maxRetries);
                    return localRuleService.getOutfitRecommendation(request);
                }

                try {
                    long waitTime = (long) Math.pow(2, retryCount.get() - 1) * 1000;
                    log.info("等待{}ms后重试...", waitTime);
                    Thread.sleep(waitTime);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    return localRuleService.getOutfitRecommendation(request);
                }
            } catch (Exception e) {
                log.error("【豆包AI】调用失败，降级使用本地规则", e);
                return localRuleService.getOutfitRecommendation(request);
            }
        }

        return localRuleService.getOutfitRecommendation(request);
    }

    private String buildPrompt(AiRecommendRequest request) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("你是一位专业的穿搭顾问，请为用户提供穿搭推荐。\n\n");
        prompt.append("【用户需求】\n");
        prompt.append("场合：").append(request.getOccasion()).append("\n");
        prompt.append("年龄：").append(request.getAge()).append("岁\n");
        prompt.append("身材：").append(request.getBodyType()).append("\n");
        prompt.append("温度：").append(request.getTemperature()).append("℃\n");
        prompt.append("性别：").append(request.getGender()).append("\n");

        if (request.getStylePreference() != null) {
            prompt.append("风格偏好：").append(request.getStylePreference()).append("\n");
        } else {
            prompt.append("风格偏好：无\n");
        }

        if (request.getBudget() != null) {
            prompt.append("预算：").append(request.getBudget()).append("\n");
        } else {
            prompt.append("预算：无\n");
        }

        if (request.getHeight() != null) {
            prompt.append("身高：").append(request.getHeight()).append("cm\n");
        } else {
            prompt.append("身高：未指定\n");
        }

        if (request.getWeight() != null) {
            prompt.append("体重：").append(request.getWeight()).append("kg\n");
        } else {
            prompt.append("体重：未指定\n");
        }

        if (request.getSizePreference() != null) {
            prompt.append("尺码偏好：").append(request.getSizePreference()).append("\n");
        } else {
            prompt.append("尺码偏好：无\n");
        }

        prompt.append("\n【输出要求】\n");
        prompt.append("1. 推荐一套完整的穿搭方案（上衣、下装、外套、鞋子、配饰）\n");
        prompt.append("2. 说明推荐理由\n");
        prompt.append("3. 提供风格建议\n");
        prompt.append("4. 考虑温度适配性\n\n");
        prompt.append("请以JSON格式返回，包含以下字段：\n");
        prompt.append("- recommendation: 推荐方案（字符串）\n");
        prompt.append("- reason: 推荐理由（字符串）\n");
        prompt.append("- styleTips: 风格建议（字符串）\n");
        prompt.append("- temperatureAdvice: 温度适配说明（字符串）");

        return prompt.toString();
    }

    private String callDouBaoAPI(String prompt, int attempt) throws IOException {
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", MODEL);

        JSONArray messagesArray = new JSONArray();
        JSONObject messageObj = new JSONObject();
        messageObj.put("role", "user");
        messageObj.put("content", prompt);
        messagesArray.add(messageObj);

        requestBody.put("messages", messagesArray);
        requestBody.put("stream", false);
        requestBody.put("max_tokens", 1000);
        requestBody.put("temperature", 0.7);

        log.info("【豆包AI】第{}次尝试调用API", attempt);

        RequestBody body = RequestBody.create(
                MediaType.parse("application/json; charset=utf-8"),
                requestBody.toJSONString()
        );

        Request request = new Request.Builder()
                .url(API_URL)
                .header("Authorization", "Bearer " + API_KEY)
                .header("Content-Type", "application/json")
                .post(body)
                .build();

        Response response = null;
        try {
            long startTime = System.currentTimeMillis();
            log.info("【豆包AI】第{}次调用开始...", attempt);

            response = client.newCall(request).execute();
            long endTime = System.currentTimeMillis();

            log.info("【豆包AI】第{}次调用完成，耗时: {}ms, 状态码: {}",
                    attempt, (endTime - startTime), response.code());

            if (!response.isSuccessful()) {
                String errorBody = "";
                if (response.body() != null) {
                    errorBody = response.body().string();
                }
                log.error("【豆包AI】API调用失败，状态码: {}", response.code());
                throw new IOException("API调用失败，状态码: " + response.code());
            }

            String responseBody = "";
            if (response.body() != null) {
                responseBody = response.body().string();
            }

            log.debug("【豆包AI】原始响应长度: {} chars", responseBody.length());

            JSONObject jsonResponse = JSON.parseObject(responseBody);
            if (jsonResponse.containsKey("choices")) {
                String content = jsonResponse.getJSONArray("choices")
                        .getJSONObject(0)
                        .getJSONObject("message")
                        .getString("content");
                log.info("【豆包AI】解析成功，内容长度: {} chars", content.length());
                return content;
            } else {
                log.error("【豆包AI】响应格式异常");
                throw new IOException("API返回格式异常");
            }
        } catch (IOException e) {
            log.error("【豆包AI】第{}次调用异常: {}", attempt, e.getMessage());
            throw e;
        } finally {
            if (response != null && response.body() != null) {
                response.body().close();
            }
        }
    }

    private AiRecommendResponse parseAIResponse(String aiResponseText) {
        try {
            JSONObject json = JSON.parseObject(aiResponseText);
            AiRecommendResponse response = new AiRecommendResponse();

            response.setRecommendation(json.getString("recommendation"));
            response.setReason(json.getString("reason"));
            response.setStyleTips(json.getString("styleTips"));
            response.setTemperatureAdvice(json.getString("temperatureAdvice"));

            return response;
        } catch (Exception e) {
            log.warn("AI返回非标准JSON，按文本处理");

            AiRecommendResponse response = new AiRecommendResponse();
            response.setRecommendation(aiResponseText);
            response.setReason("基于AI智能生成的个性化穿搭建议");
            response.setStyleTips("简约时尚，适合日常穿着");
            response.setTemperatureAdvice("根据当前温度调整衣物厚度");

            return response;
        }
    }
}