<template>
  <div class="dashboard-editor-container">
    <!-- 小红书风格的顶部导航栏 -->
    <div class="xiaohongshu-header">
      <div class="header-left">
        <h1 class="logo">每日穿搭</h1>
      </div>
      <div class="header-search">
  <el-autocomplete
    v-model="searchKeyword"
    :fetch-suggestions="querySearch"
    placeholder="搜索穿搭、用户、品牌..."
    prefix-icon="el-icon-search"
    size="medium"
    clearable
    @select="handleSelect"
    @keyup.enter.native="handleSearch"
  >
    <template slot-scope="{ item }">
      <div class="search-suggestion">
        <i :class="item.icon"></i>
        <span>{{ item.value }}</span>
      </div>
    </template>
  </el-autocomplete>
  <el-button 
    type="primary" 
    icon="el-icon-search" 
    size="medium" 
    circle
    @click="handleSearch"
    :loading="isSearching"
  ></el-button>
</div>
      <div class="header-right">
        <el-button type="primary" icon="el-icon-upload" @click="showPublishDialog = true">
          发布穿搭
        </el-button>
        <el-badge :value="4" class="message-badge">
          <el-button 
             icon="el-icon-message" 
                    circle 
                    size="small"
              @click="handleMessage"
          ></el-button>
</el-badge>
        <el-avatar :src="avatar" size="medium"></el-avatar>
      </div>
    </div>

    <!-- 分类标签 -->
    <div class="category-tabs">
      <el-tabs v-model="activeCategory" @tab-click="handleCategoryChange">
        <el-tab-pane label="推荐" name="recommend"></el-tab-pane>
        <el-tab-pane label="最新" name="latest"></el-tab-pane>
        <el-tab-pane label="通勤风" name="business"></el-tab-pane>
        <el-tab-pane label="休闲风" name="casual"></el-tab-pane>
        <el-tab-pane label="运动风" name="sport"></el-tab-pane>
      </el-tabs>
    </div>

    <!-- 天气和AI推荐卡片 -->
    <el-row :gutter="20" class="weather-row">
      <el-col :span="6">
        <div class="weather-card">
          <i class="el-icon-sunny"></i>
          <div class="weather-info">
            <div class="city">郑州</div>
            <div class="temp">18-25°C 晴</div>
            <div class="tips">适宜薄外套</div>
          </div>
        </div>
      </el-col>
      <el-col :span="18">
      <div class="ai-recommend-card">
  <i class="el-icon-magic-stick"></i>
  <span class="label">AI穿搭推荐：</span>
  <span class="content">{{ currentRecommendation }}</span>
  <el-button type="text" icon="el-icon-refresh" @click="refreshRecommend">换一换</el-button>
</div>
      </el-col>
    </el-row>

    <!-- 瀑布流穿搭列表 -->
    <div class="waterfall-container">
      <!-- 左列 -->
      <div class="waterfall-column">
        <div v-for="(item, index) in leftPosts" :key="'left' + index" class="post-card">
          <el-card :body-style="{ padding: '0px' }" shadow="hover" @click="goToDetail(item)">
            <div class="post-image">
              <el-image 
                :src="item.image" 
                fit="cover"
                :preview-src-list="[item.image]"
              >
                <div slot="placeholder" class="image-placeholder">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
              <span class="multi-image-badge" v-if="item.multi">
                <i class="el-icon-picture"></i> {{ item.imageCount || 3 }}
              </span>
            </div>
            <div class="post-content">
              <h3 class="post-title">{{ item.title }}</h3>
              <div class="post-tags">
                <el-tag v-for="tag in item.tags" :key="tag" size="mini" effect="plain">
                  {{ tag }}
                </el-tag>
              </div>
              <div class="post-footer">
                <div class="user">
                  <el-avatar :src="item.avatar" size="small"></el-avatar>
                  <span class="username">{{ item.username }}</span>
                </div>
                <div class="stats">
                  <span><i class="el-icon-star-off"></i> {{ item.likes }}</span>
                  <span><i class="el-icon-chat-dot-round"></i> {{ item.comments }}</span>
                </div>
              </div>
              <!-- 每个卡片都有操作按钮 -->
              <div class="post-actions">
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isLiked ? 'el-icon-star-on' : 'el-icon-star-off'"
                  :class="{ 'liked': item.isLiked }"
                  @click.stop="toggleLike(item)"
                >
                  {{ item.isLiked ? '已赞' : '点赞' }}
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  icon="el-icon-chat-dot-round"
                  @click.stop="openCommentDialog(item)"
                >
                  评论
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isCollected ? 'el-icon-collection-tag' : 'el-icon-collection'"
                  :class="{ 'collected': item.isCollected }"
                  @click.stop="toggleCollect(item)"
                >
                  {{ item.isCollected ? '已收藏' : '收藏' }}
                </el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>

      <!-- 中列 -->
      <div class="waterfall-column">
        <div v-for="(item, index) in centerPosts" :key="'center' + index" class="post-card">
          <el-card :body-style="{ padding: '0px' }" shadow="hover" @click="goToDetail(item)">
            <div class="post-image">
              <el-image :src="item.image" fit="cover">
                <div slot="placeholder" class="image-placeholder">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
              <span class="multi-image-badge" v-if="item.multi">
                <i class="el-icon-picture"></i> {{ item.imageCount || 3 }}
              </span>
            </div>
            <div class="post-content">
              <h3 class="post-title">{{ item.title }}</h3>
              <div class="post-tags">
                <el-tag v-for="tag in item.tags" :key="tag" size="mini" effect="plain">
                  {{ tag }}
                </el-tag>
              </div>
              <div class="post-footer">
                <div class="user">
                  <el-avatar :src="item.avatar" size="small"></el-avatar>
                  <span class="username">{{ item.username }}</span>
                </div>
                <div class="stats">
                  <span><i class="el-icon-star-off"></i> {{ item.likes }}</span>
                  <span><i class="el-icon-chat-dot-round"></i> {{ item.comments }}</span>
                </div>
              </div>
              <!-- 每个卡片都有操作按钮 -->
              <div class="post-actions">
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isLiked ? 'el-icon-star-on' : 'el-icon-star-off'"
                  :class="{ 'liked': item.isLiked }"
                  @click.stop="toggleLike(item)"
                >
                  {{ item.isLiked ? '已赞' : '点赞' }}
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  icon="el-icon-chat-dot-round"
                  @click.stop="openCommentDialog(item)"
                >
                  评论
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isCollected ? 'el-icon-collection-tag' : 'el-icon-collection'"
                  :class="{ 'collected': item.isCollected }"
                  @click.stop="toggleCollect(item)"
                >
                  {{ item.isCollected ? '已收藏' : '收藏' }}
                </el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>

      <!-- 右列 -->
      <div class="waterfall-column">
        <div v-for="(item, index) in rightPosts" :key="'right' + index" class="post-card">
          <el-card :body-style="{ padding: '0px' }" shadow="hover" @click="goToDetail(item)">
            <div class="post-image">
              <el-image :src="item.image" fit="cover">
                <div slot="placeholder" class="image-placeholder">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
              <span class="multi-image-badge" v-if="item.multi">
                <i class="el-icon-picture"></i> {{ item.imageCount || 3 }}
              </span>
            </div>
            <div class="post-content">
              <h3 class="post-title">{{ item.title }}</h3>
              <div class="post-tags">
                <el-tag v-for="tag in item.tags" :key="tag" size="mini" effect="plain">
                  {{ tag }}
                </el-tag>
              </div>
              <div class="post-footer">
                <div class="user">
                  <el-avatar :src="item.avatar" size="small"></el-avatar>
                  <span class="username">{{ item.username }}</span>
                </div>
                <div class="stats">
                  <span><i class="el-icon-star-off"></i> {{ item.likes }}</span>
                  <span><i class="el-icon-chat-dot-round"></i> {{ item.comments }}</span>
                </div>
              </div>
              <!-- 每个卡片都有操作按钮 -->
              <div class="post-actions">
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isLiked ? 'el-icon-star-on' : 'el-icon-star-off'"
                  :class="{ 'liked': item.isLiked }"
                  @click.stop="toggleLike(item)"
                >
                  {{ item.isLiked ? '已赞' : '点赞' }}
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  icon="el-icon-chat-dot-round"
                  @click.stop="openCommentDialog(item)"
                >
                  评论
                </el-button>
                <el-button 
                  type="text" 
                  size="mini" 
                  :icon="item.isCollected ? 'el-icon-collection-tag' : 'el-icon-collection'"
                  :class="{ 'collected': item.isCollected }"
                  @click.stop="toggleCollect(item)"
                >
                  {{ item.isCollected ? '已收藏' : '收藏' }}
                </el-button>
              </div>
            </div>
          </el-card>
        </div>
      </div>
    </div>

    <!-- 加载更多 -->
    <div class="load-more" @click="loadMore">
      <el-button type="text" icon="el-icon-refresh" :loading="loading">
        {{ loading ? '加载中...' : '点击加载更多' }}
      </el-button>
    </div>

   <!-- 发布穿搭弹窗 -->
<el-dialog 
  title="发布穿搭" 
  :visible.sync="showPublishDialog" 
  width="500px"
  :append-to-body="true"
  :close-on-click-modal="false"
  @close="handlePublishClose"
>
  <el-form :model="publishForm" label-width="80px">
    <el-form-item label="标题" required>
      <el-input v-model="publishForm.title" placeholder="给穿搭起个标题吧"></el-input>
    </el-form-item>
    
    <el-form-item label="描述" required>
      <el-input 
        v-model="publishForm.description" 
        type="textarea" 
        :rows="3"
        placeholder="描述一下你的穿搭..."
      ></el-input>
    </el-form-item>
    
    <el-form-item label="上传图片" required>
      <el-upload
        ref="upload"
        action="#"
        list-type="picture-card"
        :auto-upload="false"
        :limit="1"
        :on-change="handleImageChange"
        :on-remove="handleImageRemove"
        :file-list="imageList"
      >
        <i slot="default" class="el-icon-plus"></i>
        <div slot="file" slot-scope="{file}">
          <img class="el-upload-list__item-thumbnail" :src="file.url" alt="" />
          <span class="el-upload-list__item-actions">
            <span class="el-upload-list__item-delete" @click="handleRemove(file)">
              <i class="el-icon-delete"></i>
            </span>
          </span>
        </div>
      </el-upload>
      <div class="upload-tip">请上传1张图片，支持jpg、png格式</div>
    </el-form-item>
    
    <el-form-item label="标签">
      <el-select v-model="publishForm.tags" multiple placeholder="选择穿搭风格" filterable allow-create>
        <el-option label="通勤风" value="通勤风"></el-option>
        <el-option label="休闲风" value="休闲风"></el-option>
        <el-option label="运动风" value="运动风"></el-option>
        <el-option label="约会穿搭" value="约会穿搭"></el-option>
        <el-option label="简约风" value="简约风"></el-option>
        <el-option label="甜美风" value="甜美风"></el-option>
        <el-option label="显瘦" value="显瘦"></el-option>
        <el-option label="显高" value="显高"></el-option>
      </el-select>
    </el-form-item>
  </el-form>
  
  <span slot="footer">
    <el-button @click="showPublishDialog = false">取消</el-button>
    <el-button type="primary" @click="publishPost" :disabled="!canPublish">发布</el-button>
  </span>
</el-dialog>

       <!-- 评论弹窗组件 -->
      <CommentDialog 
      :visible="showCommentDialog"
      :post="currentCommentPost"
      @close="showCommentDialog = false"
      @update:visible="val => showCommentDialog = val"
    />
  </div>  <!-- 这是您原有的最后一个 div -->
</template>


<script>

import CommentDialog from '@/views/outfit/outfit/components/CommentDialog.vue'
import {
  getPosts,
  createPost,
  togglePostLike,
  togglePostCollect,
  getComments,
  addComment,
  getCurrentUser
} from '@/api/outfitApi'

export default {
  name: "Index",
  components: {
    CommentDialog  
  },
 data() {
  return {
    searchKeyword: '',
    activeCategory: 'recommend',
    showPublishDialog: false,
    publishForm: {
      title: '',
      description: '',
      tags: []
    },
    imageList: [],
    uploadImage: null,
    loading: false,
    avatar: '/images/头像8.png',
    
    // 搜索相关
    searchResults: [],
    isSearching: false,
    searchHistory: [],
    
    // AI穿搭推荐
    currentRecommendation: '浅杏色针织衫 + 深灰九分裤', // 默认推荐
    
    // 存储所有分类的帖子数据
    categoryPosts: {
      recommend: {
        left: [],
        center: [],
        right: []
      },
      latest: {
        left: [],
        center: [],
        right: []
      },
      business: {
        left: [],
        center: [],
        right: []
      },
      casual: {
        left: [],
        center: [],
        right: []
      },
      sport: {
        left: [],
        center: [],
        right: []
      }
    },
    
    // 当前显示的帖子（根据activeCategory从categoryPosts中获取）
    leftPosts: [],
    centerPosts: [],
    rightPosts: [],
    
    showCommentDialog: false,
    currentCommentPost: null,
    publishCounter: 0
  };
},
  computed: {
    canPublish() {
      return this.publishForm.title && 
             this.publishForm.description && 
             this.imageList.length > 0;
    }
  },
  created() {
    // 初始化所有分类的帖子数据
    this.initCategoryPosts();
    // 显示默认分类（推荐）
    this.showCategoryPosts('recommend');
  },
  methods: {
  // 初始化各分类的帖子数据
  initCategoryPosts() {
    // 推荐分类的帖子
    this.categoryPosts.recommend = {
      left: [
        {
          id: 1,
          image: '/images/通勤风简约.png',
          title: '通勤穿搭｜简约又不失高级感',
          tags: ['通勤风', '简约'],
          avatar: '/images/头像1.png',
          username: '时尚小咖',
          likes: 234,
          comments: 45,
          isLiked: false,
          isCollected: false,
          multi: true,
          imageCount: 3,
          category: 'recommend',
          commentList: [
            {
              id: 101,
              user: { name: '明天不上班', avatar: '/images/头像2.png' },
              content: '第一套有链接吗姐妹！求求了！！',
              time: '2小时前',
              likes: 24,
              isLiked: false
            }
          ]
        },
        {
          id: 4,
          image: '/images/通勤风西装.png',
          title: '西装外套的多种搭配',
          tags: ['通勤风', '西装'],
          avatar: '/images/头像4.png',
          username: '职场丽人',
          likes: 876,
          comments: 123,
          isLiked: false,
          isCollected: false,
          category: 'recommend',
          commentList: [
            {
              id: 401,
              user: { name: '今天星期几', avatar: '/images/头像2.png' },
              content: '被种草了！！姐妹好会穿',
              time: '5分钟前',
              likes: 12,
              isLiked: false
            }
          ]
        }
      ],
      center: [
        {
          id: 2,
          image: '/images/简约黑白.png',
          title: '黑白配经典永不过时',
          tags: ['简约', '黑白'],
          avatar: '/images/头像2.png',
          username: '搭配师小林',
          likes: 432,
          comments: 67,
          isLiked: false,
          isCollected: false,
          category: 'recommend',
          commentList: [
            {
              id: 201,
              user: { name: '不想上班', avatar: '/images/头像3.png' },
              content: '黑白yyds！永远不会出错',
              time: '15分钟前',
              likes: 18,
              isLiked: false
            }
          ]
        },
        {
          id: 5,
          image: '/images/显高.png',
          title: '显高显瘦穿搭公式',
          tags: ['显瘦', '技巧'],
          avatar: '/images/头像5.png',
          username: '穿搭技巧',
          likes: 987,
          comments: 156,
          isLiked: false,
          isCollected: false,
          category: 'recommend',
          commentList: [
            {
              id: 501,
              user: { name: '150小个子', avatar: '/images/头像1.png' },
              content: '本矮子星人狂喜！！立马收藏',
              time: '8分钟前',
              likes: 43,
              isLiked: false
            }
          ]
        }
      ],
      right: [
        {
          id: 3,
          image: '/images/实用白衬衫.png',
          title: '一衣多穿｜白衬衫的7种搭配',
          tags: ['实用', '白衬衫'],
          avatar: '/images/头像3.png',
          username: '极简生活',
          likes: 654,
          comments: 98,
          isLiked: false,
          isCollected: false,
          category: 'recommend',
          commentList: [
            {
              id: 301,
              user: { name: '抠搜打工人', avatar: '/images/头像2.png' },
              content: '白衬衫真的百搭！！衣柜必备',
              time: '20分钟前',
              likes: 16,
              isLiked: false
            }
          ]
        },
        {
          id: 6,
          image: '/images/温柔甜美.png',
          title: '周末约会装，温柔甜美风',
          tags: ['约会', '甜美'],
          avatar: '/images/头像6.png',
          username: '穿搭日记',
          likes: 567,
          comments: 89,
          isLiked: false,
          isCollected: false,
          category: 'recommend',
          commentList: [
            {
              id: 601,
              user: { name: '恋爱ing', avatar: '/images/头像4.png' },
              content: '刚和男朋友分手 看到这个又想谈恋爱了',
              time: '12分钟前',
              likes: 34,
              isLiked: false
            }
          ]
        }
      ]
    };
    
    // 通勤风分类的帖子
    this.categoryPosts.business = {
      left: [
        {
          id: 101,
          image: '/images/通勤风简约.png',
          title: '职场通勤｜简约气质穿搭',
          tags: ['通勤风', '职场'],
          avatar: '/images/头像1.png',
          username: '职场穿搭指南',
          likes: 567,
          comments: 89,
          isLiked: false,
          isCollected: false,
          category: 'business',
          commentList: [
            {
              id: 1101,
              user: { name: '打工人', avatar: '/images/头像2.png' },
              content: '太适合上班穿了！',
              time: '1小时前',
              likes: 23,
              isLiked: false
            }
          ]
        }
      ],
      center: [
        {
          id: 102,
          image: '/images/通勤风西装.png',
          title: '西装穿搭｜一周不重样',
          tags: ['通勤风', '西装'],
          avatar: '/images/头像4.png',
          username: '职场丽人',
          likes: 432,
          comments: 56,
          isLiked: false,
          isCollected: false,
          category: 'business',
          commentList: [
            {
              id: 1102,
              user: { name: '周一不想上班', avatar: '/images/头像3.png' },
              content: '图三的西装有链接吗',
              time: '3小时前',
              likes: 12,
              isLiked: false
            }
          ]
        }
      ],
      right: [
        {
          id: 103,
          image: '/images/显高.png',
          title: '显高显瘦｜小个子通勤穿搭',
          tags: ['通勤风', '小个子'],
          avatar: '/images/头像5.png',
          username: '小个子穿搭',
          likes: 789,
          comments: 134,
          isLiked: false,
          isCollected: false,
          category: 'business',
          commentList: [
            {
              id: 1103,
              user: { name: '158小个子', avatar: '/images/头像6.png' },
              content: '终于找到适合小个子的通勤装了！',
              time: '30分钟前',
              likes: 45,
              isLiked: false
            }
          ]
        }
      ]
    };
    
    // 休闲风分类的帖子
    this.categoryPosts.casual = {
      left: [
        {
          id: 201,
          image: '/images/简约黑白.png',
          title: '周末休闲｜舒服又时髦',
          tags: ['休闲风', '周末'],
          avatar: '/images/头像2.png',
          username: '休闲穿搭',
          likes: 345,
          comments: 45,
          isLiked: false,
          isCollected: false,
          category: 'casual',
          commentList: [
            {
              id: 1201,
              user: { name: '周末去哪玩', avatar: '/images/头像3.png' },
              content: '这套逛街穿正合适',
              time: '2小时前',
              likes: 12,
              isLiked: false
            }
          ]
        }
      ],
      center: [
        {
          id: 202,
          image: '/images/温柔甜美.png',
          title: '约会休闲｜甜美温柔风',
          tags: ['休闲风', '约会'],
          avatar: '/images/头像6.png',
          username: '约会穿搭',
          likes: 678,
          comments: 98,
          isLiked: false,
          isCollected: false,
          category: 'casual',
          commentList: [
            {
              id: 1202,
              user: { name: '恋爱中', avatar: '/images/头像4.png' },
              content: '男朋友说这套很好看！',
              time: '1天前',
              likes: 67,
              isLiked: false
            }
          ]
        }
      ],
      right: [
        {
          id: 203,
          image: '/images/实用白衬衫.png',
          title: '白衬衫的休闲穿法',
          tags: ['休闲风', '白衬衫'],
          avatar: '/images/头像3.png',
          username: '极简生活',
          likes: 234,
          comments: 34,
          isLiked: false,
          isCollected: false,
          category: 'casual',
          commentList: [
            {
              id: 1203,
              user: { name: '简约控', avatar: '/images/头像5.png' },
              content: '白衬衫真的百搭',
              time: '5小时前',
              likes: 8,
              isLiked: false
            }
          ]
        }
      ]
    };
    
    // 运动风分类的帖子
    this.categoryPosts.sport = {
      left: [
        {
          id: 301,
          image: '/images/显高.png',
          title: '运动休闲｜健身房穿搭',
          tags: ['运动风', '健身'],
          avatar: '/images/头像5.png',
          username: '健身穿搭',
          likes: 456,
          comments: 67,
          isLiked: false,
          isCollected: false,
          category: 'sport',
          commentList: [
            {
              id: 1301,
              user: { name: '健身小白', avatar: '/images/头像4.png' },
              content: '这套瑜伽服有链接吗',
              time: '4小时前',
              likes: 15,
              isLiked: false
            }
          ]
        }
      ],
      center: [
        {
          id: 302,
          image: '/images/温柔甜美.png',
          title: '运动风也可以很甜美',
          tags: ['运动风', '甜美'],
          avatar: '/images/头像6.png',
          username: '运动女孩',
          likes: 567,
          comments: 78,
          isLiked: false,
          isCollected: false,
          category: 'sport',
          commentList: [
            {
              id: 1302,
              user: { name: '跑步爱好者', avatar: '/images/头像1.png' },
              content: '运动装也能这么好看',
              time: '2小时前',
              likes: 23,
              isLiked: false
            }
          ]
        }
      ],
      right: [
        {
          id: 303,
          image: '/images/简约黑白.png',
          title: '黑白运动风｜经典搭配',
          tags: ['运动风', '黑白'],
          avatar: '/images/头像2.png',
          username: '运动博主',
          likes: 789,
          comments: 123,
          isLiked: false,
          isCollected: false,
          category: 'sport',
          commentList: [
            {
              id: 1303,
              user: { name: '黑白控', avatar: '/images/头像3.png' },
              content: '黑白配永远的神',
              time: '1小时前',
              likes: 34,
              isLiked: false
            }
          ]
        }
      ]
    };
    
    // 最新分类（复制推荐的数据）
    this.categoryPosts.latest = JSON.parse(JSON.stringify(this.categoryPosts.recommend));
    this.categoryPosts.latest.left.forEach(item => item.id += 1000);
    this.categoryPosts.latest.center.forEach(item => item.id += 1000);
    this.categoryPosts.latest.right.forEach(item => item.id += 1000);
  },
  
  // 显示指定分类的帖子
  showCategoryPosts(category) {
    const categoryData = this.categoryPosts[category];
    if (categoryData) {
      this.leftPosts = categoryData.left || [];
      this.centerPosts = categoryData.center || [];
      this.rightPosts = categoryData.right || [];
    }
  },
  
  // 消息通知
  handleMessage() {
    const h = this.$createElement;
    
    // 消息列表数据
    const messages = [
      {
        id: 1,
        type: 'like',
        icon: 'el-icon-star-on',
        iconColor: '#ff6b6b',
        content: '时尚小咖 赞了你的穿搭',
        time: '5分钟前',
        avatar: '/images/头像1.png'
      },
      {
        id: 2,
        type: 'comment',
        icon: 'el-icon-chat-dot-round',
        iconColor: '#409eff',
        content: '职场丽人 评论了你的帖子：这套真好看！',
        time: '1小时前',
        avatar: '/images/头像4.png'
      },
      {
        id: 3,
        type: 'follow',
        icon: 'el-icon-user',
        iconColor: '#67c23a',
        content: '搭配师小林 关注了你',
        time: '3小时前',
        avatar: '/images/头像2.png'
      },
      {
        id: 4,
        type: 'system',
        icon: 'el-icon-bell',
        iconColor: '#e6a23c',
        content: '系统通知：你的穿搭被推荐到首页',
        time: '昨天',
        avatar: ''
      }
    ];
    
    // 构建消息列表
    const messageItems = messages.map(msg => 
      h('div', {
        class: 'message-item',
        on: {
          click: () => {
            this.$msgbox.close();
            this.$message.info(`查看消息：${msg.content}`);
          }
        }
      }, [
        msg.avatar ? 
          h('el-avatar', {
            props: { src: msg.avatar, size: 'small' }
          }) : 
          h('div', { class: 'message-icon ' + msg.type }, [
            h('i', { class: msg.icon, style: { color: msg.iconColor } })
          ]),
        h('div', { class: 'message-content' }, [
          h('div', { class: 'message-text' }, msg.content),
          h('div', { class: 'message-time' }, msg.time)
        ])
      ])
    );
    
    // 添加查看全部按钮
    messageItems.push(
      h('div', { class: 'message-footer' }, [
        h('el-button', {
          props: { type: 'text', size: 'small' },
          on: {
            click: () => {
              this.$msgbox.close();
              this.$message.info('查看全部消息');
            }
          }
        }, '查看全部消息')
      ])
    );
    
    this.$msgbox({
      title: '消息通知',
      message: h('div', { class: 'message-list' }, messageItems),
      showConfirmButton: false,
      showCancelButton: true,
      cancelButtonText: '关闭',
      customClass: 'message-dialog'
    }).catch(() => {});
  },
  
  // 搜索方法
  handleSearch() {
    if (!this.searchKeyword.trim()) {
      this.$message.warning('请输入搜索关键词');
      return;
    }
    
    this.isSearching = true;
    const keyword = this.searchKeyword.toLowerCase().trim();
    
    // 保存搜索历史
    if (!this.searchHistory.includes(keyword)) {
      this.searchHistory.unshift(keyword);
      if (this.searchHistory.length > 5) {
        this.searchHistory.pop();
      }
    }
    
    // 搜索结果
    const results = [];
    
    // 遍历所有分类的所有帖子
    Object.keys(this.categoryPosts).forEach(category => {
      ['left', 'center', 'right'].forEach(column => {
        this.categoryPosts[category][column].forEach(post => {
          // 搜索标题、标签、用户名
          const matchesTitle = post.title.toLowerCase().includes(keyword);
          const matchesTags = post.tags.some(tag => tag.toLowerCase().includes(keyword));
          const matchesUsername = post.username.toLowerCase().includes(keyword);
          
          if (matchesTitle || matchesTags || matchesUsername) {
            results.push({
              ...post,
              matchType: matchesTitle ? '标题' : (matchesTags ? '标签' : '用户'),
              category: category
            });
          }
        });
      });
    });
    
    this.searchResults = results;
    this.isSearching = false;
    
    if (results.length === 0) {
      this.$message.info(`未找到与"${keyword}"相关的内容`);
    } else {
      this.$message.success(`找到 ${results.length} 条相关内容`);
      this.showSearchResults();
    }
  },
  
  // 显示搜索结果
  showSearchResults() {
    const h = this.$createElement;
    const results = this.searchResults.map(item => 
      h('div', {
        class: 'search-result-item',
        on: {
          click: () => {
            this.$msgbox.close();
            this.goToDetail(item);
          }
        }
      }, [
        h('img', {
          attrs: { src: item.image },
          class: 'search-result-img'
        }),
        h('div', { class: 'search-result-info' }, [
          h('div', { class: 'search-result-title' }, item.title),
          h('div', { class: 'search-result-meta' }, 
            `匹配: ${item.matchType} · ${item.username} · ${item.likes}赞`
          )
        ])
      ])
    );
    
    this.$msgbox({
      title: '搜索结果',
      message: h('div', { class: 'search-results' }, results),
      showConfirmButton: false,
      showCancelButton: true,
      cancelButtonText: '关闭',
      customClass: 'search-results-dialog'
    }).catch(() => {});
  },
  
  // 搜索建议
  querySearch(queryString, cb) {
    if (!queryString) {
      cb([]);
      return;
    }
    
    const suggestions = [];
    const keyword = queryString.toLowerCase();
    
    // 从所有帖子中提取建议
    Object.keys(this.categoryPosts).forEach(category => {
      ['left', 'center', 'right'].forEach(column => {
        this.categoryPosts[category][column].forEach(post => {
          // 标题建议
          if (post.title.toLowerCase().includes(keyword) && 
              !suggestions.some(s => s.value === post.title)) {
            suggestions.push({
              value: post.title,
              icon: 'el-icon-document',
              type: '标题'
            });
          }
          
          // 标签建议
          post.tags.forEach(tag => {
            if (tag.toLowerCase().includes(keyword) && 
                !suggestions.some(s => s.value === tag)) {
              suggestions.push({
                value: tag,
                icon: 'el-icon-collection-tag',
                type: '标签'
              });
            }
          });
          
          // 用户名建议
          if (post.username.toLowerCase().includes(keyword) && 
              !suggestions.some(s => s.value === post.username)) {
            suggestions.push({
              value: post.username,
              icon: 'el-icon-user',
              type: '用户'
            });
          }
        });
      });
    });
    
    // 限制建议数量
    cb(suggestions.slice(0, 8));
  },
  
  // 选择搜索建议
  handleSelect(item) {
    this.searchKeyword = item.value;
    this.handleSearch();
  },
  
  // 清除搜索
  clearSearch() {
    this.searchKeyword = '';
    this.searchResults = [];
    this.showCategoryPosts(this.activeCategory);
  },
  
  // 监听搜索输入，按回车搜索
  handleSearchEnter() {
    this.handleSearch();
  },
  
  // 使用搜索历史
  useSearchHistory(keyword) {
    this.searchKeyword = keyword;
    this.handleSearch();
  },
  
  // 清除搜索历史
  clearSearchHistory() {
    this.searchHistory = [];
    this.$message.success('搜索历史已清除');
  },
  
  handleCategoryChange(tab) {
    const category = tab.name;
    this.activeCategory = category;
    this.showCategoryPosts(category);
    this.$message.success(`切换到${tab.label}分类`);
  },
  
 refreshRecommend() {
  // 获取当前天气（假设从weather-card获取）
  const weather = this.getCurrentWeather();
  
  // 根据天气推荐穿搭
  
  let recommendations = [];
  
  if (weather.includes('晴')) {
    recommendations = [
      '浅色T恤 + 牛仔短裤',
      '碎花连衣裙 + 草帽',
      'POLO衫 + 卡其裤',
      '防晒衣 + 运动裤'
    ];
  } else if (weather.includes('雨')) {
    recommendations = [
      '防水风衣 + 牛仔裤',
      '雨靴 + 休闲装',
      '连帽卫衣 + 运动裤',
      '短靴 + 长裙'
    ];
  } else if (weather.includes('冷') || weather.includes('冬')) {
    recommendations = [
      '羽绒服 + 高领毛衣',
      '羊毛大衣 + 围巾',
      '加绒卫衣 + 棉裤',
      '皮草外套 + 长靴'
    ];
  } else {
    recommendations = [
      '针织衫 + 直筒裤',
      '衬衫 + 半身裙',
      '卫衣 + 工装裤',
      '西装外套 + 牛仔裤'
    ];
  }
  
  // 随机选择
  const randomIndex = Math.floor(Math.random() * recommendations.length);
  this.currentRecommendation = recommendations[randomIndex];
  
  // 显示动画效果
  this.$message({
    message: 'AI已为您更新穿搭推荐',
    type: 'success',
    iconClass: 'el-icon-magic-stick',
    duration: 1500
  });
},

// 获取当前天气（需要根据您的实际天气数据来）
getCurrentWeather() {
  // 这里可以从weather-card获取天气信息
  // 简单示例：
  const weatherCard = document.querySelector('.weather-info .temp');
  return weatherCard ? weatherCard.textContent : '晴';
},
  
  toggleLike(item) {
    item.isLiked = !item.isLiked;
    if (item.isLiked) {
      item.likes++;
      this.$message.success('点赞成功');
    } else {
      item.likes--;
      this.$message.info('已取消点赞');
    }
  },
  
  toggleCollect(item) {
    item.isCollected = !item.isCollected;
    if (item.isCollected) {
      this.$message.success('收藏成功');
    } else {
      this.$message.info('已取消收藏');
    }
  },
  
  openCommentDialog(item) {
    console.log('打开评论:', item)
    this.currentCommentPost = item
    this.showCommentDialog = true
  },
  
  handleAddComment(content) {
    if (!this.currentCommentPost || !content.trim()) return;
    
    const newComment = {
      id: Date.now(),
      user: {
        name: '当前用户',
        avatar: this.avatar || '/images/默认头像.png'
      },
      content: content,
      time: '刚刚',
      likes: 0,
      isLiked: false
    };
    
    if (!this.currentCommentPost.commentList) {
      this.$set(this.currentCommentPost, 'commentList', []);
    }
    
    this.currentCommentPost.commentList.push(newComment);
    this.currentCommentPost.comments++;
    
    this.$message.success('评论发表成功');
  },
  
  handleImageChange(file, fileList) {
    this.imageList = fileList;
    if (file.raw) {
      this.uploadImage = URL.createObjectURL(file.raw);
    }
  },
  
  handleImageRemove(file, fileList) {
    this.imageList = fileList;
    if (fileList.length === 0) {
      this.uploadImage = null;
    }
  },
  
  handleRemove(file) {
    this.$refs.upload.handleRemove(file);
  },
  
  handlePublishClose() {
    this.imageList = [];
    this.uploadImage = null;
    this.publishForm = {
      title: '',
      description: '',
      tags: []
    };
  },
  
  publishPost() {
    if (!this.publishForm.title) {
      this.$message.warning('请输入标题');
      return;
    }
    
    if (!this.publishForm.description) {
      this.$message.warning('请输入描述');
      return;
    }
    
    if (this.imageList.length === 0) {
      this.$message.warning('请上传图片');
      return;
    }
    
    // 创建新帖子
    const newPost = {
      id: Date.now(),
      image: this.uploadImage || '/images/默认穿搭.png',
      title: this.publishForm.title,
      description: this.publishForm.description,
      tags: this.publishForm.tags.length ? this.publishForm.tags : ['新发布'],
      avatar: this.avatar,
      username: '当前用户',
      likes: 0,
      comments: 0,
      isLiked: false,
      isCollected: false,
      multi: false,
      category: this.activeCategory,
      commentList: []
    };
    
    // 轮播添加：左 -> 中 -> 右
    const columnIndex = this.publishCounter % 3;
    
    // 添加到当前分类的数据中
    if (columnIndex === 0) {
      this.categoryPosts[this.activeCategory].left.push(newPost);
    } else if (columnIndex === 1) {
      this.categoryPosts[this.activeCategory].center.push(newPost);
    } else {
      this.categoryPosts[this.activeCategory].right.push(newPost);
    }
    
    // 更新当前显示的帖子
    this.showCategoryPosts(this.activeCategory);
    
    // 计数器加1
    this.publishCounter++;
    
    // 关闭弹窗并重置表单
    this.showPublishDialog = false;
    this.publishForm = {
      title: '',
      description: '',
      tags: []
    };
    this.imageList = [];
    this.uploadImage = null;
    
    this.$message.success('发布成功！');
  },
  
  loadMore() {
    this.loading = true;
    setTimeout(() => {
      const newPost = {
        id: Date.now(),
        image: '/images/温柔风.png',
        title: '新穿搭' + (Math.random() * 100).toFixed(0),
        tags: ['新潮', '时尚'],
        avatar: '/images/头像10.png',
        username: '新用户',
        likes: Math.floor(Math.random() * 500),
        comments: Math.floor(Math.random() * 100),
        isLiked: false,
        isCollected: false,
        category: this.activeCategory,
        commentList: []
      };
      
      const random = Math.floor(Math.random() * 3);
      if (random === 0) {
        this.categoryPosts[this.activeCategory].left.push(newPost);
        this.leftPosts.push(newPost);
      } else if (random === 1) {
        this.categoryPosts[this.activeCategory].center.push(newPost);
        this.centerPosts.push(newPost);
      } else {
        this.categoryPosts[this.activeCategory].right.push(newPost);
        this.rightPosts.push(newPost);
      }
      
      this.loading = false;
      this.$message.success('加载成功');
    }, 1000);
  },
  
  goToDetail(item) {
    this.$router.push({
      path: '/outfit/outfit/detail',
      query: { post: JSON.stringify(item) }
    })
  }
}
};
</script>

<style lang="scss" scoped>

.dashboard-editor-container {
  padding: 30px;
  position: relative;
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", sans-serif;
  overflow: hidden;
  background-color: #f0f2f5;

  &::before {
    content: "";
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 0;
    background: 
      radial-gradient(circle at 20% 30%, rgba(255, 228, 196, 0.4) 0%, transparent 40%),
      radial-gradient(circle at 80% 20%, rgba(255, 228, 196, 0.4) 0%, transparent 40%),
      radial-gradient(circle at 50% 80%, rgba(255, 228, 196, 0.4) 0%, transparent 50%),
      radial-gradient(circle at 10% 90%, rgba(255, 228, 196, 0.4) 0%, transparent 40%);
    filter: blur(80px);
    transform: scale(1.2);
  }

  & > * {
    position: relative;
    z-index: 1;
  }
}

.xiaohongshu-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(255, 255, 255, 0.4);
  padding: 15px 30px;
  border-radius: 12px;
  margin-bottom: 25px;
  position: sticky;
  top: 0;
  z-index: 100;

  .logo {
    font-family: "Optima", "Playfair Display", serif;
    letter-spacing: 2px;
    font-size: 24px;
    background: linear-gradient(135deg, #333, #666);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  .header-search {
    display: flex;
    align-items: center;
    gap: 8px;
    
    ::v-deep .el-autocomplete {
      width: 300px;
      
      .el-input__inner {
        background-color: rgba(255, 255, 255, 0.5);
        border: 1px solid rgba(255, 255, 255, 0.3);
        transition: all 0.3s;
        
        &:focus {
          background-color: #fff;
          width: 350px;
        }
      }
    }
  }

  .header-right {
    display: flex;
    align-items: center;
    gap: 15px;
  }
}

.category-tabs {
  background: white;
  padding: 0 24px;
  border-radius: 8px;
  margin-bottom: 20px;
  
  ::v-deep .el-tabs__nav-wrap::after {
    height: 0;
  }
  
  ::v-deep .el-tabs__item {
    font-size: 16px;
    padding: 0 20px;
  }
}

.weather-row {
  margin-bottom: 20px;
}

.weather-card {
  background: rgba(30, 30, 30, 0.5); 
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: #fff;
  border-radius: 16px;
  padding: 20px;
  transition: transform 0.3s;
  
  &:hover {
    transform: scale(1.02);
    background: rgba(30, 30, 30, 0.6);
  }

  i {
    font-size: 40px;
    color: #ffcc33;
    filter: drop-shadow(0 0 10px rgba(255, 204, 51, 0.5));
  }

  .weather-info {
    .city {
      font-size: 18px;
      font-weight: 300;
      letter-spacing: 1px;
    }
    .temp {
      font-family: 'Helvetica Neue', Arial;
      font-size: 22px;
      margin: 5px 0;
    }
    .tips {
      background: rgba(255, 255, 255, 0.15);
      padding: 2px 8px;
      border-radius: 4px;
      display: inline-block;
    }
  }
}

.ai-recommend-card {
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  border-radius: 16px;
  padding: 15px 20px;
  display: flex;
  align-items: center;
  height: 100%;
  
  .label {
    font-style: italic;
    color: #666;
    margin-left: 8px;
  }
  
  .content {
    font-size: 16px;
    letter-spacing: 0.5px;
    color: #333;
    font-weight: 400;
    flex: 1;
    margin: 0 10px;
  }
}

.waterfall-container {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
}

.waterfall-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.post-card {
  width: 100%;
  break-inside: avoid;
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0,0,0,0.1);
  }
}

.post-image {
  position: relative;
  width: 100%;
  overflow: hidden;
  border-radius: 8px 8px 0 0;
  
  ::v-deep .el-image {
    width: 100%;
    height: auto;
    display: block;
  }
  
  .image-placeholder {
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f5f7fa;
    color: #909399;
    font-size: 24px;
  }
}

.multi-image-badge {
  position: absolute;
  top: 10px;
  right: 10px;
  background: rgba(0, 0, 0, 0.6);
  color: white;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  z-index: 1;
}

.post-content {
  padding: 15px;
}

.post-title {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: 600;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.post-tags {
  margin-bottom: 12px;
  
  .el-tag {
    margin-right: 6px;
    margin-bottom: 6px;
    background-color: #f0f2f5;
    border-color: #f0f2f5;
    color: #666;
  }
}

.post-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 0;
  border-top: 1px solid #f0f0f0;
  
  .user {
    display: flex;
    align-items: center;
    gap: 8px;
    
    .username {
      font-size: 13px;
      color: #666;
      max-width: 100px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
  
  .stats {
    display: flex;
    gap: 12px;
    font-size: 12px;
    color: #909399;
    
    i {
      margin-right: 3px;
    }
  }
}

.post-actions {
  display: flex;
  justify-content: space-around;
  padding: 8px 0 0;
  border-top: 1px solid #f0f0f0;
  margin-top: 8px;
  
  .el-button {
    color: #666;
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    
    &:hover {
      color: #9ec4e3;
    }
    
    &.liked {
      color: #ff6b6b;
    }
    
    &.collected {
      color: #e6a23c;
    }
    
    i {
      font-size: 14px;
    }
  }
}

.load-more {
  text-align: center;
  padding: 20px;
  
  .el-button {
    font-size: 14px;
  }
}

.message-badge {
  ::v-deep .el-badge__content {
    background-color: #ff6b6b;
  }
}

@media screen and (max-width: 768px) {
  .xiaohongshu-header {
    flex-direction: column;
    gap: 10px;
    
    .header-search {
      width: 100%;
    }
    
    .header-right {
      width: 100%;
      justify-content: center;
    }
  }
  
  .waterfall-container {
    flex-direction: column;
  }
}

.glass-effect {
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(12px) saturate(180%);
  -webkit-backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
}

@keyframes luxury-spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.refresh-btn:active i {
  animation: luxury-spin 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.upload-tip {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
}

.el-upload-list__item-actions {
  position: absolute;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  cursor: default;
  text-align: center;
  color: #fff;
  opacity: 0;
  font-size: 20px;
  background-color: rgba(0, 0, 0, 0.5);
  transition: opacity .3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.el-upload-list__item:hover .el-upload-list__item-actions {
  opacity: 1;
}

.el-upload-list__item-delete {
  cursor: pointer;
  margin: 0 5px;
  
  &:hover {
    color: #ff6b6b;
  }
}

/* 搜索建议样式 */
.search-suggestion {
  display: flex;
  align-items: center;
  gap: 8px;
  
  i {
    color: #909399;
    font-size: 14px;
  }
  
  span {
    font-size: 13px;
  }
}

/* 搜索结果样式 */
.search-results {
  max-height: 400px;
  overflow-y: auto;
  padding: 10px;
  
  .search-result-item {
    display: flex;
    gap: 12px;
    padding: 10px;
    border-bottom: 1px solid #f0f0f0;
    cursor: pointer;
    transition: background 0.2s;
    
    &:hover {
      background-color: #f5f7fa;
    }
    
    .search-result-img {
      width: 60px;
      height: 60px;
      object-fit: cover;
      border-radius: 4px;
    }
    
    .search-result-info {
      flex: 1;
      
      .search-result-title {
        font-size: 14px;
        font-weight: 500;
        margin-bottom: 4px;
      }
      
      .search-result-meta {
        font-size: 12px;
        color: #909399;
      }
    }
  }
}

/* 消息弹窗样式 */
.message-list {
  max-height: 400px;
  overflow-y: auto;
  padding: 0 10px;
}

.message-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border-bottom: 1px solid #f0f0f0;
  cursor: pointer;
  transition: background 0.2s;
}

.message-item:hover {
  background-color: #f5f7fa;
}

.message-item:last-child {
  border-bottom: none;
}

.message-icon {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: #f0f2f5;
  display: flex;
  align-items: center;
  justify-content: center;
  
  i {
    font-size: 18px;
  }
  
  &.like { background-color: #ffeded; }
  &.comment { background-color: #ecf5ff; }
  &.follow { background-color: #f0f9eb; }
  &.system { background-color: #fdf6ec; }
}

.message-content {
  flex: 1;
  
  .message-text {
    font-size: 14px;
    color: #333;
    margin-bottom: 4px;
  }
  
  .message-time {
    font-size: 12px;
    color: #999;
  }
}

.message-footer {
  text-align: center;
  padding: 15px 0 5px;
  border-top: 1px solid #f0f0f0;
  margin-top: 5px;
}

.message-dialog {
  .el-dialog__body {
    padding: 10px 20px;
  }
}
</style>