<template>
  <div class="sidebar-logo-container" :class="{'collapse':collapse}" :style="{ backgroundColor: sideTheme === 'theme-dark' && navType !== 3 ? variables.menuBackground : variables.menuLightBackground }">
    <transition name="sidebarLogoFade">
      <router-link v-if="collapse" key="collapse" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" />
        <h1 v-else class="sidebar-title" :style="{ color: sideTheme === 'theme-dark' && navType !== 3 ? variables.logoTitleColor : variables.logoLightTitleColor }">{{ title }} </h1>
      </router-link>
      <router-link v-else key="expand" class="sidebar-logo-link" to="/">
        <img v-if="logo" :src="logo" class="sidebar-logo" />
        <h1 class="sidebar-title" :style="{ color: sideTheme === 'theme-dark' && navType !== 3 ? variables.logoTitleColor : variables.logoLightTitleColor }">{{ title }} </h1>
      </router-link>
    </transition>
  </div>
</template>

<script>
import logoImg from '@/assets/logo/logo.png'
import variables from '@/assets/styles/variables.scss'

export default {
  name: 'SidebarLogo',
  props: {
    collapse: {
      type: Boolean,
      required: true
    }
  },
  computed: {
    variables() {
      return variables
    },
    sideTheme() {
      return this.$store.state.settings.sideTheme
    },
    navType() {
      return this.$store.state.settings.navType
    }
  },
  data() {
    return {
      title: '每日穿搭推荐',
      logo: logoImg
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebarLogoFade-enter-active {
  transition: opacity 1.5s;
}

.sidebarLogoFade-enter,
.sidebarLogoFade-leave-to {
  opacity: 0;
}

.sidebar-logo-container {
  position: relative;
  height: 50px;
  line-height: 50px;
  //background: #2b2f3a;
  
  /* 改成图片背景 ↓ */
   background: 
     rgba(255, 255, 255, 0.6)  /* 透明度 */
     url('/images/menu_bg6.png') no-repeat center center !important;
   background-size: cover !important;

background: 
    rgba(255, 255, 255, 0.5)
    url('/images/sidebar-bg.jpg') no-repeat center center !important;
  background-size: cover !important;
  

  
  text-align: center;
  overflow: hidden;

  & .sidebar-logo-link {
    height: 100%;
    width: 100%;

    & .sidebar-logo {
      width: 32px;
      height: 32px;
      vertical-align: middle;
      margin-right: 12px;
    }

  & .sidebar-title {
  display: inline-block;
  margin: 0;
  vertical-align: middle;

  // 💡 核心 1：使用更具人文气息的衬线体
  // "STSong" (华文宋体) 在中文环境下非常有这种艺术馆的质感
  font-family: "Didot", "Playfair Display", "STSong", "Songti SC", serif;
  
  // 💡 核心 2：颜色改为图片中的“灰褐金”
  // 这种颜色比纯白更有温度，比纯金更高级
  color: #8c8379; 
  
  font-weight: 400;     // 字体要细，越细越显贵
  font-size: 15px;
  line-height: 50px;
  
  // 💡 核心 3：极致的呼吸感
  letter-spacing: 0.25em; // 进一步拉开字间距
  text-transform: uppercase;

  // 💡 核心 4：消除廉价的投影，改为纯净的平滑过渡
  text-shadow: none; 
  transition: all 0.6s cubic-bezier(0.22, 1, 0.36, 1);

  &:hover {
    // 悬浮时变为图片中那种明亮的“香槟金”
    color: #a68b32de;
    letter-spacing: 0.35em; // 产生一种向两边舒展的优雅感
    filter: blur(0.2px);   // 模拟一种柔光滤镜效果
  }
}
  }
}
</style>