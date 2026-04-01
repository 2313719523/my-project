<template>
  <div class="app-container cache-list-wrapper">
    <el-row :gutter="20">
      <el-col :span="8">
        <div class="luxury-card frosted-glass">
          <div class="card-header">
            <span class="title"><i class="el-icon-collection"></i> 缓存命名空间</span>
            <el-button
              type="text"
              icon="el-icon-refresh-right"
              class="refresh-btn"
              @click="refreshCacheNames()"
            ></el-button>
          </div>
          <el-table
            v-loading="loading"
            :data="cacheNames"
            :height="tableHeight"
            highlight-current-row
            @row-click="getCacheKeys"
            class="luxury-table"
          >
            <el-table-column label="ID" width="50" type="index" />
            <el-table-column label="名称" align="left" prop="cacheName" :show-overflow-tooltip="true" :formatter="nameFormatter" />
            <el-table-column label="备注" align="center" prop="remark" :show-overflow-tooltip="true" />
            <el-table-column label="清理" width="60" align="center">
              <template slot-scope="scope">
                <el-button size="mini" type="text" class="delete-btn" icon="el-icon-refresh" @click.stop="handleClearCacheName(scope.row)"></el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>

      <el-col :span="8">
        <div class="luxury-card frosted-glass">
          <div class="card-header">
            <span class="title"><i class="el-icon-key"></i> 缓存数据项</span>
            <el-button
              type="text"
              icon="el-icon-refresh-right"
              class="refresh-btn"
              @click="refreshCacheKeys()"
            ></el-button>
          </div>
          <el-table
            v-loading="subLoading"
            :data="cacheKeys"
            :height="tableHeight"
            highlight-current-row
            @row-click="handleCacheValue"
            class="luxury-table"
          >
            <el-table-column label="ID" width="50" type="index" />
            <el-table-column label="缓存键名" align="left" :show-overflow-tooltip="true" :formatter="keyFormatter" />
            <el-table-column label="操作" width="60" align="center">
              <template slot-scope="scope">
                <el-button size="mini" type="text" class="delete-btn" icon="el-icon-delete" @click.stop="handleClearCacheKey(scope.row)"></el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>

      <el-col :span="8">
        <div class="luxury-card frosted-glass content-card">
          <div class="card-header">
            <span class="title"><i class="el-icon-document"></i> 实时数据报文</span>
            <el-button
              type="text"
              icon="el-icon-magic-stick"
              class="clear-all-btn"
              @click="handleClearCacheAll()"
              >全量刷新</el-button
            >
          </div>
          <div class="cache-form-wrapper">
            <el-form :model="cacheForm" label-position="top">
              <el-form-item label="NAMESPACE (空间)">
                <div class="readonly-tag">{{ cacheForm.cacheName || 'Waiting...' }}</div>
              </el-form-item>
              <el-form-item label="KEY (键名)">
                <div class="readonly-tag">{{ cacheForm.cacheKey || 'Waiting...' }}</div>
              </el-form-item>
              <el-form-item label="VALUE (数据详情)">
                <el-input
                  v-model="cacheForm.cacheValue"
                  type="textarea"
                  :rows="12"
                  readonly
                  class="luxury-textarea"
                />
              </el-form-item>
            </el-form>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listCacheName, listCacheKey, getCacheValue, clearCacheName, clearCacheKey, clearCacheAll } from "@/api/monitor/cache"

export default {
  name: "CacheList",
  data() {
    return {
      cacheNames: [],
      cacheKeys: [],
      cacheForm: {},
      loading: true,
      subLoading: false,
      nowCacheName: "",
      tableHeight: window.innerHeight - 260
    }
  },
  created() {
    this.getCacheNames()
  },
  methods: {
    getCacheNames() {
      this.loading = true
      listCacheName().then(response => {
        this.cacheNames = response.data
        this.loading = false
      })
    },
    refreshCacheNames() {
      this.getCacheNames()
      this.$modal.msgSuccess("命名空间已更新")
    },
    handleClearCacheName(row) {
      clearCacheName(row.cacheName).then(() => {
        this.$modal.msgSuccess("缓存已重置");
        this.getCacheKeys()
      })
    },
    getCacheKeys(row) {
      const cacheName = row !== undefined ? row.cacheName : this.nowCacheName
      if (cacheName === "") return
      this.subLoading = true
      listCacheKey(cacheName).then(response => {
        this.cacheKeys = response.data
        this.subLoading = false
        this.nowCacheName = cacheName
      })
    },
    refreshCacheKeys() {
      this.getCacheKeys()
      this.$modal.msgSuccess("键名列表已同步")
    },
    handleClearCacheKey(cacheKey) {
      clearCacheKey(cacheKey).then(() => {
        this.$modal.msgSuccess("单项缓存已清理");
        this.getCacheKeys()
      })
    },
    nameFormatter(row) {
      return row.cacheName.replace(":", "")
    },
    keyFormatter(cacheKey) {
      return cacheKey.replace(this.nowCacheName, "")
    },
    handleCacheValue(cacheKey) {
      getCacheValue(this.nowCacheName, cacheKey).then(response => {
        this.cacheForm = response.data
      })
    },
    handleClearCacheAll() {
      this.$confirm('确定要清理系统所有缓存数据吗？', '系统预警', { type: 'warning' }).then(() => {
        return clearCacheAll()
      }).then(() => {
        this.$modal.msgSuccess("系统全量缓存已刷新")
      }).catch(() => {})
    }
  }
}
</script>

<style scoped lang="scss">
.cache-list-wrapper {
  padding: 24px;
  background: #fdfcfb;
  min-height: calc(100vh - 84px);

  .frosted-glass {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.02);
  }

  .luxury-card {
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 20px;
    height: calc(100vh - 140px);
    display: flex;
    flex-direction: column;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 1px solid #f5f5f5;

      .title {
        font-size: 14px;
        font-weight: 600;
        color: #1a1a1a;
        letter-spacing: 0.5px;
        i { color: #c5a391; margin-right: 8px; }
      }

      .refresh-btn { color: #999; &:hover { color: #c5a391; } }
      .clear-all-btn { color: #f56c6c; font-size: 12px; }
    }
  }

  .luxury-table {
    ::v-deep {
      background: transparent;
      th { background: transparent; color: #999; font-size: 12px; font-weight: 500; }
      td { background: transparent; padding: 12px 0; border-bottom: 1px solid #fafafa; }
      .el-table__row--highlight-current-row td {
        background-color: rgba(197, 163, 145, 0.1) !important; // 选中使用香槟金淡色
      }
    }
    .delete-btn { color: #ccc; &:hover { color: #c5a391; } }
  }

  .cache-form-wrapper {
    padding-top: 10px;
    ::v-deep .el-form-item__label {
      font-size: 11px;
      color: #bbb;
      text-transform: uppercase;
      margin-bottom: 0;
    }
    
    .readonly-tag {
      background: #f9f9f9;
      padding: 8px 12px;
      border-radius: 6px;
      font-size: 13px;
      color: #666;
      font-family: monospace;
      margin-bottom: 10px;
    }

    .luxury-textarea ::v-deep .el-textarea__inner {
      background: #1e1e1e; // 深色背景模拟代码编辑器
      color: #a9d18e; // 淡淡的绿色，很有科技感
      border: none;
      border-radius: 8px;
      font-family: 'Courier New', Courier, monospace;
      font-size: 13px;
      line-height: 1.6;
      padding: 15px;
    }
  }
}
</style>