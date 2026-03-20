<template>
  <div class="menu-preview-standalone">
    <div class="decorative-sphere sphere-1"></div>
    <div class="decorative-sphere sphere-2"></div>
    <div class="header-bar">
      <div class="logo">设计系统</div>
      <div class="style-switcher">
        <button v-for="s in styles" :key="s" :class="{active: active===s}" @click="active=s">{{s}}</button>
      </div>
      <div class="close-btn" @click="$router.go(-1)">✕</div>
    </div>
    <transition name="fade" mode="out-in">
      <component :is="currentComponent" :key="active"></component>
    </transition>
  </div>
</template>

<script>
import StyleA from '@/views/menu-previews/StyleA'
import StyleB from '@/views/menu-previews/StyleB'
import StyleC from '@/views/menu-previews/StyleC'

export default {
  name: 'MenuPreview',
  components: { StyleA, StyleB, StyleC },
  data() {
    return { 
      active: 'A',
      styles: ['A', 'B', 'C']
    }
  },
  computed: {
    currentComponent() {
      return this.active === 'A' ? 'StyleA' : this.active === 'B' ? 'StyleB' : 'StyleC'
    }
  }
}
</script>

<style scoped>
.menu-preview-standalone{
  position: fixed;
  inset: 0;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
  background-attachment: fixed;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  z-index: 9999;
}

.decorative-sphere{
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  pointer-events: none;
}

.sphere-1{
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(255, 150, 50, 0.28), transparent 60%);
  top: -100px;
  right: -100px;
  animation: float 6s ease-in-out infinite;
}

.sphere-2{
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(100, 200, 255, 0.2), transparent 60%);
  bottom: -80px;
  left: -80px;
  animation: float 8s ease-in-out infinite reverse;
}

@keyframes float{
  0%, 100% { transform: translateY(0px) }
  50% { transform: translateY(30px) }
}

.header-bar{
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 18px 28px;
  backdrop-filter: blur(12px);
  background: rgba(255, 255, 255, 0.05);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  position: relative;
  z-index: 10;
}

.logo{
  font-size: 20px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 1px;
}

.style-switcher{
  display: flex;
  gap: 8px;
}

.style-switcher button{
  padding: 8px 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  background: rgba(255, 255, 255, 0.04);
  color: rgba(255, 255, 255, 0.6);
  border-radius: 6px;
  cursor: pointer;
  transition: all .25s;
  font-weight: 600;
}

.style-switcher button:hover{
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.style-switcher button.active{
  background: rgba(255, 150, 50, 0.4);
  color: #fff;
  border-color: rgba(255, 150, 50, 0.6);
  box-shadow: 0 0 20px rgba(255, 150, 50, 0.3);
}

.close-btn{
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  cursor: pointer;
  border-radius: 50%;
  transition: all .2s;
}

.close-btn:hover{
  background: rgba(255, 255, 255, 0.1);
}

.fade-enter-active, .fade-leave-active{
  transition: opacity .4s;
}

.fade-enter, .fade-leave-to{
  opacity: 0;
}
</style>