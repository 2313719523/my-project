<template>
  <div class="app-container">
    <el-form ref="form" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="单品名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入单品名称" />
      </el-form-item>
      <el-form-item label="品类" prop="category">
        <el-select v-model="form.category" placeholder="请选择品类">
          <el-option label="上装" value="上装" />
          <el-option label="下装" value="下装" />
          <el-option label="鞋履" value="鞋履" />
          <el-option label="配饰" value="配饰" />
          <el-option label="外套" value="外套" />
        </el-select>
      </el-form-item>
      <el-form-item label="颜色" prop="color">
        <el-input v-model="form.color" placeholder="请输入颜色" />
      </el-form-item>
      <el-form-item label="季节" prop="season">
        <el-select v-model="form.season" placeholder="请选择季节">
          <el-option label="春秋" value="春秋" />
          <el-option label="四季" value="四季" />
          <el-option label="冬季" value="冬季" />
        </el-select>
      </el-form-item>
      <el-form-item label="价格" prop="price">
        <el-input v-model="form.price" placeholder="请输入价格">
          <template slot="prepend">¥</template>
        </el-input>
      </el-form-item>
      <el-form-item label="是否常用" prop="isCommon">
        <el-switch v-model="form.isCommon" active-text="常用" inactive-text="不常用" />
      </el-form-item>
      <el-form-item label="备注" prop="remark">
        <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submitForm">提交</el-button>
        <el-button @click="cancel">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
import { getItem, addItem, updateItem } from "@/api/wardrobe/item";

export default {
  name: "WardrobeItemAdd",
  data() {
    return {
      // 表单数据
      form: {
        id: null,
        name: null,
        category: null,
        color: null,
        season: null,
        price: null,
        isCommon: false,
        remark: null
      },
      // 表单验证规则
      rules: {
        name: [{ required: true, message: "单品名称不能为空", trigger: "blur" }],
        category: [{ required: true, message: "请选择品类", trigger: "change" }],
        color: [{ required: true, message: "颜色不能为空", trigger: "blur" }],
        season: [{ required: true, message: "请选择季节", trigger: "change" }],
        price: [{ required: true, message: "价格不能为空", trigger: "blur" }]
      }
    };
  },
  created() {
    const id = this.$route.params.id;
    if (id) {
      this.getInfo(id);
    }
  },
  methods: {
    // 获取详情
    getInfo(id) {
      getItem(id).then(response => {
        this.form = response.data;
      });
    },
    // 提交表单
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id) {
            updateItem(this.form).then(() => {
              this.$message.success("修改成功");
              this.$router.push("/wardrobe/item");
            });
          } else {
            addItem(this.form).then(() => {
              this.$message.success("新增成功");
              this.$router.push("/wardrobe/item");
            });
          }
        }
      });
    },
    // 取消
    cancel() {
      this.$router.push("/wardrobe/item");
    }
  }
};
</script>