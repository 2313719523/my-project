<template>
  <div class="app-container luxury-wardrobe">
    <div class="luxury-toolbar">
      <div class="page-header">
        <h1 class="page-title">我的衣橱</h1>
        <p class="page-subtitle">{{ itemList.length }} 件独特单品</p>
      </div>
      <div class="action-group">
        <el-input 
          v-model="queryParams.name" 
          placeholder="搜索单品..." 
          clearable 
          class="luxury-search"
          prefix-icon="el-icon-search"
          @keyup.enter.native="handleQuery" 
        />
        <el-select v-model="queryParams.category" placeholder="全部品类" clearable class="luxury-select">
          <el-option label="上装" value="上装" />
          <el-option label="下装" value="下装" />
          <el-option label="鞋履" value="鞋履" />
          <el-option label="外套" value="外套" />
          <el-option label="裙装" value="裙装" />
        </el-select>
        <el-button type="text" class="btn-reset" @click="resetQuery">重置</el-button>
        <el-button type="primary" class="btn-add-luxury" @click="handleAdd">+ 新增单品</el-button>
      </div>
    </div>

    <div class="wardrobe-grid" v-loading="loading">
      <el-empty v-if="itemList.length === 0" description="衣橱空空的，开启您的时尚之旅吧"></el-empty>

      <div v-for="item in itemList" :key="item.id" class="grid-item">
        <div class="product-card">
          <div class="product-image-wrapper">
            <img 
              v-if="item.imgUrl" 
              :src="baseUrl + item.imgUrl" 
              class="product-image"
              @error="handleImgError"
            >
            <div v-else class="image-placeholder">
              <i class="el-icon-picture-outline"></i>
            </div>
            <span class="product-tag">{{ item.season || '四季' }}</span>
            
            <div class="product-overlay">
              <el-button type="text" icon="el-icon-edit" @click="handleUpdate(item)"></el-button>
              <el-button type="text" icon="el-icon-delete" @click="handleDelete(item)"></el-button>
              <el-button 
                type="text" 
                :icon="item.isFavorite === '1' ? 'el-icon-star-on' : 'el-icon-star-off'" 
                @click="toggleFavorite(item)" 
                class="fav-btn"
                :style="{ color: item.isFavorite === '1' ? '#c4a77d' : '#fff' }"
              ></el-button>
            </div>
          </div>
          
          <div class="product-info">
            <p class="product-category">{{ item.category }}</p>
            <h3 class="product-name">{{ item.name }}</h3>
            <p class="product-price">￥{{ item.price || '0' }}</p>
          </div>
        </div>
      </div>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="550px" append-to-body class="luxury-dialog">
      <el-form ref="form" :model="form" :rules="rules" label-position="top">
        <el-form-item label="单品名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入单品名称" />
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="品类" prop="category">
              <el-select v-model="form.category" placeholder="请选择品类" style="width: 100%">
                <el-option label="上装" value="上装" />
                <el-option label="下装" value="下装" />
                <el-option label="鞋履" value="鞋履" />
                <el-option label="外套" value="外套" />
                <el-option label="裙装" value="裙装" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="价格" prop="price">
              <el-input-number v-model="form.price" :precision="2" :step="1" :min="0" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="单品颜色" prop="color">
          <el-input v-model="form.color" placeholder="请输入颜色（如：珍珠白、莫兰迪灰）" />
        </el-form-item>

        <el-form-item label="季节" prop="season">
          <el-radio-group v-model="form.season" class="luxury-radio">
            <el-radio-button label="春秋">春秋</el-radio-button>
            <el-radio-button label="夏季">夏季</el-radio-button>
            <el-radio-button label="冬季">冬季</el-radio-button>
            <el-radio-button label="四季">四季</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="单品图片">
          <image-upload v-model="form.imgUrl"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel" class="btn-cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm" class="btn-confirm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listItem, getItem, updateItem, delItem, addItem } from "@/api/wardrobe/item";

export default {
  name: "WardrobeItem",
  data() {
    return {
      baseUrl: "http://localhost:8080", 
      loading: true,
      itemList: [],
      open: false, 
      title: "",
      form: {},
      queryParams: {
        name: null,
        category: this.$route.query.category || null,
        style: null
      },
      rules: {
        name: [{ required: true, message: "单品名称不能为空", trigger: "blur" }],
        category: [{ required: true, message: "品类不能为空", trigger: "change" }],
        // 🌟 修改点：颜色必填校验，改为失焦触发
        color: [{ required: true, message: "颜色备注不能为空", trigger: "blur" }]
      }
    };
  },
  created() {
    this.getList();
  },
  watch: {
    '$route.query.category': {
      handler(val) {
        this.queryParams.category = val || null;
        this.handleQuery();
      },
      immediate: false
    }
  },

  methods: {
    getList() {
      this.loading = true;
      listItem(this.queryParams).then(response => {
        this.itemList = response.rows || response.data || [];
        this.loading = false;
      });
    },
    handleQuery() { this.getList(); },
    resetQuery() {
      this.queryParams = { name: null, category: null, style: null };
      if (this.$route.query.category) {
        this.$router.replace({ path: this.$route.path, query: {} });
      }
      this.handleQuery();
    },
    reset() {
      // 🌟 修改点：重置时 color 设为空字符串，等待你手动填写
      this.form = { id: null, name: null, category: null, color: "", season: "四季", price: 0, imgUrl: null };
      this.resetForm("form");
    },
    cancel() { this.open = false; this.reset(); },
    handleAdd() { this.reset(); this.open = true; this.title = "添加单品"; },
    handleUpdate(item) {
      this.reset();
      getItem(item.id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改单品";
      });
    },
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateItem(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addItem(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    handleDelete(item) {
      this.$confirm('确定要从衣橱删除“' + item.name + '”吗?', "提示", { type: "warning" }).then(() => {
        return delItem(item.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("已移除");
      });
    },
    toggleFavorite(item) {
      const targetStatus = item.isFavorite === '1' ? '0' : '1';
      updateItem({ id: item.id, isFavorite: targetStatus }).then(() => {
        item.isFavorite = targetStatus;
      });
    },
    handleImgError(e) { e.target.src = "https://via.placeholder.com/400?text=No+Image"; }
  }
};
</script>

<style scoped>
/* 保持你原有的所有样式 */
.luxury-wardrobe {
  background-color: #fcfaf7 !important;
  padding: 40px;
  min-height: 100vh;
}

.luxury-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 50px;
  border-bottom: 1px solid #e0dcd5;
  padding-bottom: 20px;
}

.page-title {
  font-size: 32px;
  font-family: "Noto Serif SC", serif;
  font-weight: 500;
  color: #1a1a1a;
  margin: 0;
}

.page-subtitle {
  color: #8c8c8c;
  font-size: 14px;
  margin-top: 5px;
}

.action-group {
  display: flex;
  align-items: center;
  gap: 15px;
}

.luxury-search >>> .el-input__inner,
.luxury-select >>> .el-input__inner {
  border: none;
  border-bottom: 1px solid #d9d9d9;
  border-radius: 0;
  background: transparent;
  padding-left: 0;
  color: #1a1a1a;
  transition: border-color 0.3s;
}

.luxury-search >>> .el-input__inner:focus,
.luxury-select >>> .el-input__inner:focus {
  border-bottom: 1px solid #c4a77d;
}

.btn-reset {
  color: #8c8c8c;
  margin-right: 10px;
}
.btn-reset:hover { color: #1a1a1a; }

.btn-add-luxury {
  background-color: #1a1a1a;
  border-color: #1a1a1a;
  border-radius: 2px;
  font-weight: 500;
  padding: 10px 20px;
}
.btn-add-luxury:hover {
  background-color: #333;
  border-color: #333;
}

.wardrobe-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 40px;
}

.product-card {
  background: transparent;
  border: none;
  overflow: hidden;
  transition: transform 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
}

.product-image-wrapper {
  position: relative;
  height: 380px;
  background-color: #fff;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.product-image {
  max-width: 90%;
  max-height: 90%;
  object-fit: contain;
  transition: transform 0.6s ease;
}

.product-card:hover .product-image {
  transform: scale(1.05);
}

.product-tag {
  position: absolute;
  top: 15px;
  left: 15px;
  background-color: #1a1a1a;
  color: #fff;
  font-size: 11px;
  padding: 3px 8px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.product-overlay {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  background-color: rgba(0,0,0,0.4);
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  opacity: 0;
  transition: opacity 0.3s;
  z-index: 10;
}

.product-image-wrapper:hover .product-overlay {
  opacity: 1;
}

.product-overlay .el-button {
  color: #fff;
  font-size: 20px;
  padding: 0;
}
.product-overlay .el-button:hover {
  color: #c4a77d;
}

.product-info {
  padding: 15px 0;
  text-align: center;
}

.product-category {
  font-size: 12px;
  color: #8c8c8c;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 5px;
}

.product-name {
  font-size: 16px;
  color: #1a1a1a;
  font-weight: 500;
  margin: 0 0 10px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-price {
  font-size: 16px;
  color: #1a1a1a;
  font-weight: 600;
  font-family: "Helvetica Neue", sans-serif;
}

.luxury-dialog >>> .el-dialog__header {
  border-bottom: 1px solid #e0dcd5;
  text-align: center;
}
.luxury-dialog >>> .el-dialog__title {
  font-family: "Noto Serif SC", serif;
  font-weight: 500;
  color: #1a1a1a;
}
.luxury-dialog >>> .el-form-item__label {
  font-size: 12px;
  color: #8c8c8c;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 0;
}
.luxury-dialog >>> .el-input__inner,
.luxury-dialog >>> .el-select .el-input__inner {
  border: 1px solid #d9d9d9;
  border-radius: 0;
}
.luxury-dialog >>> .el-input__inner:focus {
  border-color: #c4a77d;
}

.luxury-radio >>> .el-radio-button__inner {
  border-radius: 0 !important;
  background: transparent;
  color: #1a1a1a;
  border-color: #d9d9d9;
}
.luxury-radio >>> .el-radio-button__orig-radio:checked + .el-radio-button__inner {
  background-color: #1a1a1a;
  border-color: #1a1a1a;
  color: #fff;
  box-shadow: none;
}

.btn-cancel { border-radius: 0; color: #8c8c8c; }
.btn-confirm { background-color: #1a1a1a; border-color: #1a1a1a; border-radius: 0; }
.btn-confirm:hover { background-color: #333; border-color: #333; }

.image-placeholder { color: #d9d9d9; font-size: 60px; }

.luxury-search >>> .el-input__inner {
  padding-left: 35px !important; 
  border: none;
  border-bottom: 1px solid #d9d9d9;
  border-radius: 0;
  background: transparent;
  color: #1a1a1a;
  height: 40px;
  line-height: 40px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.luxury-search >>> .el-input__prefix {
  left: 8px;
  color: #8c8c8c;
  display: flex;
  align-items: center;
}

.luxury-search >>> .el-input__inner:focus {
  border-bottom: 1px solid #c4a77d;
}

.luxury-search >>> .el-input__inner:focus + .el-input__prefix {
  color: #c4a77d;
}

.category-icon-wrapper {
  background-color: #ffffff;
  border: 1px solid #f0efed;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  transition: all 0.4s ease;
  cursor: pointer;
}

.category-icon-wrapper i, 
.category-icon-wrapper svg {
  color: #2c2a26 !important;
  font-size: 24px;
}

.category-icon-wrapper:hover {
  transform: translateY(-5px);
  border-color: #c4a77d;
}

.category-icon-wrapper:hover i {
  color: #c4a77d !important;
}
</style>