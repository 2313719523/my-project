package com.kk.outfit.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.kk.common.annotation.Excel;
import com.kk.common.core.domain.BaseEntity;

/**
 * 穿搭主对象 outfit
 * 
 * @author kk
 * @date 2026-01-27
 */
public class Outfit extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 穿搭ID */
    private Long outfitId;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 穿搭标题 */
    @Excel(name = "穿搭标题")
    private String title;

    /** 穿搭描述 */
    @Excel(name = "穿搭描述")
    private String description;

    /** 风格标签 */
    @Excel(name = "风格标签")
    private String styleTag;

    /** 场景标签 */
    @Excel(name = "场景标签")
    private String sceneTag;

    /** 图片JSON数组 */
    @Excel(name = "图片JSON数组")
    private String images;

    /** 浏览数 */
    @Excel(name = "浏览数")
    private Long viewCount;

    /** 点赞数 */
    @Excel(name = "点赞数")
    private Long likeCount;

    /** 收藏数 */
    @Excel(name = "收藏数")
    private Long collectCount;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 删除标志 */
    private String delFlag;

    public void setOutfitId(Long outfitId) 
    {
        this.outfitId = outfitId;
    }

    public Long getOutfitId() 
    {
        return outfitId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setTitle(String title) 
    {
        this.title = title;
    }

    public String getTitle() 
    {
        return title;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setStyleTag(String styleTag) 
    {
        this.styleTag = styleTag;
    }

    public String getStyleTag() 
    {
        return styleTag;
    }

    public void setSceneTag(String sceneTag) 
    {
        this.sceneTag = sceneTag;
    }

    public String getSceneTag() 
    {
        return sceneTag;
    }

    public void setImages(String images) 
    {
        this.images = images;
    }

    public String getImages() 
    {
        return images;
    }

    public void setViewCount(Long viewCount) 
    {
        this.viewCount = viewCount;
    }

    public Long getViewCount() 
    {
        return viewCount;
    }

    public void setLikeCount(Long likeCount) 
    {
        this.likeCount = likeCount;
    }

    public Long getLikeCount() 
    {
        return likeCount;
    }

    public void setCollectCount(Long collectCount) 
    {
        this.collectCount = collectCount;
    }

    public Long getCollectCount() 
    {
        return collectCount;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setDelFlag(String delFlag) 
    {
        this.delFlag = delFlag;
    }

    public String getDelFlag() 
    {
        return delFlag;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("outfitId", getOutfitId())
            .append("userId", getUserId())
            .append("title", getTitle())
            .append("description", getDescription())
            .append("styleTag", getStyleTag())
            .append("sceneTag", getSceneTag())
            .append("images", getImages())
            .append("viewCount", getViewCount())
            .append("likeCount", getLikeCount())
            .append("collectCount", getCollectCount())
            .append("status", getStatus())
            .append("delFlag", getDelFlag())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
