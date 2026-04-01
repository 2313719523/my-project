<template>
  <div class="app-container outfit-monitor-wrapper">
    <el-row :gutter="20" class="statistics-section">
      <el-col :span="6" v-for="(val, key) in statConfig" :key="key">
        <div class="luxury-stat-card frosted-glass">
          <div class="stat-icon"><i :class="val.icon"></i></div>
          <div class="stat-info">
            <div class="stat-label">{{ val.label }}</div>
            <div class="stat-value" :class="{ 'warning-text': val.isWarning }">
              {{ stats[val.prop] || 0 }}<small>{{ val.unit }}</small>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <div class="toolbar-section frosted-glass">
      <el-form :model="queryParams" ref="queryForm" size="medium" :inline="true">
        <el-form-item label="监控用户" prop="userName">
          <el-input 
            v-model="queryParams.userName" 
            placeholder="搜索活跃设计师" 
            clearable 
            class="luxury-input"
            @keyup.enter.native="handleQuery" 
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" class="btn-gold" @click="handleQuery">同步状态</el-button>
          <el-button icon="el-icon-refresh" class="btn-outline" @click="resetQuery">重置</el-button>
          <el-button type="text" icon="el-icon-setting" class="btn-link" @click="$router.push('/system/dict')">维护库</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="table-container frosted-glass">
      <el-table v-loading="loading" :data="list" style="width: 100%" class="luxury-table">
        <el-table-column label="RANK" type="index" align="center" width="80" />
        <el-table-column label="活跃设计师" align="left" prop="userName" min-width="150">
          <template slot-scope="scope">
            <div class="user-profile">
              <div class="user-avatar">{{ scope.row.userName.substring(0,1).toUpperCase() }}</div>
              <span class="user-name">{{ scope.row.userName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="活跃坐标" align="center" prop="loginLocation">
          <template slot-scope="scope">
            <span class="location-tag"><i class="el-icon-location-outline"></i> {{ scope.row.loginLocation }}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布终端" align="center" prop="os">
          <template slot-scope="scope">
            <span class="os-tag">{{ scope.row.os }}</span>
          </template>
        </el-table-column>
        <el-table-column label="最后活跃" align="center" prop="loginTime" width="180">
          <template slot-scope="scope">
            <span class="time-text">{{ parseTime(scope.row.loginTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="风控操作" align="center" width="220">
          <template slot-scope="scope">
            <el-button size="mini" type="text" class="op-btn audit" @click="handleAudit(scope.row)">审核内容</el-button>
            <el-divider direction="vertical"></el-divider>
            <el-button size="mini" type="text" class="op-btn logout" @click="handleForceLogout(scope.row)">违规清理</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-wrapper">
        <pagination v-show="total>0" :total="total" :page.sync="pageNum" :limit.sync="pageSize" @pagination="getList" />
      </div>
    </div>
  </div>
</template>

<script>
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
      queryParams: { userName: undefined },
      stats: {
        activeUserCount: 0,
        todayPostCount: 0,
        hotStyle: "加载中...",
        auditWarningCount: 0
      },
      // 样式配置：方便模板循环
      statConfig: {
        users: { label: '活跃用户', prop: 'activeUserCount', unit: '人', icon: 'el-icon-user', isWarning: false },
        posts: { label: '今日方案', prop: 'todayPostCount', unit: '篇', icon: 'el-icon-picture-outline', isWarning: false },
        style: { label: '热门风格', prop: 'hotStyle', unit: '', icon: 'el-icon-magic-stick', isWarning: false },
        warning: { label: '违规预警', prop: 'auditWarningCount', unit: '条', icon: 'el-icon-warning-outline', isWarning: true }
      }
    }
  },
  created() {
    this.getList();
    this.getDashboardData();
  },
  methods: {
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
      this.getDashboardData()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleAudit(row) {
      this.$router.push({ path: '/outfit/audit', query: { userName: row.userName } });
    },
    handleForceLogout(row) {
      this.$modal.confirm('检测到异常活跃或违规行为，是否强退用户 "' + row.userName + '"？').then(function() {
        return forceLogout(row.tokenId)
      }).then(() => {
        this.getList()
        this.getDashboardData()
        this.$modal.msgSuccess("已将其强制下线")
      }).catch(() => {})
    }
  }
}
</script>

<style scoped lang="scss">
.outfit-monitor-wrapper {
  padding: 24px;
  background: #fdfcfb; // 暖白奶油色背景
  min-height: calc(100vh - 84px);

  .frosted-glass {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.02);
  }

  // 1. 顶部卡片
  .statistics-section {
    margin-bottom: 24px;
    .luxury-stat-card {
      padding: 24px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      transition: all 0.3s ease;
      
      &:hover { transform: translateY(-4px); box-shadow: 0 8px 30px rgba(0,0,0,0.05); }

      .stat-icon {
        width: 48px;
        height: 48px;
        background: #f5f5f5;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16px;
        i { font-size: 20px; color: #c5a391; }
      }

      .stat-label { font-size: 12px; color: #999; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 4px; }
      .stat-value { 
        font-size: 24px; font-weight: 300; color: #1a1a1a; 
        small { font-size: 12px; margin-left: 4px; color: #666; font-weight: 400;}
      }
      .warning-text { color: #b03030 !important; font-weight: 500; }
    }
  }

  // 2. 工具栏
  .toolbar-section {
    padding: 20px;
    border-radius: 12px;
    margin-bottom: 20px;
    .luxury-input ::v-deep .el-input__inner {
      background: transparent;
      border: none;
      border-bottom: 1px solid #eee;
      border-radius: 0;
      &:focus { border-color: #c5a391; }
    }
    .btn-gold { background: #1a1a1a; border: none; border-radius: 4px; padding: 10px 20px; }
    .btn-outline { border: 1px solid #ddd; color: #666; border-radius: 4px; }
  }

  // 3. 表格部分
  .table-container {
    border-radius: 12px;
    padding: 10px 20px;

    .luxury-table {
      ::v-deep {
        background: transparent;
        th { background: transparent; border-bottom: 1px solid #f5f5f5; color: #999; font-weight: 500; font-size: 12px; }
        td { background: transparent; border-bottom: 1px solid #fafafa; padding: 16px 0; }
        .el-table__row:hover td { background-color: rgba(0,0,0,0.01) !important; }
      }
    }

    .user-profile {
      display: flex;
      align-items: center;
      .user-avatar {
        width: 32px; height: 32px; background: #e6e6f2; color: #8a8ab9;
        border-radius: 50%; display: flex; align-items: center; justify-content: center;
        font-size: 12px; font-weight: bold; margin-right: 10px;
      }
      .user-name { font-weight: 500; color: #333; }
    }

    .location-tag { color: #666; font-size: 13px; i { color: #c5a391; } }
    .os-tag { background: #f5f5f5; color: #999; padding: 2px 8px; border-radius: 4px; font-size: 11px; }
    .time-text { color: #bbb; font-size: 12px; }
    
    .op-btn {
      font-size: 13px;
      &.audit { color: #c5a391; }
      &.logout { color: #999; &:hover { color: #b03030; } }
    }
  }

  .pagination-wrapper { padding: 20px 0; display: flex; justify-content: flex-end; }
}
</style>