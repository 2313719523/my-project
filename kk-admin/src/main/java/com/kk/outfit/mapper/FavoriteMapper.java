package com.kk.outfit.mapper;

import com.kk.outfit.domain.Favorite;
import com.kk.outfit.domain.Outfit;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface FavoriteMapper {
    public Favorite selectFavoriteByUserIdAndOutfitId(@Param("userId") Long userId, @Param("outfitId") Long outfitId);
    public int insertFavorite(Favorite favorite);
    public int deleteFavorite(@Param("userId") Long userId, @Param("outfitId") Long outfitId);
    public int countFavoriteByOutfitId(Long outfitId);
    public List<Outfit> selectFavoriteOutfitsByUserId(Long userId);
}