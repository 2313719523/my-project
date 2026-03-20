package com.kk.wardrobe.controller;

import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.wardrobe.dto.AiRecommendRequest;
import com.kk.wardrobe.dto.AiRecommendResponse;
import com.kk.wardrobe.service.impl.DouBaoAIServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/wardrobe/recommend")
public class AiRecommendController extends BaseController {

    @Autowired
    private DouBaoAIServiceImpl douBaoAIService;

    /**
     * 获取AI穿搭推荐
     */
    @PostMapping("/ai")
    public AjaxResult getAiRecommendation(@RequestBody AiRecommendRequest request) {
        try {
            // 参数验证
            if (request.getOccasion() == null || request.getAge() == null ||
                    request.getBodyType() == null || request.getTemperature() == null) {
                return AjaxResult.error("缺少必要参数");
            }

            // 调用AI服务
            AiRecommendResponse response = douBaoAIService.getOutfitRecommendation(request);

            return AjaxResult.success("推荐成功", response);

        } catch (Exception e) {
            logger.error("获取AI推荐失败", e);
            return AjaxResult.error("推荐失败：" + e.getMessage());
        }
    }

    /**
     * 获取推荐历史（简化版）
     */
    @GetMapping("/history")
    public AjaxResult getRecommendHistory() {
        return AjaxResult.success("获取成功", "推荐历史功能待实现");
    }
}