<template>
<div class="app-container wardrobe-home">
<!-- 顶部搜索栏 -->
<div class="search-bar">
  <el-input 
    placeholder="搜索单品、品牌或风格..."
    v-model="searchKeyword"
    class="search-input"
    @keyup.enter="handleSearch"
  >
    <i slot="prefix" class="el-icon-search"></i>
  </el-input>
</div>
<!-- 轮播图 -->
<div class="banner-section">
  <el-carousel :interval="4000" height="300px" indicator-position="outside">
    <el-carousel-item v-for="item in banners" :key="item.id">
      <div 
        class="banner-item" 
        :style="{ backgroundImage: 'url(' + item.image + ')' }"
      >
        <div class="banner-content">
          <h3 class="banner-title">{{ item.title }}</h3>
          <p class="banner-desc">{{ item.description }}</p>
        </div>
      </div>
    </el-carousel-item>
  </el-carousel>
</div>
<!-- 快捷分类入口 -->
<div class="quick-categories">
  <h3 class="section-title">单品分类</h3>
  <el-row :gutter="20">
    <el-col 
      v-for="category in categories" 
      :key="category.id" 
      :xs="12" 
      :sm="8" 
      :md="6"
    >
      <div class="category-card" @click="goCategory(category)">
        <div class="category-icon">
          <i :class="category.icon"></i>
        </div>
        <span class="category-name">{{ category.name }}</span>
        <span class="category-count">{{ category.count }}件</span>
      </div>
    </el-col>
  </el-row>
</div>
<!-- 衣橱统计 -->
<div class="stats-section">
  <h3 class="section-title"> 衣橱概览</h3>
  <el-row :gutter="20">
    <el-col :xs="12" :sm="6" v-for="(value, key) in stats" :key="key">
      <dv-border-box-8 class="stat-card">
        <div class="stat-content">
          <div class="stat-value">{{ value }}</div>
          <div class="stat-label">{{ getStatLabel(key) }}</div>
        </div>
      </dv-border-box-8>
    </el-col>
  </el-row>
</div>

<!-- 最近添加 -->
<div class="recent-section">
  <div class="section-header">
    <h3 class="section-title"> 最近添加</h3>
    <el-button type="text" @click="$router.push('/wardrobe/manage')">
      查看全部 <i class="el-icon-arrow-right"></i>
    </el-button>
  </div>
  <el-row :gutter="20">
    <el-col 
      v-for="item in recentItems" 
      :key="item.id" 
      :xs="12" 
      :sm="8" 
      :md="6"
    >
      <div class="recent-card" @click="viewDetail(item.id)">
        <div class="card-image">
          <img :src="item.image" :alt="item.name" />
        </div>
        <div class="card-content">
          <h4>{{ item.name }}</h4>
          <div class="card-meta">
            <span>{{ item.category }}</span>
            <span>·</span>
            <span>{{ item.color }}</span>
          </div>
          <div class="card-date">{{ formatDate(item.date) }}</div>
        </div>
      </div>
    </el-col>
  </el-row>
</div>


</div>
 

</template>

<script>
export default {
  name: 'WardrobeHome',
data() {
  return {
    searchKeyword: '',  // 搜索关键词
    
    // 轮播图数据
    banners: [
      {
        id: 1,
        image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&q=80',
        title: '极简衣橱 · 品质生活',
        description: '少而精的单品，构建你的胶囊衣橱'
      },
      {
        id: 2,
        image: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800&q=80',
        title: '春季穿搭指南',
        description: '温暖色彩与轻盈面料'
      }
    ],
    
    // 分类数据
    categories: [
      { id: 1, name: '上装', icon: 'el-icon-sunny', type: 'top', count: 12 },
      { id: 2, name: '下装', icon: 'el-icon-moon', type: 'bottom', count: 8 },
      { id: 3, name: '裙装', icon: 'el-icon-female', type: 'dress', count: 6 },
      { id: 4, name: '外套', icon: 'el-icon-cloudy', type: 'outerwear', count: 5 },
      { id: 5, name: '鞋履', icon: 'el-icon-star-off', type: 'shoes', count: 7 },
      { id: 6, name: '配饰', icon: 'el-icon-present', type: 'accessories', count: 10 }
    ],
    
    // 统计数据
    stats: {
      total: 42,
      categories: 6,
      favorites: 15,
      recent: 8
    },
    
    // 最近添加的单品
    recentItems: [
      {
        id: 1,
        name: '纯棉白衬衫',
        image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&q=80',
        category: '上装',
        color: '白色',
        brand: 'COS',
        date: '2024-03-15'
      },
      {
        id: 2,
        name: '直筒牛仔裤',
        image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&q=80',
        category: '下装',
        color: '蓝色',
        brand: 'Levi\'s',
        date: '2024-03-14'
      },
      {
        id: 3,
        name: '运动跑鞋',
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w-400&q=80',
        category: '鞋履',
        color: '白色',
        brand: 'Nike',
        date: '2024-03-13'
      },
      {
        id: 4,
        name: '简约手表',
        image: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=400&q=80',
        category: '配饰',
        color: '银色',
        brand: 'DW',
        date: '2024-03-12'
      }
    ]
  }
},
  methods: {
  handleSearch() {
    if (this.searchKeyword.trim()) {
      this.$router.push(`/wardrobe/search?keyword=${this.searchKeyword}`)
    }
  },
  
  goCategory(category) {
    this.$router.push(`/wardrobe/manage?category=${category.type}`)
  },
  
  viewDetail(id) {
    this.$router.push(`/wardrobe/detail/${id}`)
  },
  
  getStatLabel(key) {
    const labels = {
      total: '总单品数',
      categories: '品类数量',
      favorites: '常用单品',
      recent: '最近添加'
    }
    return labels[key] || key
  },
  
  formatDate(dateStr) {
    const date = new Date(dateStr)
    return `${date.getMonth() + 1}月${date.getDate()}日添加`
  }
}
}
</script>

<style scoped>
/* 样式将在这里添加 */
.wardrobe-home {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* 搜索栏 */
.search-bar {
  margin-bottom: 30px;
  text-align: center;
}
.search-input {
  max-width: 600px;
  margin: 0 auto;
}

/* 轮播图 */
.banner-section {
  margin-bottom: 40px;
}
.banner-item {
  height: 300px;
  background-size: cover;
  background-position: center;
  position: relative;
  border-radius: 8px;
  overflow: hidden;
}
.banner-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 30px;
  background: linear-gradient(transparent, rgba(0,0,0,0.7));
  color: white;
}
.banner-title {
  font-size: 24px;
  margin-bottom: 8px;
  font-weight: 300;
}
.banner-desc {
  font-size: 14px;
  opacity: 0.9;
}

/* 分类入口 */
.quick-categories {
  margin-bottom: 40px;
}
.section-title {
  font-size: 18px;
  font-weight: 400;
  margin-bottom: 20px;
  color: #333;
}
.category-card {
  text-align: center;
  padding: 20px 10px;
  cursor: pointer;
  transition: all 0.3s;
  border-radius: 8px;
  background: #fff;
  border: 1px solid #f0f0f0;
  margin-bottom: 20px;
}
.category-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.category-icon {
  font-size: 32px;
  color: #409EFF;
  margin-bottom: 10px;
}
.category-name {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
}
.category-count {
  font-size: 12px;
  color: #999;
}

/* 统计卡片 */
.stats-section {
  margin-bottom: 40px;
}
.stat-card {
  height: 100px;
  margin-bottom: 20px;
}
.stat-content {
  text-align: center;
  padding: 20px;
}
.stat-value {
  font-size: 32px;
  font-weight: 300;
  color: #333;
  margin-bottom: 8px;
}
.stat-label {
  font-size: 14px;
  color: #999;
}

/* 最近添加 */
.recent-section {
  margin-top: 40px;
}
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}
.recent-card {
  background: white;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
}
.recent-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}
.card-image {
  height: 180px;
  overflow: hidden;
}
.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s;
}
.recent-card:hover .card-image img {
  transform: scale(1.05);
}
.card-content {
  padding: 15px;
}
.card-content h4 {
  font-size: 14px;
  margin: 0 0 8px 0;
  font-weight: 400;
  color: #333;
}
.card-meta {
  display: flex;
  gap: 5px;
  font-size: 12px;
  color: #666;
  margin-bottom: 8px;
}
.card-date {
  font-size: 11px;
  color: #999;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .wardrobe-home {
    padding: 15px;
  }
  .banner-title {
    font-size: 18px;
  }
  .stat-value {
    font-size: 24px;
  }
}
</style>