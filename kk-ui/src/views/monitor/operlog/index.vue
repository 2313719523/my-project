<template>
  <div class="app-container operlog-wrapper">
    <div class="welcome-section">
      <h2 class="page-title">操作审计中心 <span class="sub-title">Operation Audit Logs</span></h2>
    </div>

    <div class="glass-toolbar search-bar-wrapper">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" class="luxury-form">
        <el-form-item label="操作地址" prop="operIp">
          <el-input v-model="queryParams.operIp" placeholder="IP Address" clearable class="luxury-input-small" />
        </el-form-item>
        <el-form-item label="系统模块" prop="title">
          <el-input v-model="queryParams.title" placeholder="Module" clearable class="luxury-input-small" />
        </el-form-item>
        <el-form-item label="操作人" prop="operName">
          <el-input v-model="queryParams.operName" placeholder="Operator" clearable class="luxury-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="Status" clearable style="width: 100px" class="luxury-select">
            <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作时间">
          <el-date-picker
            v-model="dateRange"
            style="width: 240px"
            value-format="yyyy-MM-dd HH:mm:ss"
            type="daterange"
            range-separator="-"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            class="luxury-date-picker"
          ></el-date-picker>
        </el-form-item>
        <el-form-item class="btn-group">
          <el-button type="primary" icon="el-icon-search" @click="handleQuery" class="btn-gold">检索</el-button>
          <el-button icon="el-icon-refresh" @click="resetQuery" class="btn-outline">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="action-bar-wrapper">
      <el-button
        type="danger"
        icon="el-icon-delete"
        size="mini"
        class="btn-text-danger"
        :disabled="multiple"
        @click="handleDelete"
        v-hasPermi="['monitor:operlog:remove']"
      >删除选中</el-button>
      <el-button
        type="text"
        icon="el-icon-brush"
        size="mini"
        class="btn-text-grey"
        @click="handleClean"
        v-hasPermi="['monitor:operlog:remove']"
      >清空全部记录</el-button>
      <el-button
        type="text"
        icon="el-icon-download"
        size="mini"
        class="btn-text-gold"
        @click="handleExport"
        v-hasPermi="['monitor:operlog:export']"
      >导出报表</el-button>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" style="float: right"></right-toolbar>
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
        <el-table-column type="selection" width="50" align="center" />
        <el-table-column label="编号" align="center" prop="operId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.operId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="系统模块" align="center" prop="title" />
        <el-table-column label="操作行为" align="center" prop="businessType">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_oper_type" :value="scope.row.businessType" class="luxury-tag"/>
          </template>
        </el-table-column>
        <el-table-column label="操作人员" align="center" prop="operName" width="120" sortable="custom" />
        <el-table-column label="IP地址 / 地点" align="center" prop="operIp" width="160" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <div class="ip-info">
              <span class="ip-text">{{ scope.row.operIp }}</span>
              <span class="location-text">{{ scope.row.operLocation }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" prop="status">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="记录时间" align="center" prop="operTime" width="170" sortable="custom">
          <template slot-scope="scope">
            <span class="time-text">{{ parseTime(scope.row.operTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="响应" align="center" prop="costTime" width="100" sortable="custom">
          <template slot-scope="scope">
            <span :class="['cost-badge', scope.row.costTime > 500 ? 'slow' : 'fast']">{{ scope.row.costTime }}ms</span>
          </template>
        </el-table-column>
        <el-table-column label="明细" align="center" width="100">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)" class="btn-view-text">详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    <el-dialog title="LOG DETAILS / 审计明细" :visible.sync="open" width="800px" append-to-body class="luxury-dialog">
      <div class="detail-container">
        <el-form ref="form" :model="form" label-width="100px" size="mini">
          <el-row :gutter="20">
            <el-col :span="12">
              <div class="info-card">
                <p class="label">操作模块</p>
                <p class="val gold-text">{{ form.title }} / {{ typeFormat(form) }}</p>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="info-card">
                <p class="label">请求方式</p>
                <p class="val"><el-tag size="mini" effect="dark" class="method-tag">{{ form.requestMethod }}</el-tag></p>
              </div>
            </el-col>
            <el-col :span="24">
              <div class="info-card">
                <p class="label">目标方法 (Method)</p>
                <code class="code-block">{{ form.method }}</code>
              </div>
            </el-col>
            <el-col :span="24">
              <div class="info-card">
                <p class="label">请求参数 (Payload)</p>
                <div class="json-content dark-code">{{ form.operParam }}</div>
              </div>
            </el-col>
            <el-col :span="24">
              <div class="info-card">
                <p class="label">响应结果 (Result)</p>
                <div class="json-content success-code">{{ form.jsonResult }}</div>
              </div>
            </el-col>
            <el-col :span="24" v-if="form.status === 1">
              <div class="info-card">
                <p class="label">错误追溯 (Error Trace)</p>
                <div class="json-content error-code">{{ form.errorMsg }}</div>
              </div>
            </el-col>
          </el-row>
        </el-form>
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
        status: undefined
      }
    }
  },
  created() { this.getList() },
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
      this.$modal.confirm('确定要移除所选审计记录吗？').then(() => {
        return delOperlog(operIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("记录已删除")
      }).catch(() => {})
    },
    handleClean() {
      this.$modal.confirm('警告：此操作将永久清空所有历史操作日志！').then(() => {
        return cleanOperlog()
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("清理完成")
      }).catch(() => {})
    },
    handleExport() {
      this.download('monitor/operlog/export', { ...this.queryParams }, `audit_log_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>

<style scoped lang="scss">
.operlog-wrapper {
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

  // 搜索栏
  .glass-toolbar {
    background: white;
    border-radius: 16px;
    padding: 20px 25px;
    margin-bottom: 20px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.02);
    border: 1px solid #f2f2f2;
    
    ::v-deep .el-form-item__label { font-weight: 500; color: #666; }
    .luxury-input-small ::v-deep .el-input__inner { border: none; border-bottom: 1px solid #eee; border-radius: 0; background: transparent; }
  }

  .action-bar-wrapper {
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 15px;
    .btn-text-danger { color: #f56c6c; border: none; background: rgba(245, 108, 108, 0.05); }
    .btn-text-grey { color: #999; }
    .btn-text-gold { color: #c5a391; font-weight: bold; }
  }

  // 表格
  .frosted-glass {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
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
      .ip-text { font-size: 13px; color: #333; }
      .location-text { font-size: 11px; color: #bbb; }
    }
    .time-text { color: #888; font-size: 13px; }
    
    .cost-badge {
      padding: 3px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;
      &.fast { background: rgba(103, 194, 58, 0.1); color: #67c23a; }
      &.slow { background: rgba(245, 108, 108, 0.1); color: #f56c6c; }
    }
    .btn-view-text { color: #c5a391; font-weight: bold; &:hover { color: #a98467; } }
  }

  // 按钮
  .btn-gold { background: #1a1a1a !important; border: none; border-radius: 8px; color: white; }
  .btn-outline { border: 1px solid #eee; border-radius: 8px; background: transparent; }

  // 弹窗与详情
  .luxury-dialog ::v-deep .el-dialog {
    border-radius: 24px;
    .el-dialog__header { padding: 30px 30px 10px; .el-dialog__title { font-weight: 600; color: #1a1a1a; } }
    
    .detail-container {
      padding: 0 10px;
      .info-card {
        background: #fdfcfb; border-radius: 12px; padding: 15px; margin-bottom: 15px;
        .label { font-size: 11px; color: #bbb; text-transform: uppercase; margin: 0 0 5px 0; }
        .val { font-size: 14px; color: #333; font-weight: 500; margin: 0; }
        .gold-text { color: #c5a391; }
      }
      
      .code-block { display: block; background: #2d2d2d; color: #f8f8f2; padding: 12px; border-radius: 8px; font-family: monospace; font-size: 12px; overflow-x: auto; }
      
      .json-content {
        padding: 15px; border-radius: 12px; font-family: monospace; font-size: 12px; line-height: 1.5;
        max-height: 180px; overflow-y: auto;
        &.dark-code { background: #f5f5f5; color: #666; border: 1px solid #eee; }
        &.success-code { background: rgba(103, 194, 58, 0.05); color: #67c23a; border: 1px solid rgba(103, 194, 58, 0.1); }
        &.error-code { background: rgba(245, 108, 108, 0.05); color: #f56c6c; border: 1px solid rgba(245, 108, 108, 0.1); }
      }
      
      .method-tag { background: #1a1a1a; border: none; border-radius: 4px; padding: 0 8px; }
    }
  }
}
</style>