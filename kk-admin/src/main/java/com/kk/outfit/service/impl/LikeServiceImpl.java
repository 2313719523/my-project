package com.kk.outfit.service.impl;

import com.kk.common.core.domain.AjaxResult;
import com.kk.common.utils.SecurityUtils;
import com.kk.outfit.domain.Like;
import com.kk.outfit.domain.Outfit;
import com.kk.outfit.mapper.LikeMapper;
import com.kk.outfit.mapper.OutfitMapper;
import com.kk.outfit.service.ILikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LikeServiceImpl implements ILikeService {

    @Autowired
    private LikeMapper likeMapper;

    @Autowired
    private OutfitMapper outfitMapper;

    @Override
    @Transactional
    public AjaxResult like(Long outfitId) {
        Long userId = SecurityUtils.getUserId();

        Like existingLike = likeMapper.selectLikeByUserIdAndOutfitId(userId, outfitId);

        if (existingLike != null) {
            likeMapper.deleteLike(userId, outfitId);

            Outfit outfit = outfitMapper.selectOutfitByOutfitId(outfitId);
            outfit.setLikeCount(outfit.getLikeCount() - 1);
            outfitMapper.updateOutfit(outfit);

            return AjaxResult.success("取消点赞成功");
        } else {
            Like like = new Like();
            like.setUserId(userId);
            like.setOutfitId(outfitId);
            likeMapper.insertLike(like);

            Outfit outfit = outfitMapper.selectOutfitByOutfitId(outfitId);
            outfit.setLikeCount(outfit.getLikeCount() + 1);
            outfitMapper.updateOutfit(outfit);

            return AjaxResult.success("点赞成功");
        }
    }

    @Override
    public boolean hasUserLiked(Long userId, Long outfitId) {
        return likeMapper.selectLikeByUserIdAndOutfitId(userId, outfitId) != null;
    }

    @Override
    public int countLikes(Long outfitId) {
        return likeMapper.countLikeByOutfitId(outfitId);
    }
}