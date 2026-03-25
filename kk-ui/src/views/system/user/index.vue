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

        <el-table-column label="会员等级" align="center" width="120">
          <template slot-scope="scope">
            <el-tag :type="scope.row.userId === 1 ? 'warning' : 'success'" effect="dark" class="level-tag">
              {{ scope.row.userId === 1 ? '超级博主' : '潮流达人' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="状态控制" align="center" width="100">
          <template slot-scope="scope">
            <el-tooltip :content="scope.row.status === '0' ? '正常运行' : '已封禁'" placement="top">
              <el-switch 
                v-model="scope.row.status" 
                active-value="0" 
                inactive-value="1" 
                active-color="#c9ab8d"
                class="custom-switch"
              ></el-switch>
            </el-tooltip>
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

    <el-dialog :title="title" :visible.sync="open" width="450px" append-to-body class="fancy-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="会员昵称" prop="nickName">
          <el-input v-model="form.nickName" placeholder="起个好听的名字" class="fancy-input" />
        </el-form-item>
        <el-form-item label="登录账号" prop="userName">
          <el-input v-model="form.userName" placeholder="用于系统登录" class="fancy-input" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="性别">
              <el-select v-model="form.sex" style="width: 100%" class="fancy-input">
                <el-option label="绅士" value="0" />
                <el-option label="淑女" value="1" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="初始状态">
              <el-radio-group v-underline v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="btn-cancel" @click="cancel">暂不</el-button>
        <el-button class="btn-confirm" @click="submitForm">确认加入</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listUser, getUser, addUser, updateUser, delUser } from "@/api/system/user";

export default {
  name: "MemberManagement",
  data() {
    return {
      loading: false,
      ids: [],
      multiple: true,
      userList: [],
      title: "",
      open: false,
      form: { sex: "0", status: "0" },
      rules: {
        userName: [{ required: true, message: "账号必填哦", trigger: "blur" }],
        nickName: [{ required: true, message: "昵称必填哦", trigger: "blur" }]
      }
    };
  },
  created() { this.getList(); },
  methods: {
    getList() {
      this.loading = true;
      listUser().then(res => {
        this.userList = res.rows;
        this.loading = false;
      }).catch(() => { this.loading = false; });
    },
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "✨ 邀约新会员";
    },
    handleUpdate(row) {
      this.reset();
      this.form = { ...row };
      this.open = true;
      this.title = "📝 资料修缮";
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.userId);
      this.multiple = !selection.length;
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.userId === undefined) {
            this.form.password = "123456"; // 默认密码
          }
          const action = this.form.userId !== undefined ? updateUser : addUser;
          action(this.form).then(() => {
            this.$modal.msgSuccess("操作成功啦！");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    handleDelete(row) {
      const uIds = row.userId || this.ids;
      this.$modal.confirm('确定要将这些潮流达人移出列表吗？').then(() => {
        return delUser(uIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已成功移除");
      });
    },
    reset() { this.form = { userId: undefined, userName: undefined, nickName: undefined, sex: "0", status: "0" }; },
    cancel() { this.open = false; }
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
      color: #333;
      font-size: 24px;
      font-weight: 800;
      letter-spacing: 1px;
      .sub-title { color: #888; font-size: 14px; font-weight: normal; margin-left: 10px; }
    }
  }

  /* 胶囊栏 */
  .glass-toolbar {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    padding: 15px 25px;
    border-radius: 50px;
    margin-bottom: 25px;
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 32px rgba(0,0,0,0.05);
  }

  /* 按钮特效 */
  .btn-gradient-add {
    background: linear-gradient(135deg, #c9ab8d 0%, #a88e72 100%) !important;
    border: none;
    border-radius: 20px;
    padding: 10px 25px;
    transition: all 0.3s;
    &:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(201,171,141,0.4); }
  }

  .btn-glass-del {
    background: rgba(255, 255, 255, 0.5) !important;
    border: 1px solid #ffeded !important;
    color: #ff4949 !important;
    border-radius: 20px;
  }

  /* 表格美化 */
  .table-wrapper {
    background: rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(20px);
    border-radius: 25px;
    padding: 20px;
    border: 1px solid rgba(255,255,255,0.3);
  }

  .custom-glass-table {
    background: transparent !important;
    ::v-deep tr { background: transparent !important; &:hover td { background: rgba(255,255,255,0.3) !important; } }
    ::v-deep th.el-table__cell { background: transparent !important; color: #222; border-bottom: 2px solid #eee; }
    ::v-deep td.el-table__cell { border-bottom: 1px solid rgba(0,0,0,0.03); }
  }

  /* 会员信息单元格 */
  .user-info-cell {
    display: flex;
    align-items: center;
    .user-avatar {
      width: 40px; height: 40px;
      background: #c9ab8d;
      color: white;
      border-radius: 12px;
      display: flex; align-items: center; justify-content: center;
      font-weight: bold; margin-right: 12px;
    }
    .u-nickname { font-weight: bold; color: #333; }
    .u-account { font-size: 12px; color: #999; }
  }

  .id-badge { color: #c9ab8d; font-family: 'Courier New', Courier, monospace; font-weight: bold; }
  .btn-edit { color: #c9ab8d !important; font-weight: bold; }
  .btn-delete { color: #ff6b6b !important; font-weight: bold; }
}

/* 弹窗高级感 */
::v-deep .fancy-dialog {
  .el-dialog {
    border-radius: 30px !important;
    overflow: hidden;
    background: rgba(255, 255, 255, 0.9) !important;
    backdrop-filter: blur(20px);
    .el-dialog__header { padding: 30px 30px 10px; .el-dialog__title { font-weight: 800; color: #444; } }
    .el-form-item__label { font-weight: bold; color: #666; padding: 0; }
    .fancy-input .el-input__inner { border-radius: 12px; border: 1px solid #eee; background: rgba(255,255,255,0.5); &:focus { border-color: #c9ab8d; } }
  }
  .btn-confirm { background: #333 !important; color: white; border: none; border-radius: 15px; padding: 12px 30px; }
  .btn-cancel { border-radius: 15px; padding: 12px 30px; border: 1px solid #eee; }
}
</style>