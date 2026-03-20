<template>
  <div class="dashboard-editor-container">
    <!-- 小红书风格的顶部导航栏 -->
    <div class="xiaohongshu-header">
      <div class="header-left">
        <h1 class="logo">每日穿搭</h1>
      </div>
      <div class="header-search">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索穿搭、用户、品牌..."
          prefix-icon="el-icon-search"
          size="medium"
          clearable
        />
      </div>
      <div class="header-right">
        <el-button type="primary" icon="el-icon-upload" @click="showPublishDialog = true">
          发布穿搭
        </el-button>
        <el-badge :value="3" class="message-badge">
          <el-button icon="el-icon-message" circle size="small"></el-button>
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
          <span class="content">浅杏色针织衫 + 深灰九分裤</span>
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
      imageList: [], // 上传的图片列表
      uploadImage: null, // 存储上传的图片数据
      loading: false,
      avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
      
      leftPosts: [
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
          commentList: [
            {
              id: 101,
              user: {
                name: '明天不上班',
                avatar: '/images/头像2.png'
              },
              content: '第一套有链接吗姐妹！求求了！！',
              time: '2小时前',
              likes: 24,
              isLiked: false
            },
            {
              id: 102,
              user: {
                name: '小个子穿搭',
                avatar: '/images/头像3.png'
              },
              content: '158能穿吗 会不会拖地啊',
              time: '1小时前',
              likes: 8,
              isLiked: false
            },
            {
              id: 103,
              user: {
                name: '饭饭',
                avatar: '/images/头像4.png'
              },
              content: '码住！明天上班就这么穿',
              time: '30分钟前',
              likes: 15,
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
          commentList: [
            {
              id: 401,
              user: {
                name: '今天星期几',
                avatar: '/images/头像2.png'
              },
              content: '被种草了！！姐妹好会穿',
              time: '5分钟前',
              likes: 12,
              isLiked: false
            },
            {
              id: 402,
              user: {
                name: '别管我了',
                avatar: '/images/头像3.png'
              },
              content: '图三西装有链接吗！！急急急',
              time: '10分钟前',
              likes: 5,
              isLiked: false
            },
            {
              id: 403,
              user: {
                name: '想吃火锅',
                avatar: '/images/头像1.png'
              },
              content: '啊啊啊好好看 求这一整套链接！！',
              time: '刚刚',
              likes: 0,
              isLiked: false
            }
          ]
        }
      ],
      
      centerPosts: [
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
          commentList: [
            {
              id: 201,
              user: {
                name: '不想上班',
                avatar: '/images/头像3.png'
              },
              content: '黑白yyds！永远不会出错',
              time: '15分钟前',
              likes: 18,
              isLiked: false
            },
            {
              id: 202,
              user: {
                name: '小羊',
                avatar: '/images/头像4.png'
              },
              content: '图二裤子有🔗吗姐妹',
              time: '25分钟前',
              likes: 6,
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
          commentList: [
            {
              id: 501,
              user: {
                name: '150小个子',
                avatar: '/images/头像1.png'
              },
              content: '本矮子星人狂喜！！立马收藏',
              time: '8分钟前',
              likes: 43,
              isLiked: false
            },
            {
              id: 502,
              user: {
                name: '减肥ing',
                avatar: '/images/头像2.png'
              },
              content: '正好最近在减肥 学起来！',
              time: '20分钟前',
              likes: 12,
              isLiked: false
            },
            {
              id: 503,
              user: {
                name: '今天瘦了吗',
                avatar: '/images/头像3.png'
              },
              content: '@我朋友 进来学穿搭！！',
              time: '40分钟前',
              likes: 5,
              isLiked: false
            }
          ]
        }
      ],
      
      rightPosts: [
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
          commentList: [
            {
              id: 301,
              user: {
                name: '抠搜打工人',
                avatar: '/images/头像2.png'
              },
              content: '白衬衫真的百搭！！衣柜必备',
              time: '20分钟前',
              likes: 16,
              isLiked: false
            },
            {
              id: 302,
              user: {
                name: '想吃烤肉',
                avatar: '/images/头像3.png'
              },
              content: '第七套绝了！正好周末约会穿',
              time: '35分钟前',
              likes: 9,
              isLiked: false
            },
            {
              id: 303,
              user: {
                name: '早起困难户',
                avatar: '/images/头像4.png'
              },
              content: '马住马住 再也不愁穿啥了',
              time: '50分钟前',
              likes: 21,
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
          commentList: [
            {
              id: 601,
              user: {
                name: '恋爱ing',
                avatar: '/images/头像4.png'
              },
              content: '刚和男朋友分手 看到这个又想谈恋爱了',
              time: '12分钟前',
              likes: 34,
              isLiked: false
            },
            {
              id: 602,
              user: {
                name: '不想起床',
                avatar: '/images/头像5.png'
              },
              content: '求裙子！周末约会正需要！！',
              time: '25分钟前',
              likes: 11,
              isLiked: false
            },
            {
              id: 603,
              user: {
                name: '单身狗',
                avatar: '/images/头像2.png'
              },
              content: '虽然没有约会 但先收藏了哈哈哈',
              time: '1小时前',
              likes: 28,
              isLiked: false
            },
            {
              id: 604,
              user: {
                name: '甜甜圈',
                avatar: '/images/头像3.png'
              },
              content: '@闺蜜 我们周末穿这个去拍照！',
              time: '50分钟前',
              likes: 6,
              isLiked: false
            }
          ]
        }
      ],
      
      showCommentDialog: false,
      currentCommentPost: null,
      publishCounter: 0
    };
  },
  computed: {
    // 计算是否可以发布
    canPublish() {
      return this.publishForm.title && 
             this.publishForm.description && 
             this.imageList.length > 0;
    }
  },
  methods: {
    handleCategoryChange() {
      this.$message.success(`切换到${this.activeCategory}分类`);
    },
    
    refreshRecommend() {
      this.$message.success('已为您刷新穿搭推荐');
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
    
    // 处理图片变更
    handleImageChange(file, fileList) {
      this.imageList = fileList;
      // 创建本地预览URL
      if (file.raw) {
        this.uploadImage = URL.createObjectURL(file.raw);
      }
    },
    
    // 处理图片移除
    handleImageRemove(file, fileList) {
      this.imageList = fileList;
      if (fileList.length === 0) {
        this.uploadImage = null;
      }
    },
    
    // 处理移除
    handleRemove(file) {
      this.$refs.upload.handleRemove(file);
    },
    
    // 弹窗关闭时的处理
    handlePublishClose() {
      // 清除上传的图片
      this.imageList = [];
      this.uploadImage = null;
      this.publishForm = {
        title: '',
        description: '',
        tags: []
      };
    },
    
    publishPost() {
      // 验证表单
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
      
      // 创建新帖子，使用上传的图片
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
        commentList: []
      };
      
      // 轮播添加：左 -> 中 -> 右 -> 左 -> 中 -> 右 ...
      const columnIndex = this.publishCounter % 3;
      
      if (columnIndex === 0) {
        this.leftPosts.push(newPost);
      } else if (columnIndex === 1) {
        this.centerPosts.push(newPost);
      } else {
        this.rightPosts.push(newPost);
      }
      
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
          avatar: 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png',
          username: '新用户',
          likes: Math.floor(Math.random() * 500),
          comments: Math.floor(Math.random() * 100),
          isLiked: false,
          isCollected: false,
          commentList: []
        };
        
        const random = Math.floor(Math.random() * 3);
        if (random === 0) this.leftPosts.push(newPost);
        else if (random === 1) this.centerPosts.push(newPost);
        else this.rightPosts.push(newPost);
        
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
/* 您的原有样式完全不变 */
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
    ::v-deep .el-input__inner {
      background-color: rgba(255, 255, 255, 0.5);
      border: 1px solid rgba(255, 255, 255, 0.3);
      transition: all 0.3s;
      &:focus {
        background-color: #fff;
        width: 350px;
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
  }
  
  .content {
    font-size: 16px;
    letter-spacing: 0.5px;
    color: #333;
    font-weight: 400;
    flex: 1;
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
      color: #409eff;
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
</style>