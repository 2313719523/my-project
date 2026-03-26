<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">系统操作日志 <span class="sub-title">/ Operation Logs</span></h2>
    </div>

    <div class="glass-toolbar search-bar-wrapper">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="操作地址" prop="operIp">
          <el-input v-model="queryParams.operIp" placeholder="请输入地址" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="系统模块" prop="title">
          <el-input v-model="queryParams.title" placeholder="请输入模块" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="操作人员" prop="operName">
          <el-input v-model="queryParams.operName" placeholder="请输入人员" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 100px">
            <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="时间">
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
        <el-form-item>
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
            v-hasPermi="['monitor:operlog:remove']"
          >批量删除</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            icon="el-icon-brush"
            size="mini"
            class="btn-glass-del"
            @click="handleClean"
            v-hasPermi="['monitor:operlog:remove']"
          >清空日志</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="warning"
            icon="el-icon-download"
            size="mini"
            class="btn-gradient-add"
            @click="handleExport"
            v-hasPermi="['monitor:operlog:export']"
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
        <el-table-column type="selection" width="50" align="center" />
        <el-table-column label="编号" align="center" prop="operId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.operId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="系统模块" align="center" prop="title" :show-overflow-tooltip="true" />
        <el-table-column label="操作类型" align="center" prop="businessType">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_oper_type" :value="scope.row.businessType"/>
          </template>
        </el-table-column>
        <el-table-column label="操作人员" align="center" prop="operName" width="110" sortable="custom" />
        <el-table-column label="地址/地点" align="center" prop="operIp" width="130" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <span>{{ scope.row.operIp }}</span><br/>
            <small style="color: #999">{{ scope.row.operLocation }}</small>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="日期" align="center" prop="operTime" width="160" sortable="custom">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.operTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="耗时" align="center" prop="costTime" width="100" sortable="custom">
          <template slot-scope="scope">
            <span class="cost-time">{{ scope.row.costTime }}ms</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="80">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" class="text-btn-gold">详细</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    <el-dialog title="🔍 日志明细" :visible.sync="open" width="800px" append-to-body class="fancy-dialog">
      <div class="glass-detail-body">
        <el-form ref="form" :model="form" label-width="100px" size="mini">
          <el-row>
            <el-col :span="12">
              <el-form-item label="操作模块："><b class="highlight-text">{{ form.title }} / {{ typeFormat(form) }}</b></el-form-item>
              <el-form-item label="操作人员：">{{ form.operName }} / {{ form.operIp }}</el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="请求方式："><el-tag size="mini">{{ form.requestMethod }}</el-tag></el-form-item>
              <el-form-item label="请求耗时："><span class="success-text">{{ form.costTime }}毫秒</span></el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="操作方法："><code class="code-block">{{ form.method }}</code></el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="请求参数：">
                <div class="json-content">{{ form.operParam }}</div>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="返回参数：">
                <div class="json-content success">{{ form.jsonResult }}</div>
              </el-form-item>
            </el-col>
            <el-col :span="24" v-if="form.status === 1">
              <el-form-item label="异常信息：">
                <div class="json-content error">{{ form.errorMsg }}</div>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-search" @click="open = false" style="padding: 10px 30px">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { list, delOperlog, cleanOperlog } from "@/api/monitor/operlog"

export default {
  name: "Operlog",
  dicts: ['sys_oper_type', 'sys_common_status'],
  data() {
    return {
      loading: true,
      ids: [],
      multiple: true,
      showSearch: true,
      total: 0,
      list: [],
      open: false,
      dateRange: [],
      defaultSort: { prop: "operTime", order: "descending" },
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operIp: undefined,
        title: undefined,
        operName: undefined,
        businessType: undefined,
        status: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      list(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.list = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    typeFormat(row) {
      return this.selectDictLabel(this.dict.type.sys_oper_type, row.businessType)
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.operId)
      this.multiple = !selection.length
    },
    handleSortChange(column) {
      this.queryParams.orderByColumn = column.prop
      this.queryParams.isAsc = column.order
      this.getList()
    },
    handleView(row) {
      this.open = true
      this.form = row
    },
    handleDelete(row) {
      const operIds = row.operId || this.ids
      this.$modal.confirm('确认删除编号 "' + operIds + '" 的日志记录吗？').then(() => {
        return delOperlog(operIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleClean() {
      this.$modal.confirm('确定清空所有操作日志吗？').then(() => {
        return cleanOperlog()
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("清空成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download('monitor/operlog/export', {
        ...this.queryParams
      }, `operlog_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

<style scoped lang="scss">
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 25px;
  //background: url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=2070') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;
  position: relative;
  z-index: 1;

  .welcome-section {
    margin-bottom: 20px;
    .page-title {
      color: #333; font-size: 22px; font-weight: 800;
      .sub-title { color: #666; font-size: 13px; margin-left: 8px; }
    }
  }

  /* 核心修复层级：防止点击失效 */
  .glass-toolbar {
    position: relative;
    z-index: 100;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(12px);
    border-radius: 15px;
    padding: 15px 20px;
    margin-bottom: 15px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  }

  .table-wrapper {
    position: relative;
    z-index: 50;
    background: rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(20px);
    border-radius: 20px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background: transparent !important; }
    ::v-deep th.el-table__cell {
      background: rgba(255, 255, 255, 0.2) !important; color: #333; font-weight: 800;
    }
    ::v-deep td.el-table__cell { border-bottom: 1px solid rgba(0,0,0,0.03); }
  }

  /* 按钮样式重塑 */
  .btn-gradient-add {
    background: linear-gradient(135deg, #d4a373 0%, #a98467 100%) !important;
    border: none; color: white !important; border-radius: 8px; font-weight: 600;
    cursor: pointer;
    &:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(169, 132, 103, 0.4); }
  }

  .btn-glass-del {
    background: rgba(255, 107, 107, 0.1) !important;
    border: 1px solid rgba(255, 107, 107, 0.2); color: #ff6b6b !important;
    border-radius: 8px;
    cursor: pointer;
    &:hover { background: rgba(255, 107, 107, 0.2) !important; }
  }

  .btn-search {
    background: #333 !important; border: none; color: white; border-radius: 8px; cursor: pointer;
  }

  .btn-reset { border-radius: 8px; background: rgba(255,255,255,0.8) !important; cursor: pointer; }

  .id-badge {
    background: rgba(212, 163, 115, 0.15); color: #8d6e63;
    padding: 2px 8px; border-radius: 4px; font-family: monospace; font-weight: bold;
  }

  .cost-time { font-weight: bold; color: #a98467; }
  .text-btn-gold { color: #a98467 !important; font-weight: bold; }

  /* 详情弹窗特有样式 */
  .highlight-text { color: #a98467; font-size: 15px; }
  .success-text { color: #67c23a; font-weight: bold; }
  .code-block { background: #f4f4f5; padding: 5px 10px; border-radius: 5px; color: #666; display: block; overflow-x: auto; }
  
  .json-content {
    background: rgba(0,0,0,0.03);
    padding: 12px;
    border-radius: 10px;
    font-family: monospace;
    max-height: 200px;
    overflow-y: auto;
    border-left: 4px solid #ddd;
    &.success { color: #67c23a; border-left-color: #67c23a; }
    &.error { color: #f56c6c; border-left-color: #f56c6c; }
  }
}

/* 弹窗全局覆盖 */
::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 20px !important;
    background: rgba(255, 255, 255, 0.95) !important;
    backdrop-filter: blur(10px);
    overflow: hidden;
    .el-dialog__header { padding-top: 25px; .el-dialog__title { font-weight: 800; } }
  }
}

/* 标签穿透修正 */
::v-deep .el-tag {
  border-radius: 6px;
  font-weight: 600;
  &.el-tag--success { background: rgba(103, 194, 58, 0.1); border: none; color: #67c23a; }
  &.el-tag--danger { background: rgba(245, 108, 108, 0.1); border: none; color: #f56c6c; }
}
</style>