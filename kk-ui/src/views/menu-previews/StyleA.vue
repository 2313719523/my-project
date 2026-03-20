<template>
  <div class="style-a-container">
    <div class="top-nav">
      <div v-for="(item, i) in navItems" :key="i" class="nav-item" @click="selectNav(item)" :class="{active: activeNav===item.title}">
        <span class="nav-icon">{{item.icon}}</span>
        <span>{{item.title}}</span>
      </div>
    </div>
    <div class="content">
      <transition-group name="card" tag="div" class="card-grid">
        <div v-for="(c, i) in cards" :key="c.id" class="card" @click="openCard(c)" @keydown.enter="openCard(c)" tabindex="0">
          <div class="card-bg"></div>
          <div class="card-overlay"></div>
          <div class="card-content">
            <div class="card-icon">{{c.icon}}</div>
            <h3>{{c.title}}</h3>
            <p>{{c.desc}}</p>
          </div>
          <div class="card-hover-state">
            <span>点击进入 →</span>
          </div>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StyleA',
  data(){
    return {
      activeNav: '系统',
      navItems: [
        { title: '系统', icon: '⚙' },
        { title: '穿搭', icon: '👔' },
        { title: '统计', icon: '📊' }
      ],
      cards: [
        { id: 1, title: '用户管理', desc: '管理系统用户', icon: '👤', section: '系统' },
        { id: 2, title: '角色管理', desc: '设置用户角色', icon: '🔐', section: '系统' },
        { id: 3, title: '单品库', desc: '衣橱单品', icon: '👕', section: '穿搭' },
        { id: 4, title: 'AI推荐', desc: '智能搭配', icon: '✨', section: '穿搭' },
        { id: 5, title: '数据报表', desc: '系统统计', icon: '📈', section: '统计' },
        { id: 6, title: '热点分析', desc: '趋势分析', icon: '🔥', section: '统计' }
      ]
    }
  },
  methods: {
    selectNav(item) { this.activeNav = item.title },
    openCard(c) { this.$message.success(`打开: ${c.title}`) }
  },
  computed: {
    filteredCards() { return this.cards.filter(c => c.section === this.activeNav) }
  }
}
</script>

<style scoped>
.style-a-container{
  position: relative;
  height: 100%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  z-index: 2;
}

.top-nav{
  display: flex;
  gap: 16px;
  padding: 18px 28px;
  backdrop-filter: blur(10px);
  background: rgba(255, 255, 255, 0.04);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.nav-item{
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 18px;
  border-radius: 8px;
  color: rgba(255, 255, 255, 0.6);
  cursor: pointer;
  transition: all .25s;
}

.nav-item:hover{
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
}

.nav-item.active{
  background: rgba(255, 150, 50, 0.3);
  color: #fff;
  border-bottom: 2px solid rgba(255, 150, 50, 0.8);
}

.nav-icon{ font-size: 18px }

.content{
  flex: 1;
  padding: 28px;
  overflow-y: auto;
}

.card-grid{
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 20px;
}

.card{
  position: relative;
  height: 180px;
  border-radius: 14px;
  overflow: hidden;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(8px);
  transition: all .3s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.card:hover{
  transform: translateY(-12px) scale(1.03);
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 150, 50, 0.5);
  box-shadow: 0 20px 60px rgba(255, 150, 50, 0.2);
}

.card-bg{
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(255, 150, 50, 0.1), rgba(100, 200, 255, 0.05));
  filter: blur(8px);
}

.card-overlay{
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 30% 30%, rgba(255,255,255,0.08), transparent 60%);
}

.card-content{
  position: relative;
  text-align: center;
  width: 100%;
  padding: 14px;
}

.card-icon{
  font-size: 32px;
  margin-bottom: 10px;
}

.card h3{
  margin: 8px 0 4px;
  font-size: 16px;
  color: #fff;
}

.card p{
  font-size: 12px;
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
}

.card-hover-state{
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 150, 50, 0.2);
  color: #fff;
  opacity: 0;
  transition: opacity .2s;
}

.card:hover .card-hover-state{
  opacity: 1;
}

.card-enter-active{ transition: all .4s cubic-bezier(0.34, 1.56, 0.64, 1) }
.card-leave-active{ transition: all .2s }
.card-enter{ opacity: 0; transform: translateY(30px) scale(0.9) }
</style>
