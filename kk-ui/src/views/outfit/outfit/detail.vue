<template>
  <div class="detail-container">
    <el-button class="back-btn" icon="el-icon-arrow-left" @click="$router.back()">
      返回
    </el-button>
    
    <div class="detail-content" v-if="post">
      <!-- 图片区域 -->
      <div class="detail-images">
        <el-carousel height="500px" indicator-position="outside">
          <el-carousel-item v-for="(img, index) in post.images || [post.image]" :key="index">
            <el-image :src="img" fit="contain"></el-image>
          </el-carousel-item>
        </el-carousel>
      </div>
      
      <!-- 信息区域 -->
      <div class="detail-info">
        <div class="detail-header">
          <h1 class="detail-title">{{ post.title }}</h1>
          <div class="detail-stats">
            <span><i class="el-icon-view"></i> {{ post.views || 1234 }}</span>
            <span><i class="el-icon-star-off"></i> {{ post.likes }}</span>
            <span><i class="el-icon-chat-dot-round"></i> {{ post.comments }}</span>
          </div>
        </div>
        
        <!-- 用户信息 -->
        <div class="detail-user">
          <el-avatar :src="post.avatar" size="large"></el-avatar>
          <div class="user-info">
            <div class="user-name">{{ post.username }}</div>
            <div class="user-bio">穿搭博主 · 每日更新</div>
          </div>
          <el-button type="primary" plain size="small">+ 关注</el-button>
        </div>
        
        <!-- 描述 -->
        <div class="detail-desc">
          {{ post.description || '分享今日穿搭，希望你喜欢~' }}
        </div>
        
        <!-- 标签 -->
        <div class="detail-tags">
          <el-tag v-for="tag in post.tags" :key="tag" size="medium" effect="plain">
            #{{ tag }}
          </el-tag>
        </div>
        
        <!-- 穿搭单品 -->
        <div class="detail-items">
          <h3>穿搭单品</h3>
          <div class="items-list">
            <div class="item" v-for="item in post.items || defaultItems" :key="item.name">
              <span class="item-icon">{{ item.icon }}</span>
              <span class="item-name">{{ item.name }}</span>
              <span class="item-brand">{{ item.brand }}</span>
            </div>
          </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="detail-actions">
          <el-button 
            type="primary" 
            :icon="post.isLiked ? 'el-icon-star-on' : 'el-icon-star-off'"
            @click="toggleLike"
          >
            {{ post.isLiked ? '已赞' : '点赞' }}
          </el-button>
          <el-button icon="el-icon-chat-dot-round" @click="showComment = true">
            评论
          </el-button>
          <el-button 
            :icon="post.isCollected ? 'el-icon-collection-tag' : 'el-icon-collection'"
            @click="toggleCollect"
          >
            {{ post.isCollected ? '已收藏' : '收藏' }}
          </el-button>
          <el-button icon="el-icon-share">分享</el-button>
        </div>
      </div>
    </div>
    
    <!-- 评论区 -->
    <CommentDialog 
      :visible.sync="showComment"
      :post="post"
    />
  </div>
</template>

<script>
// 修改这里：改成相对路径
import CommentDialog from './components/CommentDialog.vue'

export default {
  name: 'DetailPage',
  components: {
    CommentDialog
  },
  data() {
    return {
      post: null,
      showComment: false,
      defaultItems: [
        { icon: '👚', name: 'V领针织衫', brand: 'Uniqlo' },
        { icon: '👖', name: '高腰直筒裤', brand: 'ZARA' },
        { icon: '👞', name: '乐福鞋', brand: 'Dr.Martens' }
      ]
    }
  },
  created() {
    // 获取传递的数据
    const postData = this.$route.query.post
    if (postData) {
      try {
        this.post = JSON.parse(postData)
      } catch (e) {
        console.error('解析数据失败', e)
        this.loadMockData()
      }
    } else {
      this.loadMockData()
    }
  },
  methods: {
    loadMockData() {
      this.post = {
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
        views: 1234
      }
    },
    toggleLike() {
      this.post.isLiked = !this.post.isLiked
      this.post.likes += this.post.isLiked ? 1 : -1
      this.$message.success(this.post.isLiked ? '点赞成功' : '已取消点赞')
    },
    toggleCollect() {
      this.post.isCollected = !this.post.isCollected
      this.$message.success(this.post.isCollected ? '收藏成功' : '已取消收藏')
    }
  }
}
</script>

<style lang="scss" scoped>
.detail-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  
  .back-btn {
    margin-bottom: 20px;
  }
}

.detail-content {
  display: flex;
  gap: 30px;
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0,0,0,0.1);
  
  .detail-images {
    flex: 1;
    background: #f5f5f5;
    
    ::v-deep .el-carousel__container {
      height: 500px;
    }
  }
  
  .detail-info {
    flex: 1;
    padding: 30px;
    
    .detail-header {
      margin-bottom: 20px;
      
      .detail-title {
        font-size: 24px;
        margin: 0 0 10px 0;
      }
      
      .detail-stats {
        display: flex;
        gap: 20px;
        color: #999;
        font-size: 14px;
        
        i {
          margin-right: 5px;
        }
      }
    }
    
    .detail-user {
      display: flex;
      align-items: center;
      gap: 15px;
      padding: 20px 0;
      border-top: 1px solid #f0f0f0;
      border-bottom: 1px solid #f0f0f0;
      
      .user-info {
        flex: 1;
        
        .user-name {
          font-size: 16px;
          font-weight: 500;
          margin-bottom: 5px;
        }
        
        .user-bio {
          font-size: 13px;
          color: #999;
        }
      }
    }
    
    .detail-desc {
      padding: 20px 0;
      font-size: 15px;
      line-height: 1.6;
      color: #333;
    }
    
    .detail-tags {
      margin-bottom: 20px;
      
      .el-tag {
        margin-right: 10px;
        margin-bottom: 10px;
      }
    }
    
    .detail-items {
      h3 {
        font-size: 16px;
        margin-bottom: 15px;
      }
      
      .items-list {
        .item {
          display: flex;
          align-items: center;
          padding: 10px 0;
          border-bottom: 1px solid #f5f5f5;
          
          .item-icon {
            font-size: 20px;
            width: 40px;
          }
          
          .item-name {
            flex: 1;
            font-weight: 500;
          }
          
          .item-brand {
            color: #999;
            font-size: 13px;
          }
        }
      }
    }
    
    .detail-actions {
      display: flex;
      gap: 15px;
      margin-top: 30px;
      
      .el-button {
        flex: 1;
      }
    }
  }
}

@media screen and (max-width: 768px) {
  .detail-content {
    flex-direction: column;
  }
}
</style>