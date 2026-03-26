<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">登录日志监控 <span class="sub-title">/ Login Information</span></h2>
    </div>

    <div class="glass-toolbar search-bar-wrapper">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" class="custom-form">
        <el-form-item label="登录地址" prop="ipaddr">
          <el-input v-model="queryParams.ipaddr" placeholder="请输入地址" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="用户名称" prop="userName">
          <el-input v-model="queryParams.userName" placeholder="请输入名称" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 100px">
            <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="登录时间">
          <el-date-picker
            v-model="dateRange"
            style="width: 230px"
            value-format="yyyy-MM-dd HH:mm:ss"
            type="daterange"
            range-separator="-"
            start-placeholder="开始"
            end-placeholder="结束"
          ></el-date-picker>
        </el-form-item>
        <el-form-item class="operation-btns">
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" class="btn-search">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery" class="btn-reset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="glass-toolbar action-bar-wrapper">
      <el-row :gutter="10">
        <el-col :span="1.5">
          <el-button
            type="danger"
            icon="el-icon-delete"
            size="mini"
            class="btn-glass-del"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['monitor:logininfor:remove']"
          >批量删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            icon="el-icon-brush"
            size="mini"
            class="btn-glass-del"
            @click="handleClean"
            v-hasPermi="['monitor:logininfor:remove']"
          >清空记录</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="primary"
            icon="el-icon-unlock"
            size="mini"
            class="btn-gradient-add"
            :disabled="single"
            @click="handleUnlock"
            v-hasPermi="['monitor:logininfor:unlock']"
          >解锁用户</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            icon="el-icon-download"
            size="mini"
            class="btn-gradient-add"
            @click="handleExport"
            v-hasPermi="['monitor:logininfor:export']"
          >导出日志</el-button>
        </el-col>
        <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" style="float: right"></right-toolbar>
      </el-row>
    </div>

    <div class="table-wrapper">
      <el-table 
        ref="tables" 
        v-loading="loading" 
        :data="list" 
        @selection-change="handleSelectionChange" 
        :default-sort="defaultSort" 
        @sort-change="handleSortChange"
        class="custom-glass-table"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="访问编号" align="center" prop="infoId">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.infoId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="用户名称" align="center" prop="userName" sortable="custom" />
        <el-table-column label="登录地址" align="center" prop="ipaddr" width="130" />
        <el-table-column label="登录地点" align="center" prop="loginLocation" />
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="操作信息" align="center" prop="msg" />
        <el-table-column label="登录日期" align="center" prop="loginTime" sortable="custom" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.loginTime) }}</span>
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
  created() {
    this.getList();
  },
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
      this.$modal.confirm('确认删除编号 "' + infoIds + '" 的日志？').then(() => {
        return delLogininfor(infoIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    handleClean() {
      this.$modal.confirm('确认清空所有日志？').then(() => {
        return cleanLogininfor();
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("清空成功");
      }).catch(() => {});
    },
    handleUnlock() {
      const username = this.selectName;
      this.$modal.confirm('确认解锁用户 "' + username + '" ？').then(() => {
        return unlockLogininfor(username);
      }).then(() => {
        this.$modal.msgSuccess("用户 " + username + " 已解锁");
      }).catch(() => {});
    },
    handleExport() {
      this.download('monitor/logininfor/export', {
        ...this.queryParams
      }, `login_log_${new Date().getTime()}.xlsx`);
    }
  }
};
</script>

<style scoped lang="scss">
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 25px;
  //background: url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=2070') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;
  position: relative;

  .welcome-section {
    margin-bottom: 20px;
    .page-title {
      color: #333; font-size: 22px; font-weight: 800;
      .sub-title { color: #666; font-size: 13px; margin-left: 8px; text-transform: uppercase; }
    }
  }

  /* 核心修复：确保 toolbar 的点击穿透 */
  .glass-toolbar {
    position: relative;
    z-index: 100; /* 提高层级 */
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 15px 20px;
    margin-bottom: 15px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
    
    // 确保内部元素不被遮挡
    overflow: visible; 
  }

  .table-wrapper {
    position: relative;
    z-index: 50;
    background: rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(15px);
    border-radius: 20px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #d4a373 0%, #a98467 100%) !important;
    border: none; color: white !important; border-radius: 8px; font-weight: 600;
    &:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(169, 132, 103, 0.4); }
    &:active { transform: translateY(0); }
  }

  .btn-glass-del {
    background: rgba(255, 107, 107, 0.1) !important;
    border: 1px solid rgba(255, 107, 107, 0.2); color: #ff6b6b !important;
    border-radius: 8px;
    &:hover { background: rgba(255, 107, 107, 0.2) !important; }
  }

  .btn-search {
    background: #4a4a4a !important; border: none; color: white; border-radius: 8px;
  }

  .id-badge {
    background: rgba(212, 163, 115, 0.15); color: #8d6e63;
    padding: 2px 8px; border-radius: 4px; font-family: monospace; font-weight: bold;
  }

  /* 表格透明适配 */
  .custom-glass-table {
    background: transparent !important;
    &::before { display: none; }
    ::v-deep tr { background: transparent !important; }
    ::v-deep .el-table__cell { background: transparent !important; border-bottom: 1px solid rgba(0,0,0,0.05); }
  }
}

/* 状态标签美化 */
::v-deep .el-tag--success { background: rgba(103, 194, 58, 0.1); border: none; color: #67c23a; }
::v-deep .el-tag--danger { background: rgba(245, 108, 108, 0.1); border: none; color: #f56c6c; }
</style>