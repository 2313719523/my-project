<template>
  <div class="app-container notice-harmony-container">
    <div class="search-glass-card shadow-hover">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="公告标题" prop="noticeTitle">
          <el-input
            v-model="queryParams.noticeTitle"
            placeholder="搜索标题..."
            clearable
            class="luxury-input"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item label="分类" prop="noticeType">
          <el-select v-model="queryParams.noticeType" placeholder="全部类型" clearable style="width: 120px" class="luxury-input">
            <el-option
              v-for="dict in dict.type.sys_notice_type"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" round class="btn-champagne" @click="handleQuery">查询</el-button>
          <el-button icon="el-icon-refresh" round class="btn-plain" @click="resetQuery">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="main-content-card shadow-hover">
      <el-row :gutter="15" class="mb18 action-bar">
        <el-col :span="4">
          <el-button
            type="primary"
            icon="el-icon-plus"
            size="mini"
            class="btn-brown"
            @click="handleAdd"
            v-hasPermi="['system:notice:add']"
          >发布动态</el-button>
        </el-col>
        <el-col :span="5">
          <el-button
            type="danger"
            plain
            icon="el-icon-delete"
            size="mini"
            round
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['system:notice:remove']"
          >批量下线</el-button>
        </el-col>
        <el-col :span="15">
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
        </el-col>
      </el-row>

      <el-table
        v-loading="loading"
        :data="noticeList"
        @selection-change="handleSelectionChange"
        class="harmony-table"
      >
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="标题" align="left" prop="noticeTitle" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <div class="title-cell" @click="handleView(scope.row)">
              <span class="main-title">{{ scope.row.noticeTitle }}</span>
              <span v-if="scope.row.status == '0'" class="new-dot"></span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="分类" align="center" prop="noticeType" width="120">
          <template slot-scope="scope">
            <el-tag
              :class="scope.row.noticeType == '1' ? 'tag-notice' : 'tag-announce'"
              size="small"
            >
              <dict-tag :options="dict.type.sys_notice_type" :value="scope.row.noticeType"/>
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="发布官" align="center" prop="createBy" width="120" />
        <el-table-column label="日期" align="center" prop="createTime" width="150">
          <template slot-scope="scope">
            <span class="time-text">{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-view" class="op-btn" @click="handleView(scope.row)">详情</el-button>
            <el-button size="mini" type="text" icon="el-icon-edit" class="op-btn" @click="handleUpdate(scope.row)" v-hasPermi="['system:notice:edit']">编辑</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" class="op-btn delete" @click="handleDelete(scope.row)" v-hasPermi="['system:notice:remove']">删除</el-button>
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

    <el-drawer
      :title="form.noticeTitle"
      :visible.sync="viewOpen"
      direction="rtl"
      size="40%"
      custom-class="luxury-drawer"
    >
      <div class="drawer-content">
        <div class="drawer-meta">
          <span><i class="el-icon-user"></i> {{ form.createBy }}</span>
          <span><i class="el-icon-time"></i> {{ form.createTime }}</span>
        </div>
        <el-divider></el-divider>
        <div class="drawer-body ql-editor" v-html="form.noticeContent"></div>
      </div>
    </el-drawer>

    <el-dialog :title="title" :visible.sync="open" width="780px" append-to-body custom-class="luxury-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="标题" prop="noticeTitle">
              <el-input v-model="form.noticeTitle" placeholder="请输入公告标题" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="类型" prop="noticeType">
              <el-select v-model="form.noticeType" placeholder="选择类型" style="width: 100%">
                <el-option v-for="dict in dict.type.sys_notice_type" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in dict.type.sys_notice_status" :key="dict.value" :label="dict.value">{{dict.label}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="内容">
              <editor v-model="form.noticeContent" :min-height="192"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm" class="btn-brown">确 定</el-button>
        <el-button @click="cancel" round>取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listNotice, getNotice, delNotice, addNotice, updateNotice } from "@/api/system/notice"

export default {
  name: "Notice",
  dicts: ['sys_notice_status', 'sys_notice_type'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      viewOpen: false,
      total: 0,
      noticeList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeTitle: undefined,
        createBy: undefined,
        status: undefined
      },
      form: {},
      rules: {
        noticeTitle: [{ required: true, message: "公告标题不能为空", trigger: "blur" }],
        noticeType: [{ required: true, message: "公告类型不能为空", trigger: "change" }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    handleView(row) {
      const noticeId = row.noticeId || this.ids
      getNotice(noticeId).then(response => {
        this.form = response.data
        this.viewOpen = true
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        noticeId: undefined,
        noticeTitle: undefined,
        noticeType: undefined,
        noticeContent: undefined,
        status: "0"
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.noticeId)
      this.single = selection.length!=1
      this.multiple = !selection.length
    },
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "发布新动态"
    },
    handleUpdate(row) {
      this.reset()
      const noticeId = row.noticeId || this.ids
      getNotice(noticeId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改公告"
      })
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.noticeId != undefined) {
            updateNotice(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addNotice(this.form).then(response => {
              this.$modal.msgSuccess("新增成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      const noticeIds = row.noticeId || this.ids
      this.$modal.confirm('是否确认删除公告编号为"' + noticeIds + '"的数据项？').then(() => {
        return delNotice(noticeIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    }
  }
}
</script>

<style lang="scss">
.notice-harmony-container {
  .el-tag {
    border-radius: 12px !important;
    border: none !important;
    font-weight: 500;
    padding: 0 10px !important;
    height: 24px;
    line-height: 24px;
  }
  .tag-notice {
    background: #f8f0e9 !important;
    color: #b98a6f !important;
  }
  .tag-announce {
    background: #e8f4f0 !important;
    color: #55967e !important;
  }
}
</style>

<style lang="scss" scoped>
$primary-brown: #9b7e6f;
$cream-white: #fdfcfb;

.notice-harmony-container {
  background-color: $cream-white;
  padding: 24px;
  min-height: calc(100vh - 84px);

  .search-glass-card {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
    border-radius: 12px;
    padding: 20px 24px 4px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.5);
  }

  .main-content-card {
    background: #fff;
    border-radius: 12px;
    padding: 24px;
    border: 1px solid rgba(0, 0, 0, 0.02);
  }

  .btn-brown {
    background-color: $primary-brown;
    border-color: $primary-brown;
    color: #fff;
    border-radius: 6px;
    &:hover { background-color: lighten($primary-brown, 5%); }
  }

  .btn-champagne {
    background-color: #c5a391;
    border-color: #c5a391;
    color: #fff;
    &:hover { opacity: 0.9; }
  }

  .btn-plain {
    border-color: #e5e5e5;
    color: #666;
  }

  .harmony-table {
    ::v-deep {
      .el-table__header th {
        background-color: #fcfaf8;
        color: #888;
        font-weight: 500;
        border-bottom: 1px solid #f0f0f0;
      }
      .el-table__row {
        cursor: pointer;
        &:hover td {
          background-color: #fdfcfb !important;
        }
      }
    }
  }

  .title-cell {
    display: flex;
    align-items: center;
    .main-title {
      font-size: 14px;
      color: #333;
      transition: color 0.2s;
    }
    &:hover .main-title {
      color: $primary-brown;
    }
    .new-dot {
      width: 6px;
      height: 6px;
      background-color: #c5a391;
      border-radius: 50%;
      margin-left: 8px;
    }
  }

  .op-btn {
    color: #999;
    font-size: 13px;
    margin: 0 6px;
    &:hover { color: $primary-brown; }
    &.delete:hover { color: #f56c6c; }
  }

  ::v-deep .luxury-drawer {
    .el-drawer__header {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      padding: 20px 30px;
      margin-bottom: 0;
    }
    .drawer-content {
      padding: 0 30px 30px;
      .drawer-meta {
        color: #999;
        font-size: 13px;
        margin-bottom: 15px;
        span { margin-right: 20px; i { margin-right: 4px; } }
      }
      .drawer-body {
        line-height: 1.8;
        font-size: 15px;
        color: #444;
      }
    }
  }

  ::v-deep .luxury-dialog {
    border-radius: 12px;
    .el-dialog__header { padding: 20px 25px; }
    .el-dialog__footer { padding: 20px 25px; border-top: 1px solid #f8f8f8; }
  }

  .shadow-hover {
    transition: all 0.3s ease;
    &:hover {
      box-shadow: 0 10px 30px rgba(155, 126, 111, 0.08);
    }
  }
}
</style>