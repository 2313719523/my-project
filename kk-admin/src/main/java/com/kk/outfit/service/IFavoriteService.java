package com.kk.outfit.service;

import com.kk.common.core.domain.AjaxResult;
import com.kk.outfit.domain.Outfit;
import java.util.List;

public interface IFavoriteService {
    public AjaxResult favorite(Long outfitId);
    public boolean hasUserFavorited(Long userId, Long outfitId);
    public int countFavorites(Long outfitId);
    public List<Outfit> selectMyFavorites();
}