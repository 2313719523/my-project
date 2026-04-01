<template>
  <div class="app-container strategy-center-wrapper">
    <div class="header-section">
      <div class="title-group">
        <h2 class="main-title">参数管理中心</h2>
        <p class="sub-title">Strategy & Logic Configuration</p>
      </div>
      <div class="action-group">
        <el-button type="primary" icon="el-icon-plus" class="btn-gold" @click="handleAdd">新增策略</el-button>
        <el-button icon="el-icon-refresh" class="btn-outline" @click="handleRefreshCache">刷新缓存</el-button>
      </div>
    </div>

    <div class="search-bar frosted-glass">
      <el-input
        v-model="queryParams.configName"
        placeholder="搜索策略或权重名称..."
        prefix-icon="el-icon-search"
        class="luxury-input"
        clearable
        @keyup.enter.native="handleQuery"
      />
      <el-button type="text" class="filter-link" @click="handleQuery">筛选生效策略</el-button>
    </div>

    <div v-loading="loading" class="strategy-grid">
      <div v-for="item in configList" :key="item.configId" class="strategy-item">
        <div class="luxury-strategy-card frosted-glass">
          <div class="card-header">
            <span class="logic-tag">{{ item.configKey.split('.')[0].toUpperCase() }}</span>
            <div class="card-actions">
              <el-button type="text" icon="el-icon-edit-outline" @click="handleUpdate(item)"></el-button>
              <el-divider direction="vertical"></el-divider>
              <el-button type="text" icon="el-icon-delete" class="delete-btn" @click="handleDelete(item)"></el-button>
            </div>
          </div>
          
          <h3 class="config-name">{{ item.configName }}</h3>
          <div class="key-container">
            <code class="config-key">{{ item.configKey }}</code>
          </div>
          
          <div class="value-display-box">
            <span class="label">当前策略权重值</span>
            <span class="value">{{ item.configValue }}</span>
          </div>
          
          <p class="config-remark">{{ item.remark || '此项逻辑暂未添加详细运维描述...' }}</p>
          
          <div class="card-footer">
            <span class="time"><i class="el-icon-date"></i> {{ parseTime(item.createTime, '{y}-{m}-{d}') }}</span>
            <span class="status-active"><i class="el-icon-check"></i> 实时生效中</span>
          </div>
        </div>
      </div>
    </div>

    <div class="pagination-wrapper">
      <pagination
        v-show="total>0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
    </div>

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body class="luxury-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="策略显示名称" prop="configName">
          <el-input v-model="form.configName" placeholder="例如：穿搭权重 - 下雨天气系数" class="luxury-input-inner" />
        </el-form-item>
        <el-form-item label="引擎键名 (Config Key)" prop="configKey">
          <el-input v-model="form.configKey" placeholder="outfit.weight.rain" class="luxury-input-inner" />
        </el-form-item>
        <el-form-item label="生效数值 (Value)" prop="configValue">
          <el-input v-model="form.configValue" placeholder="请输入数值或配置JSON" class="luxury-input-inner" />
        </el-form-item>
        <el-form-item label="逻辑影响说明">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="描述此配置如何影响 AI 推荐模型..." class="luxury-input-inner" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="btn-outline">暂 缓</el-button>
        <el-button type="primary" @click="submitForm" class="btn-gold">同步至推荐引擎</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listConfig, getConfig, delConfig, addConfig, updateConfig, refreshCache } from "@/api/system/config"

export default {
  name: "Config",
  data() {
    return {
      loading: true,
      total: 0,
      configList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        configName: undefined
      },
      form: {},
      rules: {
        configName: [{ required: true, message: "策略名称必填", trigger: "blur" }],
        configKey: [{ required: true, message: "引擎键名必填", trigger: "blur" }],
        configValue: [{ required: true, message: "策略数值必填", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    getList() {
      this.loading = true;
      listConfig(this.queryParams).then(res => {
        this.configList = res.rows;
        this.total = res.total;
        this.loading = false;
      });
    },
    cancel() { this.open = false; this.reset(); },
    reset() {
      this.form = { configId: undefined, configName: undefined, configKey: undefined, configValue: undefined, remark: undefined };
      this.resetForm("form");
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList(); },
    handleAdd() { this.reset(); this.open = true; this.title = "新增策略项"; },
    handleUpdate(row) {
      this.reset();
      getConfig(row.configId).then(res => {
        this.form = res.data;
        this.open = true;
        this.title = "调整策略逻辑";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          const action = this.form.configId ? updateConfig : addConfig;
          action(this.form).then(() => {
            this.$modal.msgSuccess("策略已实时同步至引擎");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    handleDelete(row) {
      this.$modal.confirm(`确定要废弃[${row.configName}]推荐逻辑吗？`).then(() => {
        return delConfig(row.configId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("策略已移除");
      });
    },
    handleRefreshCache() {
      refreshCache().then(() => this.$modal.msgSuccess("推荐引擎缓存已刷新"));
    }
  }
}
</script>

<style scoped lang="scss">
.strategy-center-wrapper {
  padding: 30px;
  background: #fdfcfb;
  min-height: calc(100vh - 84px);

  .header-section {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    margin-bottom: 30px;
    .main-title { font-size: 26px; color: #1a1a1a; margin: 0; font-weight: 500; }
    .sub-title { color: #c5a391; font-size: 12px; text-transform: uppercase; letter-spacing: 2px; margin-top: 5px; }
  }

  .frosted-glass {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 24px rgba(0,0,0,0.02);
  }

  // 搜索栏
  .search-bar {
    padding: 20px 24px;
    border-radius: 16px;
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    gap: 20px;
    .luxury-input { width: 300px; ::v-deep .el-input__inner { border: none; border-bottom: 1px solid #eee; border-radius: 0; background: transparent; } }
    .filter-link { color: #999; font-size: 13px; &:hover { color: #c5a391; } }
  }

  // 网格
  .strategy-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 25px;
  }

  .luxury-strategy-card {
    padding: 24px;
    border-radius: 24px;
    transition: all 0.3s ease;
    &:hover { transform: translateY(-6px); box-shadow: 0 12px 30px rgba(0,0,0,0.05); }

    .card-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
      .logic-tag { background: #f5f5f5; color: #999; padding: 2px 8px; border-radius: 4px; font-size: 10px; font-weight: bold; letter-spacing: 1px; }
      .card-actions i { color: #ccc; margin-left: 10px; cursor: pointer; &:hover { color: #c5a391; } }
      .delete-btn { color: #ccc; &:hover { color: #f56c6c; } }
    }

    .config-name { font-size: 18px; color: #333; margin: 0 0 10px 0; font-weight: 500; }
    .key-container { margin-bottom: 20px; .config-key { font-family: monospace; color: #c5a391; background: rgba(197, 163, 145, 0.08); padding: 4px 8px; border-radius: 6px; font-size: 12px; } }

    .value-display-box {
      background: #fdfcfb;
      border: 1px dashed #eee;
      padding: 15px;
      border-radius: 12px;
      margin-bottom: 20px;
      display: flex;
      flex-direction: column;
      .label { font-size: 11px; color: #bbb; margin-bottom: 5px; }
      .value { font-size: 24px; font-weight: 300; color: #1a1a1a; font-family: 'Helvetica Neue', Arial; }
    }

    .config-remark { font-size: 13px; color: #888; line-height: 1.6; min-height: 40px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }

    .card-footer {
      margin-top: 20px;
      padding-top: 15px;
      border-top: 1px solid #f9f9f9;
      display: flex;
      justify-content: space-between;
      align-items: center;
      .time { font-size: 11px; color: #ccc; }
      .status-active { font-size: 11px; color: #67c23a; }
    }
  }

  // 按钮
  .btn-gold { background: #1a1a1a; border: none; padding: 12px 25px; border-radius: 8px; &:hover { background: #333; } }
  .btn-outline { border: 1px solid #ddd; color: #666; padding: 12px 25px; border-radius: 8px; }

  // 弹窗
  .luxury-dialog ::v-deep .el-dialog {
    border-radius: 20px;
    .el-dialog__title { font-weight: 500; color: #1a1a1a; }
    .luxury-input-inner .el-input__inner, .luxury-input-inner .el-textarea__inner {
      background: #f9f9f9; border: none; border-radius: 8px;
    }
    .el-form-item__label { font-weight: 500; font-size: 13px; color: #666; }
  }

  .pagination-wrapper { margin-top: 40px; display: flex; justify-content: flex-end; }
}
</style>