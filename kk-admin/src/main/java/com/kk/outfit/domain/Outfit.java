package com.kk.outfit.domain;

import com.kk.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class Outfit extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long outfitId;    // 对应数据库 id
    private Long userId;      // 对应数据库 user_id
    private String title;     // 标题
    private String description; // 对应数据库 content
    private String images;    // 对应数据库 image
    private String styleTag;
    private String sceneTag;
    private Long viewCount;
    private Long likeCount;    // 点赞数（必须保留）
    private Long collectCount; // 收藏数（必须保留）
    private String status;     // 状态
    private String delFlag;
    private String category;

    // 新增字段：用户名和头像
    private String userName;
    private String avatar;

    // ========== 原有 getter/setter ==========
    public void setOutfitId(Long outfitId) { this.outfitId = outfitId; }
    public Long getOutfitId() { return outfitId; }

    public void setUserId(Long userId) { this.userId = userId; }
    public Long getUserId() { return userId; }

    public void setTitle(String title) { this.title = title; }
    public String getTitle() { return title; }

    public void setDescription(String description) { this.description = description; }
    public String getDescription() { return description; }

    public void setImages(String images) { this.images = images; }
    public String getImages() { return images; }

    public void setViewCount(Long viewCount) { this.viewCount = viewCount; }
    public Long getViewCount() { return viewCount; }

    public void setLikeCount(Long likeCount) { this.likeCount = likeCount; }
    public Long getLikeCount() { return likeCount; }

    public void setCollectCount(Long collectCount) { this.collectCount = collectCount; }
    public Long getCollectCount() { return collectCount; }

    public void setStatus(String status) { this.status = status; }
    public String getStatus() { return status; }

    public void setStyleTag(String styleTag) { this.styleTag = styleTag; }
    public String getStyleTag() { return styleTag; }

    public void setSceneTag(String sceneTag) { this.sceneTag = sceneTag; }
    public String getSceneTag() { return sceneTag; }

    // ========== 新增 getter/setter ==========
    public void setUserName(String userName) { this.userName = userName; }
    public String getUserName() { return userName; }

    public void setAvatar(String avatar) { this.avatar = avatar; }
    public String getAvatar() { return avatar; }
    public void setCategory(String category) { this.category = category; }
    public String getCategory() { return category; }
    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
                .append("outfitId", getOutfitId())
                .append("title", getTitle())
                .toString();
    }
}