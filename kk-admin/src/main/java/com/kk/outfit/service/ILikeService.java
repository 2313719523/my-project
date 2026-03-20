package com.kk.outfit.service;

import com.kk.common.core.domain.AjaxResult;

public interface ILikeService {
    public AjaxResult like(Long outfitId);
    public boolean hasUserLiked(Long userId, Long outfitId);
    public int countLikes(Long outfitId);
}