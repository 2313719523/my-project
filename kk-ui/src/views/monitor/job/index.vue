<template>
  <div class="app-container job-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">自动化调度中心 <span class="sub-title">/ Outfit Task Scheduler</span></h2>
    </div>

    <div class="glass-toolbar search-bar">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="false" v-show="showSearch">
        <el-form-item label="任务名称" prop="jobName">
          <el-input v-model="queryParams.jobName" placeholder="任务名称" clearable class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 100px">
            <el-option v-for="dict in dict.type.sys_job_status" :key="dict.value" :label="dict.label" :value="dict.value" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" class="btn-search">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery" class="btn-reset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="glass-toolbar actions">
      <el-row :gutter="10">
        <el-col :span="1.5">
          <el-button type="primary" icon="el-icon-plus" size="medium" class="btn-gradient-add" @click="handleAdd">新增任务</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="info" icon="el-icon-s-operation" size="medium" class="btn-glass-log" @click="handleJobLog">查看日志</el-button>
        </el-col>
      </el-row>
    </div>

    <div class="table-wrapper">
      <el-table v-loading="loading" :data="jobList" class="custom-glass-table">
        <el-table-column label="编号" prop="jobId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.jobId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="任务名称" prop="jobName" :show-overflow-tooltip="true" />
        <el-table-column label="调用目标" prop="invokeTarget" :show-overflow-tooltip="true" />
        <el-table-column label="执行周期" prop="cronExpression" align="center" />
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <el-switch v-model="scope.row.status" active-value="0" inactive-value="1" active-color="#c9ab8d" @change="handleStatusChange(scope.row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="220">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" class="btn-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-caret-right" class="btn-edit" @click="handleRun(scope.row)">执行</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" class="btn-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    </div>
</template>

<style scoped lang="scss">
.job-glass-container {
  min-height: calc(100vh - 84px);
  padding: 30px;
  /* 替换成你系统的背景图 */
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); 
  background-size: cover;

  .welcome-section {
    margin-bottom: 25px;
    .page-title { color: #333; font-size: 24px; font-weight: 800; 
      .sub-title { color: #888; font-size: 14px; margin-left: 10px; } 
    }
  }

  .glass-toolbar {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 20px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.3);
  }

  .table-wrapper {
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep .el-table__row { background: transparent !important; }
    ::v-deep th.el-table__cell { background: rgba(255,255,255,0.1) !important; color: #333; font-weight: bold; }
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none; border-radius: 50px; color: white;
  }

  .btn-glass-log {
    background: rgba(255, 255, 255, 0.6) !important;
    border: 1px solid #ddd; border-radius: 50px; color: #666 !important;
  }

  .id-badge { color: #c9ab8d; font-family: monospace; font-weight: bold; }
  .btn-edit { color: #c9ab8d !important; font-weight: bold; }
  .btn-delete { color: #ff6b6b !important; }

  /* 输入框美化 */
  .fancy-input-small {
    ::v-deep .el-input__inner {
      border-radius: 15px;
      background: rgba(255,255,255,0.5);
      border: 1px solid rgba(255,255,255,0.3);
    }
  }
}
</style>