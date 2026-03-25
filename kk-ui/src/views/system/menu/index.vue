<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">导航架构管理 <span class="sub-title">/ Menu System</span></h2>
    </div>

    <div class="glass-toolbar search-bar">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="菜单名称" prop="menuName">
          <el-input
            v-model="queryParams.menuName"
            placeholder="搜索菜单..."
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
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery" class="btn-search">查询</el-button>
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
            size="mini"
            class="btn-gradient-add"
            @click="handleAdd"
            v-hasPermi="['system:menu:add']"
          >新增根类目</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button
            type="info"
            icon="el-icon-sort"
            size="mini"
            class="btn-glass-sort"
            @click="toggleExpandAll"
          >全部展开/折叠</el-button>
        </el-col>
      </el-row>
    </div>

    <div class="table-wrapper">
      <el-table
        v-if="refreshTable"
        v-loading="loading"
        :data="menuList"
        row-key="menuId"
        :default-expand-all="isExpandAll"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        class="custom-glass-table"
      >
        <el-table-column prop="menuName" label="菜单名称" :show-overflow-tooltip="true" width="160">
          <template slot-scope="scope">
            <span class="menu-name-text">{{ scope.row.menuName }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="icon" label="图标" align="center" width="100">
          <template slot-scope="scope">
            <div class="icon-wrapper">
              <svg-icon :icon-class="scope.row.icon" class-name="menu-svg-icon" />
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="orderNum" label="排序" width="60" align="center"></el-table-column>
        <el-table-column prop="perms" label="权限标识" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="component" label="组件路径" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="status" label="状态" width="80" align="center">
          <template slot-scope="scope">
            <dict-tag :options="dict.type.sys_normal_disable" :value="scope.row.status"/>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-edit"
              class="btn-edit"
              @click="handleUpdate(scope.row)"
              v-hasPermi="['system:menu:edit']"
            >修改</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-plus"
              class="btn-edit"
              @click="handleAdd(scope.row)"
              v-hasPermi="['system:menu:add']"
            >新增</el-button>
            <el-button
              size="mini"
              type="text"
              icon="el-icon-delete"
              class="btn-delete"
              @click="handleDelete(scope.row)"
              v-hasPermi="['system:menu:remove']"
            >删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="680px" append-to-body class="fancy-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-width="100px" label-position="top">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="上级菜单" prop="parentId">
              <treeselect
                v-model="form.parentId"
                :options="menuOptions"
                :normalizer="normalizer"
                :show-count="true"
                placeholder="选择上级菜单"
                class="fancy-treeselect"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="菜单类型" prop="menuType">
              <el-radio-group v-model="form.menuType" class="fancy-radio-group">
                <el-radio-button label="M">目录</el-radio-button>
                <el-radio-button label="C">菜单</el-radio-button>
                <el-radio-button label="F">按钮</el-radio-button>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item label="菜单图标" prop="icon">
              <el-popover
                placement="bottom-start"
                width="460"
                trigger="click"
                @show="$refs['iconSelect'].reset()"
              >
                <IconSelect ref="iconSelect" @selected="selected" :active-icon="form.icon" />
                <el-input slot="reference" v-model="form.icon" placeholder="点击选择图标" readonly class="fancy-input">
                  <svg-icon
                    v-if="form.icon"
                    slot="prefix"
                    :icon-class="form.icon"
                    style="width: 25px; color: #c9ab8d;"
                  />
                  <i v-else slot="prefix" class="el-icon-search el-input__icon" />
                </el-input>
              </el-popover>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="显示排序" prop="orderNum">
              <el-input-number v-model="form.orderNum" controls-position="right" :min="0" class="fancy-number" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="菜单名称" prop="menuName">
              <el-input v-model="form.menuName" placeholder="请输入菜单名称" class="fancy-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType == 'C'">
            <el-form-item prop="routeName">
              <span slot="label">
                <el-tooltip content="默认不填则和路由地址相同" placement="top">
                  <i class="el-icon-question"></i>
                </el-tooltip>
                路由名称
              </span>
              <el-input v-model="form.routeName" placeholder="请输入路由名称" class="fancy-input" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item label="是否外链" prop="isFrame">
              <el-radio-group v-model="form.isFrame" class="fancy-radio-group-small">
                <el-radio label="0">是</el-radio>
                <el-radio label="1">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="form.menuType != 'F'">
            <el-form-item label="路由地址" prop="path">
              <el-input v-model="form.path" placeholder="请输入路由地址" class="fancy-input" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-cancel" @click="cancel">取 消</el-button>
        <el-button type="primary" class="btn-confirm" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
// 此处逻辑完全保持你原来的代码，直接粘贴即可
import { listMenu, getMenu, delMenu, addMenu, updateMenu } from "@/api/system/menu"
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import IconSelect from "@/components/IconSelect"

export default {
  name: "Menu",
  dicts: ['sys_show_hide', 'sys_normal_disable'],
  components: { Treeselect, IconSelect },
  data() {
    return {
      loading: true,
      showSearch: true,
      menuList: [],
      menuOptions: [],
      title: "",
      open: false,
      isExpandAll: false,
      refreshTable: true,
      queryParams: {
        menuName: undefined,
        visible: undefined
      },
      form: {},
      rules: {
        menuName: [{ required: true, message: "菜单名称不能为空", trigger: "blur" }],
        orderNum: [{ required: true, message: "菜单顺序不能为空", trigger: "blur" }],
        path: [{ required: true, message: "路由地址不能为空", trigger: "blur" }]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    selected(name) { this.form.icon = name },
    getList() {
      this.loading = true
      listMenu(this.queryParams).then(response => {
        this.menuList = this.handleTree(response.data, "menuId")
        this.loading = false
      })
    },
    normalizer(node) {
      if (node.children && !node.children.length) { delete node.children }
      return { id: node.menuId, label: node.menuName, children: node.children }
    },
    getTreeselect() {
      listMenu().then(response => {
        this.menuOptions = []
        const menu = { menuId: 0, menuName: '主类目', children: [] }
        menu.children = this.handleTree(response.data, "menuId")
        this.menuOptions.push(menu)
      })
    },
    cancel() { this.open = false; this.reset() },
    reset() {
      this.form = {
        menuId: undefined, parentId: 0, menuName: undefined, icon: undefined,
        menuType: "M", orderNum: undefined, isFrame: "1", isCache: "0",
        visible: "0", status: "0"
      }
      this.resetForm("form")
    },
    handleQuery() { this.getList() },
    resetQuery() { this.resetForm("queryForm"); this.handleQuery() },
    handleAdd(row) {
      this.reset(); this.getTreeselect()
      if (row != null && row.menuId) { this.form.parentId = row.menuId } else { this.form.parentId = 0 }
      this.open = true; this.title = "添加菜单"
    },
    toggleExpandAll() {
      this.refreshTable = false; this.isExpandAll = !this.isExpandAll
      this.$nextTick(() => { this.refreshTable = true })
    },
    handleUpdate(row) {
      this.reset(); this.getTreeselect()
      getMenu(row.menuId).then(response => {
        this.form = response.data; this.open = true; this.title = "修改菜单"
      })
    },
    submitForm: function() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.menuId != undefined) {
            updateMenu(this.form).then(response => {
              this.$modal.msgSuccess("修改成功"); this.open = false; this.getList()
            })
          } else {
            addMenu(this.form).then(response => {
              this.$modal.msgSuccess("新增成功"); this.open = false; this.getList()
            })
          }
        }
      })
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除名称为"' + row.menuName + '"的数据项？').then(function() {
        return delMenu(row.menuId)
      }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功") }).catch(() => {})
    }
  }
}
</script>

<style scoped lang="scss">
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 25px;
 // background: url('https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1600&q=80') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;

  .welcome-section {
    margin-bottom: 20px;
    .page-title { 
      color: #333; font-size: 24px; font-weight: 800; text-shadow: 0 2px 4px rgba(255,255,255,0.5);
      .sub-title { color: #666; font-size: 14px; margin-left: 10px; font-weight: 400; }
    }
  }

  /* 胶囊工具栏 */
  .glass-toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 50px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.05);
    display: flex; align-items: center;
    &.search-bar { border-radius: 20px; padding: 10px 20px; }
  }

  /* 表格卡片 */
  .table-wrapper {
    background: rgba(255, 255, 255, 0.35);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255,255,255,0.3);
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background-color: transparent !important; }
    ::v-deep .el-table__header-wrapper th { 
      background-color: transparent !important; 
      color: #333; font-weight: 800; border-bottom: 2px solid rgba(201, 171, 141, 0.3); 
    }
    ::v-deep .el-table__row:hover > td { background-color: rgba(255,255,255,0.4) !important; }
    
    .menu-name-text { font-weight: 600; color: #444; }
    .icon-wrapper {
      display: inline-flex; padding: 8px;
      background: rgba(201, 171, 141, 0.15); border-radius: 10px;
      .menu-svg-icon { color: #c9ab8d; font-size: 16px; }
    }
  }

  /* 按钮与交互 */
  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none; border-radius: 20px; color: white; transition: 0.3s;
    &:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(201,171,141,0.4); }
  }
  .btn-glass-sort {
    background: rgba(255, 255, 255, 0.5) !important;
    border: 1px solid #c9ab8d !important;
    border-radius: 20px; color: #c9ab8d !important;
  }
  .btn-edit { color: #c9ab8d !important; font-weight: 600; }
  .btn-delete { color: #ff6b6b !important; font-weight: 600; }
}

/* 弹窗样式定制 */
::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,255,255,0.5);
    .el-dialog__header { padding: 30px 30px 10px; }
    .el-dialog__title { font-weight: 800; color: #333; font-size: 20px; }
    .el-form-item__label { font-weight: 700; color: #555; padding-bottom: 4px; }
  }
  
  .fancy-input .el-input__inner, .fancy-treeselect .vue-treeselect__control {
    border-radius: 15px !important;
    background: rgba(245, 245, 245, 0.5) !important;
    border: 1px solid #eee !important;
    &:focus { border-color: #c9ab8d !important; background: #fff !important; }
  }

  .fancy-radio-group {
    .el-radio-button__inner {
      border-radius: 12px !important; margin-right: 12px;
      border: 1px solid #eee !important; transition: 0.3s;
    }
    .el-radio-button__orig-radio:checked + .el-radio-button__inner {
      background: #c9ab8d !important; border-color: #c9ab8d !important;
      box-shadow: 0 4px 12px rgba(201,171,141,0.3);
    }
  }

  .btn-confirm { background: #333 !important; border: none; border-radius: 15px; padding: 12px 35px; }
  .btn-cancel { border-radius: 15px; padding: 12px 35px; border: 1px solid #ddd; }
}
</style>