<template>
  <div class="modern-menu">
    <div class="menu-grid">
      <div v-for="item in menuItems" :key="item.path" class="menu-card" @click="go(item)" tabindex="0">
        <div class="card-media" :style="mediaStyle(item)"></div>
        <div class="card-content">
          <div class="card-title">{{item.meta && item.meta.title || item.name}}</div>
          <div class="card-desc">{{item.meta && item.meta.desc || ''}}</div>
        </div>
        <div class="card-overlay"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ModernMenu',
  data() {
    return {
      menuItems: []
    }
  },
  created() {
    // 读取路由表生成菜单：只收集顶层路由（带有子路由且有 meta.title 的）
    const routes = this.$router.options.routes || []
    const items = []
    
    routes.forEach(route => {
      // 只收集有子路由、带 meta.title 且不隐藏的顶层路由
      if (route.children && route.children.length > 0 && route.meta && route.meta.title && route.hidden !== true) {
        let navPath = route.path || '/'
        
        // 对于 path 为 '' 或 '/' 的路由，导航到其第一个子路由（如果存在）
        if ((route.path === '' || route.path === '/') && route.children && route.children.length > 0) {
          const firstChild = route.children[0]
          navPath = `/${firstChild.path || 'index'}`.replace(/\/+/g, '/')
        }
        
        items.push({
          ...route,
          path: navPath
        })
      }
    })
    
    this.menuItems = items
  },
  methods: {
    mediaStyle(item) {
      const img = item.meta && item.meta.menuImage
      if (img) return { backgroundImage: `url(${img})`, backgroundSize: 'cover', backgroundPosition: 'center' }
      return { background: 'linear-gradient(135deg, rgba(255,150,50,0.18), rgba(100,200,255,0.06))' }
    },
    go(item) {
      if (item.path) this.$router.push(item.path).catch(()=>{})
    }
  }
}
</script>

<style scoped>
.modern-menu{ padding: 18px; height:100%; box-sizing:border-box }
.menu-grid{ display:grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap:18px }
.menu-card{ position:relative; height:180px; border-radius:14px; overflow:hidden; cursor:pointer; border:1px solid rgba(255,255,255,0.06); background: rgba(255,255,255,0.03); backdrop-filter: blur(8px); transition: transform .28s, box-shadow .28s }
.menu-card:hover{ transform: translateY(-10px); box-shadow: 0 20px 60px rgba(0,0,0,0.28) }
.card-media{ position:absolute; inset:0; filter: blur(6px) saturate(1.05); opacity:0.9 }
.card-overlay{ position:absolute; inset:0; background: linear-gradient(180deg, rgba(0,0,0,0.08), rgba(0,0,0,0.18)); }
.card-content{ position:relative; z-index:2; padding:16px; color:#fff }
.card-title{ font-size:16px; font-weight:700; margin-bottom:6px }
.card-desc{ font-size:13px; color: rgba(255,255,255,0.78) }

@media (max-width: 768px){
  .menu-grid{ grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap:12px }
  .menu-card{ height:140px }
}
</style>
