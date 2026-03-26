<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">业务参数配置 <span class="sub-title">/ Dictionary Type</span></h2>
    </div>

    <div class="glass-toolbar search-bar">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="参数名称" prop="dictName">
          <el-input
            v-model="queryParams.dictName"
            placeholder="如：穿搭风格"
            clearable
            @keyup.enter.native="handleQuery"
            class="fancy-input-small"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 100px">
            <el-option
              v-for="dict in dict.type.sys_normal_disable"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            />
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
          <el-button
            type="primary"
            icon="el-icon-plus"
            size="medium"
            class="btn-gradient-add"
            @click="handleAdd"
          >新增类型</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="danger"
            icon="el-icon-delete"
            size="medium"
            class="btn-glass-del"
            :disabled="multiple"
            @click="handleDelete"
          >批量移除</el-button>
        </el-col>
      </el-row>
    </div>

    <div class="table-wrapper">
      <el-table v-loading="loading" :data="typeList" @selection-change="handleSelectionChange" class="custom-glass-table">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="编号" prop="dictId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.dictId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="参数名称" prop="dictName" :show-overflow-tooltip="true" />
        <el-table-column label="参数类型" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            <router-link :to="'/system/dict-data/index/' + scope.row.dictId" class="link-type">
              <span style="color: #c9ab8d; font-weight: bold; cursor: pointer;">{{ scope.row.dictType }}</span>
            </router-link>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" align="center" prop="createTime" width="180">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.createTime) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="160">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" class="btn-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" class="btn-delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body class="fancy-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="参数名称" prop="dictName">
          <el-input v-model="form.dictName" placeholder="请输入参数名称" class="fancy-input" />
        </el-form-item>
        <el-form-item label="参数类型" prop="dictType">
          <el-input v-model="form.dictType" placeholder="请输入参数类型" class="fancy-input" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" class="fancy-input" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-cancel" @click="cancel">取 消</el-button>
        <el-button class="btn-confirm" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listType, getType, delType, addType, updateType, refreshCache } from "@/api/system/dict/type";

export default {
  name: "Dict",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      typeList: [],
      title: "",
      open: false,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        dictName: undefined,
        dictType: undefined,
        status: undefined
      },
      form: {},
      rules: {
        dictName: [
          { required: true, message: "字典名称不能为空", trigger: "blur" }
        ],
        dictType: [
          { required: true, message: "字典类型不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listType(this.queryParams).then(response => {
        this.typeList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    cancel() {
      this.open = false;
      this.reset();
    },
    reset() {
      this.form = {
        dictId: undefined,
        dictName: undefined,
        dictType: undefined,
        status: "0",
        remark: undefined
      };
      this.resetForm("form");
    },
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "✨ 新增参数类型";
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.dictId);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    handleUpdate(row) {
      this.reset();
      const dictId = row.dictId || this.ids;
      getType(dictId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "📝 修改参数配置";
      });
    },
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.dictId != undefined) {
            updateType(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addType(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(row) {
      const dictIds = row.dictId || this.ids;
      this.$modal.confirm('是否确认删除编号为"' + dictIds + '"的数据项？').then(function() {
        return delType(dictIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped lang="scss">
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 30px;
  background: url('https://images.unsplash.com/photo-1445205170230-053b830c6039?q=80&w=2070') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;

  .welcome-section {
    margin-bottom: 25px;
    .page-title {
      color: #333;
      font-size: 24px;
      font-weight: 800;
      .sub-title {
        color: #888;
        font-size: 14px;
        margin-left: 10px;
      }
    }
  }

  .glass-toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 50px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }

  .table-wrapper {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr {
      background: transparent !important;
    }
    ::v-deep th.el-table__cell {
      background: transparent !important;
      color: #333;
      font-weight: 800;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }
    ::v-deep td.el-table__cell {
      border-bottom: 1px solid rgba(0, 0, 0, 0.03);
    }
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none;
    border-radius: 20px;
    color: white;
    font-weight: bold;
    box-shadow: 0 4px 15px rgba(201, 171, 141, 0.4);
    &:hover { transform: translateY(-2px); opacity: 0.9; }
  }

  /* 批量删除按钮样式优化：磨砂红色 */
  .btn-glass-del {
    background: rgba(255, 73, 73, 0.1) !important;
    border-radius: 20px;
    color: #ff4949 !important;
    border: 1px solid rgba(255, 73, 73, 0.3) !important;
    backdrop-filter: blur(5px);
    transition: all 0.3s;
    &:hover { 
      background: rgba(255, 73, 73, 0.2) !important;
      box-shadow: 0 4px 12px rgba(255, 73, 73, 0.2);
    }
    &.is-disabled {
       background: rgba(200, 200, 200, 0.1) !important;
       color: #999 !important;
       border: 1px solid rgba(200, 200, 200, 0.2) !important;
    }
  }

  .id-badge {
    color: #c9ab8d;
    font-family: monospace;
    font-weight: bold;
    background: rgba(201, 171, 141, 0.1);
    padding: 2px 8px;
    border-radius: 6px;
  }

  .btn-edit { color: #c9ab8d !important; font-weight: bold; margin-right: 10px; }
  
  /* 表格内删除按钮：亮红色+渐变感 */
  .btn-delete { 
    color: #ff6b6b !important; 
    font-weight: bold;
    transition: all 0.2s;
    &:hover {
      color: #ff4949 !important;
      text-shadow: 0 0 8px rgba(255, 107, 107, 0.3);
      transform: scale(1.05);
    }
  }
}

/* 弹窗高级感 */
::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    background: rgba(255, 255, 255, 0.9) !important;
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.3);
  }
  .el-dialog__title { font-weight: 800; color: #333; }
  .btn-confirm {
    background: #333 !important;
    color: white;
    border-radius: 15px;
    padding: 10px 25px;
    border: none;
  }
  .btn-cancel {
    border-radius: 15px;
    padding: 10px 25px;
  }
  .el-form-item__label { font-weight: bold; color: #555; }
}
</style>

<style lang="scss">
.el-message-box {
  border-radius: 20px !important;
  border: none !important;
  backdrop-filter: blur(10px);
  background: rgba(255, 255, 255, 0.9) !important;
  .el-message-box__title {
    font-weight: bold;
    color: #333;
  }
  .el-button--primary {
    background-color: #333 !important;
    border-color: #333 !important;
    border-radius: 10px !important;
  }
  .el-button--default {
    border-radius: 10px !important;
  }
}
::v-deep .el-tag {
  border-radius: 8px;           // 更圆润的边角，符合你的 Dialog 风格
  font-weight: 700;             // 加粗字体，在模糊背景下更清晰
  padding: 0 12px;
  height: 28px;
  line-height: 26px;
  border: 1px solid transparent; 
  transition: all 0.3s cubic-bezier(0.645, 0.045, 0.355, 1);
  backdrop-filter: blur(4px);   // 标签自身也带微弱磨砂效果

  // 1. "正常" 状态 (success/light) - 采用莫兰迪绿系
  &.el-tag--success, &.el-tag--light { 
    background: rgba(66, 185, 131, 0.15) !important; 
    color: #389e72 !important; 
    border-color: rgba(66, 185, 131, 0.3) !important;
    
    // 呼吸感小圆点
    &::before {
      content: '';
      display: inline-block;
      width: 6px;
      height: 6px;
      background: #42b983;
      border-radius: 50%;
      margin-right: 6px;
      vertical-align: middle;
      box-shadow: 0 0 8px rgba(66, 185, 131, 0.6); // 发光效果
    }
  }

  // 2. "停用/异常" 状态 (danger) - 采用磨砂红系
  &.el-tag--danger {
    background: rgba(255, 107, 107, 0.15) !important;
    color: #e65b5b !important;
    border-color: rgba(255, 107, 107, 0.3) !important;
    
    &::before {
      content: '';
      display: inline-block;
      width: 6px;
      height: 6px;
      background: #ff6b6b;
      border-radius: 50%;
      margin-right: 6px;
      vertical-align: middle;
      box-shadow: 0 0 8px rgba(255, 107, 107, 0.6);
    }
  }

  // 3. 悬停交互：轻微上浮与亮度提升
  &:hover {
    transform: translateY(-2px);
    filter: brightness(1.1);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
}

/* 修正表格内文字垂直居中问题 */
.custom-glass-table {
  ::v-deep .cell {
    display: flex;
    align-items: center;
    justify-content: center; // 如果你希望居中对齐
  }
}
</style>