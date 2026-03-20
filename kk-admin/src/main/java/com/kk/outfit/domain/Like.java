package com.kk.outfit.domain;

import com.kk.common.core.domain.BaseEntity;

public class Like extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long likeId;
    private Long userId;
    private Long outfitId;

    public Long getLikeId() { return likeId; }
    public void setLikeId(Long likeId) { this.likeId = likeId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getOutfitId() { return outfitId; }
    public void setOutfitId(Long outfitId) { this.outfitId = outfitId; }
}