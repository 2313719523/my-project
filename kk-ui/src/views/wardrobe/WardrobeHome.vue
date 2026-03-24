<template>
  <div class="luxury-home-container">
    <header class="luxury-header">
      <div class="header-content">
        <h1 class="brand-title">MY CLOSET</h1>
        <p class="brand-quote">"Style is a way to say who you are without having to speak."</p>
      </div>
    </header>

    <div class="gallery-section">
      <el-carousel :interval="5000" type="card" height="450px" indicator-position="outside" class="luxury-banner">
        <el-carousel-item v-for="(item, index) in banners" :key="index">
          <div class="banner-wrapper">
            <img :src="item.url" class="banner-img">
            <div class="banner-overlay">
              <span class="banner-tag">TRENDING</span>
              <h2 class="banner-title">{{ item.title }}</h2>
              <el-button type="text" class="banner-link">EXPLORE →</el-button>
            </div>
          </div>
        </el-carousel-item>
      </el-carousel>
    </div>

    <div class="stats-grid">
      <div v-for="stat in stats" :key="stat.label" class="stat-card">
        <div class="stat-glass-effect">
          <span class="stat-value">{{ stat.value }}</span>
          <span class="stat-label">{{ stat.label }}</span>
        </div>
      </div>
    </div>

    <div class="category-section">
      <div class="section-header">
        <h3 class="section-title">品类浏览 / CATEGORIES</h3>
        <div class="title-line"></div>
      </div>
      
      <div class="category-flex">
        <div 
          v-for="cat in categories" 
          :key="cat.name" 
          class="cat-card" 
          @click="goToManage(cat.name)"
        >
          <div class="cat-icon-box">
            <i :class="cat.icon"></i>
          </div>
          <span class="cat-name">{{ cat.name }}</span>
          <span class="cat-english">{{ cat.english }}</span>
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
      // 建议：这里的图片路径请确保存在，或替换为你喜欢的时尚大片
      banners: [
        { title: 'Spring / Summer 2026', url: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=2070' },
        { title: 'Minimalist Aesthetics', url: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=2010' },
        { title: 'Retro Renaissance', url: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=1920' }
      ],
      stats: [
        { label: 'TOTAL ITEMS', value: 0 },
        { label: 'CATEGORIES', value: 5 },
        { label: 'FAVORITES', value: 0 },
        { label: 'RECENTLY', value: 0 }
      ],
      categories: [
        { name: '上装', english: 'TOPS', icon: 'el-icon-sunny' },
        { name: '下装', english: 'BOTTOMS', icon: 'el-icon-bottom' },
        { name: '裙装', english: 'DRESSES', icon: 'el-icon-sugar' },
        { name: '外套', english: 'OUTERWEAR', icon: 'el-icon-cloudy' },
        { name: '鞋履', english: 'FOOTWEAR', icon: 'el-icon-bicycle' }
      ]
    };
  },
  created() {
    this.loadStats();
  },
  methods: {
    loadStats() {
      listItem().then(res => {
        const list = res.rows || res.data || [];
        this.stats[0].value = list.length;
        this.stats[2].value = list.filter(i => i.isFavorite === '1').length;
        this.stats[3].value = list.slice(0, 5).length;
      });
    },
    goToManage(catName) {
      this.$router.push({ path: '/wardrobe/item', query: { category: catName }});
    }
  }
};
</script>

<style scoped>
/* 核心：米白背景与时尚排版 */
.luxury-home-container {
  background-color: #fcfaf7; /* 对应推荐页的背景色 */
  min-height: 100vh;
  padding: 60px 40px;
  font-family: "Noto Serif SC", serif;
}

/* 1. Header 样式 */
.luxury-header {
  text-align: center;
  margin-bottom: 60px;
}
.brand-title {
  font-size: 48px;
  letter-spacing: 8px;
  font-weight: 300;
  color: #1a1a1a;
  margin: 0;
}
.brand-quote {
  font-style: italic;
  color: #8c8c8c;
  margin-top: 15px;
  font-size: 16px;
}

/* 2. 画廊/轮播图 */
.luxury-banner >>> .el-carousel__mask {
  background-color: transparent;
}
.banner-wrapper {
  position: relative;
  height: 100%;
  border-radius: 4px;
  overflow: hidden;
}
.banner-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 1.2s ease;
}
.banner-wrapper:hover .banner-img {
  transform: scale(1.05);
}
.banner-overlay {
  position: absolute;
  bottom: 40px;
  left: 40px;
  color: white;
  z-index: 2;
}
.banner-tag {
  font-size: 12px;
  letter-spacing: 2px;
  background: rgba(255,255,255,0.2);
  padding: 4px 12px;
  backdrop-filter: blur(4px);
}
.banner-title {
  font-size: 28px;
  margin: 15px 0;
  font-weight: 400;
}
.banner-link {
  color: white;
  letter-spacing: 2px;
  font-size: 13px;
  border-bottom: 1px solid white;
  padding-bottom: 2px;
}

/* 3. 数据透视 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 30px;
  margin: 60px 0;
}
.stat-card {
  height: 140px;
  background: #fff;
  border: 1px solid #eee;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.4s;
}
.stat-card:hover {
  border-color: #c4a77d; /* 金色点缀 */
  transform: translateY(-5px);
}
.stat-value {
  display: block;
  font-size: 32px;
  color: #1a1a1a;
  font-weight: 600;
  text-align: center;
}
.stat-label {
  display: block;
  font-size: 11px;
  color: #8c8c8c;
  letter-spacing: 2px;
  margin-top: 8px;
  text-align: center;
}

/* 4. 品类部分 */
.category-section { margin-top: 80px; }
.section-header { margin-bottom: 40px; text-align: center; }
.section-title { font-size: 20px; letter-spacing: 4px; color: #1a1a1a; }
.title-line { 
  width: 40px; height: 1px; background: #c4a77d; 
  margin: 15px auto; 
}

.category-flex {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}
.cat-card {
  flex: 1;
  background: #fff;
  padding: 40px 20px;
  text-align: center;
  cursor: pointer;
  border: 1px solid transparent;
  transition: all 0.3s;
}
.cat-card:hover {
  background: #1a1a1a;
}
.cat-card:hover .cat-name, 
.cat-card:hover .cat-english,
.cat-card:hover .cat-icon-box {
  color: #fff;
}
.cat-icon-box { font-size: 28px; color: #1a1a1a; margin-bottom: 20px; }
.cat-name { display: block; font-size: 16px; margin-bottom: 5px; color: #1a1a1a; }
.cat-english { display: block; font-size: 10px; color: #8c8c8c; letter-spacing: 1px; }

</style>