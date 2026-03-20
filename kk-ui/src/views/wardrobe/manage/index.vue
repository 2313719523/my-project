<template>
  <div class="app-container wardrobe-manage">
    <!-- 顶部操作栏 -->
<div class="action-bar">
  <div class="action-left">
    <el-button type="primary" icon="el-icon-plus" @click="handleAdd">
      添加单品
    </el-button>
    <el-button icon="el-icon-upload" @click="handleImport">
      批量导入
    </el-button>
  </div>
  <div class="action-right">
    <el-input
      v-model="searchKeyword"
      placeholder="搜索单品名称..."
      prefix-icon="el-icon-search"
      style="width: 200px; margin-right: 10px;"
      @keyup.enter="handleSearch"
    />
    <el-button icon="el-icon-refresh" @click="refreshList">
      刷新
    </el-button>
  </div>
</div>

<!-- 筛选条件 -->
<el-card class="filter-card">
  <el-form :inline="true" :model="filterParams" label-width="80px">
    <el-form-item label="品类">
      <el-select v-model="filterParams.category" placeholder="全部品类" clearable>
        <el-option label="上装" value="top" />
        <el-option label="下装" value="bottom" />
        <el-option label="裙装" value="dress" />
        <el-option label="外套" value="outerwear" />
        <el-option label="鞋履" value="shoes" />
        <el-option label="配饰" value="accessories" />
      </el-select>
    </el-form-item>
    
    <el-form-item label="季节">
      <el-select v-model="filterParams.season" placeholder="全部季节" clearable>
        <el-option label="春季" value="spring" />
        <el-option label="夏季" value="summer" />
        <el-option label="秋季" value="autumn" />
        <el-option label="冬季" value="winter" />
      </el-select>
    </el-form-item>
    
    <el-form-item label="风格">
      <el-select v-model="filterParams.style" placeholder="全部风格" clearable>
        <el-option label="简约" value="simple" />
        <el-option label="商务" value="business" />
        <el-option label="休闲" value="casual" />
        <el-option label="运动" value="sports" />
        <el-option label="复古" value="vintage" />
      </el-select>
    </el-form-item>
    
    <el-form-item>
      <el-button type="primary" @click="handleFilter">筛选</el-button>
      <el-button @click="resetFilter">重置</el-button>
    </el-form-item>
  </el-form>
</el-card>

<!-- 单品表格 -->
<el-table 
  :data="clothingList" 
  style="width: 100%"
  v-loading="loading"
  @sort-change="handleSortChange"
>
  <!-- 选择列 -->
  <el-table-column type="selection" width="55" />
  
  <!-- 图片列 -->
  <el-table-column prop="image" label="图片" width="80">
    <template #default="scope">
      <el-avatar 
        :size="50" 
        :src="scope.row.image" 
        shape="square"
        @click="previewImage(scope.row.image)"
        style="cursor: pointer;"
      />
    </template>
  </el-table-column>
  
  <!-- 名称列 -->
  <el-table-column prop="name" label="单品名称" width="180" sortable>
    <template #default="scope">
      <div class="item-name-cell">
        <span>{{ scope.row.name }}</span>
        <el-tag 
          v-if="scope.row.isFavorite" 
          size="mini" 
          type="danger"
          style="margin-left: 5px;"
        >
          常用
        </el-tag>
      </div>
    </template>
  </el-table-column>
  
  <!-- 品类列 -->
  <el-table-column prop="category" label="品类" width="100">
    <template #default="scope">
      <el-tag :type="getCategoryType(scope.row.category)">
        {{ scope.row.category }}
      </el-tag>
    </template>
  </el-table-column>
  
  <!-- 颜色列 -->
  <el-table-column prop="color" label="颜色" width="100">
    <template #default="scope">
      <div class="color-display">
        <div 
          class="color-box" 
          :style="{ backgroundColor: scope.row.colorCode }"
        />
        <span>{{ scope.row.color }}</span>
      </div>
    </template>
  </el-table-column>
  
  <!-- 季节列 -->
  <el-table-column prop="season" label="季节" width="80">
    <template #default="scope">
      <el-tag 
        size="small"
        :type="getSeasonType(scope.row.season)"
      >
        {{ scope.row.season }}
      </el-tag>
    </template>
  </el-table-column>
  
  <!-- 价格列 -->
  <el-table-column prop="price" label="价格" width="100" sortable>
    <template #default="scope">
      ¥{{ scope.row.price }}
    </template>
  </el-table-column>
  
  <!-- 添加时间 -->
  <el-table-column prop="createdAt" label="添加时间" width="120" sortable>
    <template #default="scope">
      {{ formatDate(scope.row.createdAt) }}
    </template>
  </el-table-column>
  
  <!-- 操作列 -->
  <el-table-column label="操作" width="180" fixed="right">
    <template #default="scope">
      <el-button 
        size="mini" 
        type="primary" 
        icon="el-icon-edit"
        @click="handleEdit(scope.row)"
      ></el-button>
      <el-button 
        size="mini" 
        type="danger" 
        icon="el-icon-delete"
        @click="handleDelete(scope.row)"
      ></el-button>
      <el-button 
        size="mini" 
        :type="scope.row.isFavorite ? 'warning' : 'default'"
        :icon="scope.row.isFavorite ? 'el-icon-star-on' : 'el-icon-star-off'"
        @click="toggleFavorite(scope.row)"
      ></el-button>
    </template>
  </el-table-column>
</el-table>


<!-- 分页 -->
<div class="pagination-container">
  <el-pagination
    @size-change="handleSizeChange"
    @current-change="handleCurrentChange"
    :current-page="pagination.current"
    :page-sizes="[10, 20, 50, 100]"
    :page-size="pagination.size"
    layout="total, sizes, prev, pager, next, jumper"
    :total="pagination.total"
  />
</div>
  </div>
</template>

<script>
export default {
  name: 'WardrobeManage',
  data() {
  return {
    // 搜索关键词
    searchKeyword: '',
    
    // 筛选参数
    filterParams: {
      category: '',
      season: '',
      style: '',
      color: ''
    },
    
    // 表格数据
    clothingList: [],
    
    // 加载状态
    loading: false,
    
    // 分页信息
    pagination: {
      current: 1,
      size: 10,
      total: 0
    },
    
    // 排序信息
    sortInfo: {
      prop: '',
      order: ''
    }
  }
},created() {
  this.loadMockData()
},

methods: {
  // 加载虚拟数据
  loadMockData() {
    this.clothingList = [
      {
        id: 1,
        image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400&q=80',
        name: '纯棉白衬衫',
        category: '上装',
        color: '白色',
        colorCode: '#ffffff',
        season: '春秋',
        style: '简约',
        price: 299,
        brand: 'COS',
        isFavorite: true,
        createdAt: '2024-03-15'
      },
      {
        id: 2,
        image: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&q=80',
        name: '直筒牛仔裤',
        category: '下装',
        color: '蓝色',
        colorCode: '#1e90ff',
        season: '四季',
        style: '休闲',
        price: 459,
        brand: 'Levi\'s',
        isFavorite: false,
        createdAt: '2024-03-14'
      },
      {
        id: 3,
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
        name: '运动跑鞋',
        category: '鞋履',
        color: '白色',
        colorCode: '#f5f5f5',
        season: '四季',
        style: '运动',
        price: 699,
        brand: 'Nike',
        isFavorite: true,
        createdAt: '2024-03-13'
      },
      {
        id: 4,
        image: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=400&q=80',
        name: '简约手表',
        category: '配饰',
        color: '银色',
        colorCode: '#c0c0c0',
        season: '四季',
        style: '商务',
        price: 1299,
        brand: 'DW',
        isFavorite: false,
        createdAt: '2024-03-12'
      },
      {
        id: 5,
        image: 'https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=400&q=80',
        name: '羊毛大衣',
        category: '外套',
        color: '驼色',
        colorCode: '#a0522d',
        season: '冬季',
        style: '商务',
        price: 1599,
        brand: 'Massimo Dutti',
        isFavorite: true,
        createdAt: '2024-03-11'
      },
      {
        id: 6,
        image: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400&q=80',
        name: '针织连衣裙',
        category: '裙装',
        color: '黑色',
        colorCode: '#333333',
        season: '秋冬',
        style: '简约',
        price: 599,
        brand: 'ZARA',
        isFavorite: false,
        createdAt: '2024-03-10'
      },
      {
        id: 7,
        image: 'https://images.unsplash.com/photo-1544441893-675973e31985?w=400&q=80',
        name: '帆布双肩包',
        category: '配饰',
        color: '军绿色',
        colorCode: '#556b2f',
        season: '四季',
        style: '休闲',
        price: 399,
        brand: 'Herschel',
        isFavorite: false,
        createdAt: '2024-03-09'
      },
      {
        id: 8,
        image: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&q=80',
        name: '皮革乐福鞋',
        category: '鞋履',
        color: '棕色',
        colorCode: '#8b4513',
        season: '春秋',
        style: '商务',
        price: 899,
        brand: 'Clarks',
        isFavorite: true,
        createdAt: '2024-03-08'
      }
    ]
    this.pagination.total = this.clothingList.length
  },
  // 添加单品
  handleAdd() {
    this.$message.info('添加单品功能开发中')
  },
  
  // 批量导入
  handleImport() {
    this.$message.info('批量导入功能开发中')
  },
  
  // 搜索
  handleSearch() {
    if (this.searchKeyword.trim()) {
      this.$message.info(`搜索关键词: ${this.searchKeyword}`)
      // 这里应该调用API搜索
    }
  },
  
  // 刷新列表
  refreshList() {
    this.loading = true
    setTimeout(() => {
      this.loadMockData()
      this.loading = false
      this.$message.success('刷新成功')
    }, 500)
  },
  
  // 筛选
  handleFilter() {
    this.$message.info('筛选功能开发中')
    // 这里应该根据筛选参数重新加载数据
  },
  
  // 重置筛选
  resetFilter() {
    this.filterParams = {
      category: '',
      season: '',
      style: '',
      color: ''
    }
    this.$message.info('筛选条件已重置')
  },
  
  // 编辑
  handleEdit(item) {
    this.$message.info(`编辑单品: ${item.name}`)
  },
  
  // 删除
  handleDelete(item) {
    this.$confirm(`确定删除 "${item.name}" 吗？`, '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      // 这里应该调用API删除
      this.clothingList = this.clothingList.filter(i => i.id !== item.id)
      this.pagination.total = this.clothingList.length
      this.$message.success('删除成功')
    })
  },
  
  // 切换收藏
  toggleFavorite(item) {
    item.isFavorite = !item.isFavorite
    const action = item.isFavorite ? '收藏' : '取消收藏'
    this.$message.success(`${action}成功`)
  },
  
  // 图片预览
  previewImage(url) {
    window.open(url, '_blank')
  },
  
  // 品类类型颜色
  getCategoryType(category) {
    const map = {
      '上装': 'primary',
      '下装': 'success',
      '裙装': 'info',
      '外套': 'warning',
      '鞋履': '',
      '配饰': 'danger'
    }
    return map[category] || ''
  },
  
  // 季节类型颜色
  getSeasonType(season) {
    const map = {
      '春季': 'success',
      '夏季': 'warning',
      '秋季': '',
      '冬季': 'info',
      '四季': 'primary',
      '春秋': 'success'
    }
    return map[season] || ''
  },
  
  // 格式化日期
  formatDate(dateStr) {
    const date = new Date(dateStr)
    return `${date.getMonth() + 1}/${date.getDate()}`
  },
  
  // 排序变化
  handleSortChange({ column, prop, order }) {
    this.sortInfo = { prop, order }
    this.$message.info(`按 ${prop} ${order === 'ascending' ? '升序' : '降序'} 排序`)
  },
  
  // 分页大小变化
  handleSizeChange(size) {
    this.pagination.size = size
    this.$message.info(`每页显示 ${size} 条`)
  },
  
  // 当前页变化
  handleCurrentChange(page) {
    this.pagination.current = page
    this.$message.info(`切换到第 ${page} 页`)
  }
}
  }
</script>

<style scoped>
.wardrobe-manage {
  padding: 20px;
}

/* 操作栏 */
.action-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 10px;
}
.action-left, .action-right {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

/* 筛选卡片 */
.filter-card {
  margin-bottom: 20px;
}

/* 表格样式 */
.item-name-cell {
  display: flex;
  align-items: center;
}
.color-display {
  display: flex;
  align-items: center;
  gap: 8px;
}
.color-box {
  width: 16px;
  height: 16px;
  border-radius: 2px;
  border: 1px solid #eee;
}

/* 分页 */
.pagination-container {
  margin-top: 20px;
  text-align: center;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .wardrobe-manage {
    padding: 10px;
  }
  .action-bar {
    flex-direction: column;
    align-items: stretch;
  }
  .action-left, .action-right {
    width: 100%;
    justify-content: space-between;
  }
}
</style>