<template>
  <div class="app-container profile-wrapper">
    <el-row :gutter="25">
      <el-col :span="8" :xs="24">
        <el-card class="luxury-card frosted-glass shadow-hover">
          <div slot="header" class="card-header">
            <span class="header-title">个人信息</span>
          </div>
          <div class="profile-content">
            <div class="avatar-section">
              <userAvatar />
              <h3 class="user-nickname">{{ user.nickName || '管理员' }}</h3>
              <p class="user-role-badge">{{ roleGroup }}</p>
            </div>
            
            <ul class="info-list">
              <li class="info-item">
                <div class="item-label">
                  <i class="el-icon-user"></i> 用户名称
                </div>
                <div class="item-value">{{ user.userName }}</div>
              </li>
              <li class="info-item">
                <div class="item-label">
                  <i class="el-icon-mobile-phone"></i> 手机号码
                </div>
                <div class="item-value">18764110059</div>
              </li>
              <li class="info-item">
                <div class="item-label">
                  <i class="el-icon-message"></i> 用户邮箱
                </div>
                <div class="item-value">2313719523@qq.com</div>
              </li>
              <li class="info-item">
                <div class="item-label">
                  <i class="el-icon-date"></i> 创建日期
                </div>
                <div class="item-value">{{ user.createTime }}</div>
              </li>
            </ul>
          </div>
        </el-card>
      </el-col>

      <el-col :span="16" :xs="24">
        <el-card class="luxury-card frosted-glass shadow-hover">
          <div slot="header" class="card-header">
            <span class="header-title">基本资料维护</span>
          </div>
          <el-tabs v-model="selectedTab" class="luxury-tabs">
            <el-tab-pane label="个人资料" name="userinfo">
              <userInfo :user="user" />
            </el-tab-pane>
            <el-tab-pane label="安全修改密码" name="resetPwd">
              <resetPwd />
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import userAvatar from "./userAvatar"
import userInfo from "./userInfo"
import resetPwd from "./resetPwd"
import { getUserProfile } from "@/api/system/user"

export default {
  name: "Profile",
  components: { userAvatar, userInfo, resetPwd },
  data() {
    return {
      user: {},
      roleGroup: "",
      selectedTab: "userinfo"
    }
  },
  created() {
    const activeTab = this.$route.params && this.$route.params.activeTab
    if (activeTab) {
      this.selectedTab = activeTab
    }
    this.getUser()
  },
  methods: {
    getUser() {
      getUserProfile().then(response => {
        this.user = response.data
        this.roleGroup = response.roleGroup
        // 强制初始化显示指定的联系方式
        this.user.phonenumber = "18764110059";
        this.user.email = "2313719523@qq.com";
      })
    }
  }
}
</script>

<style scoped lang="scss">
.profile-wrapper {
  padding: 30px;
  background-color: #fdfcfb; // 统一背景暖色调
  min-height: calc(100vh - 84px);

  .luxury-card {
    border: none;
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(12px); // 增强毛玻璃质感
    border: 1px solid rgba(255, 255, 255, 0.4);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.02);
    transition: all 0.3s ease;
    
    &.shadow-hover:hover {
      transform: translateY(-5px);
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.05);
    }
  }

  .card-header {
    .header-title {
      font-size: 18px;
      font-weight: 600;
      color: #333;
      position: relative;
      padding-left: 14px;
      
      &::before {
        content: "";
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 18px;
        background: #c5a391; // 统一香槟金主题
        border-radius: 4px;
      }
    }
  }

  .avatar-section {
    text-align: center;
    padding: 25px 0;
    border-bottom: 1px solid rgba(0, 0, 0, 0.03);
    margin-bottom: 10px;
    
    .user-nickname {
      margin: 18px 0 6px;
      font-size: 22px;
      color: #1a1a1a;
      letter-spacing: 0.5px;
    }
    
    .user-role-badge {
      display: inline-block;
      background: linear-gradient(135deg, rgba(197, 163, 145, 0.2) 0%, rgba(197, 163, 145, 0.05) 100%);
      color: #c5a391;
      padding: 5px 16px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
    }
  }

  .info-list {
    padding: 0 15px;
    list-style: none;
    
    .info-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 18px 0;
      border-bottom: 1px dashed rgba(0, 0, 0, 0.05);
      
      &:last-child { border-bottom: none; }
      
      .item-label {
        color: #888;
        font-size: 14px;
        display: flex;
        align-items: center;
        i { margin-right: 10px; color: #c5a391; font-size: 16px; }
      }
      
      .item-value {
        color: #444;
        font-weight: 500;
        font-size: 14px;
      }
    }
  }

  // 选项卡自定义样式
  .luxury-tabs {
    ::v-deep .el-tabs__header { margin-bottom: 25px; }
    ::v-deep .el-tabs__item {
      font-size: 15px;
      height: 50px;
      line-height: 50px;
      font-weight: 500;
      color: #999;
      transition: color 0.3s;
      &.is-active { color: #c5a391; font-weight: 600; }
      &:hover { color: #c5a391; opacity: 0.8; }
    }
    ::v-deep .el-tabs__active-bar {
      background-color: #c5a391;
      height: 3px;
      border-radius: 3px;
    }
    ::v-deep .el-tabs__nav-wrap::after { background-color: #f5f5f5; }
  }
}
</style>