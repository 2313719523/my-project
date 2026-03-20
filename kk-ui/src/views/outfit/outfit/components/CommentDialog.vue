<template>
  <el-dialog 
    title="评论" 
    :visible.sync="dialogVisible" 
    width="500px"
    :append-to-body="true"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <!-- 当前穿搭信息 -->
    <div class="current-post" v-if="post">
      <el-avatar :src="post.avatar" size="small"></el-avatar>
      <span class="post-title">{{ post.title }}</span>
    </div>

    <!-- 评论列表 - 使用post.commentList -->
    <div class="comment-list" v-if="post && post.commentList && post.commentList.length > 0">
      <div v-for="comment in post.commentList" :key="comment.id" class="comment-item">
        <el-avatar :src="comment.user.avatar" size="small"></el-avatar>
        <div class="comment-content">
          <div class="comment-header">
            <span class="comment-username">{{ comment.user.name }}</span>
            <span class="comment-time">{{ comment.time }}</span>
          </div>
          <div class="comment-text">{{ comment.content }}</div>
          <div class="comment-actions">
            <el-button type="text" size="mini" @click="replyComment(comment)">
              <i class="el-icon-chat-line-round"></i> 回复
            </el-button>
            <el-button type="text" size="mini" @click="likeComment(comment)">
              <i :class="comment.isLiked ? 'el-icon-star-on' : 'el-icon-star-off'"></i>
              {{ comment.likes }}
            </el-button>
          </div>
        </div>
      </div>
    </div>
    <div v-else class="no-comment">
      暂无评论，来说两句吧~
    </div>

    <!-- 发表评论 -->
    <div class="comment-input">
      <el-input
        type="textarea"
        :rows="2"
        placeholder="写下你的评论..."
        v-model="newComment"
        ref="commentInput"
      ></el-input>
      <div class="comment-input-footer">
        <span class="emoji-btn" @click="showEmoji = !showEmoji">😊</span>
        <el-button type="primary" size="small" @click="submitComment">发表</el-button>
      </div>
    </div>
  </el-dialog>
</template>

<script>
export default {
  name: 'CommentDialog',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    post: {
      type: Object,
      default: () => ({
        commentList: []  // 默认空数组
      })
    }
  },
  data() {
    return {
      dialogVisible: false,
      newComment: '',
      showEmoji: false
    }
  },
  watch: {
    visible: {
      handler(val) {
        console.log('visible changed:', val, '当前帖子:', this.post)
        this.dialogVisible = val
      },
      immediate: true
    },
    post: {
      handler(val) {
        console.log('post changed:', val, '评论列表:', val?.commentList)
      },
      deep: true,
      immediate: true
    }
  },
  methods: {
    handleClose() {
      console.log('dialog closed')
      this.dialogVisible = false
      this.$emit('close')
      this.$emit('update:visible', false)
    },
    
    submitComment() {
      if (!this.newComment.trim()) {
        this.$message.warning('请输入评论内容')
        return
      }
      
      if (!this.post) {
        this.$message.error('帖子信息不存在')
        return
      }
      
      // 创建新评论
      const newComment = {
        id: Date.now(),
        user: {
          name: '当前用户',
          avatar: this.post.avatar || '/images/默认头像.png'
        },
        content: this.newComment,
        time: '刚刚',
        likes: 0,
        isLiked: false
      }
      
      // 确保commentList存在
      if (!this.post.commentList) {
        this.$set(this.post, 'commentList', [])
      }
      
      // 添加新评论
      this.post.commentList.unshift(newComment)
      
      // 更新评论数
      if (this.post.comments !== undefined) {
        this.post.comments++
      }
      
      // 触发父组件的事件
      this.$emit('add-comment', this.newComment)
      
      this.newComment = ''
      this.$message.success('评论成功')
    },
    
    replyComment(comment) {
      this.newComment = `回复 @${comment.user.name}：`
      this.$nextTick(() => {
        if (this.$refs.commentInput) {
          this.$refs.commentInput.focus()
        }
      })
    },
    
    likeComment(comment) {
      comment.isLiked = !comment.isLiked
      comment.likes += comment.isLiked ? 1 : -1
    }
  }
}
</script>

<style lang="scss" scoped>
.current-post {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 15px;
  
  .post-title {
    font-size: 14px;
    color: #666;
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.comment-list {
  max-height: 300px;
  overflow-y: auto;
  margin-bottom: 15px;
  padding-right: 5px;
  
  /* 自定义滚动条样式 */
  &::-webkit-scrollbar {
    width: 4px;
  }
  &::-webkit-scrollbar-thumb {
    background: #ddd;
    border-radius: 2px;
  }
}

.comment-item {
  display: flex;
  gap: 10px;
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
  
  &:last-child {
    border-bottom: none;
  }
  
  .el-avatar {
    flex-shrink: 0;
  }
  
  .comment-content {
    flex: 1;
    min-width: 0; /* 防止flex溢出 */
    
    .comment-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 5px;
      
      .comment-username {
        font-size: 13px;
        font-weight: 500;
        color: #333;
      }
      
      .comment-time {
        font-size: 11px;
        color: #999;
      }
    }
    
    .comment-text {
      font-size: 14px;
      color: #333;
      margin-bottom: 8px;
      line-height: 1.5;
      word-break: break-word;
    }
    
    .comment-actions {
      display: flex;
      gap: 15px;
      
      .el-button {
        padding: 0;
        color: #999;
        font-size: 12px;
        
        &:hover {
          color: #409eff;
        }
        
        i {
          margin-right: 3px;
        }
      }
    }
  }
}

.no-comment {
  text-align: center;
  padding: 40px 0;
  color: #999;
  font-size: 14px;
}

.comment-input {
  border-top: 1px solid #f0f0f0;
  padding-top: 15px;
  
  .comment-input-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 10px;
    
    .emoji-btn {
      font-size: 20px;
      cursor: pointer;
      transition: transform 0.2s;
      
      &:hover {
        transform: scale(1.1);
      }
    }
  }
}
</style>