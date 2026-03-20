package com.kk.wardrobe.service;

import com.kk.wardrobe.dto.AiRecommendRequest;
import com.kk.wardrobe.dto.AiRecommendResponse;

public interface AiRecommendService {
    AiRecommendResponse getOutfitRecommendation(AiRecommendRequest request);
    // 新增的流式方法
    //void getOutfitRecommendationStream(AiRecommendRequest request, SseEmitter emitter);
}