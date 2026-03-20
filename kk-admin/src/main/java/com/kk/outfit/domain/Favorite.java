package com.kk.outfit.domain;

import com.kk.common.core.domain.BaseEntity;

public class Favorite extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long favoriteId;
    private Long userId;
    private Long outfitId;

    public Long getFavoriteId() { return favoriteId; }
    public void setFavoriteId(Long favoriteId) { this.favoriteId = favoriteId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getOutfitId() { return outfitId; }
    public void setOutfitId(Long outfitId) { this.outfitId = outfitId; }
}