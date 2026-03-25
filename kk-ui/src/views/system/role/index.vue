<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">权限角色中心 <span class="sub-title">/ Role Management</span></h2>
    </div>

    <div class="glass-toolbar search-bar">
      <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="queryParams.roleName" placeholder="输入名称" clearable @keyup.enter.native="handleQuery" class="fancy-input-small" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="queryParams.status" placeholder="状态" clearable style="width: 100px">
            <el-option v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
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
          <el-button type="primary" icon="el-icon-plus" size="medium" class="btn-gradient-add" @click="handleAdd">新增角色</el-button>
        </el-col>
        <el-col :span="1.5">
          <el-button type="danger" icon="el-icon-delete" size="medium" class="btn-glass-del" :disabled="multiple" @click="handleDelete">批量移除</el-button>
        </el-col>
      </el-row>
    </div>

    <div class="table-wrapper">
      <el-table v-loading="loading" :data="roleList" @selection-change="handleSelectionChange" class="custom-glass-table">
        <el-table-column type="selection" width="55" align="center" />
        <el-table-column label="编号" prop="roleId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.roleId }}</span>
          </template>
        </el-table-column>
        <el-table-column label="角色名称" prop="roleName" :show-overflow-tooltip="true" />
        <el-table-column label="权限字符" prop="roleKey" :show-overflow-tooltip="true" />
        <el-table-column label="等级" align="center" width="120">
          <template slot-scope="scope">
            <el-tag :type="scope.row.roleId === 1 ? 'warning' : 'info'" effect="dark">
              {{ scope.row.roleId === 1 ? '超级管理' : '职能角色' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" align="center" width="100">
          <template slot-scope="scope">
            <el-switch v-model="scope.row.status" active-value="0" inactive-value="1" active-color="#c9ab8d" @change="handleStatusChange(scope.row)" />
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="220">
          <template slot-scope="scope" v-if="scope.row.roleId !== 1">
            <el-button size="mini" type="text" icon="el-icon-edit" class="btn-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-circle-check" class="btn-edit" @click="handleDataScope(scope.row)">权限</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" class="btn-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <pagination v-show="total>0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
    </div>

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body class="fancy-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="form.roleName" placeholder="如：搭配顾问" class="fancy-input" />
        </el-form-item>
        <el-form-item label="权限字符" prop="roleKey">
          <el-input v-model="form.roleKey" placeholder="如：advisor" class="fancy-input" />
        </el-form-item>
        <el-form-item label="菜单权限">
          <div class="tree-container">
            <el-checkbox v-model="menuExpand" @change="handleCheckedTreeExpand($event, 'menu')">展开</el-checkbox>
            <el-checkbox v-model="menuNodeAll" @change="handleCheckedTreeNodeAll($event, 'menu')">全选</el-checkbox>
            <el-tree
              class="tree-border glass-tree"
              :data="menuOptions"
              show-checkbox
              ref="menu"
              node-key="id"
              :check-strictly="!form.menuCheckStrictly"
              :props="defaultProps"
            ></el-tree>
          </div>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-cancel" @click="cancel">取消</el-button>
        <el-button class="btn-confirm" @click="submitForm">保存配置</el-button>
      </div>
    </el-dialog>

    <el-dialog title="分配数据权限" :visible.sync="openDataScope" width="500px" append-to-body class="fancy-dialog">
      <el-form :model="form" label-position="top">
        <el-form-item label="角色名称">
          <el-input v-model="form.roleName" :disabled="true" class="fancy-input" />
        </el-form-item>
        <el-form-item label="权限范围">
          <el-select v-model="form.dataScope" style="width:100%">
            <el-option v-for="item in dataScopeOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-confirm" @click="submitDataScope">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
// 这里保持你原来的所有 import 和 methods 逻辑不变，只需确保样式类名对应上即可
import { listRole, getRole, delRole, addRole, updateRole, dataScope, changeRoleStatus, deptTreeSelect } from "@/api/system/role"
import { treeselect as menuTreeselect, roleMenuTreeselect } from "@/api/system/menu"

export default {
  name: "Role",
  dicts: ['sys_normal_disable'],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      roleList: [],
      title: "",
      open: false,
      openDataScope: false,
      menuExpand: false,
      menuNodeAll: false,
      dateRange: [],
      menuOptions: [],
      dataScopeOptions: [
        { value: "1", label: "全部数据权限" },
        { value: "2", label: "自定数据权限" },
        { value: "5", label: "仅本人数据权限" }
      ],
      queryParams: { pageNum: 1, pageSize: 10, roleName: undefined, roleKey: undefined, status: undefined },
      form: {},
      defaultProps: { children: "children", label: "label" },
      rules: {
        roleName: [{ required: true, message: "角色名称不能为空", trigger: "blur" }],
        roleKey: [{ required: true, message: "权限字符不能为空", trigger: "blur" }]
      }
    }
  },
  created() { this.getList() },
  methods: {
    // ... 这里粘贴你原本 script 里的所有 method 方法，逻辑完全通用 ...
    // 注意：确保 handleAdd, handleUpdate 等方法里的 reset() 正常调用
    getList() {
      this.loading = true;
      listRole(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.roleList = response.rows;
          this.total = response.total;
          this.loading = false;
        }
      );
    },
    handleQuery() { this.queryParams.pageNum = 1; this.getList(); },
    resetQuery() { this.dateRange = []; this.resetForm("queryForm"); this.handleQuery(); },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.roleId);
      this.single = selection.length!=1;
      this.multiple = !selection.length;
    },
    handleStatusChange(row) {
      let text = row.status === "0" ? "启用" : "停用";
      this.$modal.confirm('确认要"' + text + '""' + row.roleName + '"角色吗？').then(function() {
        return changeRoleStatus(row.roleId, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "成功");
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0";
      });
    },
    handleAdd() { this.reset(); menuTreeselect().then(res => { this.menuOptions = res.data; }); this.open = true; this.title = "✨ 新增职能角色"; },
    handleUpdate(row) {
      this.reset();
      const roleId = row.roleId || this.ids;
      roleMenuTreeselect(roleId).then(res => {
        this.menuOptions = res.menus;
        getRole(roleId).then(response => {
          this.form = response.data;
          this.open = true;
          this.$nextTick(() => {
            res.checkedKeys.forEach(v => { this.$refs.menu.setChecked(v, true, false); });
          });
        });
      });
      this.title = "📝 修改角色配置";
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.menuIds = this.$refs.menu.getCheckedKeys().concat(this.$refs.menu.getHalfCheckedKeys());
          if (this.form.roleId != undefined) {
            updateRole(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.open = false; this.getList(); });
          } else {
            addRole(this.form).then(() => { this.$modal.msgSuccess("新增成功"); this.open = false; this.getList(); });
          }
        }
      });
    },
    handleDelete(row) {
      const roleIds = row.roleId || this.ids;
      this.$modal.confirm('确定移除编号为"' + roleIds + '"的角色吗？').then(() => { return delRole(roleIds); }).then(() => { this.getList(); this.$modal.msgSuccess("删除成功"); });
    },
    handleDataScope(row) { this.reset(); getRole(row.roleId).then(res => { this.form = res.data; this.openDataScope = true; }); },
    submitDataScope() { dataScope(this.form).then(() => { this.$modal.msgSuccess("修改成功"); this.openDataScope = false; this.getList(); }); },
    cancel() { this.open = false; this.reset(); },
    reset() {
      if (this.$refs.menu != undefined) { this.$refs.menu.setCheckedKeys([]); }
      this.form = { roleId: undefined, roleName: undefined, roleKey: undefined, roleSort: 0, status: "0", menuIds: [], menuCheckStrictly: true };
      this.resetForm("form");
    },
    handleCheckedTreeExpand(value, type) {
      let treeList = this.menuOptions;
      for (let i = 0; i < treeList.length; i++) { this.$refs.menu.store.nodesMap[treeList[i].id].expanded = value; }
    },
    handleCheckedTreeNodeAll(value, type) { this.$refs.menu.setCheckedNodes(value ? this.menuOptions: []); }
  }
};
</script>

<style scoped lang="scss">
/* 直接复用会员管理的样式，确保视觉统一 */
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 30px;
  background: url('https://source.unsplash.com/1600x900/?fashion,design') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;

  .welcome-section {
    margin-bottom: 25px;
    .page-title { color: #333; font-size: 24px; font-weight: 800; .sub-title { color: #888; font-size: 14px; margin-left: 10px; } }
  }

  .glass-toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 50px;
    margin-bottom: 20px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    display: flex; align-items: center;
    &.search-bar { border-radius: 20px; padding: 10px 20px; }
  }

  .table-wrapper {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255,255,255,0.3);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background: transparent !important; }
    ::v-deep th.el-table__cell { background: transparent !important; color: #333; }
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none; border-radius: 20px;
  }
  
  .btn-glass-del { background: rgba(255, 255, 255, 0.5) !important; border-radius: 20px; color: #ff4949 !important; }
  .id-badge { color: #c9ab8d; font-family: monospace; font-weight: bold; }
  .btn-edit { color: #c9ab8d !important; }
  .btn-delete { color: #ff6b6b !important; }

  .tree-container {
    background: rgba(255,255,255,0.5);
    padding: 15px;
    border-radius: 12px;
    border: 1px solid #eee;
  }
}

::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    background: rgba(255, 255, 255, 0.95) !important;
    backdrop-filter: blur(20px);
    .el-dialog__title { font-weight: 800; }
  }
  .btn-confirm { background: #333 !important; color: white; border-radius: 15px; padding: 10px 25px; }
  .btn-cancel { border-radius: 15px; padding: 10px 25px; }
}
</style>