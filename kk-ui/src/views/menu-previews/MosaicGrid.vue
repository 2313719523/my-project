<template>
  <div class="style-c-container">
    <transition-group name="mosaic" tag="div" class="mosaic-grid">
      <div v-for="(g, i) in groups" :key="g.id" class="mosaic-card" @click="open(g)" tabindex="0">
        <div class="mosaic-bg"></div>
        <div class="mosaic-shadow"></div>
        <div class="mosaic-content">
          <div class="mosaic-icon">{{g.icon}}</div>
          <h3>{{g.title}}</h3>
          <p>{{g.desc}}</p>
        </div>
        <div class="mosaic-glow"></div>
      </div>
    </transition-group>
  </div>
</template>

<script>
export default {
  name: 'StyleC',
  data(){
    return {
      groups: [
        { id: 1, title: '用户管理', desc: '管理系统用户', icon: '👤' },
        { id: 2, title: '角色权限', desc: '设置角色权限', icon: '🔐' },
        { id: 3, title: '单品库', desc: '衣橱单品管理', icon: '👕' },
        { id: 4, title: 'AI推荐', desc: '智能搭配推荐', icon: '✨' },
        { id: 5, title: '数据报表', desc: '系统数据统计', icon: '📊' },
        { id: 6, title: '热点分析', desc: '趋势数据分析', icon: '🔥' },
        { id: 7, title: '操作日志', desc: '记录用户操作', icon: '📝' },
        { id: 8, title: '系统设置', desc: '配置系统参数', icon: '⚙' },
        { id: 9, title: '消息中心', desc: '消息通知管理', icon: '📬' }
      ]
    }
  },
  methods: {
    open(g){ this.$message.success(`进入: ${g.title}`) }
  }
}
</script>

<style scoped>
.style-c-container{
  position: relative;
  height: 100%;
  overflow: hidden;
  padding: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
}

.mosaic-grid{
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
  width: 100%;
  max-width: 1000px;
}

.mosaic-card{
  position: relative;
  height: 200px;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(10px);
  transition: all .35s cubic-bezier(0.34, 1.56, 0.64, 1);
  display: flex;
  align-items: center;
  justify-content: center;
  outline: none;
}

.mosaic-card:hover{
  transform: translateY(-16px) scale(1.05);
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 150, 50, 0.5);
  box-shadow: 0 24px 80px rgba(255, 150, 50, 0.25);
}

.mosaic-card:focus{
  border-color: rgba(255, 150, 50, 0.8);
  box-shadow: 0 0 0 3px rgba(255, 150, 50, 0.2);
}

.mosaic-bg{
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(255, 150, 50, 0.08), rgba(100, 200, 255, 0.06));
  filter: blur(12px);
}

.mosaic-shadow{
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 30% 20%, rgba(255,255,255,0.1), transparent 60%);
}

.mosaic-content{
  position: relative;
  text-align: center;
  width: 100%;
  padding: 20px;
}

.mosaic-icon{
  font-size: 48px;
  margin-bottom: 12px;
  display: inline-block;
  transition: transform .3s;
}

.mosaic-card:hover .mosaic-icon{
  transform: scale(1.2) rotateZ(8deg);
}

.mosaic-card h3{
  color: #fff;
  font-size: 18px;
  margin: 12px 0 6px;
  font-weight: 600;
}

.mosaic-card p{
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
  margin: 0;
}

.mosaic-glow{
  position: absolute;
  inset: -50%;
  background: radial-gradient(circle, rgba(255, 150, 50, 0.3), transparent 60%);
  opacity: 0;
  transition: opacity .3s;
  pointer-events: none;
}

.mosaic-card:hover .mosaic-glow{
  opacity: 1;
}

.mosaic-enter-active{
  transition: all .4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.mosaic-leave-active{
  transition: all .2s;
}

.mosaic-enter{
  opacity: 0;
  transform: scale(0.8) translateY(20px);
}

.mosaic-leave-to{
  opacity: 0;
  transform: scale(0.9);
}

@media (max-width: 768px){
  .mosaic-grid{
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 12px;
  }
  
  .mosaic-card{
    height: 160px;
  }
  
  .mosaic-icon{ font-size: 32px }
}
</style>
