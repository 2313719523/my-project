<template>
  <div class="navbar" :class="'nav' + navType">
    <div class="left-section">
      <hamburger 
        v-if="navType != 3" 
        id="hamburger-container" 
        :is-active="sidebar.opened" 
        class="hamburger-container" 
        @toggleClick="toggleSideBar" 
      />
      <breadcrumb v-if="navType == 1" id="breadcrumb-container" class="breadcrumb-container" />
      <div v-if="navType == 3" class="system-brand-text">MAISON DE LUXE</div>
    </div>

    <div class="center-section">
      <!-- 顶部导航：同时挂上 topmenu-container 供样式选择器使用 -->
      <top-nav
        v-if="navType == 2"
        id="topmenu-container"
        class="topmenu-container topmenu-el"
      />
      <top-bar v-if="navType == 3" id="topbar-container" class="topbar-el" />
    </div>

    <div class="right-menu">
      <el-dropdown class="avatar-container right-menu-item hover-effect" trigger="hover">
        <div class="avatar-wrapper">
          <div class="user-meta">
            <span class="user-nickname">{{ nickName }}</span>
            <span class="user-status">PRODUCE</span>
          </div>
          <img :src="avatar" class="user-avatar">
        </div>
        <el-dropdown-menu slot="dropdown" class="luxury-dropdown">
          <router-link to="/user/profile">
            <el-dropdown-item>个人中心</el-dropdown-item>
          </router-link>
          <el-dropdown-item @click.native="setLayout" v-if="setting">
            <span>布局设置</span>
          </el-dropdown-item>
          <el-dropdown-item divided @click.native="logout">
            <span>退出登录</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Breadcrumb from '@/components/Breadcrumb'
import TopNav from '@/components/TopNav'
import TopBar from './TopBar'
import Logo from './Sidebar/Logo'
import Hamburger from '@/components/Hamburger'

export default {
  emits: ['setLayout'],
  components: {
    Breadcrumb,
    Logo,
    TopNav,
    TopBar,
    Hamburger
  },
  computed: {
    ...mapGetters(['sidebar', 'avatar', 'device', 'nickName']),
    setting() { return this.$store.state.settings.showSettings },
    navType() { return this.$store.state.settings.navType },
    showLogo() { return this.$store.state.settings.sidebarLogo }
  },
  methods: {
    toggleSideBar() { this.$store.dispatch('app/toggleSideBar') },
    setLayout() { this.$emit('setLayout') },
    logout() {
      this.$confirm('确定注销并退出系统吗？', '提示', {
        confirmButtonText: '确定', cancelButtonText: '取消', type: 'warning'
      }).then(() => {
        this.$store.dispatch('LogOut').then(() => { location.href = '/index' })
      }).catch(() => {})
    }
  }
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 64px; // 增加到64px，更有呼吸感
  overflow: hidden;
  position: relative;
  background: #fdfcfb !important; // 图片中的象牙米白色
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  box-shadow: 0 2px 15px rgba(0, 0, 0, 0.03);
  border-bottom: 1px solid rgba(140, 131, 121, 0.1);

  .left-section {
    display: flex;
    align-items: center;
    flex-shrink: 0;

    .hamburger-container {
      cursor: pointer;
      color: #8c8379;
      margin-right: 16px;
      &:hover { opacity: 0.7; }
    }

    .system-brand-text {
      font-family: "Didot", serif;
      font-size: 16px;
      letter-spacing: 3px;
      color: #8c8379;
    }
  }

  .center-section {
    flex: 1;      // 关键：占据中间所有剩余空间
    height: 100%;
    display: flex;
    align-items: center;
    padding: 0 20px;
    min-width: 0; // 防止内容撑破flex布局

   
    ::v-deep .topmenu-container {
      position: relative !important;
      left: 0 !important;
      width: 100%;
      background: transparent !important;
      
      .el-menu {
        background: transparent !important;
        border: none !important;
        display: flex;
      }
      .el-menu-item {
        color: #8c8379 !important;
        font-size: 14px;
        letter-spacing: 1px;
        height: 64px !important;
        line-height: 64px !important;
        &:hover { background: transparent !important; color: #d4af37 !important; }
        &.is-active { border-bottom: 2px solid #d4af37 !important; color: #2c2a26 !important; }
      }
    }
  }

  .right-menu {
    display: flex;
    align-items: center;
    flex-shrink: 0;

    .avatar-container {
      .avatar-wrapper {
        display: flex;
        align-items: center;
        cursor: pointer;

        .user-meta {
          display: flex;
          flex-direction: column;
          align-items: flex-end;
          margin-right: 12px;

          .user-nickname {
            font-size: 13px;
            font-weight: 500;
            color: #2c2a26;
            letter-spacing: 0.5px;
          }

          .user-status {
            font-size: 9px;
            color: #d4af37;
            font-weight: 700;
            letter-spacing: 1px;
            margin-top: 2px;
          }
        }

        .user-avatar {
          width: 36px;
          height: 36px;
          border-radius: 50%;
          border: 1px solid rgba(140, 131, 121, 0.15);
        }
      }
    }
  }
}

// 适配面包屑
::v-deep .breadcrumb-container {
  .el-breadcrumb__inner {
    color: #8c8379 !important;
    font-weight: 400 !important;
  }
}
</style>