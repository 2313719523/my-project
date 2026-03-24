<template>
  <div class="wardrobe-home">
    <el-carousel :interval="4000" type="card" height="300px" class="banner">
      <el-carousel-item v-for="(item, index) in banners" :key="index">
        <div class="banner-card">
          <img :src="item.url" class="banner-img">
          <div class="banner-text">{{ item.title }}</div>
        </div>
      </el-carousel-item>
    </el-carousel>

    <div class="stats-container">
      <el-row :gutter="20">
        <el-col :span="6" v-for="stat in stats" :key="stat.label">
          <div class="stat-box">
            <div class="stat-value">{{ stat.value }}</div>
            <div class="stat-label">{{ stat.label }}</div>
          </div>
        </el-col>
      </el-row>
    </div>

    <div class="category-section">
      <h3 class="section-title">品类浏览</h3>
      <div class="category-grid">
        <div v-for="cat in categories" :key="cat.name" class="cat-item" @click="goToManage(cat.name)">
          <div class="cat-icon-wrapper">
            <i :class="cat.icon"></i>
          </div>
          <span>{{ cat.name }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { listItem } from "@/api/wardrobe/item";

export default {
  data() {
    return {
      // 轮播图数据：把你最后一张图里那些漂亮的穿搭照片路径放这
      banners: [
        { title: '春日复古穿搭', url: require('@/assets/images/outfit1.jpg') },
        { title: '职场干练风', url: require('@/assets/images/outfit2.jpg') },
        { title: '极简主义美学', url: require('@/assets/images/outfit3.jpg') }
      ],
      stats: [
        { label: '总单品数', value: 0 },
        { label: '品类数量', value: 5 },
        { label: '常用单品', value: 0 },
        { label: '最近添加', value: 0 }
      ],
      categories: [
        { name: '上装', icon: 'el-icon-sunny' },
        { name: '下装', icon: 'el-icon-bottom' },
        { name: '裙装', icon: 'el-icon-sugar' },
        { name: '外套', icon: 'el-icon-cloudy' },
        { name: '鞋履', icon: 'el-icon-bicycle' }
      ]
    };
  },
  created() {
    this.loadStats();
  },
  methods: {
    loadStats() {
      listItem().then(res => {
        const list = res.rows || res.data;
        this.stats[0].value = list.length; // 总数
        this.stats[2].value = list.filter(i => i.isCommon).length; // 常用数
        this.stats[3].value = list.slice(0, 5).length; // 最近添加
      });
    },
    goToManage(catName) {
      this.$router.push({ path: '/wardrobe/item', query: { category: catName }});
    }
  }
};
</script>

<style scoped>
.wardrobe-home { padding: 20px; background: #f8f9fa; }
.banner { margin-bottom: 30px; }
.banner-card { position: relative; height: 100%; border-radius: 15px; overflow: hidden; }
.banner-img { width: 100%; height: 100%; object-fit: cover; }
.banner-text { 
  position: absolute; bottom: 0; width: 100%; padding: 15px;
  background: rgba(0,0,0,0.4); color: white; text-align: center;
}
.stat-box { 
  background: white; padding: 20px; border-radius: 12px; text-align: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.stat-value { font-size: 24px; font-weight: bold; color: #409EFF; }
.stat-label { font-size: 14px; color: #909399; margin-top: 5px; }
.category-section { margin-top: 40px; }
.category-grid { display: flex; justify-content: space-around; margin-top: 20px; }
.cat-item { cursor: pointer; text-align: center; transition: 0.3s; }
.cat-item:hover { transform: translateY(-5px); }
.cat-icon-wrapper { 
  width: 60px; height: 60px; background: white; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 24px; color: #409EFF; margin-bottom: 10px;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
</style>