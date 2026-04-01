<template>
  <div class="app-container logininfor-wrapper">
    <div class="welcome-section">
      <h2 class="page-title">访问准入监控 <span class="sub-title">Access & Login Security</span></h2>
    </div>

    <div class="glass-toolbar search-bar-wrapper">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" class="luxury-form">
        <el-form-item label="登录地址" prop="ipaddr">
          <el-input v-model="queryParams.ipaddr" placeholder="IP Address" clearable class="luxury-input-small" />
        </el-form-item>
        <el-form-item label="用户账号" prop="userName">
          <el-input v-model="queryParams.userName" placeholder="Username" clearable class="luxury-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="Status" clearable style="width: 100px" class="luxury-select">
            <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="起止日期">
          <el-date-picker
            v-model="dateRange"
            style="width: 240px"
            value-format="yyyy-MM-dd HH:mm:ss"
            type="daterange"
            range-separator="-"
            start-placeholder="开始"
            end-placeholder="结束"
            class="luxury-date-picker"
          ></el-date-picker>
        </el-form-item>
        <el-form-item class="btn-group">
          <el-button type="primary" icon="el-icon-search" @click="handleQuery" class="btn-gold">查询</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery" class="btn-outline">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="action-bar-wrapper">
      <div class="left-btns">
        <el-button
          type="danger"
          icon="el-icon-delete"
          size="mini"
          class="btn-text-danger"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['monitor:logininfor:remove']"
        >删除选中</el-button>
        <el-button
          type="text"
          icon="el-icon-brush"
          size="mini"
          class="btn-text-grey"
          @click="handleClean"
          v-hasPermi="['monitor:logininfor:remove']"
        >清理记录</el-button>
        <el-button
          type="primary"
          icon="el-icon-unlock"
          size="mini"
          class="btn-glass-unlock"
          :disabled="single"
          @click="handleUnlock"
          v-hasPermi="['monitor:logininfor:unlock']"
        >解锁账户</el-button>
      </div>
      <div class="right-btns">
        <el-button
          type="text"
          icon="el-icon-download"
          size="mini"
          class="btn-text-gold"
          @click="handleExport"
          v-hasPermi="['monitor:logininfor:export']"
        >导出审计报告</el-button>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" style="float: right; margin-left: 15px"></right-toolbar>
      </div>
    </div>

    <div class="table-wrapper frosted-glass">
      <el-table 
        ref="tables" 
        v-loading="loading" 
        :data="list" 
        @selection-change="handleSelectionChange" 
        :default-sort="defaultSort" 
        @sort-change="handleSortChange"
        class="luxury-table"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="编号" align="center" prop="infoId" width="100">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.infoId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="访问用户" align="center" prop="userName" sortable="custom" />
        <el-table-column label="IP 地址 / 地点" align="center" width="220">
          <template slot-scope="scope">
            <div class="ip-info">
              <span class="ip-addr">{{ scope.row.ipaddr }}</span>
              <span class="location">{{ scope.row.loginLocation }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status" class="luxury-tag"/>
          </template>
        </el-table-column>
        <el-table-column label="反馈消息" align="center" prop="msg" :show-overflow-tooltip="true" />
        <el-table-column label="访问时间" align="center" prop="loginTime" sortable="custom" width="180">
          <template slot-scope="scope">
            <span class="time-text">{{ parseTime(scope.row.loginTime) }}</span>
          </template>
        </el-table-column>
      </el-table>

      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </div>
  </div>
</template>

<script>
import { list, delLogininfor, cleanLogininfor, unlockLogininfor } from "@/api/monitor/logininfor";

export default {
  name: "Logininfor",
  dicts: ['sys_common_status'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      selectName: "",
      showSearch: true,
      total: 0,
      list: [],
      dateRange: [],
      defaultSort: { prop: "loginTime", order: "descending" },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ipaddr: undefined,
        userName: undefined,
        status: undefined
      }
    };
  },
  created() { this.getList(); },
  methods: {
    getList() {
      this.loading = true;
      list(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.list = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.infoId);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
      this.selectName = selection.map(item => item.userName);
    },
    handleSortChange(column) {
      this.queryParams.orderByColumn = column.prop;
      this.queryParams.isAsc = column.order;
      this.getList();
    },
    handleDelete(row) {
      const infoIds = row.infoId || this.ids;
      this.$modal.confirm('确定要移除所选记录吗？').then(() => {
        return delLogininfor(infoIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("记录已删除");
      }).catch(() => {});
    },
    handleClean() {
      this.$modal.confirm('警告：此操作将清空所有登录历史！').then(() => {
        return cleanLogininfor();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("清理完成");
      }).catch(() => {});
    },
    handleUnlock() {
      const username = this.selectName;
      this.$modal.confirm(`确定要解锁用户[${username}]的限制吗？`).then(() => {
        return unlockLogininfor(username);
      }).then(() => {
        this.$modal.msgSuccess(`用户 ${username} 已解锁`);
      }).catch(() => {});
    },
    handleExport() {
      this.download('monitor/logininfor/export', { ...this.queryParams }, `login_log_${new Date().getTime()}.xlsx`);
    }
  }
};
</script>

<style scoped lang="scss">
.logininfor-wrapper {
  padding: 30px;
  background: #fdfcfb;
  min-height: calc(100vh - 84px);

  .welcome-section {
    margin-bottom: 25px;
    .page-title {
      font-size: 24px; color: #1a1a1a; font-weight: 500; margin: 0;
      .sub-title { font-size: 13px; color: #c5a391; margin-left: 10px; letter-spacing: 1px; }
    }
  }

  // 搜索栏：统一高级白
  .glass-toolbar {
    background: white;
    border-radius: 16px;
    padding: 20px 25px;
    margin-bottom: 20px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.02);
    border: 1px solid #f2f2f2;
    
    ::v-deep .el-form-item__label { font-weight: 500; color: #666; }
    .luxury-input-small ::v-deep .el-input__inner { 
      border: none; border-bottom: 1px solid #eee; border-radius: 0; background: transparent; 
      &:focus { border-bottom-color: #c5a391; }
    }
  }

  // 操作按钮栏：统一布局
  .action-bar-wrapper {
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .left-btns { display: flex; gap: 12px; align-items: center; }
    .btn-text-danger { color: #f56c6c; border: none; background: rgba(245, 108, 108, 0.05); }
    .btn-text-grey { color: #999; }
    .btn-text-gold { color: #c5a391; font-weight: bold; }
    .btn-glass-unlock { 
      background: rgba(197, 163, 145, 0.1) !important; 
      border: 1px solid rgba(197, 163, 145, 0.2); 
      color: #c5a391 !important;
      border-radius: 8px;
    }
  }

  // 表格区域：统一磨砂质感
  .frosted-glass {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(12px);
    border-radius: 20px;
    padding: 20px;
    border: 1px solid #fff;
    box-shadow: 0 10px 30px rgba(0,0,0,0.03);
  }

  .luxury-table {
    background: transparent;
    ::v-deep {
      th.el-table__cell { background: #fdfcfb !important; color: #999; font-size: 12px; height: 50px; border: none; }
      td.el-table__cell { border-bottom: 1px solid #f9f9f9; padding: 12px 0; }
      .el-table__row:hover td { background-color: #fdfcfb !important; }
    }
    
    .id-badge { color: #c5a391; font-family: monospace; font-weight: bold; }
    .ip-info {
      display: flex; flex-direction: column;
      .ip-addr { font-size: 13px; color: #333; }
      .location { font-size: 11px; color: #bbb; }
    }
    .time-text { color: #888; font-size: 13px; }
  }

  // 按钮全局统一
  .btn-gold { background: #1a1a1a !important; border: none; border-radius: 8px; color: white; transition: all 0.3s; &:hover { opacity: 0.8; } }
  .btn-outline { border: 1px solid #eee; border-radius: 8px; background: transparent; transition: all 0.3s; &:hover { background: #f9f9f9; } }
}

/* 标签样式穿透统一 */
::v-deep .el-tag--success { 
  background: rgba(103, 194, 58, 0.1) !important; border: none !important; color: #67c23a !important; font-weight: 600; 
}
::v-deep .el-tag--danger { 
  background: rgba(245, 108, 108, 0.1) !important; border: none !important; color: #f56c6c !important; font-weight: 600; 
}
</style>