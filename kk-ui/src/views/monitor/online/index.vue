<template>
  <div class="app-container outfit-monitor-container">
    <el-row :gutter="20" class="statistics-cards">
      <el-col :span="6">
        <div class="glass-card stat-item">
          <div class="stat-label">当前活跃用户</div>
          <div class="stat-value">{{ stats.activeUserCount }} <span class="unit">人</span></div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="glass-card stat-item">
          <div class="stat-label">今日方案发布量</div>
          <div class="stat-value">{{ stats.todayPostCount }} <span class="unit">篇</span></div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="glass-card stat-item">
          <div class="stat-label">热门风格排行</div>
          <div class="stat-value">{{ stats.hotStyle || '暂无' }} <i class="el-icon-top"></i></div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="glass-card stat-item">
          <div class="stat-label">违规内容预警</div>
          <div class="stat-value warning">{{ stats.auditWarningCount }} <span class="unit">条</span></div>
        </div>
      </el-col>
    </el-row>

    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" class="glass-toolbar">
      <el-form-item label="监控用户" prop="userName">
        <el-input v-model="queryParams.userName" placeholder="请输入用户名称" clearable @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">查询活跃状态</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">刷新看板</el-button>
        <el-button type="success" icon="el-icon-setting" size="mini" @click="$router.push('/system/dict')">维护风格/场景库</el-button>
      </el-form-item>
    </el-form>

    <div class="table-wrapper glass-card">
      <el-table v-loading="loading" :data="list" style="width: 100%;">
        <el-table-column label="序号" type="index" align="center" width="50" />
        <el-table-column label="活跃用户" align="center" prop="userName" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span class="user-name-tag">{{ scope.row.userName }}</span>
          </template>
        </el-table-column>
        <el-table-column label="最近活跃地点" align="center" prop="loginLocation" />
        <el-table-column label="发布终端" align="center" prop="os" />
        <el-table-column label="活跃时间" align="center" prop="loginTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.loginTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="合规操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-view"
              @click="handleAudit(scope.row)"
              style="color: #67C23A"
            >审核发布内容</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              @click="handleForceLogout(scope.row)"
              v-hasPermi="['monitor:online:forceLogout']"
              style="color: #F56C6C"
            >违规强退</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination v-show="total>0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" />
    </div>
  </div>
</template>

<script>
// 做了加法：同时引入在线列表API和你的穿搭统计API
import { list, forceLogout } from "@/api/monitor/online"
import { getOutfitStatistics } from "@/api/outfit/outfit" 

export default {
  name: "OutfitMonitor",
  data() {
    return {
      loading: true,
      total: 0,
      list: [],
      pageNum: 1,
      pageSize: 10,
      queryParams: {
        userName: undefined
      },
      // 做了加法：初始化统计数据对象
      stats: {
        activeUserCount: 0,
        todayPostCount: 0,
        hotStyle: "加载中...",
        auditWarningCount: 0
      }
    }
  },
  created() {
    this.getList();
    this.getDashboardData(); // 做了加法：进入页面就加载统计
  },
  methods: {
    // 做了加法：调用后端统计接口
    getDashboardData() {
      getOutfitStatistics().then(response => {
        this.stats = response.data;
      });
    },
    getList() {
      this.loading = true
      list(this.queryParams).then(response => {
        this.list = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleQuery() {
      this.pageNum = 1
      this.getList()
      this.getDashboardData() // 查询时同步刷新卡片
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleAudit(row) {
      this.$router.push({
        path: '/outfit/audit',
        query: { userName: row.userName } 
      });
    },
    handleForceLogout(row) {
      this.$modal.confirm('检测到异常活跃或违规行为，是否强退用户 "' + row.userName + '"？').then(function() {
        return forceLogout(row.tokenId)
      }).then(() => {
        this.getList()
        this.getDashboardData()
        this.$modal.msgSuccess("已将其强制下线并记录违规日志")
      }).catch(() => {})
    }
  }
}
</script>

<style scoped lang="scss">
// 样式保持你的毛玻璃高亮设计
.outfit-monitor-container {
  padding: 20px;
  background-color: #f8f9fa;

  .statistics-cards {
    margin-bottom: 20px;
    .stat-item {
      padding: 20px;
      text-align: center;
      transition: transform 0.3s;
      &:hover { transform: translateY(-5px); }
      .stat-label { font-size: 14px; color: #909399; margin-bottom: 10px; }
      .stat-value { font-size: 24px; font-weight: bold; color: #303133; }
      .unit { font-size: 12px; margin-left: 4px; }
      .warning { color: #F56C6C; }
    }
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    border: 1px solid rgba(255,255,255,0.6);
  }

  .glass-toolbar {
    padding: 15px 20px;
    margin-bottom: 15px;
    background: rgba(255, 255, 255, 0.7);
    border-radius: 10px;
  }

  .user-name-tag {
    background: #eef2fe;
    color: #409EFF;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 13px;
  }
}
</style>