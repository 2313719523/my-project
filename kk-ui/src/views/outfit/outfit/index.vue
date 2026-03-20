<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="请输入用户ID"
          clearable
          @keyup.enter.native="handleQuery"
          oninput="value=value.replace(/[^0-9]/g,'')"
        />
      </el-form-item>
      <el-form-item label="穿搭标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入穿搭标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="风格标签" prop="styleTag">
        <el-select v-model="queryParams.styleTag" placeholder="请选择风格标签" clearable>
          <el-option
            v-for="dict in dict.type.outfit_style"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="场景标签" prop="sceneTag">
        <el-select v-model="queryParams.sceneTag" placeholder="请选择场景标签" clearable>
          <el-option
            v-for="dict in dict.type.outfit_scene"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['outfit:outfit:add']"
        >发布穿搭</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['outfit:outfit:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['outfit:outfit:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['outfit:outfit:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="outfitList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="穿搭ID" align="center" prop="outfitId" width="80" />
      <el-table-column label="穿搭标题" align="center" prop="title" width="150" show-overflow-tooltip />
      <el-table-column label="穿搭描述" align="center" prop="description" width="150" show-overflow-tooltip />
      <el-table-column label="风格" align="center" prop="styleTag">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.outfit_style" :value="scope.row.styleTag"/>
        </template>
      </el-table-column>
      <el-table-column label="场景" align="center" prop="sceneTag">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.outfit_scene" :value="scope.row.sceneTag"/>
        </template>
      </el-table-column>
      <el-table-column label="图片" align="center" prop="images" width="200">
        <template slot-scope="scope">
          <el-image 
            v-if="scope.row.images && scope.row.images.split(',')[0]" 
            :src="getImageUrl(scope.row.images.split(',')[0])" 
            :preview-src-list="getImageList(scope.row.images)"
            fit="cover"
            style="width: 50px; height: 50px; border-radius: 4px; cursor: pointer;"
          />
          <span v-else>暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column label="浏览" align="center" prop="viewCount" width="80" />
      <el-table-column label="点赞" align="center" prop="likeCount" width="80" />
      <el-table-column label="收藏" align="center" prop="collectCount" width="80" />
      <el-table-column label="状态" align="center" prop="status" width="80">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
            {{ scope.row.status === '0' ? '正常' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="发布时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" width="200" fixed="right">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['outfit:outfit:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['outfit:outfit:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改穿搭对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="700px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户ID" prop="userId" v-if="false">
          <el-input v-model="form.userId" />
        </el-form-item>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="穿搭标题" prop="title">
              <el-input v-model="form.title" placeholder="请输入穿搭标题" maxlength="50" show-word-limit />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="风格标签" prop="styleTag">
              <el-select v-model="form.styleTag" placeholder="请选择风格标签" clearable style="width: 100%">
                <el-option
                  v-for="dict in dict.type.outfit_style"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="场景标签" prop="sceneTag">
              <el-select v-model="form.sceneTag" placeholder="请选择场景标签" clearable style="width: 100%">
                <el-option
                  v-for="dict in dict.type.outfit_scene"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状 态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="穿搭描述" prop="description">
          <el-input v-model="form.description" type="textarea" rows="3" placeholder="请输入穿搭描述" maxlength="200" show-word-limit />
        </el-form-item>
        
        <!-- 图片上传组件 -->
        <el-form-item label="穿搭图片" prop="images">
          <image-upload v-model="form.images" :limit="9" :file-size="5" />
          <div style="color: #999; font-size: 12px; margin-top: 5px;">
            支持jpg、png格式，最多上传9张，单张不超过5MB
          </div>
        </el-form-item>
        
        <!-- 统计信息（修改时显示） -->
        <el-row :gutter="20" v-if="form.outfitId">
          <el-col :span="8">
            <el-form-item label="浏览数" prop="viewCount">
              <el-input v-model="form.viewCount" :disabled="true" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="点赞数" prop="likeCount">
              <el-input v-model="form.likeCount" :disabled="true" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收藏数" prop="collectCount">
              <el-input v-model="form.collectCount" :disabled="true" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 查看穿搭详情对话框 -->
    <el-dialog :title="viewTitle" :visible.sync="viewOpen" width="600px" append-to-body>
      <div v-if="viewForm.outfitId">
        <el-row class="view-item">
          <el-col :span="4" class="view-label">标题：</el-col>
          <el-col :span="20" class="view-content">{{ viewForm.title }}</el-col>
        </el-row>
        <el-row class="view-item">
          <el-col :span="4" class="view-label">风格：</el-col>
          <el-col :span="8" class="view-content">
            <dict-tag :options="dict.type.outfit_style" :value="viewForm.styleTag"/>
          </el-col>
          <el-col :span="4" class="view-label">场景：</el-col>
          <el-col :span="8" class="view-content">
            <dict-tag :options="dict.type.outfit_scene" :value="viewForm.sceneTag"/>
          </el-col>
        </el-row>
        <el-row class="view-item">
          <el-col :span="4" class="view-label">描述：</el-col>
          <el-col :span="20" class="view-content">{{ viewForm.description || '暂无描述' }}</el-col>
        </el-row>
        <el-row class="view-item">
          <el-col :span="4" class="view-label">图片：</el-col>
          <el-col :span="20" class="view-content">
            <el-image 
              v-for="(img, index) in getImageList(viewForm.images)" 
              :key="index"
              :src="getImageUrl(img)"
              :preview-src-list="getImageList(viewForm.images)"
              fit="cover"
              style="width: 100px; height: 100px; margin-right: 10px; margin-bottom: 10px; border-radius: 4px; cursor: pointer;"
            />
            <span v-if="!viewForm.images">暂无图片</span>
          </el-col>
        </el-row>
        <el-row class="view-item">
          <el-col :span="4" class="view-label">统计：</el-col>
          <el-col :span="20" class="view-content">
            <el-tag size="medium" type="info">浏览 {{ viewForm.viewCount || 0 }}</el-tag>
            <el-tag size="medium" type="danger" style="margin-left: 10px;">点赞 {{ viewForm.likeCount || 0 }}</el-tag>
            <el-tag size="medium" type="warning" style="margin-left: 10px;">收藏 {{ viewForm.collectCount || 0 }}</el-tag>
          </el-col>
        </el-row>
        <el-row class="view-item">
          <el-col :span="4" class="view-label">发布时间：</el-col>
          <el-col :span="20" class="view-content">{{ viewForm.createTime }}</el-col>
        </el-row>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listOutfit, getOutfit, delOutfit, addOutfit, updateOutfit } from "@/api/outfit/outfit"
import ImageUpload from '@/components/ImageUpload'

export default {
  name: "Outfit",
  components: {
    ImageUpload
  },
  dicts: ['outfit_scene', 'outfit_style'],
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 穿搭表格数据
      outfitList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查看弹出层
      viewOpen: false,
      viewTitle: "",
      viewForm: {},
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userId: null,
        title: null,
        styleTag: null,
        sceneTag: null,
        status: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        title: [
          { required: true, message: "穿搭标题不能为空", trigger: "blur" }
        ],
        styleTag: [
          { required: true, message: "请选择风格标签", trigger: "change" }
        ],
        sceneTag: [
          { required: true, message: "请选择场景标签", trigger: "change" }
        ]
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询穿搭列表 */
    getList() {
      this.loading = true
      listOutfit(this.queryParams).then(response => {
        this.outfitList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    // 取消按钮
    cancel() {
      this.open = false
      this.reset()
    },
    // 表单重置
    reset() {
      this.form = {
        outfitId: null,
        userId: null,
        title: null,
        description: null,
        styleTag: null,
        sceneTag: null,
        images: null,
        viewCount: 0,
        likeCount: 0,
        collectCount: 0,
        status: "0",
        delFlag: "0",
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
      }
      this.resetForm("form")
    },
    /** 搜索按钮操作 */
    handleQuery() {
      if (this.queryParams.userId && isNaN(this.queryParams.userId)) {
        this.queryParams.userId = ''
      }
      if (this.queryParams.userId && !isNaN(this.queryParams.userId)) {
        this.queryParams.userId = Number(this.queryParams.userId)
      }
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.outfitId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset()
      this.open = true
      this.title = "发布穿搭"
    },
    /** 查看按钮操作 */
    handleView(row) {
      this.viewForm = row
      this.viewTitle = "穿搭详情 - " + row.title
      this.viewOpen = true
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset()
      const outfitId = row.outfitId || this.ids
      getOutfit(outfitId).then(response => {
        this.form = response.data
        this.open = true
        this.title = "修改穿搭"
      })
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.outfitId != null) {
            updateOutfit(this.form).then(response => {
              this.$modal.msgSuccess("修改成功")
              this.open = false
              this.getList()
            })
          } else {
            addOutfit(this.form).then(response => {
              this.$modal.msgSuccess("发布成功")
              this.open = false
              this.getList()
            })
          }
        }
      })
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const outfitIds = row.outfitId || this.ids
      this.$modal.confirm('是否确认删除穿搭编号为"' + outfitIds + '"的数据项？').then(function() {
        return delOutfit(outfitIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('outfit/outfit/export', {
        ...this.queryParams
      }, `outfit_${new Date().getTime()}.xlsx`)
    },
    // 获取图片完整URL
    getImageUrl(img) {
      if (!img) return ''
      if (img.startsWith('http')) return img
      return process.env.VUE_APP_BASE_API + img
    },
    // 获取图片列表
    getImageList(images) {
      if (!images) return []
      return images.split(',').map(img => this.getImageUrl(img))
    }
  }
}
</script>

<style scoped>
.view-item {
  margin-bottom: 15px;
  line-height: 32px;
}
.view-label {
  text-align: right;
  padding-right: 10px;
  color: #909399;
  font-weight: bold;
}
.view-content {
  color: #606266;
}
.el-form-item {
  margin-bottom: 22px;
}
</style>