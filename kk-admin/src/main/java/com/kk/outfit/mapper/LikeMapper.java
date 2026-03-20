package com.kk.outfit.mapper;

import com.kk.outfit.domain.Like;
import org.apache.ibatis.annotations.Param;

public interface LikeMapper {
    public Like selectLikeByUserIdAndOutfitId(@Param("userId") Long userId, @Param("outfitId") Long outfitId);
    public int insertLike(Like like);
    public int deleteLike(@Param("userId") Long userId, @Param("outfitId") Long outfitId);
    public int countLikeByOutfitId(Long outfitId);
}