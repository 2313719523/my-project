/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 50729 (5.7.29-log)
 Source Host           : localhost:3306
 Source Schema         : kk-recommend

 Target Server Type    : MySQL
 Target Server Version : 50729 (5.7.29-log)
 File Encoding         : 65001

 Date: 05/05/2026 14:26:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for clothes
-- ----------------------------
DROP TABLE IF EXISTS `clothes`;
CREATE TABLE `clothes`  (
  `clothes_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '服装ID（主键）',
  `user_id` bigint(20) NOT NULL COMMENT '所属用户ID（关联sys_user.user_id）',
  `clothes_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服装名称（如：黑色西装外套）',
  `category` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服装品类（上衣/下装/鞋子/配饰/外套等）',
  `style` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '风格（简约/商务/休闲/甜酷/运动等）',
  `season` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '适用季节（春季/夏季/秋季/冬季/四季通用）',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色',
  `size` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '尺码',
  `is_available` tinyint(4) NOT NULL DEFAULT 1 COMMENT '是否可用（1-可用，0-已丢弃）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`clothes_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE COMMENT '用户ID索引，优化查询'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户服装表（衣橱单品）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clothes
-- ----------------------------

-- ----------------------------
-- Table structure for clothing_comment
-- ----------------------------
DROP TABLE IF EXISTS `clothing_comment`;
CREATE TABLE `clothing_comment`  (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `outfit_id` bigint(20) NOT NULL COMMENT '穿搭ID',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父评论ID',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`comment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '评论表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clothing_comment
-- ----------------------------

-- ----------------------------
-- Table structure for clothing_favorite
-- ----------------------------
DROP TABLE IF EXISTS `clothing_favorite`;
CREATE TABLE `clothing_favorite`  (
  `favorite_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `outfit_id` bigint(20) NOT NULL COMMENT '穿搭ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `uk_user_outfit_fav`(`user_id`, `outfit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clothing_favorite
-- ----------------------------

-- ----------------------------
-- Table structure for clothing_like
-- ----------------------------
DROP TABLE IF EXISTS `clothing_like`;
CREATE TABLE `clothing_like`  (
  `like_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `outfit_id` bigint(20) NOT NULL COMMENT '穿搭ID',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`like_id`) USING BTREE,
  UNIQUE INDEX `uk_user_outfit`(`user_id`, `outfit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '点赞表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of clothing_like
-- ----------------------------

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (1, 'ry_outfit', '穿搭主表', NULL, NULL, 'RyOutfit', 'crud', 'element-ui', 'com.ruoyi.system', 'system', 'outfit', '穿搭主', 'ruoyi', '0', '/', '{}', 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (1, 1, 'outfit_id', '穿搭ID', 'bigint(20)', 'Long', 'outfitId', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (2, 1, 'user_id', '用户ID', 'bigint(20)', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (3, 1, 'title', '穿搭标题', 'varchar(100)', 'String', 'title', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (4, 1, 'description', '穿搭描述', 'text', 'String', 'description', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 4, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (5, 1, 'style_tag', '风格标签', 'varchar(50)', 'String', 'styleTag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'outfit_style', 5, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (6, 1, 'scene_tag', '场景标签', 'varchar(50)', 'String', 'sceneTag', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'outfit_scene', 6, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (7, 1, 'images', '图片JSON数组', 'text', 'String', 'images', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'textarea', '', 7, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (8, 1, 'view_count', '浏览数', 'int(11)', 'Long', 'viewCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (9, 1, 'like_count', '点赞数', 'int(11)', 'Long', 'likeCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (10, 1, 'collect_count', '收藏数', 'int(11)', 'Long', 'collectCount', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (11, 1, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'radio', '', 11, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (12, 1, 'del_flag', '删除标志', 'char(1)', 'String', 'delFlag', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (13, 1, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 13, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (14, 1, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (15, 1, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'input', '', 15, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');
INSERT INTO `gen_table_column` VALUES (16, 1, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 16, 'admin', '2026-01-27 10:44:12', '', '2026-01-27 11:26:45');

-- ----------------------------
-- Table structure for outfit
-- ----------------------------
DROP TABLE IF EXISTS `outfit`;
CREATE TABLE `outfit`  (
  `outfit_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '穿搭ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '穿搭标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '穿搭描述',
  `style_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风格标签',
  `scene_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '场景标签',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '图片JSON数组',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览数',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `collect_count` int(11) NULL DEFAULT 0 COMMENT '收藏数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '删除标志',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`outfit_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '穿搭主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit
-- ----------------------------
INSERT INTO `outfit` VALUES (1, 1, '今日穿搭', '今日穿搭分享', 'casual', 'work', '/profile/upload/2026/03/08/智能穿搭推荐封面_20260308204657A001.png', 500, 89, 10, '0', '0', '', '2026-03-07 20:23:38', '', '2026-03-08 20:47:05');

-- ----------------------------
-- Table structure for outfit_collect
-- ----------------------------
DROP TABLE IF EXISTS `outfit_collect`;
CREATE TABLE `outfit_collect`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_post`(`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收藏记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit_collect
-- ----------------------------

-- ----------------------------
-- Table structure for outfit_comment
-- ----------------------------
DROP TABLE IF EXISTS `outfit_comment`;
CREATE TABLE `outfit_comment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论主键ID',
  `target_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NULL DEFAULT 1 COMMENT '用户ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '穿搭评论表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit_comment
-- ----------------------------

-- ----------------------------
-- Table structure for outfit_config
-- ----------------------------
DROP TABLE IF EXISTS `outfit_config`;
CREATE TABLE `outfit_config`  (
  `config_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置类型（occasion-场合, style-风格, body_type-身材）',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名称（如：日常办公、简约风）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 38 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '穿搭风格场景配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit_config
-- ----------------------------
INSERT INTO `outfit_config` VALUES (1, 'occasion', '日常办公', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (2, 'occasion', '旅游出行', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (3, 'occasion', '约会', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (4, 'style', '简约风', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (5, 'style', '多巴胺风', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (6, 'style', '甜美风', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (7, 'body_type', '梨型身材', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (8, 'body_type', '沙漏型身材', '0', '2026-03-31 22:49:04');
INSERT INTO `outfit_config` VALUES (9, 'style', '通勤风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (10, 'style', '复古风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (11, 'style', '运动风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (12, 'style', '中性风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (13, 'style', '优雅风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (14, 'style', '波西米亚风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (15, 'style', '街头潮流风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (16, 'style', '极简主义风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (17, 'style', '学院风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (18, 'style', '法式浪漫风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (19, 'style', '北欧冷淡风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (20, 'style', '日系森女风', '0', '2026-04-01 00:35:35');
INSERT INTO `outfit_config` VALUES (21, 'occasion', '家庭聚会', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (22, 'occasion', '毕业典礼', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (23, 'occasion', '生日派对', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (24, 'occasion', '商务会议', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (25, 'occasion', '朋友聚会', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (26, 'occasion', '婚礼宾客', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (27, 'occasion', '面试场合', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (28, 'occasion', '运动健身', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (29, 'occasion', '逛街购物', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (30, 'occasion', '艺术展览', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (31, 'occasion', '音乐会/剧院', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (32, 'occasion', '海边度假', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (33, 'occasion', '滑雪运动', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (34, 'occasion', '户外徒步', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (35, 'occasion', '公司年会', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (36, 'occasion', '商务晚宴', '0', '2026-04-01 00:40:00');
INSERT INTO `outfit_config` VALUES (37, 'occasion', '产品发布会', '0', '2026-04-01 00:40:00');

-- ----------------------------
-- Table structure for outfit_like
-- ----------------------------
DROP TABLE IF EXISTS `outfit_like`;
CREATE TABLE `outfit_like`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `post_id` bigint(20) NOT NULL COMMENT '帖子ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'post' COMMENT '类型：post-帖子 comment-评论',
  `target_id` bigint(20) NULL DEFAULT NULL COMMENT '目标ID（评论ID）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_post`(`user_id`, `post_id`, `type`) USING BTREE,
  INDEX `idx_post_id`(`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '点赞记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit_like
-- ----------------------------

-- ----------------------------
-- Table structure for outfit_post
-- ----------------------------
DROP TABLE IF EXISTS `outfit_post`;
CREATE TABLE `outfit_post`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '帖子ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容描述',
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片URL',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标签，多个用逗号分隔',
  `user_id` bigint(20) NOT NULL COMMENT '发布用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户头像',
  `like_count` int(11) NULL DEFAULT 0 COMMENT '点赞数',
  `comment_count` int(11) NULL DEFAULT 0 COMMENT '评论数',
  `collect_count` int(11) NULL DEFAULT 0 COMMENT '收藏数',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'recommend' COMMENT '分类',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '审核状态（0待审核 1通过 2违规）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '穿搭帖子表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of outfit_post
-- ----------------------------
INSERT INTO `outfit_post` VALUES (1, '通勤穿搭｜简约又不失高级感', '今天分享一套非常适合上班的通勤穿搭，简约又高级', '/profile/upload/通勤风简约.png', '通勤风,简约', 1, '时尚小咖', '/images/头像1.png', 0, 0, 0, 'business', '1', '2026-03-20 19:25:59', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (2, '黑白配经典永不过时', '黑白配色永远是最经典的选择', '/profile/upload/简约黑白.png', '简约,黑白', 2, '搭配师小林', '/images/头像2.png', 0, 0, 0, 'casual', '1', '2026-03-20 19:25:59', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (3, '一衣多穿｜白衬衫的7种搭配', '白衬衫真的是万能单品，7种搭配方式分享', '/profile/upload/实用白衬衫.png', '实用,白衬衫', 3, '极简生活', '/images/头像3.png', 0, 0, 0, 'casual', '1', '2026-03-20 19:25:59', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (4, '西装外套的多种搭配', '如何穿出高级感', '/profile/upload/通勤风西装.png', '通勤风、西装', 1, '职场丽人', '/images/头像4.png', 0, 0, 0, 'business', '1', '2026-04-12 23:52:42', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (5, '显高显瘦穿搭公式', '这样穿搭不会出错', '/profile/upload/显高.png', '显瘦、技巧', 1, '穿搭技巧', '/images/头像5.png', 0, 0, 0, 'sport', '1', '2026-04-12 23:55:41', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (6, '周末约会装，温柔甜美风', '少女感爆棚', '/profile/upload/温柔甜美.png', '约会、甜美', 1, '穿搭日记', '/images/头像3.png', 0, 0, 0, 'sport', '1', '2026-04-12 23:57:48', '2026-04-14 22:29:48');
INSERT INTO `outfit_post` VALUES (24, '雨天', 'ootd', '/profile/upload/2026/04/14/雨天卫衣_20260414220338A003.png', '休闲风', 1, '', '', 0, 0, 0, 'recommend', '1', '2026-04-14 22:03:42', '2026-04-14 22:03:53');
INSERT INTO `outfit_post` VALUES (25, '11', '11', '/profile/upload/2026/04/30/屏幕截图 2023-03-13 155848_20260430232417A001.png', '通勤风', 1, 'admin', '/images/头像8.png', 0, 0, 0, 'recommend', '0', '2026-04-30 23:24:20', '2026-04-30 23:24:20');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '调度器状态表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-01-13 09:43:47', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 106 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, 'kk', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, 'kk', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, 'kk', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, 'kk', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, 'kk', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (30, 1, '通勤风', 'commute', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:08:51', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (31, 2, '休闲风', 'casual', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:09:33', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (32, 3, '学院风', 'campus', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:10:00', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (33, 4, '复古风', 'vintage', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:10:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (34, 5, '运动风', 'sport', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:10:43', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (35, 6, '街头风', 'street', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:11:06', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (36, 7, '甜美风', 'sweet', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:11:29', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (37, 8, '简约风', 'minimal', 'outfit_style', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:11:49', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (38, 1, '日常上班', 'work', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:23:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (39, 2, '周末约会', 'date', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:23:21', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (40, 3, '旅行出游', 'travel', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:23:48', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (41, 4, '运动健身', 'fitness', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:24:07', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (42, 5, '校园上课', 'school', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:24:22', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (43, 6, '商务会议', 'meeting', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:24:40', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (44, 7, '派对聚会', 'party', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:24:57', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (45, 8, '日常逛街', 'shopping', 'outfit_scene', NULL, 'default', 'N', '0', 'admin', '2026-01-27 11:25:16', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-01-13 09:43:47', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (11, '穿搭风格', 'outfit_style', '0', 'admin', '2026-01-27 11:06:33', '', NULL, '穿搭风格');
INSERT INTO `sys_dict_type` VALUES (12, '穿搭场景', 'outfit_scene', '0', 'admin', '2026-01-27 11:12:22', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2026-01-13 09:43:47', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2026-01-13 09:43:47', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2026-01-13 09:43:47', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 437 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 09:46:16');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 10:48:01');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 14:58:03');
INSERT INTO `sys_logininfor` VALUES (103, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 16:50:30');
INSERT INTO `sys_logininfor` VALUES (104, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '退出成功', '2026-01-13 18:11:03');
INSERT INTO `sys_logininfor` VALUES (105, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 18:11:05');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '退出成功', '2026-01-13 18:29:52');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '1', '验证码错误', '2026-01-13 18:31:29');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-13 18:31:34');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-14 09:26:24');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 10:12:29');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '退出成功', '2026-01-14 10:45:22');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-14 10:58:55');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 11:36:54');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 12:40:45');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '退出成功', '2026-01-14 12:41:21');
INSERT INTO `sys_logininfor` VALUES (116, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 12:41:31');
INSERT INTO `sys_logininfor` VALUES (117, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 13:57:07');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '1', '验证码已失效', '2026-01-14 13:57:07');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 13:57:12');
INSERT INTO `sys_logininfor` VALUES (120, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 17:41:32');
INSERT INTO `sys_logininfor` VALUES (121, 'admin', '127.0.0.1', '内网IP', 'Firefox 143.0', 'Windows >=10', '0', '登录成功', '2026-01-14 17:41:42');
INSERT INTO `sys_logininfor` VALUES (122, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码已失效', '2026-01-15 09:05:19');
INSERT INTO `sys_logininfor` VALUES (123, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码错误', '2026-01-15 09:05:20');
INSERT INTO `sys_logininfor` VALUES (124, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-15 09:05:22');
INSERT INTO `sys_logininfor` VALUES (125, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码已失效', '2026-01-15 15:42:46');
INSERT INTO `sys_logininfor` VALUES (126, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-15 15:42:47');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 09:13:08');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码已失效', '2026-01-16 09:13:08');
INSERT INTO `sys_logininfor` VALUES (129, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码已失效', '2026-01-16 09:13:08');
INSERT INTO `sys_logininfor` VALUES (130, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 11:13:20');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '1', '验证码已失效', '2026-01-16 11:13:20');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 12:42:55');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Edge 143', 'Windows >=10', '0', '登录成功', '2026-01-16 12:51:55');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 13:42:26');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 15:37:47');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Firefox 146.0', 'Windows >=10', '0', '登录成功', '2026-01-16 21:42:35');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-21 15:25:18');
INSERT INTO `sys_logininfor` VALUES (138, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-21 16:45:14');
INSERT INTO `sys_logininfor` VALUES (139, 'admin', '127.0.0.1', '内网IP', 'Chrome 75.0.3770.100', 'Windows 10.0', '1', '验证码错误', '2026-01-21 16:53:13');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 75.0.3770.100', 'Windows 10.0', '0', '登录成功', '2026-01-21 16:53:18');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-21 16:56:16');
INSERT INTO `sys_logininfor` VALUES (142, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-21 17:38:18');
INSERT INTO `sys_logininfor` VALUES (143, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码错误', '2026-01-21 17:38:18');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 09:38:04');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 14:14:32');
INSERT INTO `sys_logininfor` VALUES (146, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 14:58:54');
INSERT INTO `sys_logininfor` VALUES (147, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-22 15:47:00');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-22 16:34:06');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '退出成功', '2026-01-22 16:59:03');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '1', '验证码已失效', '2026-01-22 17:22:38');
INSERT INTO `sys_logininfor` VALUES (151, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-22 17:22:42');
INSERT INTO `sys_logininfor` VALUES (152, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '1', '验证码错误', '2026-01-23 11:18:14');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-23 11:18:17');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-23 14:28:38');
INSERT INTO `sys_logininfor` VALUES (155, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '退出成功', '2026-01-23 14:45:04');
INSERT INTO `sys_logininfor` VALUES (156, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-23 14:55:16');
INSERT INTO `sys_logininfor` VALUES (157, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '退出成功', '2026-01-23 14:55:34');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-23 15:04:37');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-01-23 15:05:08');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-23 16:55:18');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-26 09:47:06');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-01-26 10:36:16');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-26 10:46:27');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-26 11:26:44');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-26 14:08:02');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-26 16:10:56');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-27 09:41:50');
INSERT INTO `sys_logininfor` VALUES (168, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '1', '验证码已失效', '2026-01-27 10:06:16');
INSERT INTO `sys_logininfor` VALUES (169, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-27 10:06:20');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-27 10:43:12');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-27 11:54:18');
INSERT INTO `sys_logininfor` VALUES (172, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-27 14:29:22');
INSERT INTO `sys_logininfor` VALUES (173, 'admin', '127.0.0.1', '内网IP', 'Firefox 147.0', 'Windows >=10', '0', '登录成功', '2026-01-27 15:35:00');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 09:31:18');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 09:31:56');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 10:37:48');
INSERT INTO `sys_logininfor` VALUES (177, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 11:28:41');
INSERT INTO `sys_logininfor` VALUES (178, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 14:27:52');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-01-30 17:54:33');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-02 09:49:09');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-02 11:14:14');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-02 16:18:27');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-02 17:57:16');
INSERT INTO `sys_logininfor` VALUES (184, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-02 17:57:17');
INSERT INTO `sys_logininfor` VALUES (185, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-03 09:25:24');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-03 11:43:47');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-03 14:18:10');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-03 16:57:03');
INSERT INTO `sys_logininfor` VALUES (189, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-03 17:41:33');
INSERT INTO `sys_logininfor` VALUES (190, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-03 17:41:41');
INSERT INTO `sys_logininfor` VALUES (191, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 10:57:22');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 12:20:27');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 16:42:25');
INSERT INTO `sys_logininfor` VALUES (194, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-04 16:59:35');
INSERT INTO `sys_logininfor` VALUES (195, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-04 17:11:37');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 17:11:46');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 17:47:04');
INSERT INTO `sys_logininfor` VALUES (198, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-04 17:47:13');
INSERT INTO `sys_logininfor` VALUES (199, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 20:31:07');
INSERT INTO `sys_logininfor` VALUES (200, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-04 20:33:49');
INSERT INTO `sys_logininfor` VALUES (201, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 21:05:50');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-04 21:06:15');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 21:13:13');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-04 21:13:17');
INSERT INTO `sys_logininfor` VALUES (205, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '1', '验证码已失效', '2026-02-04 21:59:28');
INSERT INTO `sys_logininfor` VALUES (206, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-04 21:59:37');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 13:30:05');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '退出成功', '2026-02-06 13:50:29');
INSERT INTO `sys_logininfor` VALUES (209, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 13:50:39');
INSERT INTO `sys_logininfor` VALUES (210, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 16:40:52');
INSERT INTO `sys_logininfor` VALUES (211, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 18:57:25');
INSERT INTO `sys_logininfor` VALUES (212, 'admin', '127.0.0.1', '内网IP', 'Edge 144', 'Windows >=10', '0', '登录成功', '2026-02-06 20:31:55');
INSERT INTO `sys_logininfor` VALUES (213, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 18:17:56');
INSERT INTO `sys_logininfor` VALUES (214, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-07 20:01:50');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-08 19:50:02');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-08 20:25:42');
INSERT INTO `sys_logininfor` VALUES (217, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-08 21:24:11');
INSERT INTO `sys_logininfor` VALUES (218, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 17:54:02');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 19:10:25');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码错误', '2026-03-09 20:53:08');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 20:53:15');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '退出成功', '2026-03-09 20:56:22');
INSERT INTO `sys_logininfor` VALUES (223, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码错误', '2026-03-09 21:00:12');
INSERT INTO `sys_logininfor` VALUES (224, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-09 21:00:20');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-10 22:15:38');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '退出成功', '2026-03-10 22:16:36');
INSERT INTO `sys_logininfor` VALUES (227, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '1', '验证码已失效', '2026-03-10 22:26:00');
INSERT INTO `sys_logininfor` VALUES (228, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-10 22:26:07');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-19 08:22:45');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-19 08:22:50');
INSERT INTO `sys_logininfor` VALUES (231, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-19 14:14:49');
INSERT INTO `sys_logininfor` VALUES (232, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-19 16:24:51');
INSERT INTO `sys_logininfor` VALUES (233, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-19 20:13:07');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-20 12:47:32');
INSERT INTO `sys_logininfor` VALUES (235, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-20 13:20:22');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-20 20:04:36');
INSERT INTO `sys_logininfor` VALUES (237, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-20 20:49:51');
INSERT INTO `sys_logininfor` VALUES (238, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-23 18:06:30');
INSERT INTO `sys_logininfor` VALUES (239, 'admin', '127.0.0.1', '内网IP', 'Edge 145', 'Windows >=10', '0', '登录成功', '2026-03-23 20:36:45');
INSERT INTO `sys_logininfor` VALUES (240, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-24 11:45:58');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-24 12:32:26');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-24 15:02:31');
INSERT INTO `sys_logininfor` VALUES (243, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 11:55:38');
INSERT INTO `sys_logininfor` VALUES (244, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 11:55:46');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 13:17:27');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 13:17:38');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 14:46:24');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 14:47:05');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:32:18');
INSERT INTO `sys_logininfor` VALUES (250, 'ixy', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:32:32');
INSERT INTO `sys_logininfor` VALUES (251, 'xy', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 16:35:40');
INSERT INTO `sys_logininfor` VALUES (252, 'xy', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:35:49');
INSERT INTO `sys_logininfor` VALUES (253, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:35:59');
INSERT INTO `sys_logininfor` VALUES (254, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:36:31');
INSERT INTO `sys_logininfor` VALUES (255, 'adcisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:36:41');
INSERT INTO `sys_logininfor` VALUES (256, 'adcisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:37:03');
INSERT INTO `sys_logininfor` VALUES (257, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-25 16:37:10');
INSERT INTO `sys_logininfor` VALUES (258, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:37:16');
INSERT INTO `sys_logininfor` VALUES (259, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:38:56');
INSERT INTO `sys_logininfor` VALUES (260, 'advisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:39:05');
INSERT INTO `sys_logininfor` VALUES (261, 'advisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-25 16:39:21');
INSERT INTO `sys_logininfor` VALUES (262, 'advisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:39:31');
INSERT INTO `sys_logininfor` VALUES (263, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:40:32');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:43:14');
INSERT INTO `sys_logininfor` VALUES (265, 'advisor', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:43:28');
INSERT INTO `sys_logininfor` VALUES (266, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 16:52:54');
INSERT INTO `sys_logininfor` VALUES (267, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:53:00');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:54:31');
INSERT INTO `sys_logininfor` VALUES (269, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-25 16:54:42');
INSERT INTO `sys_logininfor` VALUES (270, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:54:56');
INSERT INTO `sys_logininfor` VALUES (271, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:55:07');
INSERT INTO `sys_logininfor` VALUES (272, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:55:48');
INSERT INTO `sys_logininfor` VALUES (273, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-25 16:55:55');
INSERT INTO `sys_logininfor` VALUES (274, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:56:02');
INSERT INTO `sys_logininfor` VALUES (275, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 16:56:13');
INSERT INTO `sys_logininfor` VALUES (276, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 16:56:29');
INSERT INTO `sys_logininfor` VALUES (277, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:56:41');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:56:51');
INSERT INTO `sys_logininfor` VALUES (279, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:57:04');
INSERT INTO `sys_logininfor` VALUES (280, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:57:20');
INSERT INTO `sys_logininfor` VALUES (281, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:57:31');
INSERT INTO `sys_logininfor` VALUES (282, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 16:58:25');
INSERT INTO `sys_logininfor` VALUES (283, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 16:59:40');
INSERT INTO `sys_logininfor` VALUES (284, 'xy', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 16:59:54');
INSERT INTO `sys_logininfor` VALUES (285, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 17:00:04');
INSERT INTO `sys_logininfor` VALUES (286, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 17:00:31');
INSERT INTO `sys_logininfor` VALUES (287, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 17:01:32');
INSERT INTO `sys_logininfor` VALUES (288, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 17:02:36');
INSERT INTO `sys_logininfor` VALUES (289, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 17:03:17');
INSERT INTO `sys_logininfor` VALUES (290, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 17:10:34');
INSERT INTO `sys_logininfor` VALUES (291, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:10:39');
INSERT INTO `sys_logininfor` VALUES (292, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:11:49');
INSERT INTO `sys_logininfor` VALUES (293, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:12:18');
INSERT INTO `sys_logininfor` VALUES (294, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:12:25');
INSERT INTO `sys_logininfor` VALUES (295, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:12:56');
INSERT INTO `sys_logininfor` VALUES (296, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:14:49');
INSERT INTO `sys_logininfor` VALUES (297, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-25 17:15:13');
INSERT INTO `sys_logininfor` VALUES (298, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 17:15:24');
INSERT INTO `sys_logininfor` VALUES (299, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-25 17:17:29');
INSERT INTO `sys_logininfor` VALUES (300, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '密码输入错误5次，帐户锁定10分钟', '2026-03-25 17:17:39');
INSERT INTO `sys_logininfor` VALUES (301, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:24:05');
INSERT INTO `sys_logininfor` VALUES (302, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:26:45');
INSERT INTO `sys_logininfor` VALUES (303, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:26:53');
INSERT INTO `sys_logininfor` VALUES (304, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '验证码已失效', '2026-03-25 17:29:10');
INSERT INTO `sys_logininfor` VALUES (305, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:29:17');
INSERT INTO `sys_logininfor` VALUES (306, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-25 17:29:39');
INSERT INTO `sys_logininfor` VALUES (307, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-03-25 17:31:34');
INSERT INTO `sys_logininfor` VALUES (308, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:31:48');
INSERT INTO `sys_logininfor` VALUES (309, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:34:49');
INSERT INTO `sys_logininfor` VALUES (310, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '验证码已失效', '2026-03-25 17:41:53');
INSERT INTO `sys_logininfor` VALUES (311, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-25 17:41:58');
INSERT INTO `sys_logininfor` VALUES (312, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-03-25 17:43:26');
INSERT INTO `sys_logininfor` VALUES (313, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:43:39');
INSERT INTO `sys_logininfor` VALUES (314, 'kk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '验证码错误', '2026-03-25 17:43:45');
INSERT INTO `sys_logininfor` VALUES (315, 'kk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '验证码错误', '2026-03-25 17:43:51');
INSERT INTO `sys_logininfor` VALUES (316, 'kk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-03-25 17:43:58');
INSERT INTO `sys_logininfor` VALUES (317, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-25 17:44:19');
INSERT INTO `sys_logininfor` VALUES (318, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-03-25 17:45:31');
INSERT INTO `sys_logininfor` VALUES (319, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-25 17:45:41');
INSERT INTO `sys_logininfor` VALUES (320, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-03-25 17:45:49');
INSERT INTO `sys_logininfor` VALUES (321, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-25 17:46:02');
INSERT INTO `sys_logininfor` VALUES (322, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 17:46:35');
INSERT INTO `sys_logininfor` VALUES (323, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-25 17:47:01');
INSERT INTO `sys_logininfor` VALUES (324, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 17:47:07');
INSERT INTO `sys_logininfor` VALUES (325, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-25 18:40:37');
INSERT INTO `sys_logininfor` VALUES (326, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 09:53:59');
INSERT INTO `sys_logininfor` VALUES (327, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:06:04');
INSERT INTO `sys_logininfor` VALUES (328, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-26 10:06:19');
INSERT INTO `sys_logininfor` VALUES (329, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:06:24');
INSERT INTO `sys_logininfor` VALUES (330, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:07:40');
INSERT INTO `sys_logininfor` VALUES (331, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:07:46');
INSERT INTO `sys_logininfor` VALUES (332, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:08:25');
INSERT INTO `sys_logininfor` VALUES (333, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:08:43');
INSERT INTO `sys_logininfor` VALUES (334, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:11:23');
INSERT INTO `sys_logininfor` VALUES (335, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:11:37');
INSERT INTO `sys_logininfor` VALUES (336, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:12:32');
INSERT INTO `sys_logininfor` VALUES (337, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:12:38');
INSERT INTO `sys_logininfor` VALUES (338, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-26 10:12:45');
INSERT INTO `sys_logininfor` VALUES (339, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 10:13:02');
INSERT INTO `sys_logininfor` VALUES (340, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 12:21:43');
INSERT INTO `sys_logininfor` VALUES (341, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-26 13:16:31');
INSERT INTO `sys_logininfor` VALUES (342, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 14:47:41');
INSERT INTO `sys_logininfor` VALUES (343, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 15:51:00');
INSERT INTO `sys_logininfor` VALUES (344, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-28 16:06:08');
INSERT INTO `sys_logininfor` VALUES (345, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 16:06:24');
INSERT INTO `sys_logininfor` VALUES (346, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-28 16:06:43');
INSERT INTO `sys_logininfor` VALUES (347, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 16:06:58');
INSERT INTO `sys_logininfor` VALUES (348, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 16:53:35');
INSERT INTO `sys_logininfor` VALUES (349, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 17:43:49');
INSERT INTO `sys_logininfor` VALUES (350, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-28 18:08:53');
INSERT INTO `sys_logininfor` VALUES (351, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 18:13:34');
INSERT INTO `sys_logininfor` VALUES (352, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-28 21:08:24');
INSERT INTO `sys_logininfor` VALUES (353, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 21:08:25');
INSERT INTO `sys_logininfor` VALUES (354, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-28 23:18:02');
INSERT INTO `sys_logininfor` VALUES (355, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-29 17:09:47');
INSERT INTO `sys_logininfor` VALUES (356, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-29 21:55:00');
INSERT INTO `sys_logininfor` VALUES (357, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-29 21:57:50');
INSERT INTO `sys_logininfor` VALUES (358, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-29 21:57:55');
INSERT INTO `sys_logininfor` VALUES (359, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '退出成功', '2026-03-29 21:58:31');
INSERT INTO `sys_logininfor` VALUES (360, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-29 21:58:42');
INSERT INTO `sys_logininfor` VALUES (361, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-30 15:50:00');
INSERT INTO `sys_logininfor` VALUES (362, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-30 15:52:32');
INSERT INTO `sys_logininfor` VALUES (363, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-30 16:04:26');
INSERT INTO `sys_logininfor` VALUES (364, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-03-30 16:06:14');
INSERT INTO `sys_logininfor` VALUES (365, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-03-30 16:07:50');
INSERT INTO `sys_logininfor` VALUES (366, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-30 16:08:02');
INSERT INTO `sys_logininfor` VALUES (367, 'ikk', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-30 16:08:45');
INSERT INTO `sys_logininfor` VALUES (368, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码错误', '2026-03-31 19:02:13');
INSERT INTO `sys_logininfor` VALUES (369, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-31 19:02:19');
INSERT INTO `sys_logininfor` VALUES (370, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '验证码已失效', '2026-03-31 22:34:51');
INSERT INTO `sys_logininfor` VALUES (371, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-31 22:34:52');
INSERT INTO `sys_logininfor` VALUES (372, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-03-31 23:29:54');
INSERT INTO `sys_logininfor` VALUES (373, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-01 16:57:16');
INSERT INTO `sys_logininfor` VALUES (374, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-01 18:38:26');
INSERT INTO `sys_logininfor` VALUES (375, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '验证码错误', '2026-04-01 19:30:15');
INSERT INTO `sys_logininfor` VALUES (376, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 19:30:22');
INSERT INTO `sys_logininfor` VALUES (377, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-01 19:30:42');
INSERT INTO `sys_logininfor` VALUES (378, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 19:30:57');
INSERT INTO `sys_logininfor` VALUES (379, 'admin', '127.0.0.1', '内网IP', 'Firefox 149.0', 'Windows >=10', '0', '登录成功', '2026-04-01 20:02:54');
INSERT INTO `sys_logininfor` VALUES (380, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-01 20:07:41');
INSERT INTO `sys_logininfor` VALUES (381, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-01 20:28:50');
INSERT INTO `sys_logininfor` VALUES (382, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 20:36:04');
INSERT INTO `sys_logininfor` VALUES (383, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 20:41:11');
INSERT INTO `sys_logininfor` VALUES (384, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 21:06:20');
INSERT INTO `sys_logininfor` VALUES (385, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-01 21:34:55');
INSERT INTO `sys_logininfor` VALUES (386, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 21:35:07');
INSERT INTO `sys_logininfor` VALUES (387, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-01 21:35:13');
INSERT INTO `sys_logininfor` VALUES (388, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-01 21:35:30');
INSERT INTO `sys_logininfor` VALUES (389, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-08 19:11:34');
INSERT INTO `sys_logininfor` VALUES (390, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-08 19:50:22');
INSERT INTO `sys_logininfor` VALUES (391, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-08 20:14:41');
INSERT INTO `sys_logininfor` VALUES (392, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-12 18:28:41');
INSERT INTO `sys_logininfor` VALUES (393, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-12 20:21:07');
INSERT INTO `sys_logininfor` VALUES (394, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-12 21:33:53');
INSERT INTO `sys_logininfor` VALUES (395, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 14:38:58');
INSERT INTO `sys_logininfor` VALUES (396, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 14:39:06');
INSERT INTO `sys_logininfor` VALUES (397, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-14 14:40:49');
INSERT INTO `sys_logininfor` VALUES (398, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-14 14:43:50');
INSERT INTO `sys_logininfor` VALUES (399, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-14 14:44:09');
INSERT INTO `sys_logininfor` VALUES (400, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 15:56:50');
INSERT INTO `sys_logininfor` VALUES (401, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 19:49:28');
INSERT INTO `sys_logininfor` VALUES (402, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 20:37:04');
INSERT INTO `sys_logininfor` VALUES (403, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-14 21:00:21');
INSERT INTO `sys_logininfor` VALUES (404, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-04-14 21:02:46');
INSERT INTO `sys_logininfor` VALUES (405, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-04-14 21:03:02');
INSERT INTO `sys_logininfor` VALUES (406, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '1', '用户不存在/密码错误', '2026-04-14 21:03:18');
INSERT INTO `sys_logininfor` VALUES (407, 'admin', '127.0.0.1', '内网IP', 'Edge 146', 'Windows >=10', '0', '登录成功', '2026-04-14 21:03:34');
INSERT INTO `sys_logininfor` VALUES (408, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-15 18:11:52');
INSERT INTO `sys_logininfor` VALUES (409, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-15 19:51:16');
INSERT INTO `sys_logininfor` VALUES (410, 'ikk', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '退出成功', '2026-04-15 19:54:32');
INSERT INTO `sys_logininfor` VALUES (411, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-04-15 19:54:47');
INSERT INTO `sys_logininfor` VALUES (412, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '1', '用户不存在/密码错误', '2026-04-15 19:54:58');
INSERT INTO `sys_logininfor` VALUES (413, 'admin', '127.0.0.1', '内网IP', 'Chrome 144', 'Windows10', '0', '登录成功', '2026-04-15 19:55:12');
INSERT INTO `sys_logininfor` VALUES (414, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '验证码已失效', '2026-04-20 18:20:17');
INSERT INTO `sys_logininfor` VALUES (415, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-20 18:20:17');
INSERT INTO `sys_logininfor` VALUES (416, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-04-20 18:20:40');
INSERT INTO `sys_logininfor` VALUES (417, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-20 18:20:53');
INSERT INTO `sys_logininfor` VALUES (418, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-04-20 18:47:29');
INSERT INTO `sys_logininfor` VALUES (419, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-20 18:47:44');
INSERT INTO `sys_logininfor` VALUES (420, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-04-20 18:50:34');
INSERT INTO `sys_logininfor` VALUES (421, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-20 18:50:46');
INSERT INTO `sys_logininfor` VALUES (422, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '验证码已失效', '2026-04-21 16:21:39');
INSERT INTO `sys_logininfor` VALUES (423, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-21 16:21:44');
INSERT INTO `sys_logininfor` VALUES (424, 'ikk', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-04-21 16:23:59');
INSERT INTO `sys_logininfor` VALUES (425, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '用户不存在/密码错误', '2026-04-21 16:24:11');
INSERT INTO `sys_logininfor` VALUES (426, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-21 16:24:21');
INSERT INTO `sys_logininfor` VALUES (427, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '验证码已失效', '2026-04-21 17:47:32');
INSERT INTO `sys_logininfor` VALUES (428, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-21 17:47:36');
INSERT INTO `sys_logininfor` VALUES (429, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-21 19:19:48');
INSERT INTO `sys_logininfor` VALUES (430, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-21 22:41:22');
INSERT INTO `sys_logininfor` VALUES (431, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-30 23:21:57');
INSERT INTO `sys_logininfor` VALUES (432, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-04-30 23:22:11');
INSERT INTO `sys_logininfor` VALUES (433, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-05 12:44:22');
INSERT INTO `sys_logininfor` VALUES (434, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '退出成功', '2026-05-05 13:14:28');
INSERT INTO `sys_logininfor` VALUES (435, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '1', '用户不存在/密码错误', '2026-05-05 13:14:41');
INSERT INTO `sys_logininfor` VALUES (436, 'admin', '127.0.0.1', '内网IP', 'Edge 147', 'Windows >=10', '0', '登录成功', '2026-05-05 13:50:06');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2005 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-01-13 09:43:46', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 4, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-01-13 09:43:46', 'admin', '2026-01-23 17:58:50', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 5, 'tool', NULL, '', '', 1, 0, 'M', '1', '0', '', 'tool', 'admin', '2026-01-13 09:43:46', 'admin', '2026-01-23 17:58:58', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '知识库调用', 0, 4, 'https://www.coze.cn/space/7597380186367426586/bot/7597380708080353280', NULL, '', '', 0, 0, 'M', '0', '1', '', 'guide', 'admin', '2026-01-13 09:43:46', 'admin', '2026-03-19 14:44:34', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '会员管理中心', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-01-13 09:43:46', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '权限角色中心', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-01-13 09:43:46', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '导航架构管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-01-13 09:43:46', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '1', '0', 'system:dept:list', 'tree', 'admin', '2026-01-13 09:43:46', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '1', '0', 'system:post:list', 'post', 'admin', '2026-01-13 09:43:46', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-01-13 09:43:46', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-01-13 09:43:46', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 0, 7, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-01-13 09:43:46', 'admin', '2026-04-01 22:40:56', '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 0, 6, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-01-13 09:43:46', 'admin', '2026-04-01 22:41:05', '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户与审核', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-01-13 09:43:46', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '1', '0', 'monitor:job:list', 'job', 'admin', '2026-01-13 09:43:46', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '1', '0', 'monitor:druid:list', 'druid', 'admin', '2026-01-13 09:43:46', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-01-13 09:43:46', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '数据中枢监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-01-13 09:43:46', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-01-13 09:43:46', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-01-13 09:43:46', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-01-13 09:43:46', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-01-13 09:43:46', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-01-13 09:43:46', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-01-13 09:43:46', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2000, '衣橱管理', 0, 2, '/wardrobe', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'shopping', 'admin', '2026-01-13 17:49:28', 'admin', '2026-01-23 17:58:40', '');
INSERT INTO `sys_menu` VALUES (2002, '单品管理', 2000, 2, 'item', 'wardrobe/index', NULL, '', 1, 0, 'C', '0', '0', 'wardrobe:item:list', 'component', 'admin', '2026-01-13 17:53:59', 'admin', '2026-03-19 14:55:51', '');
INSERT INTO `sys_menu` VALUES (2003, '衣橱首页', 2000, 1, 'home', 'wardrobe/WardrobeHome', NULL, '', 1, 0, 'C', '0', '0', 'wardrobe:index:view', 'dashboard', 'admin', '2026-01-23 17:34:16', 'admin', '2026-03-24 13:40:38', '');
INSERT INTO `sys_menu` VALUES (2004, 'AI穿搭推荐', 0, 3, '/closet/recommend', 'closet/recommend', NULL, 'AIClosetRecommend', 1, 0, 'C', '0', '0', 'closet:recommend', 'star', 'admin', '2026-01-26 09:54:07', 'admin', '2026-01-26 15:39:38', '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2026 穿搭推荐系统开始调试', '1', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-01-13 09:43:47', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (3, '关于穿搭推荐系统', '2', 0x3C703E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223E68656C6C6FEFBD9EE59084E4BD8DE794A8E688B7EFBC813C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EE8BF99E9878CE698AF3C2F7370616E3E3C7374726F6E67207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EE7A9BFE690ADE68EA8E88D90E5B08FE7AB993C2F7374726F6E673E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EEFBC8CE5BE88E9AB98E585B4E4B88EE4BDA0E79BB8E98187EFBD9E3C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EE5B9B3E58FB0E79BAEE5898DE5B7B2E6ADA3E5B8B8E5BC80E694BEE4BDBFE794A8EFBC8CE5A4A7E5AEB6E58FAFE4BBA5E5B0BDE68385E6B58FE8A788E38081E4BD93E9AA8CE7A9BFE690ADE79BB8E585B3E58A9FE883BDE380823C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EE4BDBFE794A8E8BF87E7A88BE4B8ADE5A682E69E9CE98187E588B020425547E38081E58DA1E9A1BFE68896E69C89E5A5BDE79A84E683B3E6B395EFBC8CE983BDE58FAFE4BBA5E5918AE8AF89E68891E4BBACE380823C2F7370616E3E3C2F703E3C703E3C7370616E207374796C653D226261636B67726F756E642D636F6C6F723A207267626128302C20302C20302C2030293B20636F6C6F723A2072676228302C20302C2030293B223EE68891E4BBACE4BC9AE4B88DE696ADE4BC98E58C96EFBC8CE58AAAE58A9BE4B8BAE5A4A7E5AEB6E5B8A6E69DA5E69BB4E8B4B4E5BF83E79A84E69C8DE58AA1E29DA4EFB88F3C2F7370616E3E3C2F703E3C703E3C7374726F6E673E3C7370616E20636C6173733D22716C2D637572736F72223EEFBBBF3C2F7370616E3E3C2F7374726F6E673E3C2F703E, '0', 'admin', '2026-04-01 22:39:16', '', NULL, NULL);
INSERT INTO `sys_notice` VALUES (4, '穿搭推荐平台即将上线', '2', 0x3C703E3C696D67207372633D22687474703A2F2F6C6F63616C686F73743A383038302F70726F66696C652F75706C6F61642F323032362F30342F32312FE699BAE883BDE7A9BFE690ADE68EA8E88D90E5B081E99DA25F3230323630343231313734383036413030312E706E67223E3C2F703E, '0', 'admin', '2026-04-21 17:48:45', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 275 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"衣橱管理\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-13 17:49:28', 156);
INSERT INTO `sys_oper_log` VALUES (101, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"component\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"单品管理\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/wardrobe/item\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-13 17:52:33', 15);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2001', '127.0.0.1', '内网IP', '2001 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-13 17:55:58', 59);
INSERT INTO `sys_oper_log` VALUES (103, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"kk@163.com\",\"nickName\":\"kk\",\"params\":{},\"phonenumber\":\"15888888888\",\"sex\":\"1\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-14 15:22:17', 462);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"衣橱管理\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"新增菜单\'衣橱管理\'失败，菜单名称已存在\",\"code\":500}', 0, NULL, '2026-01-23 17:18:07', 41);
INSERT INTO `sys_oper_log` VALUES (105, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 17:49:28\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"我的衣橱测试\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:23:37', 26);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"theme\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"衣橱首页\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"wardrobe/index\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:34:16', 43);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 17:49:28\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"我的衣橱测试\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe/index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:34:43', 21);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 17:49:28\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"我的衣橱测试\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:35:00', 28);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"theme\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"M\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"wardrobe/index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:35:14', 35);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/index\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:51:39', 31);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/item/index\",\"createTime\":\"2026-01-13 17:53:59\",\"icon\":\"component\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"单品管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"/wardrobe/item\",\"perms\":\"wardrobe:item:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:51:55', 27);
INSERT INTO `sys_oper_log` VALUES (112, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 17:49:28\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"衣橱管理\",\"menuType\":\"M\",\"orderNum\":100,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:53:04', 31);
INSERT INTO `sys_oper_log` VALUES (113, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 17:49:28\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"衣橱管理\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"/wardrobe\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:58:40', 16);
INSERT INTO `sys_oper_log` VALUES (114, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:58:50', 31);
INSERT INTO `sys_oper_log` VALUES (115, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"tool\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":3,\"menuName\":\"系统工具\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"tool\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-23 17:58:58', 33);
INSERT INTO `sys_oper_log` VALUES (116, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"@/views/closet/recommend\",\"createBy\":\"admin\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"AI穿搭推荐\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"/closet/recommend\",\"perms\":\"closet:recommend\",\"routeName\":\"AIClosetRecommend\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 09:54:07', 38);
INSERT INTO `sys_oper_log` VALUES (117, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-26 09:56:02', 122);
INSERT INTO `sys_oper_log` VALUES (118, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-26 09:56:08', 11);
INSERT INTO `sys_oper_log` VALUES (119, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/4', '127.0.0.1', '内网IP', '4 ', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2026-01-26 09:56:21', 40);
INSERT INTO `sys_oper_log` VALUES (120, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"知识库调用\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"https://www.coze.cn/space/7597380186367426586/bot/7597380708080353280\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 09:57:51', 34);
INSERT INTO `sys_oper_log` VALUES (121, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"views/closet/recommend\",\"createTime\":\"2026-01-26 09:54:07\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"AI穿搭推荐\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"/closet/recommend\",\"perms\":\"closet:recommend\",\"routeName\":\"AIClosetRecommend\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 15:39:10', 88);
INSERT INTO `sys_oper_log` VALUES (122, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"closet/recommend\",\"createTime\":\"2026-01-26 09:54:07\",\"icon\":\"star\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2004,\"menuName\":\"AI穿搭推荐\",\"menuType\":\"C\",\"orderNum\":3,\"params\":{},\"parentId\":0,\"path\":\"/closet/recommend\",\"perms\":\"closet:recommend\",\"routeName\":\"AIClosetRecommend\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-26 15:39:38', 79);
INSERT INTO `sys_oper_log` VALUES (123, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"ry_outfit\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 10:44:12', 276);
INSERT INTO `sys_oper_log` VALUES (124, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"穿搭风格\",\"dictType\":\"outfit_style\",\"params\":{},\"remark\":\"穿搭风格\",\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:06:33', 47);
INSERT INTO `sys_oper_log` VALUES (125, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"通勤风\",\"dictSort\":1,\"dictType\":\"outfit_style\",\"dictValue\":\"commute\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:08:51', 17);
INSERT INTO `sys_oper_log` VALUES (126, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"休闲风\",\"dictSort\":2,\"dictType\":\"outfit_style\",\"dictValue\":\"casual\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:09:33', 37);
INSERT INTO `sys_oper_log` VALUES (127, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"学院风\",\"dictSort\":3,\"dictType\":\"outfit_style\",\"dictValue\":\"campus\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:10:00', 16);
INSERT INTO `sys_oper_log` VALUES (128, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"复古风\",\"dictSort\":4,\"dictType\":\"outfit_style\",\"dictValue\":\"vintage\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:10:20', 33);
INSERT INTO `sys_oper_log` VALUES (129, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"运动风\",\"dictSort\":5,\"dictType\":\"outfit_style\",\"dictValue\":\"sport\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:10:43', 33);
INSERT INTO `sys_oper_log` VALUES (130, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"街头风\",\"dictSort\":6,\"dictType\":\"outfit_style\",\"dictValue\":\"street\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:11:06', 23);
INSERT INTO `sys_oper_log` VALUES (131, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"甜美风\",\"dictSort\":7,\"dictType\":\"outfit_style\",\"dictValue\":\"sweet\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:11:29', 20);
INSERT INTO `sys_oper_log` VALUES (132, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"简约风\",\"dictSort\":8,\"dictType\":\"outfit_style\",\"dictValue\":\"minimal\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:11:50', 32);
INSERT INTO `sys_oper_log` VALUES (133, '字典类型', 1, 'com.ruoyi.web.controller.system.SysDictTypeController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/type', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"dictName\":\"穿搭场景\",\"dictType\":\"outfit_scene\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:12:22', 23);
INSERT INTO `sys_oper_log` VALUES (134, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"日常上班\",\"dictSort\":1,\"dictType\":\"outfit_scene\",\"dictValue\":\"work\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:23:05', 15);
INSERT INTO `sys_oper_log` VALUES (135, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"周末约会\",\"dictSort\":2,\"dictType\":\"outfit_scene\",\"dictValue\":\"date\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:23:21', 32);
INSERT INTO `sys_oper_log` VALUES (136, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"旅行出游\",\"dictSort\":3,\"dictType\":\"outfit_scene\",\"dictValue\":\"travel\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:23:48', 18);
INSERT INTO `sys_oper_log` VALUES (137, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"运动健身\",\"dictSort\":4,\"dictType\":\"outfit_scene\",\"dictValue\":\"fitness\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:24:07', 32);
INSERT INTO `sys_oper_log` VALUES (138, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"校园上课\",\"dictSort\":5,\"dictType\":\"outfit_scene\",\"dictValue\":\"school\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:24:22', 32);
INSERT INTO `sys_oper_log` VALUES (139, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"商务会议\",\"dictSort\":6,\"dictType\":\"outfit_scene\",\"dictValue\":\"meeting\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:24:40', 32);
INSERT INTO `sys_oper_log` VALUES (140, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"派对聚会\",\"dictSort\":7,\"dictType\":\"outfit_scene\",\"dictValue\":\"party\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:24:57', 32);
INSERT INTO `sys_oper_log` VALUES (141, '字典数据', 1, 'com.ruoyi.web.controller.system.SysDictDataController.add()', 'POST', 1, 'admin', '研发部门', '/system/dict/data', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"default\":false,\"dictLabel\":\"日常逛街\",\"dictSort\":8,\"dictType\":\"outfit_scene\",\"dictValue\":\"shopping\",\"listClass\":\"default\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:25:17', 22);
INSERT INTO `sys_oper_log` VALUES (142, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"outfit\",\"className\":\"RyOutfit\",\"columns\":[{\"capJavaField\":\"OutfitId\",\"columnComment\":\"穿搭ID\",\"columnId\":1,\"columnName\":\"outfit_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-01-27 10:44:12\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"outfitId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":2,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2026-01-27 10:44:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Title\",\"columnComment\":\"穿搭标题\",\"columnId\":3,\"columnName\":\"title\",\"columnType\":\"varchar(100)\",\"createBy\":\"admin\",\"createTime\":\"2026-01-27 10:44:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaField\":\"title\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":false,\"sort\":3,\"superColumn\":false,\"tableId\":1,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Description\",\"columnComment\":\"穿搭描述\",\"columnId\":4,\"columnName\":\"description\",\"columnType\":\"text\",\"createBy\":\"admin\",\"createTime\":\"2026-01-27 10:44:12\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"textarea\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"0\",\"javaFi', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 11:26:45', 142);
INSERT INTO `sys_oper_log` VALUES (143, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"ry_outfit\"}', NULL, 0, NULL, '2026-01-27 11:26:50', 820);
INSERT INTO `sys_oper_log` VALUES (144, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"outfit/outfit/index\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"穿搭主表\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":3,\"path\":\"outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 12:04:06', 87);
INSERT INTO `sys_oper_log` VALUES (145, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2011', '127.0.0.1', '内网IP', '2011 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-01-27 14:52:53', 49);
INSERT INTO `sys_oper_log` VALUES (146, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2012', '127.0.0.1', '内网IP', '2012 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:03', 66);
INSERT INTO `sys_oper_log` VALUES (147, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2013', '127.0.0.1', '内网IP', '2013 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:10', 41);
INSERT INTO `sys_oper_log` VALUES (148, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2014', '127.0.0.1', '内网IP', '2014 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:15', 63);
INSERT INTO `sys_oper_log` VALUES (149, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2015', '127.0.0.1', '内网IP', '2015 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:18', 49);
INSERT INTO `sys_oper_log` VALUES (150, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2016', '127.0.0.1', '内网IP', '2016 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:21', 24);
INSERT INTO `sys_oper_log` VALUES (151, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2011', '127.0.0.1', '内网IP', '2011 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:53:24', 32);
INSERT INTO `sys_oper_log` VALUES (152, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"outfit/outfit/index\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":3,\"path\":\"outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:54:42', 50);
INSERT INTO `sys_oper_log` VALUES (153, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"outfit/outfit/index\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-01-27 14:55:06', 66);
INSERT INTO `sys_oper_log` VALUES (154, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"/outfit/outfit/index\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-03 15:59:05', 134);
INSERT INTO `sys_oper_log` VALUES (155, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-03 16:00:06', 48);
INSERT INTO `sys_oper_log` VALUES (156, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-03 16:00:37', 37);
INSERT INTO `sys_oper_log` VALUES (157, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"outfit/outfit/index\",\"createTime\":\"2026-01-27 11:42:00\",\"icon\":\"peoples\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2005,\"menuName\":\"社区互动\",\"menuType\":\"C\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"/outfit/outfit\",\"perms\":\"outfit:outfit:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-02-03 16:02:35', 44);
INSERT INTO `sys_oper_log` VALUES (158, '用户管理', 3, 'com.kk.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/2', '127.0.0.1', '内网IP', '[2] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 18:23:32', 127);
INSERT INTO `sys_oper_log` VALUES (159, '穿搭主', 1, 'com.kk.outfit.controller.OutfitController.add()', 'POST', 1, 'admin', '研发部门', '/outfit/outfit', '127.0.0.1', '内网IP', '{\"collectCount\":10,\"createTime\":\"2026-03-07 20:23:38\",\"description\":\"今日穿搭分享\",\"likeCount\":89,\"outfitId\":1,\"params\":{},\"sceneTag\":\"work\",\"styleTag\":\"casual\",\"title\":\"今日穿搭\",\"userId\":1,\"viewCount\":500} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-07 20:23:38', 232);
INSERT INTO `sys_oper_log` VALUES (160, '穿搭主', 2, 'com.kk.outfit.controller.OutfitController.edit()', 'PUT', 1, 'admin', '研发部门', '/outfit/outfit', '127.0.0.1', '内网IP', '{\"collectCount\":10,\"createBy\":\"\",\"createTime\":\"2026-03-07 20:23:38\",\"delFlag\":\"0\",\"description\":\"今日穿搭分享\",\"images\":\"/profile/upload/2026/03/08/智能穿搭推荐封面_20260308204657A001.png\",\"likeCount\":89,\"outfitId\":1,\"params\":{},\"sceneTag\":\"work\",\"status\":\"0\",\"styleTag\":\"casual\",\"title\":\"今日穿搭\",\"updateBy\":\"\",\"updateTime\":\"2026-03-08 20:47:04\",\"userId\":1,\"viewCount\":500} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-08 20:47:05', 97);
INSERT INTO `sys_oper_log` VALUES (161, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"知识库调用\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":4,\"path\":\"https://www.coze.cn/space/7597380186367426586/bot/7597380708080353280\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"} ', '{\"msg\":\"修改菜单\'知识库调用\'失败，上级菜单不能选择自己\",\"code\":500}', 0, NULL, '2026-03-19 14:42:35', 64);
INSERT INTO `sys_oper_log` VALUES (162, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"guide\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":4,\"menuName\":\"知识库调用\",\"menuType\":\"M\",\"orderNum\":4,\"params\":{},\"parentId\":0,\"path\":\"https://www.coze.cn/space/7597380186367426586/bot/7597380708080353280\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"1\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 14:44:34', 46);
INSERT INTO `sys_oper_log` VALUES (163, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/index\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"item\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 14:52:22', 30);
INSERT INTO `sys_oper_log` VALUES (164, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/index\",\"createTime\":\"2026-01-13 17:53:59\",\"icon\":\"component\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"单品管理\",\"menuType\":\"C\",\"orderNum\":2,\"params\":{},\"parentId\":2000,\"path\":\"item\",\"perms\":\"wardrobe:item:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 14:55:51', 32);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/item/index\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"/wardrobe/item\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 14:57:08', 29);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/item/index\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 14:58:00', 48);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/index\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"index\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-19 15:03:26', 54);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"wardrobe/WardrobeHome\",\"createTime\":\"2026-01-23 17:34:16\",\"icon\":\"dashboard\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2003,\"menuName\":\"衣橱首页\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":2000,\"path\":\"home\",\"perms\":\"wardrobe:index:view\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 13:40:38', 75);
INSERT INTO `sys_oper_log` VALUES (169, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324163230A001.png\",\"name\":\"白色修身T恤\",\"params\":{},\"price\":299.0,\"season\":\"夏季\"} ', NULL, 1, 'Invalid bound statement (not found): com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem', '2026-03-24 16:32:33', 52);
INSERT INTO `sys_oper_log` VALUES (170, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324163230A001.png\",\"name\":\"白色修身T恤\",\"params\":{},\"price\":299.0,\"season\":\"夏季\"} ', NULL, 1, 'Invalid bound statement (not found): com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem', '2026-03-24 16:32:37', 1);
INSERT INTO `sys_oper_log` VALUES (171, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324163315A002.png\",\"name\":\"白色修身T恤\",\"params\":{},\"price\":299.0,\"season\":\"夏季\"} ', NULL, 1, 'Invalid bound statement (not found): com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem', '2026-03-24 16:33:16', 1);
INSERT INTO `sys_oper_log` VALUES (172, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324163315A002.png\",\"name\":\"白色修身T恤\",\"params\":{},\"price\":299.0,\"season\":\"夏季\"} ', NULL, 1, 'Invalid bound statement (not found): com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem', '2026-03-24 16:33:25', 1);
INSERT INTO `sys_oper_log` VALUES (173, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"id\":11,\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324163935A002.png\",\"name\":\"白色修身T恤\",\"params\":{},\"price\":199.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 16:39:36', 107);
INSERT INTO `sys_oper_log` VALUES (174, '衣橱单品', 3, 'com.kk.wardrobe.controller.WardrobeItemController.remove()', 'DELETE', 1, 'admin', '研发部门', '/wardrobe/item/11', '127.0.0.1', '内网IP', '[11] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 16:52:50', 60);
INSERT INTO `sys_oper_log` VALUES (175, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2024-03-15 00:00:00\",\"category\":\"上装\",\"color\":\"灰色\",\"common\":true,\"id\":6,\"imgUrl\":\"/profile/upload/开衫1.png\",\"isFavorite\":\"0\",\"name\":\"开衫\",\"params\":{},\"price\":299.0,\"remark\":\"\",\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 16:54:19', 66);
INSERT INTO `sys_oper_log` VALUES (176, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":6,\"isFavorite\":\"1\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 16:57:49', 16);
INSERT INTO `sys_oper_log` VALUES (177, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":6,\"isFavorite\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 16:57:50', 17);
INSERT INTO `sys_oper_log` VALUES (178, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2005', '127.0.0.1', '内网IP', '2005 ', '{\"msg\":\"存在子菜单,不允许删除\",\"code\":601}', 0, NULL, '2026-03-24 17:49:44', 29);
INSERT INTO `sys_oper_log` VALUES (179, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2006', '127.0.0.1', '内网IP', '2006 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:49:52', 57);
INSERT INTO `sys_oper_log` VALUES (180, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2007', '127.0.0.1', '内网IP', '2007 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:49:55', 40);
INSERT INTO `sys_oper_log` VALUES (181, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2008', '127.0.0.1', '内网IP', '2008 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:49:57', 46);
INSERT INTO `sys_oper_log` VALUES (182, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2009', '127.0.0.1', '内网IP', '2009 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:49:59', 35);
INSERT INTO `sys_oper_log` VALUES (183, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2010', '127.0.0.1', '内网IP', '2010 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:50:02', 40);
INSERT INTO `sys_oper_log` VALUES (184, '菜单管理', 3, 'com.kk.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2005', '127.0.0.1', '内网IP', '2005 ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 17:50:05', 42);
INSERT INTO `sys_oper_log` VALUES (185, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324180228A001.png\",\"name\":\"修身白T恤\",\"params\":{},\"price\":199.0,\"season\":\"夏季\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'color\' doesn\'t have a default value\r\n### The error may exist in file [D:\\KK-Vue\\kk-admin\\target\\classes\\mapper\\wardrobe\\WardrobeItemMapper.xml]\r\n### The error may involve com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into wardrobe_item          ( name,             category,                          season,             price,                                                    img_url,                          create_time )           values ( ?,             ?,                          ?,             ?,                                                    ?,                          sysdate() )\r\n### Cause: java.sql.SQLException: Field \'color\' doesn\'t have a default value\n; Field \'color\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'color\' doesn\'t have a default value', '2026-03-24 18:03:02', 251);
INSERT INTO `sys_oper_log` VALUES (186, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324180228A001.png\",\"name\":\"修身白T恤\",\"params\":{},\"price\":199.0,\"season\":\"夏季\"} ', NULL, 1, '\r\n### Error updating database.  Cause: java.sql.SQLException: Field \'color\' doesn\'t have a default value\r\n### The error may exist in file [D:\\KK-Vue\\kk-admin\\target\\classes\\mapper\\wardrobe\\WardrobeItemMapper.xml]\r\n### The error may involve com.kk.wardrobe.mapper.WardrobeItemMapper.insertWardrobeItem-Inline\r\n### The error occurred while setting parameters\r\n### SQL: insert into wardrobe_item          ( name,             category,                          season,             price,                                                    img_url,                          create_time )           values ( ?,             ?,                          ?,             ?,                                                    ?,                          sysdate() )\r\n### Cause: java.sql.SQLException: Field \'color\' doesn\'t have a default value\n; Field \'color\' doesn\'t have a default value; nested exception is java.sql.SQLException: Field \'color\' doesn\'t have a default value', '2026-03-24 18:03:17', 19);
INSERT INTO `sys_oper_log` VALUES (187, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"id\":12,\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324181545A002.png\",\"name\":\"修身白T恤\",\"params\":{},\"price\":199.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:15:46', 28);
INSERT INTO `sys_oper_log` VALUES (188, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"黑色\",\"id\":13,\"imgUrl\":\"/profile/upload/2026/03/24/T恤3_20260324181611A003.png\",\"name\":\"黑色T恤\",\"params\":{},\"price\":199.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:16:45', 25);
INSERT INTO `sys_oper_log` VALUES (189, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"棕色\",\"id\":14,\"imgUrl\":\"/profile/upload/2026/03/24/半身裙1_20260324181704A004.png\",\"name\":\"长款半身裙\",\"params\":{},\"price\":269.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:17:38', 21);
INSERT INTO `sys_oper_log` VALUES (190, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"黑色\",\"id\":15,\"imgUrl\":\"/profile/upload/2026/03/24/半身裙2_20260324181754A005.png\",\"name\":\"短款半身裙\",\"params\":{},\"price\":199.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:18:22', 18);
INSERT INTO `sys_oper_log` VALUES (191, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"白色\",\"id\":16,\"imgUrl\":\"/profile/upload/2026/03/24/半身裙3_20260324181953A006.png\",\"name\":\"半身裙\",\"params\":{},\"price\":299.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:20:35', 20);
INSERT INTO `sys_oper_log` VALUES (192, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2024-03-12 00:00:00\",\"category\":\"裙装\",\"color\":\"蓝色\",\"common\":false,\"id\":9,\"imgUrl\":\"/profile/upload/连衣裙1.png\",\"isFavorite\":\"0\",\"name\":\"连衣裙\",\"params\":{},\"price\":1299.0,\"remark\":\"\",\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:21:07', 15);
INSERT INTO `sys_oper_log` VALUES (193, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"珍珠白\",\"id\":17,\"imgUrl\":\"/profile/upload/2026/03/24/衬衫1_20260324182454A007.png\",\"name\":\"垂感衬衣\",\"params\":{},\"price\":356.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:25:38', 21);
INSERT INTO `sys_oper_log` VALUES (194, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"墨绿色\",\"id\":18,\"imgUrl\":\"/profile/upload/2026/03/24/衬衫2_20260324182825A008.png\",\"name\":\"格子衬衣\",\"params\":{},\"price\":499.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:29:10', 26);
INSERT INTO `sys_oper_log` VALUES (195, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"黑色\",\"id\":19,\"imgUrl\":\"/profile/upload/2026/03/24/衬衫3_20260324182943A009.png\",\"name\":\"黑衬衫\",\"params\":{},\"price\":199.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:30:00', 18);
INSERT INTO `sys_oper_log` VALUES (196, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"卡其色\",\"id\":20,\"imgUrl\":\"/profile/upload/2026/03/24/短裤1_20260324183014A010.png\",\"name\":\"工装短裤\",\"params\":{},\"price\":329.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:30:42', 17);
INSERT INTO `sys_oper_log` VALUES (197, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"莫兰迪灰\",\"id\":21,\"imgUrl\":\"/profile/upload/2026/03/24/短裤2_20260324183151A011.png\",\"name\":\"牛仔短裤\",\"params\":{},\"price\":234.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:32:39', 30);
INSERT INTO `sys_oper_log` VALUES (198, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"黑色\",\"id\":22,\"imgUrl\":\"/profile/upload/2026/03/24/短裤3_20260324183733A012.png\",\"name\":\"运动短裤\",\"params\":{},\"price\":329.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:38:00', 28);
INSERT INTO `sys_oper_log` VALUES (199, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"彩色\",\"id\":23,\"imgUrl\":\"/profile/upload/2026/03/24/开衫2_20260324183820A013.png\",\"name\":\"美拉德开衫\",\"params\":{},\"price\":499.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:38:50', 23);
INSERT INTO `sys_oper_log` VALUES (200, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"薄荷绿\",\"id\":24,\"imgUrl\":\"/profile/upload/2026/03/24/开衫3_20260324183932A015.png\",\"name\":\"开衫\",\"params\":{},\"price\":467.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:40:00', 19);
INSERT INTO `sys_oper_log` VALUES (201, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"孔雀蓝\",\"id\":25,\"imgUrl\":\"/profile/upload/2026/03/24/开衫4_20260324184026A016.png\",\"name\":\"开衫\",\"params\":{},\"price\":299.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:40:46', 28);
INSERT INTO `sys_oper_log` VALUES (202, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"裙装\",\"color\":\"蓝色、棕色\",\"id\":26,\"imgUrl\":\"/profile/upload/2026/03/24/连衣裙2_20260324184107A017.png\",\"name\":\"连衣裙两件套\",\"params\":{},\"price\":599.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:42:40', 20);
INSERT INTO `sys_oper_log` VALUES (203, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"外套\",\"color\":\"浅绿色\",\"id\":27,\"imgUrl\":\"/profile/upload/2026/03/24/连衣裙3_20260324184259A018.png\",\"name\":\"森系仙女连衣裙\",\"params\":{},\"price\":399.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:43:29', 24);
INSERT INTO `sys_oper_log` VALUES (204, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"白色\",\"id\":28,\"imgUrl\":\"/profile/upload/2026/03/24/运动背心1_20260324184621A020.png\",\"name\":\"运动背心\",\"params\":{},\"price\":199.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:46:42', 26);
INSERT INTO `sys_oper_log` VALUES (205, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"绿色\",\"id\":29,\"imgUrl\":\"/profile/upload/2026/03/24/运动背心2_20260324184707A021.png\",\"name\":\"运动背心\",\"params\":{},\"price\":199.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:47:26', 24);
INSERT INTO `sys_oper_log` VALUES (206, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"黑色\",\"id\":30,\"imgUrl\":\"/profile/upload/2026/03/24/运动背心3_20260324184741A022.png\",\"name\":\"运动背心\",\"params\":{},\"price\":199.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:47:59', 26);
INSERT INTO `sys_oper_log` VALUES (207, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"灰色\",\"id\":31,\"imgUrl\":\"/profile/upload/2026/03/24/西装裤1_20260324184815A023.png\",\"name\":\"百搭西装裤\",\"params\":{},\"price\":199.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:48:47', 19);
INSERT INTO `sys_oper_log` VALUES (208, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"黑色\",\"id\":32,\"imgUrl\":\"/profile/upload/2026/03/24/西装裤2_20260324184904A024.png\",\"name\":\"经典西装裤\",\"params\":{},\"price\":209.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:49:28', 21);
INSERT INTO `sys_oper_log` VALUES (209, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"黑色\",\"id\":33,\"imgUrl\":\"/profile/upload/2026/03/24/西装裤3_20260324184950A025.png\",\"name\":\"西装裤\",\"params\":{},\"price\":209.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:50:08', 19);
INSERT INTO `sys_oper_log` VALUES (210, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"牛仔色\",\"id\":34,\"imgUrl\":\"/profile/upload/2026/03/24/牛仔裤2_20260324185028A026.png\",\"name\":\"牛仔裤\",\"params\":{},\"price\":299.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:50:58', 24);
INSERT INTO `sys_oper_log` VALUES (211, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"黑色\",\"id\":35,\"imgUrl\":\"/profile/upload/2026/03/24/玛丽珍1_20260324185109A027.png\",\"name\":\"皮鞋\",\"params\":{},\"price\":299.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:51:35', 17);
INSERT INTO `sys_oper_log` VALUES (212, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"黑色\",\"id\":36,\"imgUrl\":\"/profile/upload/2026/03/24/牛仔裤3_20260324185151A028.png\",\"name\":\"牛仔裤\",\"params\":{},\"price\":199.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:52:13', 24);
INSERT INTO `sys_oper_log` VALUES (213, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"黑色\",\"id\":37,\"imgUrl\":\"/profile/upload/2026/03/24/皮鞋1_20260324185237A029.png\",\"name\":\"皮鞋\",\"params\":{},\"price\":399.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:52:55', 29);
INSERT INTO `sys_oper_log` VALUES (214, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"蓝色\",\"id\":38,\"imgUrl\":\"/profile/upload/2026/03/24/卫衣2_20260324185321A030.png\",\"name\":\"潮流卫衣\",\"params\":{},\"price\":203.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:53:56', 21);
INSERT INTO `sys_oper_log` VALUES (215, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"米白色\",\"id\":39,\"imgUrl\":\"/profile/upload/2026/03/24/玛丽珍2_20260324185410A031.png\",\"name\":\"白色玛丽珍\",\"params\":{},\"price\":399.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:54:29', 17);
INSERT INTO `sys_oper_log` VALUES (216, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"棕色\",\"id\":40,\"imgUrl\":\"/profile/upload/2026/03/24/皮鞋2_20260324185450A032.png\",\"name\":\"通勤小皮鞋\",\"params\":{},\"price\":299.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:55:08', 20);
INSERT INTO `sys_oper_log` VALUES (217, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"黑色\",\"id\":41,\"imgUrl\":\"/profile/upload/2026/03/24/皮鞋3_20260324185520A033.png\",\"name\":\"薄底皮鞋\",\"params\":{},\"price\":399.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:55:40', 17);
INSERT INTO `sys_oper_log` VALUES (218, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"白色\",\"id\":42,\"imgUrl\":\"/profile/upload/2026/03/24/玛丽珍3_20260324185554A034.png\",\"name\":\"玛丽珍\",\"params\":{},\"price\":299.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:56:16', 20);
INSERT INTO `sys_oper_log` VALUES (219, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"灰色\",\"id\":43,\"imgUrl\":\"/profile/upload/2026/03/24/运动鞋3_20260324185637A035.png\",\"name\":\"休闲跑步鞋\",\"params\":{},\"price\":424.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:58:13', 20);
INSERT INTO `sys_oper_log` VALUES (220, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"鞋履\",\"color\":\"白色\",\"id\":44,\"imgUrl\":\"/profile/upload/2026/03/24/运动鞋2_20260324185835A036.png\",\"name\":\"运动鞋\",\"params\":{},\"price\":322.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:58:51', 23);
INSERT INTO `sys_oper_log` VALUES (221, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"灰色\",\"id\":45,\"imgUrl\":\"/profile/upload/2026/03/24/卫衣3_20260324185908A037.png\",\"name\":\"休闲卫衣\",\"params\":{},\"price\":209.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 18:59:30', 28);
INSERT INTO `sys_oper_log` VALUES (222, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"外套\",\"color\":\"白色\",\"id\":46,\"imgUrl\":\"/profile/upload/2026/03/24/卫衣1_20260324185947A038.png\",\"name\":\"星星卫衣外套\",\"params\":{},\"price\":499.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:00:16', 27);
INSERT INTO `sys_oper_log` VALUES (223, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"米白色\",\"id\":47,\"imgUrl\":\"/profile/upload/2026/03/24/T恤2_20260324190049A039.png\",\"name\":\"修身白T恤\",\"params\":{},\"price\":299.0,\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:01:10', 17);
INSERT INTO `sys_oper_log` VALUES (224, '衣橱单品', 3, 'com.kk.wardrobe.controller.WardrobeItemController.remove()', 'DELETE', 1, 'admin', '研发部门', '/wardrobe/item/12', '127.0.0.1', '内网IP', '[12] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:01:23', 29);
INSERT INTO `sys_oper_log` VALUES (225, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"下装\",\"color\":\"深蓝色\",\"id\":48,\"imgUrl\":\"/profile/upload/2026/03/24/牛仔裤1_20260324190144A040.png\",\"name\":\"阔腿牛仔裤\",\"params\":{},\"price\":399.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:02:08', 27);
INSERT INTO `sys_oper_log` VALUES (226, '衣橱单品', 3, 'com.kk.wardrobe.controller.WardrobeItemController.remove()', 'DELETE', 1, 'admin', '研发部门', '/wardrobe/item/7', '127.0.0.1', '内网IP', '[7] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:02:19', 9);
INSERT INTO `sys_oper_log` VALUES (227, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"灰色\",\"id\":49,\"imgUrl\":\"/profile/upload/2026/03/24/开衫1_20260324190238A041.png\",\"name\":\"开衫\",\"params\":{},\"price\":299.0,\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:03:00', 29);
INSERT INTO `sys_oper_log` VALUES (228, '衣橱单品', 3, 'com.kk.wardrobe.controller.WardrobeItemController.remove()', 'DELETE', 1, 'admin', '研发部门', '/wardrobe/item/6', '127.0.0.1', '内网IP', '[6] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:03:53', 18);
INSERT INTO `sys_oper_log` VALUES (229, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2026-03-24 18:43:29\",\"category\":\"裙装\",\"color\":\"浅绿色\",\"common\":false,\"id\":27,\"imgUrl\":\"/profile/upload/2026/03/24/连衣裙3_20260324184259A018.png\",\"isFavorite\":\"0\",\"name\":\"森系仙女连衣裙\",\"params\":{},\"price\":399.0,\"remark\":\"\",\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-24 19:05:57', 10);
INSERT INTO `sys_oper_log` VALUES (230, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"1\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 15:11:28', 28);
INSERT INTO `sys_oper_log` VALUES (231, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 15:11:31', 13);
INSERT INTO `sys_oper_log` VALUES (232, '用户管理', 1, 'com.kk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"xy\",\"params\":{},\"sex\":\"1\",\"status\":\"0\",\"userName\":\"ikk\"} ', NULL, 1, 'rawPassword cannot be null', '2026-03-25 15:48:20', 50);
INSERT INTO `sys_oper_log` VALUES (233, '用户管理', 1, 'com.kk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"xy\",\"params\":{},\"sex\":\"1\",\"status\":\"0\",\"userId\":3,\"userName\":\"ikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 15:55:58', 215);
INSERT INTO `sys_oper_log` VALUES (234, '用户管理', 1, 'com.kk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"xxy\",\"params\":{},\"sex\":\"1\",\"status\":\"0\",\"userId\":4,\"userName\":\"cjikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:02:47', 187);
INSERT INTO `sys_oper_log` VALUES (235, '用户管理', 3, 'com.kk.web.controller.system.SysUserController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/user/4', '127.0.0.1', '内网IP', '[4] ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:10:48', 113);
INSERT INTO `sys_oper_log` VALUES (236, '角色管理', 1, 'com.kk.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2003,2002,2004],\"params\":{},\"roleId\":3,\"roleKey\":\"adcisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:17:48', 127);
INSERT INTO `sys_oper_log` VALUES (237, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2000,2003,2002,2004,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,4,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:38:50', 85);
INSERT INTO `sys_oper_log` VALUES (238, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2000,2003,2002,2004,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,4,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:43:04', 141);
INSERT INTO `sys_oper_log` VALUES (239, '个人信息', 2, 'com.kk.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'ikk', NULL, '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 16:55:32', 362);
INSERT INTO `sys_oper_log` VALUES (240, '个人信息', 2, 'com.kk.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'ikk', NULL, '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 17:00:27', 371);
INSERT INTO `sys_oper_log` VALUES (241, '个人信息', 2, 'com.kk.web.controller.system.SysProfileController.updatePwd()', 'PUT', 1, 'admin', '研发部门', '/system/user/profile/updatePwd', '127.0.0.1', '内网IP', '{} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-25 17:45:25', 558);
INSERT INTO `sys_oper_log` VALUES (242, '用户管理', 2, 'com.kk.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":true,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-01-13 09:43:46\",\"delFlag\":\"0\",\"dept\":{\"ancestors\":\"0,100,101\",\"children\":[],\"deptId\":103,\"deptName\":\"研发部门\",\"leader\":\"若依\",\"orderNum\":1,\"params\":{},\"parentId\":101,\"status\":\"0\"},\"deptId\":103,\"email\":\"kk@163.com\",\"loginDate\":\"2026-03-26 09:53:59\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"kk\",\"params\":{},\"phonenumber\":\"15888888888\",\"pwdUpdateDate\":\"2026-03-25 17:45:25\",\"remark\":\"管理员\",\"roleIds\":[1],\"roles\":[{\"admin\":true,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"userId\":1,\"userName\":\"admin\"} ', NULL, 1, '不允许操作超级管理员用户', '2026-03-26 10:05:40', 48);
INSERT INTO `sys_oper_log` VALUES (243, '用户管理', 2, 'com.kk.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-03-25 15:55:58\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-03-25 17:46:03\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"xy\",\"params\":{},\"phonenumber\":\"\",\"pwdUpdateDate\":\"2026-03-25 17:00:27\",\"remark\":\"管理员\",\"roleIds\":[2,3],\"roles\":[],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":3,\"userName\":\"ikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:05:58', 367);
INSERT INTO `sys_oper_log` VALUES (244, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'ikk', NULL, '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', NULL, 1, 'Cannot read the array length because \"<local4>\" is null', '2026-03-26 10:06:46', 91);
INSERT INTO `sys_oper_log` VALUES (245, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'ikk', NULL, '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[2000,2003,2002,2004],\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\",\"updateBy\":\"ikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:07:24', 170);
INSERT INTO `sys_oper_log` VALUES (246, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', NULL, 1, 'Cannot read the array length because \"<local4>\" is null', '2026-03-26 10:09:02', 37);
INSERT INTO `sys_oper_log` VALUES (247, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-01-13 09:43:46\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"menuIds\":[100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2000,2004,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:11:09', 133);
INSERT INTO `sys_oper_log` VALUES (248, '用户管理', 2, 'com.kk.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"admin\",\"createTime\":\"2026-03-25 15:55:58\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-03-26 10:07:47\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"xy\",\"params\":{},\"phonenumber\":\"\",\"pwdUpdateDate\":\"2026-03-25 17:00:27\",\"remark\":\"管理员\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"},{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":3,\"userName\":\"ikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:11:18', 93);
INSERT INTO `sys_oper_log` VALUES (249, '用户头像', 2, 'com.kk.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'ikk', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2026/03/26/793de1da12664c61a3f6e1487495dac2.png\",\"code\":200}', 0, NULL, '2026-03-26 10:12:26', 447);
INSERT INTO `sys_oper_log` VALUES (250, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', NULL, 1, 'Cannot read the array length because \"<local4>\" is null', '2026-03-26 10:14:33', 32);
INSERT INTO `sys_oper_log` VALUES (251, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', NULL, 1, 'Cannot read the array length because \"<local4>\" is null', '2026-03-26 10:14:34', 24);
INSERT INTO `sys_oper_log` VALUES (252, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', NULL, 1, 'Cannot read the array length because \"<local4>\" is null', '2026-03-26 10:15:53', 36);
INSERT INTO `sys_oper_log` VALUES (253, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"2\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[100,107],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:16:13', 84);
INSERT INTO `sys_oper_log` VALUES (254, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:21:04', 33);
INSERT INTO `sys_oper_log` VALUES (255, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-01-13 09:43:46\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:22:31', 46);
INSERT INTO `sys_oper_log` VALUES (256, '角色管理', 2, 'com.kk.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2026-03-25 16:17:48\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":false,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"roleId\":3,\"roleKey\":\"advisor\",\"roleName\":\"搭配顾问\",\"roleSort\":0,\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:22:34', 33);
INSERT INTO `sys_oper_log` VALUES (257, '用户管理', 1, 'com.kk.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"nickName\":\"xxy\",\"params\":{},\"roleIds\":[2],\"sex\":\"0\",\"status\":\"0\",\"userId\":5,\"userName\":\"kkk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:23:27', 212);
INSERT INTO `sys_oper_log` VALUES (258, '用户管理', 2, 'com.kk.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/avatar/2026/03/26/793de1da12664c61a3f6e1487495dac2.png\",\"createBy\":\"admin\",\"createTime\":\"2026-03-25 15:55:58\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2026-03-26 10:12:39\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"xy\",\"params\":{},\"phonenumber\":\"\",\"pwdUpdateDate\":\"2026-03-25 17:00:27\",\"remark\":\"管理员\",\"roleIds\":[3],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"1\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":3,\"userName\":\"ikk\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-03-26 10:23:45', 99);
INSERT INTO `sys_oper_log` VALUES (259, '登录日志', 5, 'com.kk.web.controller.monitor.SysLogininforController.export()', 'POST', 1, 'admin', '研发部门', '/monitor/logininfor/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2026-03-26 10:56:44', 5452);
INSERT INTO `sys_oper_log` VALUES (260, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/notice/index\",\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":107,\"menuName\":\"通知公告\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":0,\"path\":\"notice\",\"perms\":\"system:notice:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-01 22:10:01', 95);
INSERT INTO `sys_oper_log` VALUES (261, '通知公告', 1, 'com.kk.web.controller.system.SysNoticeController.add()', 'POST', 1, 'admin', '研发部门', '/system/notice', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"noticeContent\":\"<p><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">hello～各位用户！</span></p><p><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">这里是</span><strong style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">穿搭推荐小站</strong><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">，很高兴与你相遇～</span></p><p><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">平台目前已正常开放使用，大家可以尽情浏览、体验穿搭相关功能。</span></p><p><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">使用过程中如果遇到 BUG、卡顿或有好的想法，都可以告诉我们。</span></p><p><span style=\\\"background-color: rgba(0, 0, 0, 0); color: rgb(0, 0, 0);\\\">我们会不断优化，努力为大家带来更贴心的服务❤️</span></p><p><strong><span class=\\\"ql-cursor\\\">﻿</span></strong></p>\",\"noticeTitle\":\"关于穿搭推荐系统\",\"noticeType\":\"2\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-01 22:39:16', 61);
INSERT INTO `sys_oper_log` VALUES (262, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":108,\"menuName\":\"日志管理\",\"menuType\":\"M\",\"orderNum\":9,\"params\":{},\"parentId\":0,\"path\":\"log\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-01 22:40:16', 37);
INSERT INTO `sys_oper_log` VALUES (263, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/notice/index\",\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"message\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":107,\"menuName\":\"通知公告\",\"menuType\":\"C\",\"orderNum\":7,\"params\":{},\"parentId\":0,\"path\":\"notice\",\"perms\":\"system:notice:list\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-01 22:40:56', 35);
INSERT INTO `sys_oper_log` VALUES (264, '菜单管理', 2, 'com.kk.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2026-01-13 09:43:46\",\"icon\":\"log\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":108,\"menuName\":\"日志管理\",\"menuType\":\"M\",\"orderNum\":6,\"params\":{},\"parentId\":0,\"path\":\"log\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-01 22:41:05', 32);
INSERT INTO `sys_oper_log` VALUES (265, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2026-03-24 18:43:29\",\"category\":\"裙装\",\"color\":\"浅绿色\",\"common\":false,\"id\":27,\"imgUrl\":\"/profile/upload/2026/03/24/连衣裙3_20260324184259A018.png\",\"isFavorite\":\"0\",\"name\":\"森系仙女连衣裙\",\"params\":{},\"price\":399.0,\"remark\":\"\",\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:50:07', 62);
INSERT INTO `sys_oper_log` VALUES (266, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2026-03-24 18:43:29\",\"category\":\"裙装\",\"color\":\"浅绿色\",\"common\":false,\"id\":27,\"imgUrl\":\"/profile/upload/2026/03/24/连衣裙3_20260324184259A018.png\",\"isFavorite\":\"0\",\"name\":\"森系仙女连衣裙\",\"params\":{},\"price\":399.0,\"remark\":\"\",\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:50:19', 14);
INSERT INTO `sys_oper_log` VALUES (267, '衣橱单品', 1, 'com.kk.wardrobe.controller.WardrobeItemController.add()', 'POST', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"category\":\"上装\",\"color\":\"白色\",\"id\":50,\"imgUrl\":\"/profile/upload/2026/04/14/雨天卫衣_20260414195113A001.png\",\"name\":\"星星卫衣\",\"params\":{},\"price\":200.0,\"season\":\"四季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:51:15', 34);
INSERT INTO `sys_oper_log` VALUES (268, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2026-04-14 19:51:15\",\"category\":\"上装\",\"color\":\"白色\",\"common\":false,\"id\":50,\"imgUrl\":\"/profile/upload/2026/04/14/雨天卫衣_20260414195113A001.png\",\"isFavorite\":\"0\",\"name\":\"星星卫衣\",\"params\":{},\"price\":200.0,\"remark\":\"\",\"season\":\"夏季\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:51:29', 13);
INSERT INTO `sys_oper_log` VALUES (269, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":50,\"isFavorite\":\"1\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:51:34', 14);
INSERT INTO `sys_oper_log` VALUES (270, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":49,\"isFavorite\":\"1\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:51:52', 11);
INSERT INTO `sys_oper_log` VALUES (271, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":50,\"isFavorite\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:52:05', 16);
INSERT INTO `sys_oper_log` VALUES (272, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"id\":49,\"isFavorite\":\"0\",\"params\":{}} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-14 19:52:12', 14);
INSERT INTO `sys_oper_log` VALUES (273, '通知公告', 1, 'com.kk.web.controller.system.SysNoticeController.add()', 'POST', 1, 'admin', '研发部门', '/system/notice', '127.0.0.1', '内网IP', '{\"createBy\":\"admin\",\"noticeContent\":\"<p><img src=\\\"http://localhost:8080/profile/upload/2026/04/21/智能穿搭推荐封面_20260421174806A001.png\\\"></p>\",\"noticeTitle\":\"穿搭推荐平台即将上线\",\"noticeType\":\"2\",\"params\":{},\"status\":\"0\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-21 17:48:45', 59);
INSERT INTO `sys_oper_log` VALUES (274, '衣橱单品', 2, 'com.kk.wardrobe.controller.WardrobeItemController.edit()', 'PUT', 1, 'admin', '研发部门', '/wardrobe/item', '127.0.0.1', '内网IP', '{\"addTime\":\"2026-03-24 19:03:00\",\"category\":\"上装\",\"color\":\"灰色\",\"common\":false,\"id\":49,\"imgUrl\":\"/profile/upload/2026/03/24/开衫1_20260324190238A041.png\",\"isFavorite\":\"0\",\"name\":\"开衫\",\"params\":{},\"price\":300.0,\"remark\":\"\",\"season\":\"春秋\"} ', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2026-04-21 19:20:01', 41);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-01-13 09:43:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-01-13 09:43:46', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-01-13 09:43:46', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '1', 0, 0, '0', '0', 'admin', '2026-01-13 09:43:46', 'admin', '2026-03-26 10:22:31', '普通角色');
INSERT INTO `sys_role` VALUES (3, '搭配顾问', 'advisor', 0, '1', 1, 0, '0', '0', 'admin', '2026-03-25 16:17:48', 'ikk', '2026-03-26 10:22:34', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (2, 2004);
INSERT INTO `sys_role_menu` VALUES (3, 2000);
INSERT INTO `sys_role_menu` VALUES (3, 2002);
INSERT INTO `sys_role_menu` VALUES (3, 2003);
INSERT INTO `sys_role_menu` VALUES (3, 2004);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', 'kk', '00', 'kk@163.com', '15888888888', '1', '', '$2a$10$dGRlq3Mp7xmm9HDiqgZXl.tQjBNAwA519bBobH1CaqZwUZpmpCRL6', '0', '0', '127.0.0.1', '2026-05-05 13:50:07', '2026-03-25 17:45:25', 'admin', '2026-01-13 09:43:46', '', '2026-03-25 17:45:25', '管理员');
INSERT INTO `sys_user` VALUES (3, NULL, 'ikk', 'xy', '00', '', '', '1', '/profile/avatar/2026/03/26/793de1da12664c61a3f6e1487495dac2.png', '$2a$10$cRvpyRi4SVoz4V35sH58vuFrAJa./OKq3UwfHO249IMLr4.x6gdXq', '0', '0', '127.0.0.1', '2026-04-21 16:21:45', '2026-03-25 17:00:27', 'admin', '2026-03-25 15:55:58', 'admin', '2026-03-26 10:23:45', '管理员');
INSERT INTO `sys_user` VALUES (4, NULL, 'cjikk', 'xxy', '00', '', '', '1', '', '$2a$10$RJniltGEOUIsx2OXY3hoae7Bx/ziOIZJ4JcSxzUcUAZlCNx5iJLbi', '0', '2', '', NULL, NULL, 'admin', '2026-03-25 16:02:47', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (5, NULL, 'kkk', 'xxy', '00', '', '', '0', '', '$2a$10$PRc1u1GpL6vtk2/bvj8WS.aI8zqd/0AHWL5lsPY1hnwUcmWRJWa4S', '0', '0', '', NULL, NULL, 'admin', '2026-03-26 10:23:27', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (3, 3);
INSERT INTO `sys_user_role` VALUES (5, 2);

-- ----------------------------
-- Table structure for sys_wardrobe_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_wardrobe_item`;
CREATE TABLE `sys_wardrobe_item`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片文件名',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '衣服大类',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '颜色特征',
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片访问路径',
  `style` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风格',
  `is_favorite` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否收藏',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '衣柜单品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_wardrobe_item
-- ----------------------------
INSERT INTO `sys_wardrobe_item` VALUES (1, 'T恤1.png', 'T恤', '灰色', '/profile/upload/T恤1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (2, 'T恤2.png', 'T恤', '白色', '/profile/upload/T恤2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (3, 'T恤3.png', 'T恤', '黑色', '/profile/upload/T恤3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (4, '半身裙1.png', '半身裙', '灰色', '/profile/upload/半身裙1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (5, '半身裙2.png', '半身裙', '黑色', '/profile/upload/半身裙2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (6, '半身裙3.png', '半身裙', '米色/浅色', '/profile/upload/半身裙3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (7, '卫衣1.png', '卫衣', '白色', '/profile/upload/卫衣1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (8, '卫衣2.png', '卫衣', '蓝色', '/profile/upload/卫衣2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (9, '卫衣3.png', '卫衣', '灰色', '/profile/upload/卫衣3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (10, '开衫1.png', '开衫', '灰色', '/profile/upload/开衫1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (11, '开衫2.png', '开衫', '红色', '/profile/upload/开衫2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (12, '开衫3.png', '开衫', '米色/浅色', '/profile/upload/开衫3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (13, '开衫4.png', '开衫', '蓝色', '/profile/upload/开衫4.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (14, '牛仔裤1.png', '牛仔裤', '灰色', '/profile/upload/牛仔裤1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (15, '牛仔裤2.png', '牛仔裤', '灰色', '/profile/upload/牛仔裤2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (16, '牛仔裤3.png', '牛仔裤', '灰色', '/profile/upload/牛仔裤3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (17, '玛丽珍1.png', '玛丽珍', '灰色', '/profile/upload/玛丽珍1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (18, '玛丽珍2.png', '玛丽珍', '红色', '/profile/upload/玛丽珍2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (19, '玛丽珍3.png', '玛丽珍', '红色', '/profile/upload/玛丽珍3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (20, '皮鞋1.png', '皮鞋', '米色/浅色', '/profile/upload/皮鞋1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (21, '皮鞋2.png', '皮鞋', '米色/浅色', '/profile/upload/皮鞋2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (22, '皮鞋3.png', '皮鞋', '灰色', '/profile/upload/皮鞋3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (23, '短裤1.png', '短裤', '红色', '/profile/upload/短裤1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (24, '短裤2.png', '短裤', '灰色', '/profile/upload/短裤2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (25, '短裤3.png', '短裤', '黑色', '/profile/upload/短裤3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (26, '衬衫1.png', '衬衫', '灰色', '/profile/upload/衬衫1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (27, '衬衫2.png', '衬衫', '灰色', '/profile/upload/衬衫2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (28, '衬衫3.png', '衬衫', '蓝色', '/profile/upload/衬衫3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (29, '西装裤1.png', '西装裤', '灰色', '/profile/upload/西装裤1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (30, '西装裤2.png', '西装裤', '灰色', '/profile/upload/西装裤2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (31, '西装裤3.png', '西装裤', '黑色', '/profile/upload/西装裤3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (32, '运动背心1.png', '运动背心', '灰色', '/profile/upload/运动背心1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (33, '运动背心2.png', '运动背心', '红色', '/profile/upload/运动背心2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (34, '运动背心3.png', '运动背心', '黑色', '/profile/upload/运动背心3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (35, '运动鞋1.png', '运动鞋', '灰色', '/profile/upload/运动鞋1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (36, '运动鞋2.png', '运动鞋', '灰色', '/profile/upload/运动鞋2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (37, '运动鞋3.png', '运动鞋', '灰色', '/profile/upload/运动鞋3.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (38, '连衣裙1.png', '连衣裙', '蓝色', '/profile/upload/连衣裙1.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (39, '连衣裙2.png', '连衣裙', '灰色', '/profile/upload/连衣裙2.png', NULL, '0');
INSERT INTO `sys_wardrobe_item` VALUES (40, '连衣裙3.png', '连衣裙', '灰色', '/profile/upload/连衣裙3.png', NULL, '0');

-- ----------------------------
-- Table structure for wardrobe_item
-- ----------------------------
DROP TABLE IF EXISTS `wardrobe_item`;
CREATE TABLE `wardrobe_item`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '单品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '单品名称',
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '品类（上装/下装/鞋履/配饰/外套）',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '颜色',
  `season` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '季节（春秋/四季/冬季）',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `is_common` tinyint(1) NULL DEFAULT 0 COMMENT '是否常用（0否 1是）',
  `add_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `style` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '风格',
  `is_favorite` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '是否收藏 (0未收藏 1已收藏)',
  `img_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 51 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '衣橱单品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of wardrobe_item
-- ----------------------------
INSERT INTO `wardrobe_item` VALUES (8, '运动跑鞋', '鞋履', '白色', '四季', 699.00, 1, '2024-03-13 00:00:00', '', '', '2026-01-13 17:16:21', '', '2026-03-24 15:57:36', NULL, '0', '/profile/upload/运动鞋1.png');
INSERT INTO `wardrobe_item` VALUES (9, '连衣裙', '裙装', '蓝色', '春秋', 1299.00, 0, '2024-03-12 00:00:00', '', '', '2026-01-13 17:16:21', '', '2026-03-24 18:21:07', NULL, '0', '/profile/upload/连衣裙1.png');
INSERT INTO `wardrobe_item` VALUES (10, '拼接假两件长袖T恤', '上装', '白色', '夏季', 1599.00, 1, '2024-03-11 00:00:00', '', '', '2026-01-13 17:16:21', '', '2026-03-24 16:05:03', NULL, '0', '/profile/upload/T恤1.png');
INSERT INTO `wardrobe_item` VALUES (13, '黑色T恤', '上装', '黑色', '夏季', 199.00, 0, '2026-03-24 18:16:45', '', '', '2026-03-24 18:16:45', '', NULL, NULL, '0', '/profile/upload/2026/03/24/T恤3_20260324181611A003.png');
INSERT INTO `wardrobe_item` VALUES (14, '长款半身裙', '下装', '棕色', '四季', 269.00, 0, '2026-03-24 18:17:38', '', '', '2026-03-24 18:17:38', '', NULL, NULL, '0', '/profile/upload/2026/03/24/半身裙1_20260324181704A004.png');
INSERT INTO `wardrobe_item` VALUES (15, '短款半身裙', '下装', '黑色', '四季', 199.00, 0, '2026-03-24 18:18:22', '', '', '2026-03-24 18:18:22', '', NULL, NULL, '0', '/profile/upload/2026/03/24/半身裙2_20260324181754A005.png');
INSERT INTO `wardrobe_item` VALUES (16, '半身裙', '下装', '白色', '春秋', 299.00, 0, '2026-03-24 18:20:35', '', '', '2026-03-24 18:20:35', '', NULL, NULL, '0', '/profile/upload/2026/03/24/半身裙3_20260324181953A006.png');
INSERT INTO `wardrobe_item` VALUES (17, '垂感衬衣', '上装', '珍珠白', '春秋', 356.00, 0, '2026-03-24 18:25:38', '', '', '2026-03-24 18:25:38', '', NULL, NULL, '0', '/profile/upload/2026/03/24/衬衫1_20260324182454A007.png');
INSERT INTO `wardrobe_item` VALUES (18, '格子衬衣', '上装', '墨绿色', '春秋', 499.00, 0, '2026-03-24 18:29:10', '', '', '2026-03-24 18:29:10', '', NULL, NULL, '0', '/profile/upload/2026/03/24/衬衫2_20260324182825A008.png');
INSERT INTO `wardrobe_item` VALUES (19, '黑衬衫', '上装', '黑色', '四季', 199.00, 0, '2026-03-24 18:30:00', '', '', '2026-03-24 18:30:00', '', NULL, NULL, '0', '/profile/upload/2026/03/24/衬衫3_20260324182943A009.png');
INSERT INTO `wardrobe_item` VALUES (20, '工装短裤', '下装', '卡其色', '夏季', 329.00, 0, '2026-03-24 18:30:42', '', '', '2026-03-24 18:30:42', '', NULL, NULL, '0', '/profile/upload/2026/03/24/短裤1_20260324183014A010.png');
INSERT INTO `wardrobe_item` VALUES (21, '牛仔短裤', '下装', '莫兰迪灰', '夏季', 234.00, 0, '2026-03-24 18:32:39', '', '', '2026-03-24 18:32:39', '', NULL, NULL, '0', '/profile/upload/2026/03/24/短裤2_20260324183151A011.png');
INSERT INTO `wardrobe_item` VALUES (22, '运动短裤', '下装', '黑色', '夏季', 329.00, 0, '2026-03-24 18:38:00', '', '', '2026-03-24 18:38:00', '', NULL, NULL, '0', '/profile/upload/2026/03/24/短裤3_20260324183733A012.png');
INSERT INTO `wardrobe_item` VALUES (23, '美拉德开衫', '上装', '彩色', '四季', 499.00, 0, '2026-03-24 18:38:50', '', '', '2026-03-24 18:38:50', '', NULL, NULL, '0', '/profile/upload/2026/03/24/开衫2_20260324183820A013.png');
INSERT INTO `wardrobe_item` VALUES (24, '开衫', '上装', '薄荷绿', '春秋', 467.00, 0, '2026-03-24 18:40:00', '', '', '2026-03-24 18:40:00', '', NULL, NULL, '0', '/profile/upload/2026/03/24/开衫3_20260324183932A015.png');
INSERT INTO `wardrobe_item` VALUES (25, '开衫', '上装', '孔雀蓝', '春秋', 299.00, 0, '2026-03-24 18:40:46', '', '', '2026-03-24 18:40:46', '', NULL, NULL, '0', '/profile/upload/2026/03/24/开衫4_20260324184026A016.png');
INSERT INTO `wardrobe_item` VALUES (26, '连衣裙两件套', '裙装', '蓝色、棕色', '春秋', 599.00, 0, '2026-03-24 18:42:40', '', '', '2026-03-24 18:42:40', '', NULL, NULL, '0', '/profile/upload/2026/03/24/连衣裙2_20260324184107A017.png');
INSERT INTO `wardrobe_item` VALUES (27, '森系仙女连衣裙', '裙装', '浅绿色', '夏季', 399.00, 0, '2026-03-24 18:43:29', '', '', '2026-03-24 18:43:29', '', '2026-04-14 19:50:19', NULL, '0', '/profile/upload/2026/03/24/连衣裙3_20260324184259A018.png');
INSERT INTO `wardrobe_item` VALUES (28, '运动背心', '上装', '白色', '四季', 199.00, 0, '2026-03-24 18:46:42', '', '', '2026-03-24 18:46:42', '', NULL, NULL, '0', '/profile/upload/2026/03/24/运动背心1_20260324184621A020.png');
INSERT INTO `wardrobe_item` VALUES (29, '运动背心', '上装', '绿色', '四季', 199.00, 0, '2026-03-24 18:47:26', '', '', '2026-03-24 18:47:26', '', NULL, NULL, '0', '/profile/upload/2026/03/24/运动背心2_20260324184707A021.png');
INSERT INTO `wardrobe_item` VALUES (30, '运动背心', '上装', '黑色', '四季', 199.00, 0, '2026-03-24 18:47:59', '', '', '2026-03-24 18:47:59', '', NULL, NULL, '0', '/profile/upload/2026/03/24/运动背心3_20260324184741A022.png');
INSERT INTO `wardrobe_item` VALUES (31, '百搭西装裤', '下装', '灰色', '春秋', 199.00, 0, '2026-03-24 18:48:47', '', '', '2026-03-24 18:48:47', '', NULL, NULL, '0', '/profile/upload/2026/03/24/西装裤1_20260324184815A023.png');
INSERT INTO `wardrobe_item` VALUES (32, '经典西装裤', '上装', '黑色', '四季', 209.00, 0, '2026-03-24 18:49:28', '', '', '2026-03-24 18:49:28', '', NULL, NULL, '0', '/profile/upload/2026/03/24/西装裤2_20260324184904A024.png');
INSERT INTO `wardrobe_item` VALUES (33, '西装裤', '下装', '黑色', '春秋', 209.00, 0, '2026-03-24 18:50:08', '', '', '2026-03-24 18:50:08', '', NULL, NULL, '0', '/profile/upload/2026/03/24/西装裤3_20260324184950A025.png');
INSERT INTO `wardrobe_item` VALUES (34, '牛仔裤', '下装', '牛仔色', '春秋', 299.00, 0, '2026-03-24 18:50:58', '', '', '2026-03-24 18:50:58', '', NULL, NULL, '0', '/profile/upload/2026/03/24/牛仔裤2_20260324185028A026.png');
INSERT INTO `wardrobe_item` VALUES (35, '皮鞋', '鞋履', '黑色', '四季', 299.00, 0, '2026-03-24 18:51:35', '', '', '2026-03-24 18:51:35', '', NULL, NULL, '0', '/profile/upload/2026/03/24/玛丽珍1_20260324185109A027.png');
INSERT INTO `wardrobe_item` VALUES (36, '牛仔裤', '下装', '黑色', '春秋', 199.00, 0, '2026-03-24 18:52:13', '', '', '2026-03-24 18:52:13', '', NULL, NULL, '0', '/profile/upload/2026/03/24/牛仔裤3_20260324185151A028.png');
INSERT INTO `wardrobe_item` VALUES (37, '皮鞋', '鞋履', '黑色', '四季', 399.00, 0, '2026-03-24 18:52:55', '', '', '2026-03-24 18:52:55', '', NULL, NULL, '0', '/profile/upload/2026/03/24/皮鞋1_20260324185237A029.png');
INSERT INTO `wardrobe_item` VALUES (38, '潮流卫衣', '上装', '蓝色', '春秋', 203.00, 0, '2026-03-24 18:53:56', '', '', '2026-03-24 18:53:56', '', NULL, NULL, '0', '/profile/upload/2026/03/24/卫衣2_20260324185321A030.png');
INSERT INTO `wardrobe_item` VALUES (39, '白色玛丽珍', '鞋履', '米白色', '四季', 399.00, 0, '2026-03-24 18:54:29', '', '', '2026-03-24 18:54:29', '', NULL, NULL, '0', '/profile/upload/2026/03/24/玛丽珍2_20260324185410A031.png');
INSERT INTO `wardrobe_item` VALUES (40, '通勤小皮鞋', '鞋履', '棕色', '四季', 299.00, 0, '2026-03-24 18:55:08', '', '', '2026-03-24 18:55:08', '', NULL, NULL, '0', '/profile/upload/2026/03/24/皮鞋2_20260324185450A032.png');
INSERT INTO `wardrobe_item` VALUES (41, '薄底皮鞋', '鞋履', '黑色', '四季', 399.00, 0, '2026-03-24 18:55:40', '', '', '2026-03-24 18:55:40', '', NULL, NULL, '0', '/profile/upload/2026/03/24/皮鞋3_20260324185520A033.png');
INSERT INTO `wardrobe_item` VALUES (42, '玛丽珍', '鞋履', '白色', '春秋', 299.00, 0, '2026-03-24 18:56:16', '', '', '2026-03-24 18:56:16', '', NULL, NULL, '0', '/profile/upload/2026/03/24/玛丽珍3_20260324185554A034.png');
INSERT INTO `wardrobe_item` VALUES (43, '休闲跑步鞋', '鞋履', '灰色', '四季', 424.00, 0, '2026-03-24 18:58:13', '', '', '2026-03-24 18:58:13', '', NULL, NULL, '0', '/profile/upload/2026/03/24/运动鞋3_20260324185637A035.png');
INSERT INTO `wardrobe_item` VALUES (44, '运动鞋', '鞋履', '白色', '四季', 322.00, 0, '2026-03-24 18:58:51', '', '', '2026-03-24 18:58:51', '', NULL, NULL, '0', '/profile/upload/2026/03/24/运动鞋2_20260324185835A036.png');
INSERT INTO `wardrobe_item` VALUES (45, '休闲卫衣', '上装', '灰色', '春秋', 209.00, 0, '2026-03-24 18:59:30', '', '', '2026-03-24 18:59:30', '', NULL, NULL, '0', '/profile/upload/2026/03/24/卫衣3_20260324185908A037.png');
INSERT INTO `wardrobe_item` VALUES (46, '星星卫衣外套', '外套', '白色', '春秋', 499.00, 0, '2026-03-24 19:00:15', '', '', '2026-03-24 19:00:15', '', NULL, NULL, '0', '/profile/upload/2026/03/24/卫衣1_20260324185947A038.png');
INSERT INTO `wardrobe_item` VALUES (47, '修身白T恤', '上装', '米白色', '夏季', 299.00, 0, '2026-03-24 19:01:10', '', '', '2026-03-24 19:01:10', '', NULL, NULL, '0', '/profile/upload/2026/03/24/T恤2_20260324190049A039.png');
INSERT INTO `wardrobe_item` VALUES (48, '阔腿牛仔裤', '下装', '深蓝色', '春秋', 399.00, 0, '2026-03-24 19:02:08', '', '', '2026-03-24 19:02:08', '', NULL, NULL, '0', '/profile/upload/2026/03/24/牛仔裤1_20260324190144A040.png');
INSERT INTO `wardrobe_item` VALUES (49, '开衫', '上装', '灰色', '春秋', 299.00, 0, '2026-03-24 19:03:00', '', '', '2026-03-24 19:03:00', '', '2026-04-21 19:20:01', NULL, '0', '/profile/upload/2026/03/24/开衫1_20260324190238A041.png');
INSERT INTO `wardrobe_item` VALUES (50, '星星卫衣', '上装', '白色', '四季', 200.00, 0, '2026-04-14 19:51:15', '', '', '2026-04-14 19:51:15', '', '2026-04-14 19:52:05', NULL, '0', '/profile/upload/2026/04/14/雨天卫衣_20260414195113A001.png');


-- 添加浏览量字段
ALTER TABLE outfit_post ADD COLUMN view_count INT DEFAULT 0 COMMENT '浏览量';`clothes``clothing_comment`



SET FOREIGN_KEY_CHECKS = 1;
