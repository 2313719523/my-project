<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">数据字典中心 <span class="sub-title">/ Dictionary Data</span></h2>
    </div>

    <div class="glass-toolbar search-bar">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true">
        <el-form-item label="所属类型" prop="dictType">
          <el-select v-model="queryParams.dictType" class="fancy-select">
            <el-option
              v-for="item in typeOptions"
              :key="item.dictId"
              :label="item.dictName"
              :value="item.dictType"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="标签名称" prop="dictLabel">
          <el-input
            v-model="queryParams.dictLabel"
            placeholder="如：学院风"
            clearable
            class="fancy-input-small"
            @keyup.enter.native="handleQuery"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" class="btn-search">搜索</el-button>
          <el-button icon="el-icon-close" size="mini" @click="handleClose" class="btn-reset">关闭</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="glass-toolbar actions">
      <el-button
        type="primary"
        icon="el-icon-plus"
        size="medium"
        class="btn-gradient-add"
        @click="handleAdd"
      >新增标签数据</el-button>
    </div>

    <div class="table-wrapper">
      <el-table v-loading="loading" :data="dataList" class="custom-glass-table">
        <el-table-column label="数据标签" align="center" prop="dictLabel">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.listClass === 'primary' ? '' : scope.row.listClass"
              effect="dark"
              :style="{ 'border-radius': '8px', 'background': scope.row.cssClass, 'border': 'none' }"
            >
              {{ scope.row.dictLabel }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="数据键值" align="center" prop="dictValue" />
        <el-table-column label="显示排序" align="center" prop="dictSort" width="80" />
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="备注" align="center" prop="remark" :show-overflow-tooltip="true" />
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
        <el-form-item label="参数类型">
          <el-input v-model="form.dictType" :disabled="true" class="fancy-input" />
        </el-form-item>
        <el-form-item label="标签名称" prop="dictLabel">
          <el-input v-model="form.dictLabel" placeholder="请输入数据标签" class="fancy-input" />
        </el-form-item>
        <el-form-item label="数据键值" prop="dictValue">
          <el-input v-model="form.dictValue" placeholder="请输入数据键值" class="fancy-input" />
        </el-form-item>
        <el-form-item label="样式属性 (CSS/颜色代码)" prop="cssClass">
          <el-input v-model="form.cssClass" placeholder="可填写十六进制颜色代码，如 #c9ab8d" class="fancy-input" />
        </el-form-item>
        <el-form-item label="显示排序" prop="dictSort">
          <el-input-number v-model="form.dictSort" controls-position="right" :min="0" />
        </el-form-item>
        <el-form-item label="回显样式" prop="listClass">
          <el-select v-model="form.listClass" style="width: 100%">
            <el-option
              v-for="item in listClassOptions"
              :key="item.value"
              :label="item.label + '(' + item.value + ')'"
              :value="item.value"
            />
          </el-select>
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
import { listData, getData, delData, addData, updateData } from "@/api/system/dict/data";
import { optionselect as getDictOptionselect, getType } from "@/api/system/dict/type";

export default {
  name: "Data",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 字典表格数据
      dataList: [],
      // 默认字典类型
      defaultDictType: "",
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 数据标签回显样式
      listClassOptions: [
        { value: "default", label: "默认" },
        { value: "primary", label: "主要" },
        { value: "success", label: "成功" },
        { value: "info", label: "信息" },
        { value: "warning", label: "警告" },
        { value: "danger", label: "危险" }
      ],
      // 类型数据列表
      typeOptions: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        dictName: undefined,
        dictType: undefined,
        status: undefined
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        dictLabel: [
          { required: true, message: "数据标签不能为空", trigger: "blur" }
        ],
        dictValue: [
          { required: true, message: "数据键值不能为空", trigger: "blur" }
        ],
        dictSort: [
          { required: true, message: "数据顺序不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    const dictId = this.$route.params && this.$route.params.dictId;
    this.getType(dictId);
    this.getTypeList();
  },
  methods: {
    /** 查询字典类型详细 */
    getType(dictId) {
      getType(dictId).then(response => {
        this.queryParams.dictType = response.data.dictType;
        this.defaultDictType = response.data.dictType;
        this.getList();
      });
    },
    /** 查询字典类型列表 */
    getTypeList() {
      getDictOptionselect().then(response => {
        this.typeOptions = response.data;
      });
    },
    /** 查询字典数据列表 */
    getList() {
      this.loading = true;
      listData(this.queryParams).then(response => {
        this.dataList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        dictCode: undefined,
        dictLabel: undefined,
        dictValue: undefined,
        cssClass: undefined,
        listClass: 'default',
        dictSort: 0,
        status: "0",
        remark: undefined
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 返回按钮操作 */
    handleClose() {
      const obj = { path: "/system/dict" };
      this.$tab.closeOpenPage(obj);
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.queryParams.dictType = this.defaultDictType;
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "✨ 添加字典数据";
      this.form.dictType = this.queryParams.dictType;
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.dictCode);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const dictCode = row.dictCode || this.ids;
      getData(dictCode).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "📝 修改参数标签";
      });
    },
    /** 提交按钮 */
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.dictCode != undefined) {
            updateData(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addData(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const dictCodes = row.dictCode || this.ids;
      this.$modal.confirm('是否确认删除数据项？').then(function() {
        return delData(dictCodes);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped lang="scss">
/* 这里的样式与 index.vue 保持高度一致以确前风格统一 */
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 30px;
  background: url('https://images.unsplash.com/photo-1445205170230-053b830c6039?q=80&w=2070') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;

  .welcome-section {
    margin-bottom: 25px;
    .page-title {
      color: #333; font-size: 24px; font-weight: 800;
      .sub-title { color: #888; font-size: 14px; margin-left: 10px; }
    }
  }

  .glass-toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 50px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
  }

  .table-wrapper {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.3);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background: transparent !important; }
    ::v-deep th.el-table__cell {
      background: transparent !important; color: #333; font-weight: 800;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }
    ::v-deep td.el-table__cell { border-bottom: 1px solid rgba(0, 0, 0, 0.03); }
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none; border-radius: 20px; color: white; font-weight: bold;
  }
  
  .btn-search { background: #333 !important; border: none; border-radius: 12px; }
  .btn-reset { background: rgba(255,255,255,0.8); border-radius: 12px; color: #333; }

  .btn-edit { color: #c9ab8d !important; font-weight: bold; }
  .btn-delete { color: #ff6b6b !important; font-weight: bold; }
}

::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    background: rgba(255, 255, 255, 0.9) !important;
    backdrop-filter: blur(20px);
  }
  .btn-confirm {
    background: #333 !important; color: white;
    border-radius: 15px; padding: 10px 25px;
  }
  .btn-cancel { border-radius: 15px; padding: 10px 25px; }
}
</style>