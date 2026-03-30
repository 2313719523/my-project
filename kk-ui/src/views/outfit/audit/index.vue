<template>
  <div class="audit-container">
    <div class="filter-section glass-card">
      <el-form :inline="true" :model="queryParams" size="small">
        <el-form-item label="博主账号">
          <el-input v-model="queryParams.username" placeholder="请输入博主账号" clearable @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="帖子状态" clearable @change="handleQuery">
            <el-option label="待审核" value="0" />
            <el-option label="已通过" value="1" />
            <el-option label="已下架" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="post-grid" v-loading="loading">
      <div v-for="item in postList" :key="item.id" class="post-card glass-card">
        <div class="card-header">
          <el-avatar :size="30" :src="item.avatar" />
          <span class="username">{{ item.username }}</span>
          <el-tag size="mini" :type="statusType(item.status)">{{ statusName(item.status) }}</el-tag>
        </div>
        
        <div class="card-cover">
          <el-image :src="getRealImg(item.image)" fit="cover" :preview-src-list="[getRealImg(item.image)]">
            <div slot="error" class="image-slot"><i class="el-icon-picture-outline"></i></div>
          </el-image>
        </div>

        <div class="card-body">
          <h4 class="post-title">{{ item.title }}</h4>
          <div class="post-stats">
            <span><i class="el-icon-star-off"></i> {{ item.likeCount || 0 }}</span>
            <span><i class="el-icon-chat-dot-round"></i> {{ item.commentCount || 0 }}</span>
          </div>
          
          <div class="card-actions" v-if="item.status === '0'">
            <el-button type="success" size="mini" plain icon="el-icon-check" @click="handleAudit(item, '1')">通过</el-button>
            <el-button type="danger" size="mini" plain icon="el-icon-close" @click="handleAudit(item, '2')">下架</el-button>
          </div>
        </div>
      </div>
    </div>

    <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
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
      // 基础路径，根据你后端静态资源配置修改
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
    // 关键点：接收来自监控页的跳转参数
    const queryUser = this.$route.query.userName;
    if (queryUser) {
      this.queryParams.username = queryUser;
      this.queryParams.status = undefined; // 查看该用户所有帖子
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
      // 如果存的是相对路径 /images/... 则拼接后端地址
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
    statusType(status) {
      return status === '1' ? 'success' : (status === '2' ? 'danger' : 'warning');
    },
    statusName(status) {
      const map = { '0': '待审核', '1': '已通过', '2': '已违规' };
      return map[status];
    },
    handleAudit(row, status) {
      const text = status === '1' ? "通过" : "下架";
      this.$confirm(`确认要${text}博主 "${row.username}" 的这篇帖子吗？`, "警告", {
        type: "warning"
      }).then(() => {
        return updatePostStatus(row.id, status);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("操作成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped lang="scss">
.audit-container {
  padding: 20px;
  background-color: #f8f9fa;
  min-height: calc(100vh - 84px);

  .glass-card {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(8px);
    border-radius: 12px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 20px rgba(0,0,0,0.05);
    margin-bottom: 20px;
  }

  .filter-section { padding: 15px 20px 5px; }

  .post-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 20px;
  }

  .post-card {
    display: flex;
    flex-direction: column;
    overflow: hidden;
    transition: all 0.3s;
    &:hover { transform: translateY(-5px); }

    .card-header {
      padding: 10px;
      display: flex;
      align-items: center;
      gap: 10px;
      .username { flex: 1; font-size: 13px; font-weight: bold; }
    }

    .card-cover {
      height: 300px;
      .el-image { width: 100%; height: 100%; }
    }

    .card-body {
      padding: 12px;
      .post-title { margin: 0 0 10px; font-size: 14px; color: #333; height: 40px; overflow: hidden; }
      .post-stats { font-size: 12px; color: #999; margin-bottom: 12px; span { margin-right: 15px; } }
      .card-actions { display: flex; gap: 8px; .el-button { flex: 1; } }
    }
  }
}
</style>