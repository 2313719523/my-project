package com.kk.wardrobe.dto;

import lombok.Data;
import java.util.List;

@Data
public class AiRecommendResponse {
    // 推荐结果
    private String recommendation;
    // 推荐理由
    private String reason;
    // 单品列表
    private List<ClothingItem> items;
    // 风格建议
    private String styleTips;
    // 温度适配说明
    private String temperatureAdvice;

    @Data
    public static class ClothingItem {
        private String name;
        private String type;
        private String color;
        private String material;
        private String brandSuggest;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getColor() {
            return color;
        }

        public void setColor(String color) {
            this.color = color;
        }

        public String getMaterial() {
            return material;
        }

        public void setMaterial(String material) {
            this.material = material;
        }

        public String getBrandSuggest() {
            return brandSuggest;
        }

        public void setBrandSuggest(String brandSuggest) {
            this.brandSuggest = brandSuggest;
        }
    }
}