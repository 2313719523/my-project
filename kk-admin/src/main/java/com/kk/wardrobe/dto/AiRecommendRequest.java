package com.kk.wardrobe.dto;

import lombok.Data;

@Data
public class AiRecommendRequest {
    // 场合
    private String occasion;
    // 年龄
    private Integer age;
    // 身材类型
    private String bodyType;
    // 温度
    private Integer temperature;
    // 性别（可选）
    private String gender = "女性";
    // 风格偏好（可选）
    private String stylePreference;
    // 预算范围（可选）
    private String budget;
    // 身高（可选）
    private Integer height;
    // 体重（可选）
    private Integer weight;
    // 尺码偏好（可选）
    private String sizePreference;


}