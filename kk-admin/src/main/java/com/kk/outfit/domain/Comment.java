package com.kk.outfit.domain;

import com.kk.common.core.domain.BaseEntity;

public class Comment extends BaseEntity {
    private static final long serialVersionUID = 1L;

    private Long commentId;
    private Long userId;
    private Long outfitId;
    private Long parentId;
    private String content;
    private String userName;
    private String parentUserName;

    public Long getCommentId() { return commentId; }
    public void setCommentId(Long commentId) { this.commentId = commentId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getOutfitId() { return outfitId; }
    public void setOutfitId(Long outfitId) { this.outfitId = outfitId; }
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getParentUserName() { return parentUserName; }
    public void setParentUserName(String parentUserName) { this.parentUserName = parentUserName; }
}