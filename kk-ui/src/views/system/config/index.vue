<template>
  <div class="app-container" style="background: #fdfdfd; min-height: calc(100vh - 84px); padding: 24px;">
    <div class="header-section">
      <div class="title-group">
        <h2 class="main-title">推荐引擎策略中心</h2>
        <p class="sub-title">Engine Strategy & Logic Configuration</p>
      </div>
      <div class="action-group">
        <el-button type="primary" icon="el-icon-plus" round class="btn-premium" @click="handleAdd">新增策略</el-button>
        <el-button icon="el-icon-refresh" round class="btn-outline" @click="handleRefreshCache">刷新缓存</el-button>
      </div>
    </div>

    <div class="search-bar">
      <el-input
        v-model="queryParams.configName"
        placeholder="搜索策略名称..."
        prefix-icon="el-icon-search"
        class="search-input"
        clearable
        @keyup.enter.native="handleQuery"
      />
      <el-button type="text" icon="el-icon-finished" @click="handleQuery">过滤结果</el-button>
    </div>

    <div v-loading="loading" class="strategy-grid">
      <div v-for="item in configList" :key="item.configId" class="strategy-card">
        <div class="card-glow"></div>
        <div class="card-content">
          <div class="card-header">
            <el-tag size="mini" effect="dark" class="tag-type">{{ item.configKey.split('.')[0] || 'Logic' }}</el-tag>
            <div class="card-actions">
              <i class="el-icon-edit-outline" @click="handleUpdate(item)"></i>
              <i class="el-icon-delete" style="color: #ff7875" @click="handleDelete(item)"></i>
            </div>
          </div>
          
          <h3 class="config-name">{{ item.configName }}</h3>
          <code class="config-key">{{ item.configKey }}</code>
          
          <div class="value-box">
            <span class="value-label">当前权重值</span>
            <span class="value-text">{{ item.configValue }}</span>
          </div>
          
          <p class="config-remark">{{ item.remark || '暂无详细描述...' }}</p>
          
          <div class="card-footer">
            <span class="update-time"><i class="el-icon-time"></i> {{ parseTime(item.createTime, '{y}-{m}-{d}') }}</span>
          </div>
        </div>
      </div>
    </div>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
      style="margin-top: 30px; background: transparent;"
    />

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body class="premium-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="策略名称" prop="configName">
          <el-input v-model="form.configName" placeholder="例如：穿搭权重 - 降水概率" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="逻辑键名 (Config Key)" prop="configKey">
              <el-input v-model="form.configKey" placeholder="outfit.weight.rain" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="策略值 (Value)" prop="configValue">
          <el-input v-model="form.configValue" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="逻辑说明">
          <el-input v-model="form.remark" type="textarea" placeholder="描述此配置如何影响 AI 推荐结果..." />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" round>取 消</el-button>
        <el-button type="primary" @click="submitForm" round class="btn-premium">同步策略</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
/* 标题样式 */
.header-section {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 40px;
}
.main-title {
  font-size: 28px;
  font-weight: 600;
  color: #1d1d1f;
  margin: 0;
  letter-spacing: -0.5px;
}
.sub-title {
  color: #86868b;
  font-size: 14px;
  margin: 4px 0 0 0;
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* 搜索框美化 */
.search-bar {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 30px;
}
.search-input >>> .el-input__inner {
  border: none;
  background: #f5f5f7;
  border-radius: 12px;
  height: 45px;
  width: 300px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.search-input >>> .el-input__inner:focus {
  background: #fff;
  box-shadow: 0 0 0 4px rgba(0, 122, 255, 0.1);
}

/* 策略卡片网格 */
.strategy-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 25px;
}
.strategy-card {
  position: relative;
  background: #fff;
  border-radius: 24px;
  padding: 24px;
  border: 1px solid #f2f2f2;
  transition: all 0.4s ease;
  overflow: hidden;
  cursor: default;
}
.strategy-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0,0,0,0.08);
}
.card-glow {
  position: absolute;
  top: -50%; left: -50%;
  width: 200%; height: 200%;
  background: radial-gradient(circle at center, rgba(0,122,255,0.03) 0%, transparent 70%);
  pointer-events: none;
}

/* 卡片内元素 */
.card-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16px;
}
.tag-type {
  border-radius: 6px;
  background: #1d1d1f;
  border: none;
  font-weight: 500;
}
.card-actions i {
  margin-left: 12px;
  cursor: pointer;
  font-size: 18px;
  color: #86868b;
  transition: color 0.2s;
}
.card-actions i:hover { color: #007aff; }

.config-name {
  font-size: 20px;
  color: #1d1d1f;
  margin: 0 0 8px 0;
  font-weight: 600;
}
.config-key {
  font-family: 'SF Mono', monospace;
  font-size: 12px;
  color: #007aff;
  background: rgba(0,122,255,0.05);
  padding: 4px 8px;
  border-radius: 6px;
}

.value-box {
  margin: 20px 0;
  padding: 16px;
  background: #f5f5f7;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
}
.value-label {
  font-size: 11px;
  color: #86868b;
  text-transform: uppercase;
  margin-bottom: 4px;
}
.value-text {
  font-size: 24px;
  font-weight: 700;
  color: #1d1d1f;
}

.config-remark {
  font-size: 14px;
  color: #48484a;
  line-height: 1.5;
  height: 42px;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.card-footer {
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px solid #f2f2f2;
}
.update-time {
  font-size: 12px;
  color: #aeaeb2;
}

/* 按钮美化 */
.btn-premium {
  background: #007aff !important;
  border: none !important;
  padding: 12px 24px !important;
  font-weight: 500;
  box-shadow: 0 4px 14px 0 rgba(0,118,255,0.39);
}
.btn-outline {
  border: 1px solid #d2d2d7 !important;
  color: #1d1d1f !important;
  padding: 12px 24px !important;
}

/* 对话框美化 */
.premium-dialog >>> .el-dialog {
  border-radius: 28px;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}
.premium-dialog >>> .el-dialog__header {
  padding: 30px 30px 10px;
}
.premium-dialog >>> .el-dialog__title {
  font-weight: 600;
  font-size: 22px;
}
</style>

<script>
// 方法和逻辑保持不变，只需确保引入的 JS 逻辑与之前一致即可
import { listConfig, getConfig, delConfig, addConfig, updateConfig, refreshCache } from "@/api/system/config"

export default {
  name: "Config",
  data() {
    return {
      loading: true,
      ids: [],
      total: 0,
      configList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        configName: undefined,
        configKey: undefined
      },
      form: {},
      rules: {
        configName: [{ required: true, message: "标题必填", trigger: "blur" }],
        configKey: [{ required: true, message: "键名必填", trigger: "blur" }],
        configValue: [{ required: true, message: "数值必填", trigger: "blur" }]
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
    handleAdd() { this.reset(); this.open = true; this.title = "New Strategy"; },
    handleUpdate(row) {
      this.reset();
      getConfig(row.configId).then(res => {
        this.form = res.data;
        this.open = true;
        this.title = "Update Strategy";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          const action = this.form.configId ? updateConfig : addConfig;
          action(this.form).then(() => {
            this.$modal.msgSuccess("策略同步成功");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    handleDelete(row) {
      this.$modal.confirm('确定要废弃此项推荐逻辑吗？').then(() => {
        return delConfig(row.configId);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("策略已移除");
      });
    },
    handleRefreshCache() {
      refreshCache().then(() => this.$modal.msgSuccess("引擎缓存已更新"));
    }
  }
}
</script>