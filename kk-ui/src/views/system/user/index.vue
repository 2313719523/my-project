<template>
  <div class="app-container member-glass-container">
    <div class="welcome-section">
      <h2 class="page-title">会员管理中心 <span class="sub-title">/ Member Management</span></h2>
    </div>

    <div class="glass-toolbar">
      <el-row :gutter="15">
        <el-col :span="1.5">
          <el-button 
            type="primary" 
            icon="el-icon-plus" 
            size="medium" 
            class="btn-gradient-add" 
            @click="handleAdd"
          >新增会员</el-button>
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
      <el-table 
        v-loading="loading" 
        :data="userList" 
        class="custom-glass-table"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" align="center" />
        
        <el-table-column label="编号" align="center" prop="userId" width="80">
          <template slot-scope="scope">
            <span class="id-badge">#{{ scope.row.userId }}</span>
          </template>
        </el-table-column>

        <el-table-column label="会员信息" min-width="150">
          <template slot-scope="scope">
            <div class="user-info-cell">
              <div class="user-avatar">{{ scope.row.nickName.substring(0,1) }}</div>
              <div class="user-detail">
                <div class="u-nickname">{{ scope.row.nickName }}</div>
                <div class="u-account">ID: {{ scope.row.userName }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="所属角色" align="center" min-width="120">
          <template slot-scope="scope">
            <el-tag 
              v-for="role in scope.row.roles" 
              :key="role.roleId" 
              size="mini" 
              class="role-mini-tag"
            >
              {{ role.roleName }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="状态控制" align="center" width="100">
          <template slot-scope="scope">
            <el-switch 
              v-model="scope.row.status" 
              active-value="0" 
              inactive-value="1" 
              active-color="#c9ab8d"
              @change="handleStatusChange(scope.row)"
            ></el-switch>
          </template>
        </el-table-column>

        <el-table-column label="操作" align="center" width="180">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-edit" class="btn-edit" @click="handleUpdate(scope.row)">修改</el-button>
            <el-button size="mini" type="text" icon="el-icon-delete" class="btn-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body class="fancy-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="会员昵称" prop="nickName">
              <el-input v-model="form.nickName" placeholder="起个好听的名字" class="fancy-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="登录账号" prop="userName">
              <el-input v-model="form.userName" placeholder="用于系统登录" class="fancy-input" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="赋予权限角色" prop="roleIds">
          <el-select v-model="form.roleIds" multiple placeholder="请选择角色" style="width: 100%" class="fancy-input">
            <el-option
              v-for="item in roleOptions"
              :key="item.roleId"
              :label="item.roleName"
              :value="item.roleId"
              :disabled="item.status == 1"
            ></el-option>
          </el-select>
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="初始密码" v-if="form.userId == undefined" prop="password">
              <el-input v-model="form.password" placeholder="默认 123456" type="password" class="fancy-input" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="初始状态">
              <el-radio-group v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">封禁</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-cancel" @click="cancel">暂不</el-button>
        <el-button class="btn-confirm" @click="submitForm">确认保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listUser, getUser, addUser, updateUser, delUser, changeUserStatus } from "@/api/system/user";

export default {
  name: "MemberManagement",
  data() {
    return {
      loading: false,
      ids: [],
      multiple: true,
      userList: [],
      roleOptions: [], // 存储可选角色列表
      title: "",
      open: false,
      form: {},
      rules: {
        userName: [{ required: true, message: "账号必填哦", trigger: "blur" }],
        nickName: [{ required: true, message: "昵称必填哦", trigger: "blur" }],
        roleIds: [{ required: true, message: "请至少分配一个角色", trigger: "change" }]
      }
    };
  },
  created() { 
    this.getList(); 
  },
  methods: {
    getList() {
      this.loading = true;
      listUser().then(res => {
        this.userList = res.rows;
        this.loading = false;
      });
    },
    reset() {
      this.form = { userId: undefined, userName: undefined, nickName: undefined, password: "123456", sex: "0", status: "0", roleIds: [] };
      this.resetForm("form");
    },
    handleAdd() {
      this.reset();
      // 调用 getUser 获取角色选项
      getUser().then(response => {
        this.roleOptions = response.roles;
        this.open = true;
        this.title = "✨ 邀约新会员";
      });
    },
    handleUpdate(row) {
      this.reset();
      const userId = row.userId;
      // 获取用户信息及角色分配情况
      getUser(userId).then(response => {
        this.form = response.data;
        this.roleOptions = response.roles;
        this.form.roleIds = response.roleIds; // 这一步至关重要，用于回显已选角色
        this.open = true;
        this.title = "📝 资料修缮";
      });
    },
    handleStatusChange(row) {
      let text = row.status === "0" ? "启用" : "停用";
      this.$modal.confirm('确认要' + text + '"' + row.nickName + '"吗？').then(function() {
        return changeUserStatus(row.userId, row.status);
      }).then(() => {
        this.$modal.msgSuccess(text + "成功");
      }).catch(function() {
        row.status = row.status === "0" ? "1" : "0";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          const action = this.form.userId !== undefined ? updateUser : addUser;
          action(this.form).then(() => {
            this.$modal.msgSuccess("保存成功啦！");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    handleDelete(row) {
      const uIds = row.userId || this.ids;
      this.$modal.confirm('确定要移除这些会员吗？').then(() => {
        return delUser(uIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已成功移除");
      });
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId);
      this.multiple = !selection.length;
    },
    cancel() { this.open = false; this.reset(); }
  }
};
</script>

<style scoped lang="scss">
.member-glass-container {
  min-height: calc(100vh - 84px);
  padding: 30px;
  background: url('https://source.unsplash.com/1600x900/?fashion,cloth') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;

  .welcome-section {
    margin-bottom: 30px;
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
    margin-bottom: 25px;
    border: 1px solid rgba(255, 255, 255, 0.4);
  }

  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none; border-radius: 20px;
  }

  .btn-glass-del {
    background: rgba(255, 255, 255, 0.5) !important;
    border-radius: 20px; color: #ff4949 !important;
  }

  .table-wrapper {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(20px);
    border-radius: 25px; padding: 20px;
    border: 1px solid rgba(255,255,255,0.3);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background: transparent !important; }
    ::v-deep th.el-table__cell { background: transparent !important; color: #222; }
  }

  .user-info-cell {
    display: flex; align-items: center;
    .user-avatar {
      width: 40px; height: 40px; background: #c9ab8d; color: white;
      border-radius: 12px; display: flex; align-items: center; justify-content: center;
      font-weight: bold; margin-right: 12px;
    }
  }

  .role-mini-tag {
    margin: 2px; border-radius: 8px; color: #c9ab8d; border: 1px solid #c9ab8d; background: transparent;
  }

  .id-badge { color: #c9ab8d; font-family: monospace; font-weight: bold; }
  .btn-edit { color: #c9ab8d !important; }
  .btn-delete { color: #ff6b6b !important; }
}

::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    background: rgba(255, 255, 255, 0.95) !important;
    backdrop-filter: blur(20px);
    .fancy-input .el-input__inner { border-radius: 12px; background: rgba(255,255,255,0.5); }
  }
  .btn-confirm { background: #333 !important; color: white; border-radius: 15px; padding: 12px 30px; }
  .btn-cancel { border-radius: 15px; padding: 12px 30px; }
}
</style>