package com.kk.outfit.service.impl;

import com.kk.common.core.domain.AjaxResult;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Favorite;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.mapper.FavoriteMapper;
import com.kk.outfit.mapper.OutfitMapper;
import com.kk.outfit.service.IFavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FavoriteServiceImpl implements IFavoriteService {

    @Autowired
    private FavoriteMapper favoriteMapper;

    @Autowired
    private OutfitMapper outfitMapper;

    @Override
    @Transactional
    public AjaxResult favorite(Long outfitId) {
        Long userId = SecurityUtils.getUserId();

        Favorite existingFavorite = favoriteMapper.selectFavoriteByUserIdAndOutfitId(userId, outfitId);

        if (existingFavorite != null) {
            favoriteMapper.deleteFavorite(userId, outfitId);

            Outfit outfit = outfitMapper.selectOutfitByOutfitId(outfitId);
            outfit.setCollectCount(outfit.getCollectCount() - 1);
            outfitMapper.updateOutfit(outfit);

            return AjaxResult.success("取消收藏成功");
        } else {
            Favorite favorite = new Favorite();
            favorite.setUserId(userId);
            favorite.setOutfitId(outfitId);
            favoriteMapper.insertFavorite(favorite);

            Outfit outfit = outfitMapper.selectOutfitByOutfitId(outfitId);
            outfit.setCollectCount(outfit.getCollectCount() + 1);
            outfitMapper.updateOutfit(outfit);

            return AjaxResult.success("收藏成功");
        }
    }

    @Override
    public boolean hasUserFavorited(Long userId, Long outfitId) {
        return favoriteMapper.selectFavoriteByUserIdAndOutfitId(userId, outfitId) != null;
    }

    @Override
    public int countFavorites(Long outfitId) {
        return favoriteMapper.countFavoriteByOutfitId(outfitId);
    }

    @Override
    public List<Outfit> selectMyFavorites() {
        Long userId = SecurityUtils.getUserId();
        return favoriteMapper.selectFavoriteOutfitsByUserId(userId);
    }
}