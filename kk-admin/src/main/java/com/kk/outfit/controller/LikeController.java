package com.kk.outfit.controller;

import com.kk.common.core.controller.BaseController;
import com.kk.common.core.domain.AjaxResult;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.service.ILikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/outfit/like")
public class LikeController extends BaseController {

    @Autowired
    private ILikeService likeService;

    @PostMapping("/{outfitId}")
    public AjaxResult like(@PathVariable Long outfitId) {
        return likeService.like(outfitId);
    }

    @GetMapping("/check/{outfitId}")
    public AjaxResult checkLike(@PathVariable Long outfitId) {
        boolean liked = likeService.hasUserLiked(SecurityUtils.getUserId(), outfitId);
        return AjaxResult.success(liked);
    }

    @GetMapping("/count/{outfitId}")
    public AjaxResult count(@PathVariable Long outfitId) {
        return AjaxResult.success(likeService.countLikes(outfitId));
    }
}