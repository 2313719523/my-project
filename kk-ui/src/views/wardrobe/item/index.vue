<template>
  <div class="app-container">
    <el-card class="query-card" style="margin-bottom: 20px; border-radius: 12px;">
      <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="68px">
        <el-form-item label="单品名称" prop="name">
          <el-input v-model="queryParams.name" placeholder="搜索我的衣橱..." clearable size="small" @keyup.enter.native="handleQuery" />
        </el-form-item>
        <el-form-item label="品类" prop="category">
          <el-select v-model="queryParams.category" placeholder="全部品类" clearable size="small">
            <el-option label="上装" value="上装" />
            <el-option label="下装" value="下装" />
            <el-option label="鞋履" value="鞋履" />
            <el-option label="外套" value="外套" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
          <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          <el-button icon="el-icon-plus" size="mini" type="success" @click="handleAdd">新增单品</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-row :gutter="20" v-loading="loading">
      <el-empty v-if="itemList.length === 0" description="衣橱空空的，快去添加单品吧"></el-empty>

      <el-col :span="6" v-for="item in itemList" :key="item.id" style="margin-bottom: 25px;">
        <el-card :body-style="{ padding: '0px' }" class="item-card">
          <div class="image-wrapper">
            <img 
              v-if="item.imgUrl" 
              :src="baseUrl + item.imgUrl" 
              class="item-image"
              @error="handleImgError"
            >
            <div v-else class="image-placeholder">
              <i class="el-icon-picture-outline"></i>
              <span>未设置图片</span>
            </div>
            <div class="item-season-tag">{{ item.season || '四季' }}</div>
          </div>
          
          <div class="item-content">
            <div class="item-header">
              <span class="item-name">{{ item.name }}</span>
              <el-button 
                type="text" 
                :icon="item.isFavorite === '1' ? 'el-icon-star-on' : 'el-icon-star-off'" 
                @click="toggleFavorite(item)" 
                class="fav-btn"
                :style="{ color: item.isFavorite === '1' ? '#f1c40f' : '#909399' }"
              ></el-button>
            </div>
            
            <div class="bottom-info">
              <el-tag size="mini" type="success" effect="light">{{ item.category }}</el-tag>
              <span class="item-price">￥{{ item.price || '0' }}</span>
            </div>

            <div class="action-btns">
              <el-button type="text" size="mini" icon="el-icon-edit" @click="handleUpdate(item)">修改</el-button>
              <el-button type="text" size="mini" icon="el-icon-delete" style="color: #F56C6C" @click="handleDelete(item)">删除</el-button>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { listItem, updateItem, delItem } from "@/api/wardrobe/item";

export default {
  name: "WardrobeItem",
  data() {
    return {
      // ⚠️ 重点：这里直接写死后端端口地址，跳过 dev-api 代理
      baseUrl: "http://localhost:8080", 
      loading: true,
      itemList: [],
      queryParams: {
        name: null,
        category: this.$route.query.category || null,
        style: null
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    getList() {
      this.loading = true;
      listItem(this.queryParams).then(response => {
        // 兼容处理：若依的分页数据通常在 rows 里
        this.itemList = response.rows || response.data || [];
        this.loading = false;
      });
    },
    handleQuery() { this.getList(); },
    resetQuery() {
      this.queryParams = { name: null, category: null, style: null };
      this.handleQuery();
    },
    handleAdd() { this.$router.push('/wardrobe/item/add'); },
    handleUpdate(item) { this.$router.push('/wardrobe/item/edit/' + item.id); },
    handleDelete(item) {
      this.$confirm('确定要从衣橱删除“' + item.name + '”吗?', "提示", {
        type: "warning"
      }).then(() => {
        return delItem(item.id);
      }).then(() => {
        this.getList();
        this.$message.success("已移除");
      });
    },
    toggleFavorite(item) {
      const targetStatus = item.isFavorite === '1' ? '0' : '1';
      updateItem({ id: item.id, isFavorite: targetStatus }).then(() => {
        item.isFavorite = targetStatus;
      });
    },
    handleImgError(e) {
      // 图片加载失败时的备用处理
      e.target.src = "https://via.placeholder.com/200?text=Image+Error";
    }
  }
};
</script>

<style scoped>
/* 卡片整体样式 */
.item-card {
  border-radius: 15px;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
  border: none;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}
.item-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 12px 30px rgba(0,0,0,0.12);
}

/* 图片容器 */
.image-wrapper {
  position: relative;
  height: 240px;
  background: #f8f9fa;
  display: flex;
  align-items: center;
  justify-content: center;
}
.item-image {
  width: 100%;
  height: 100%;
  object-fit: cover; /* 保证图片不变形 */
}

/* 悬浮标签 */
.item-season-tag {
  position: absolute;
  top: 12px;
  right: 12px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(4px);
  color: #333;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: bold;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

/* 文字内容区 */
.item-content { padding: 16px; }
.item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}
.item-name {
  font-weight: 600;
  font-size: 16px;
  color: #2c3e50;
}
.bottom-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}
.item-price {
  color: #ff4757;
  font-weight: 700;
  font-size: 17px;
}

/* 按钮区域 */
.action-btns {
  border-top: 1px solid #f1f2f6;
  padding-top: 12px;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}
.fav-btn { font-size: 20px; padding: 0; }
</style>