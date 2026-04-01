<template>
  <div class="app-container audit-wrapper">
    <div class="filter-section luxury-board">
      <el-form :inline="true" :model="queryParams" size="medium">
        <el-form-item label="博主账号">
          <el-input 
            v-model="queryParams.username" 
            placeholder="搜索创作者..." 
            clearable 
            class="luxury-input"
            @keyup.enter.native="handleQuery" 
          />
        </el-form-item>
        <el-form-item label="当前状态">
          <el-select v-model="queryParams.status" placeholder="全部分类" clearable @change="handleQuery" class="luxury-select">
            <el-option label="待审核" value="0" />
            <el-option label="已发布" value="1" />
            <el-option label="已屏蔽" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" class="btn-gold" icon="el-icon-search" @click="handleQuery">筛选</el-button>
          <el-button icon="el-icon-refresh" class="btn-outline" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="post-grid" v-loading="loading">
      <div v-for="item in postList" :key="item.id" class="post-item">
        <div class="post-card frosted-glass">
          <div class="card-header">
            <div class="author-info">
              <el-avatar :size="28" :src="item.avatar" class="author-avatar" />
              <span class="username">{{ item.username }}</span>
            </div>
            <div class="status-indicator" :class="'status-' + item.status">
              <span class="dot"></span> {{ statusName(item.status) }}
            </div>
          </div>
          
          <div class="card-cover-wrapper">
            <el-image 
              :src="getRealImg(item.image)" 
              fit="cover" 
              class="post-image"
              :preview-src-list="[getRealImg(item.image)]"
            >
              <div slot="placeholder" class="image-slot"><i class="el-icon-loading"></i></div>
            </el-image>
            <div class="stats-overlay">
              <span><i class="el-icon-star-off"></i> {{ item.likeCount || 0 }}</span>
              <span><i class="el-icon-chat-dot-round"></i> {{ item.commentCount || 0 }}</span>
            </div>
          </div>

          <div class="card-content">
            <h4 class="post-title">{{ item.title }}</h4>
            
            <div class="action-footer" v-if="item.status === '0'">
              <el-button type="text" class="btn-approve" @click="handleAudit(item, '1')">
                <i class="el-icon-check"></i> 核准发布
              </el-button>
              <el-divider direction="vertical"></el-divider>
              <el-button type="text" class="btn-reject" @click="handleAudit(item, '2')">
                <i class="el-icon-close"></i> 屏蔽内容
              </el-button>
            </div>
            <div class="action-footer info-only" v-else>
              <span class="time-stamp">{{ parseTime(item.createTime, '{m}-{d} {h}:{i}') }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="pagination-container">
      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>
  </div>
</template>

<script>
import { listAuditPosts, updatePostStatus } from "@/api/outfit/audit";

export default {
  name: "PostAudit",
  data() {
    return {
      loading: false,
      total: 0,
      postList: [],
      baseUrl: process.env.VUE_APP_BASE_API,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        username: undefined,
        status: '0'
      }
    };
  },
  created() {
    const queryUser = this.$route.query.userName;
    if (queryUser) {
      this.queryParams.username = queryUser;
      this.queryParams.status = undefined;
    }
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listAuditPosts(this.queryParams).then(res => {
        this.postList = res.rows;
        this.total = res.total;
        this.loading = false;
      });
    },
    getRealImg(url) {
      if (!url) return '';
      return url.startsWith('http') ? url : this.baseUrl + url;
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.queryParams = { pageNum: 1, pageSize: 10, username: undefined, status: '0' };
      this.getList();
    },
    statusName(status) {
      const map = { '0': '待审阅', '1': '已准予', '2': '违规处理' };
      return map[status];
    },
    handleAudit(row, status) {
      const text = status === '1' ? "通过" : "下架";
      this.$confirm(`确认要${text}博主 "${row.username}" 的这篇帖子吗？`, "审核决策", {
        confirmButtonText: '确定执行',
        cancelButtonText: '暂缓',
        type: "warning"
      }).then(() => {
        return updatePostStatus(row.id, status);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("决策已执行");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped lang="scss">
.audit-wrapper {
  padding: 30px;
  background: #fdfcfb; // 统一的暖白底色
  min-height: calc(100vh - 84px);

  .luxury-board {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 30px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.02);
  }

  // 1. 搜索框美化
  .luxury-input ::v-deep .el-input__inner,
  .luxury-select ::v-deep .el-input__inner {
    border: none;
    border-bottom: 1px solid #eee;
    background: transparent;
    border-radius: 0;
    font-size: 13px;
    &:focus { border-color: #c5a391; }
  }
  .btn-gold { background: #1a1a1a; border: none; padding: 10px 25px; }
  .btn-outline { border: 1px solid #ddd; color: #888; }

  // 2. 网格布局
  .post-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 30px;
  }

  // 3. 卡片细节
  .post-card {
    border-radius: 20px; // 大圆角更有时尚感
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    border: 1px solid rgba(0,0,0,0.03);

    &:hover {
      transform: translateY(-8px);
      box-shadow: 0 15px 35px rgba(0,0,0,0.08);
      .card-cover-wrapper .post-image { transform: scale(1.05); }
      .stats-overlay { opacity: 1; }
    }

    .card-header {
      padding: 15px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #fff;

      .author-info {
        display: flex;
        align-items: center;
        .username { font-size: 12px; font-weight: 600; color: #333; margin-left: 8px; }
      }

      .status-indicator {
        font-size: 11px;
        display: flex;
        align-items: center;
        .dot { width: 6px; height: 6px; border-radius: 50%; margin-right: 6px; }
        &.status-0 { color: #c5a391; .dot { background: #c5a391; } }
        &.status-1 { color: #67c23a; .dot { background: #67c23a; } }
        &.status-2 { color: #f56c6c; .dot { background: #f56c6c; } }
      }
    }

    .card-cover-wrapper {
      position: relative;
      height: 380px;
      overflow: hidden;

      .post-image {
        width: 100%;
        height: 100%;
        transition: transform 0.6s ease;
      }

      .stats-overlay {
        position: absolute;
        bottom: 0; left: 0; right: 0;
        padding: 20px;
        background: linear-gradient(to top, rgba(0,0,0,0.4), transparent);
        color: #fff;
        font-size: 12px;
        display: flex;
        gap: 15px;
        opacity: 0;
        transition: opacity 0.3s;
        span i { margin-right: 4px; }
      }
    }

    .card-content {
      padding: 18px;
      background: #fff;

      .post-title {
        margin: 0 0 15px;
        font-size: 14px;
        font-weight: 500;
        color: #222;
        line-height: 1.5;
        height: 42px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .action-footer {
        border-top: 1px solid #f9f9f9;
        padding-top: 15px;
        display: flex;
        align-items: center;
        justify-content: space-around;

        .btn-approve { color: #67c23a; font-weight: 500; font-size: 13px; &:hover { opacity: 0.7; } }
        .btn-reject { color: #f56c6c; font-weight: 500; font-size: 13px; &:hover { opacity: 0.7; } }
        
        &.info-only { justify-content: flex-start; }
        .time-stamp { color: #ccc; font-size: 11px; font-family: monospace; }
      }
    }
  }

  .pagination-container {
    margin-top: 40px;
    display: flex;
    justify-content: center;
  }
}
</style>