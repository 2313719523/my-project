package com.kk.outfit_api.controller;

import com.kk.common.core.domain.AjaxResult;
import com.kk.outfit.service.IOutfitService;
import com.kk.system.domain.OutfitConfig;
import com.kk.system.mapper.OutfitConfigMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * 穿搭系统一体化API接口
 * 包含：帖子、评论、点赞、收藏全部功能
 */
@RestController
@RequestMapping("/outfit-api")
public class OutfitApiController {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private IOutfitService outfitService;
    @Autowired
    private OutfitConfigMapper outfitConfigMapper;

    // ==================== 帖子相关接口 ====================

    /**
     * 获取帖子列表（支持分类筛选）
     */
    @GetMapping("/posts")
    public Map<String, Object> getPosts(@RequestParam(required = false) String category,
                                        @RequestParam(defaultValue = "1") Integer pageNum,
                                        @RequestParam(defaultValue = "20") Integer pageSize) {
        Map<String, Object> result = new HashMap<>();
        try {
            StringBuilder sql = new StringBuilder();
            List<Object> params = new ArrayList<>();

            sql.append("SELECT * FROM outfit_post WHERE status = '0'");

            if (category != null && !category.isEmpty() && !"recommend".equals(category)) {
                sql.append(" AND category = ?");
                params.add(category);
            }

            sql.append(" ORDER BY create_time DESC");

            // 分页查询
            sql.append(" LIMIT ? OFFSET ?");
            params.add(pageSize);
            params.add((pageNum - 1) * pageSize);

            List<Map<String, Object>> posts = jdbcTemplate.queryForList(sql.toString(), params.toArray());

            // 获取总数
            String countSql = "SELECT COUNT(*) FROM outfit_post WHERE status = '0'";
            if (category != null && !category.isEmpty() && !"recommend".equals(category)) {
                countSql += " AND category = '" + category + "'";
            }
            Long total = jdbcTemplate.queryForObject(countSql, Long.class);

            result.put("code", 200);
            result.put("msg", "查询成功");
            result.put("rows", posts);
            result.put("total", total);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "查询失败：" + e.getMessage());
            result.put("rows", new ArrayList<>());
            result.put("total", 0);
        }
        return result;
    }

    /**
     * 获取帖子详情
     */
    @GetMapping("/post/{id}")
    public Map<String, Object> getPost(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        try {
            String sql = "SELECT * FROM outfit_post WHERE id = ?";
            Map<String, Object> post = jdbcTemplate.queryForMap(sql, id);

            // 增加浏览量
            jdbcTemplate.update("UPDATE outfit_post SET view_count = IFNULL(view_count, 0) + 1 WHERE id = ?", id);

            result.put("code", 200);
            result.put("msg", "查询成功");
            result.put("data", post);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "查询失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 发布新帖子
     */
    @PostMapping("/post")
    public Map<String, Object> createPost(@RequestBody Map<String, Object> postData) {
        Map<String, Object> result = new HashMap<>();
        try {
            String title = (String) postData.get("title");
            String content = (String) postData.get("description");
            String image = (String) postData.get("image");

            // 处理标签
            Object tagsObj = postData.get("tags");
            String tags = "";
            if (tagsObj instanceof List) {
                tags = String.join(",", (List<String>) tagsObj);
            } else if (tagsObj instanceof String) {
                tags = (String) tagsObj;
            }

            String category = (String) postData.getOrDefault("category", "recommend");
            Long userId = postData.get("userId") != null ?
                    ((Number) postData.get("userId")).longValue() : 1L;
            String username = (String) postData.getOrDefault("username", "当前用户");
            String avatar = (String) postData.getOrDefault("avatar", "/images/默认头像.png");

            String sql = "INSERT INTO outfit_post (title, content, image, tags, user_id, username, avatar, category, create_time) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";

            int affectedRows = jdbcTemplate.update(sql, title, content, image, tags, userId, username, avatar, category);

            if (affectedRows > 0) {
                // 获取刚插入的ID
                Long postId = jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Long.class);

                Map<String, Object> data = new HashMap<>();
                data.put("id", postId);

                result.put("code", 200);
                result.put("msg", "发布成功");
                result.put("data", data);
            } else {
                result.put("code", 500);
                result.put("msg", "发布失败：数据库插入失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "发布失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 点赞/取消点赞帖子
     */
    @PostMapping("/post/{id}/like")
    public Map<String, Object> togglePostLike(@PathVariable Long id, @RequestParam Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 检查是否已经点赞
            String checkSql = "SELECT COUNT(*) FROM outfit_like WHERE post_id = ? AND user_id = ? AND type = 'post'";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, id, userId);

            if (count != null && count > 0) {
                // 取消点赞
                String deleteSql = "DELETE FROM outfit_like WHERE post_id = ? AND user_id = ? AND type = 'post'";
                jdbcTemplate.update(deleteSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_post SET like_count = like_count - 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "取消点赞");
            } else {
                // 添加点赞
                String insertSql = "INSERT INTO outfit_like (post_id, user_id, type) VALUES (?, ?, 'post')";
                jdbcTemplate.update(insertSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_post SET like_count = like_count + 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "点赞成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "操作失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 收藏/取消收藏帖子
     */
    @PostMapping("/post/{id}/collect")
    public Map<String, Object> togglePostCollect(@PathVariable Long id, @RequestParam Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 检查是否已经收藏
            String checkSql = "SELECT COUNT(*) FROM outfit_collect WHERE post_id = ? AND user_id = ?";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, id, userId);

            if (count != null && count > 0) {
                // 取消收藏
                String deleteSql = "DELETE FROM outfit_collect WHERE post_id = ? AND user_id = ?";
                jdbcTemplate.update(deleteSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_post SET collect_count = collect_count - 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "取消收藏");
            } else {
                // 添加收藏
                String insertSql = "INSERT INTO outfit_collect (post_id, user_id) VALUES (?, ?)";
                jdbcTemplate.update(insertSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_post SET collect_count = collect_count + 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "收藏成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "操作失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 获取用户对帖子的点赞和收藏状态
     */
    @GetMapping("/post/{id}/status")
    public Map<String, Object> getPostStatus(@PathVariable Long id, @RequestParam Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 检查点赞状态
            String likeSql = "SELECT COUNT(*) FROM outfit_like WHERE post_id = ? AND user_id = ? AND type = 'post'";
            Integer isLiked = jdbcTemplate.queryForObject(likeSql, Integer.class, id, userId);

            // 检查收藏状态
            String collectSql = "SELECT COUNT(*) FROM outfit_collect WHERE post_id = ? AND user_id = ?";
            Integer isCollected = jdbcTemplate.queryForObject(collectSql, Integer.class, id, userId);

            Map<String, Object> data = new HashMap<>();
            data.put("isLiked", isLiked != null && isLiked > 0);
            data.put("isCollected", isCollected != null && isCollected > 0);

            result.put("code", 200);
            result.put("msg", "查询成功");
            result.put("data", data);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "查询失败：" + e.getMessage());
        }
        return result;
    }

    // ==================== 评论相关接口 ====================

    /**
     * 获取帖子的评论列表
     */
    @GetMapping("/post/{postId}/comments")
    public Map<String, Object> getComments(@PathVariable Long postId) {
        Map<String, Object> result = new HashMap<>();
        try {
            String sql = "SELECT * FROM outfit_comment WHERE post_id = ? AND status = '0' ORDER BY create_time DESC";
            List<Map<String, Object>> comments = jdbcTemplate.queryForList(sql, postId);

            // 为每条评论添加点赞状态（简化处理）
            for (Map<String, Object> comment : comments) {
                comment.put("isLiked", false);
            }

            result.put("code", 200);
            result.put("msg", "查询成功");
            result.put("data", comments);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "查询失败：" + e.getMessage());
            result.put("data", new ArrayList<>());
        }
        return result;
    }

    /**
     * 发表评论
     */
    @PostMapping("/comment")
    public Map<String, Object> addComment(@RequestBody Map<String, Object> commentData) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long postId = ((Number) commentData.get("postId")).longValue();
            String content = (String) commentData.get("content");
            Long userId = commentData.get("userId") != null ?
                    ((Number) commentData.get("userId")).longValue() : 1L;
            String username = (String) commentData.getOrDefault("username", "当前用户");
            String avatar = (String) commentData.getOrDefault("avatar", "/images/默认头像.png");

            String sql = "INSERT INTO outfit_comment (post_id, user_id, username, avatar, content, create_time) " +
                    "VALUES (?, ?, ?, ?, ?, NOW())";

            int affectedRows = jdbcTemplate.update(sql, postId, userId, username, avatar, content);

            if (affectedRows > 0) {
                // 更新帖子的评论数
                jdbcTemplate.update("UPDATE outfit_post SET comment_count = comment_count + 1 WHERE id = ?", postId);

                // 获取刚插入的评论
                Long commentId = jdbcTemplate.queryForObject("SELECT LAST_INSERT_ID()", Long.class);
                Map<String, Object> newComment = jdbcTemplate.queryForMap("SELECT * FROM outfit_comment WHERE id = ?", commentId);
                newComment.put("isLiked", false);

                result.put("code", 200);
                result.put("msg", "评论成功");
                result.put("data", newComment);
            } else {
                result.put("code", 500);
                result.put("msg", "评论失败：数据库插入失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "评论失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 点赞/取消点赞评论
     */
    @PostMapping("/comment/{id}/like")
    public Map<String, Object> toggleCommentLike(@PathVariable Long id, @RequestParam Long userId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 检查是否已经点赞
            String checkSql = "SELECT COUNT(*) FROM outfit_like WHERE target_id = ? AND user_id = ? AND type = 'comment'";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, id, userId);

            if (count != null && count > 0) {
                // 取消点赞
                String deleteSql = "DELETE FROM outfit_like WHERE target_id = ? AND user_id = ? AND type = 'comment'";
                jdbcTemplate.update(deleteSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_comment SET like_count = like_count - 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "取消点赞");
            } else {
                // 添加点赞
                String insertSql = "INSERT INTO outfit_like (target_id, user_id, type) VALUES (?, ?, 'comment')";
                jdbcTemplate.update(insertSql, id, userId);
                jdbcTemplate.update("UPDATE outfit_comment SET like_count = like_count + 1 WHERE id = ?", id);
                result.put("code", 200);
                result.put("msg", "点赞成功");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("code", 500);
            result.put("msg", "操作失败：" + e.getMessage());
        }
        return result;
    }

    // ==================== 用户相关接口 ====================

    /**
     * 获取当前用户信息（模拟登录用户）
     */
    @GetMapping("/user/current")
    public Map<String, Object> getCurrentUser() {
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> user = new HashMap<>();
        user.put("userId", 1L);
        user.put("username", "穿搭爱好者");
        user.put("nickName", "穿搭爱好者");
        user.put("avatar", "/images/头像8.png");

        result.put("code", 200);
        result.put("msg", "查询成功");
        result.put("data", user);
        return result;
    }
    @GetMapping("/statistics")
    public AjaxResult getStatistics() {
        // 使用注入的 outfitService 调用方法
        return AjaxResult.success(outfitService.selectOutfitStatistics());
    }

    /**
     * 获取所有穿搭配置（用于下拉框）
     */
    @GetMapping("/configs")
    public AjaxResult getAllConfigs() {
        return AjaxResult.success(outfitConfigMapper.selectOutfitConfigList(new OutfitConfig()));
    }
}