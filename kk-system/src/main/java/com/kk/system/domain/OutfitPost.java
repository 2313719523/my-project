package com.kk.system.domain;

import com.kk.common.core.domain.BaseEntity;
import lombok.Data;

/**
 * 穿搭方案对象 outfit_post
 */
@Data
public class OutfitPost extends BaseEntity {
    private Long id;                // id
    private String title;           // 标题
    private String content;         // 内容
    private String image;           // 图片
    private String tags;            // 标签
    private Long userId;            // user_id
    private String username;        // username
    private String avatar;          // 头像
    private Integer likeCount;      // 点赞数
    private Integer commentCount;   // 评论数
    private Integer collectCount;   // 收藏数
    private String category;        // 分类
    private String status;          // 状态：0待审核 1通过 2违规
}