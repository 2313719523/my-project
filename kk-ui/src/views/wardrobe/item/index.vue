<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" label-width="68px">
      <el-form-item label="单品名称" prop="name">
        <el-input v-model="queryParams.name" placeholder="请输入单品名称" clearable size="small" />
      </el-form-item>
      <el-form-item label="品类" prop="category">
        <el-select v-model="queryParams.category" placeholder="请选择品类" clearable size="small">
          <el-option label="上装" value="上装" />
          <el-option label="下装" value="下装" />
          <el-option label="鞋履" value="鞋履" />
          <el-option label="配饰" value="配饰" />
          <el-option label="外套" value="外套" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="small" @click="handleAdd">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="small" @click="handleDelete">删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="itemList">
      <el-table-column label="单品名称" align="center" prop="name" />
      <el-table-column label="品类" align="center" prop="category">
        <template slot-scope="scope">
          <el-tag>{{ scope.row.category }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="颜色" align="center" prop="color">
        <template slot-scope="scope">
          <div style="display: flex; align-items: center; justify-content: center;">
            <div :style="{ width: '20px', height: '20px', backgroundColor: getColorCode(scope.row.color), borderRadius: '50%', marginRight: '8px' }"></div>
            <span>{{ scope.row.color }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="季节" align="center" prop="season">
        <template slot-scope="scope">
          <el-tag>{{ scope.row.season }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="价格" align="center" prop="price">
        <template slot-scope="scope">
          <span style="color: #ff6b6b; font-weight: bold;">¥{{ scope.row.price }}</span>
        </template>
      </el-table-column>
      <el-table-column label="是否常用" align="center" prop="isCommon">
        <template slot-scope="scope">
          <el-tag :type="scope.row.isCommon ? 'success' : 'info'">{{ scope.row.isCommon ? '常用' : '' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="添加时间" align="center" prop="addTime" width="180" />
      <el-table-column label="操作" align="center" width="180">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import { listItem, delItem } from "@/api/wardrobe/item";

export default {
  name: "WardrobeItem",
  data() {
    return {
      loading: true,
      itemList: [],
      queryParams: {
        name: null,
        category: null
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
        this.itemList = response.data || response.rows || [];
        this.loading = false;
      });
    },
    getColorCode(color) {
      const map = {
        '白色': '#ffffff', '蓝色': '#1890ff', '黑色': '#000000',
        '红色': '#ff4d4f', '驼色': '#d2691e', '银色': '#c0c0c0'
      };
      return map[color] || '#cccccc';
    },
    handleQuery() {
      this.getList();
    },
    resetQuery() {
      this.queryParams = { name: null, category: null };
      this.getList();
    },
    handleAdd() {
      this.$message.info('新增功能需要创建add.vue页面');
    },
    handleUpdate() {
      this.$message.info('修改功能需要创建add.vue页面');
    },
    handleDelete(row) {
      this.$confirm('确认删除？', "警告", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        const ids = row.id ? [row.id] : [];
        delItem(ids).then(() => {
          this.$message.success("删除成功");
          this.getList();
        });
      });
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
}
.mb8 {
  margin-bottom: 16px;
}
</style>