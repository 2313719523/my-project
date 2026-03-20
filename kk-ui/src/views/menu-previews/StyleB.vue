<template>
  <div class="style-b-container">
    <div class="dock-container">
      <div class="dock">
        <div v-for="(it, i) in items" :key="it.id" class="dock-item" @mouseenter="hoverIdx=i" @mouseleave="hoverIdx=null" @click="selectItem(it)" :class="{active: activeItem===it.id}">
          <div class="dock-icon">{{it.icon}}</div>
          <transition name="label-fade">
            <div v-if="hoverIdx===i" class="dock-label">{{it.title}}</div>
          </transition>
        </div>
      </div>
    </div>
    <transition name="panel-slide" mode="out-in">
      <div v-if="activeItem" class="panel" :key="activeItem">
        <h2>{{activeTitle}}</h2>
        <transition-group name="item-list" tag="div" class="item-list">
          <div v-for="(c, idx) in activeItems" :key="c.id" class="list-item" @click="openItem(c)">
            <span class="item-icon">{{c.icon}}</span>
            <span class="item-title">{{c.title}}</span>
            <span class="item-arrow">→</span>
          </div>
        </transition-group>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'StyleB',
  data(){
    return {
      hoverIdx: null,
      activeItem: 1,
      items: [
        { id: 1, title: '系统', icon: '⚙', children: [{id: 11, title: '用户管理', icon: '👤'}, {id: 12, title: '角色权限', icon: '🔐'}] },
        { id: 2, title: '穿搭', icon: '👔', children: [{id: 21, title: '单品库', icon: '👕'}, {id: 22, title: 'AI推荐', icon: '✨'}] },
        { id: 3, title: '数据', icon: '📊', children: [{id: 31, title: '报表', icon: '📈'}, {id: 32, title: '热点', icon: '🔥'}] }
      ]
    }
  },
  computed: {
    activeTitle(){
      const item = this.items.find(i => i.id === this.activeItem)
      return item ? item.title : ''
    },
    activeItems(){
      const item = this.items.find(i => i.id === this.activeItem)
      return item ? item.children : []
    }
  },
  methods: {
    selectItem(it){ this.activeItem = it.id },
    openItem(c){ this.$message.success(`打开: ${c.title}`) }
  }
}
</script>

<style scoped>
.style-b-container{
  position: relative;
  height: 100%;
  display: flex;
  align-items: center;
  overflow: hidden;
  z-index: 2;
}

.dock-container{
  display: flex;
  align-items: center;
  height: 100%;
  padding: 20px;
}

.dock{
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 16px 12px;
  background: rgba(255, 255, 255, 0.04);
  border-radius: 14px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.dock-item{
  position: relative;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  transition: all .2s;
}

.dock-icon{
  width: 48px;
  height: 48px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.04);
  font-size: 24px;
  transition: all .25s;
}

.dock-item:hover .dock-icon{
  background: rgba(255, 150, 50, 0.2);
  transform: scale(1.1);
}

.dock-item.active .dock-icon{
  background: rgba(255, 150, 50, 0.4);
  box-shadow: 0 0 24px rgba(255, 150, 50, 0.3);
}

.dock-label{
  padding: 6px 12px;
  background: rgba(255, 150, 50, 0.3);
  border-radius: 6px;
  color: #fff;
  font-size: 12px;
  white-space: nowrap;
}

.label-fade-enter-active, .label-fade-leave-active{
  transition: opacity .15s;
}

.label-fade-enter, .label-fade-leave-to{
  opacity: 0;
}

.panel{
  flex: 1;
  margin-left: 20px;
  padding: 28px;
  border-radius: 14px;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
}

.panel h2{
  color: #fff;
  margin-bottom: 20px;
  font-size: 24px;
}

.item-list{
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.list-item{
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.03);
  color: #fff;
  cursor: pointer;
  transition: all .25s;
}

.list-item:hover{
  background: rgba(255, 150, 50, 0.2);
  transform: translateX(8px);
}

.item-icon{ font-size: 18px }

.item-title{ flex: 1 }

.item-arrow{
  color: rgba(255, 255, 255, 0.4);
  transition: all .2s;
}

.list-item:hover .item-arrow{
  color: rgba(255, 150, 50, 0.8);
  transform: translateX(4px);
}

.item-list-enter-active{ transition: all .3s }
.item-list-leave-active{ transition: all .2s }
.item-list-enter{ opacity: 0; transform: translateX(-20px) }

.panel-slide-enter-active{ transition: all .3s }
.panel-slide-leave-active{ transition: all .2s }
.panel-slide-enter, .panel-slide-leave-to{ opacity: 0; transform: translateX(-30px) }
</style>
