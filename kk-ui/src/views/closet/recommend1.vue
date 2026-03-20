<template>
  <div class="app-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1>AI智能穿搭推荐</h1>
      <p class="subtitle">基于本地规则引擎的个性化穿搭方案</p>
    </div>

    <div class="recommend-container">
      <!-- 左侧：输入表单 -->
      <div class="input-section">
        <el-card class="form-card" shadow="hover" style="background: #F8F5F0; border: 1px solid #E8E0D5;">
          <div slot="header" style="border-bottom: 1px solid #E8E0D5;">
            <span class="card-title" style="color: #6B4B32;">输入穿搭需求</span>
          </div>
          
          <el-form ref="form" :model="formData" label-width="120px">
            <!-- 场合选择 -->
            <el-form-item label="场合" prop="occasion" required>
              <el-select v-model="formData.occasion" placeholder="请选择场合" class="full-width">
                <el-option label="日常办公" value="日常办公" />
                <el-option label="旅游出行" value="旅游出行" />
                <el-option label="家庭聚会" value="家庭聚会" />
                <el-option label="毕业典礼" value="毕业典礼" />
                <el-option label="生日派对" value="生日派对" />
                <el-option label="商务会议" value="商务会议" />
                <el-option label="朋友聚会" value="朋友聚会" />
                <el-option label="约会" value="约会" />
                <el-option label="婚礼宾客" value="婚礼宾客" />
                <el-option label="面试场合" value="面试场合" />
                <el-option label="运动健身" value="运动健身" />
                <el-option label="逛街购物" value="逛街购物" />
                <el-option label="艺术展览" value="艺术展览" />
                <el-option label="音乐会/剧院" value="音乐会/剧院" />
                <el-option label="海边度假" value="海边度假" />
                <el-option label="滑雪运动" value="滑雪运动" />
                <el-option label="户外徒步" value="户外徒步" />
                <el-option label="公司年会" value="公司年会" />
                <el-option label="商务晚宴" value="商务晚宴" />
                <el-option label="产品发布会" value="产品发布会" />
              </el-select>
            </el-form-item>

            <!-- 年龄输入 -->
            <el-form-item label="年龄" prop="age" required>
              <el-input-number 
                v-model="formData.age" 
                :min="16" 
                :max="60" 
                controls-position="right"
                class="full-width"
              />
            </el-form-item>

            <!-- 身高体重 -->
            <el-form-item label="身高(cm)" prop="height">
            <el-input-number 
                v-model="formData.height" 
                :min="140" 
                :max="220" 
                controls-position="right"
                class="full-width"
            />
            </el-form-item>

            <el-form-item label="体重(kg)" prop="weight">
            <el-input-number 
                v-model="formData.weight" 
                :min="35" 
                :max="150" 
                controls-position="right"
                class="full-width"
            />
            </el-form-item>

            <el-form-item label="尺码偏好" prop="sizePreference">
            <el-select v-model="formData.sizePreference" placeholder="选择尺码" class="full-width">
                <el-option label="XS/S (偏小)" value="偏小" />
                <el-option label="M (标准)" value="标准" />
                <el-option label="L/XL (偏大)" value="偏大" />
                <el-option label="宽松款" value="宽松" />
                <el-option label="修身款" value="修身" />
                <el-option label="紧身款" value="紧身" />
            </el-select>
            </el-form-item>

            <!-- 身材类型 -->
            <el-form-item label="身材类型" prop="bodyType" required>
              <el-select v-model="formData.bodyType" placeholder="请选择身材类型" class="full-width">
                <el-option label="梨型身材" value="梨型身材" />
                <el-option label="苹果型身材" value="苹果型身材" />
                <el-option label="沙漏型身材" value="沙漏型身材" />
                <el-option label="矩形身材" value="矩形身材" />
              </el-select>
            </el-form-item>

            <!-- 温度输入 -->
            <el-form-item label="温度(℃)" prop="temperature" required>
              <div class="temperature-input">
                <el-input-number 
                  v-model="formData.temperature" 
                  :min="-20" 
                  :max="40" 
                  controls-position="right"
                  class="temp-number"
                />
                <span class="temp-unit">℃</span>
              </div>
              <div class="temp-tips" v-if="formData.temperature !== null">
                <el-tag :type="getTempTagType(formData.temperature)" size="small" style="background: #E8D7C3; border-color: #D4C1A7; color: #6B4B32;">
                  {{ getTempAdvice(formData.temperature) }}
                </el-tag>
              </div>
            </el-form-item>

            <!-- 性别选择 -->
            <el-form-item label="性别" prop="gender">
              <el-radio-group v-model="formData.gender">
                <el-radio label="女性" style="color: #6B4B32;">女性</el-radio>
                <el-radio label="男性" style="color: #6B4B32;">男性</el-radio>
              </el-radio-group>
            </el-form-item>

            <!-- 风格偏好 -->
            <el-form-item label="风格偏好">
            <el-select v-model="formData.stylePreference" placeholder="选择风格偏好" class="full-width">
                <el-option label="简约风" value="简约风" />
                <el-option label="通勤风" value="通勤风" />
                <el-option label="甜美风" value="甜美风" />
                <el-option label="复古风" value="复古风" />
                <el-option label="运动风" value="运动风" />
                <el-option label="中性风" value="中性风" />
                <el-option label="优雅风" value="优雅风" />
                <el-option label="波西米亚风" value="波西米亚风" />
                <el-option label="街头潮流风" value="街头潮流风" />
                <el-option label="极简主义风" value="极简主义风" />
                <el-option label="学院风" value="学院风" />
                <el-option label="法式浪漫风" value="法式浪漫风" />
                <el-option label="北欧冷淡风" value="北欧冷淡风" />
                <el-option label="日系森女风" value="日系森女风" />
            </el-select>
            </el-form-item>

            <!-- 预算范围 -->
            <el-form-item label="预算范围">
            <el-select v-model="formData.budget" placeholder="选择预算范围" class="full-width">
                <el-option label="平价（300元以下）" value="平价" />
                <el-option label="中等（300-1000元）" value="中等" />
                <el-option label="轻奢（1000-3000元）" value="轻奢" />
                <el-option label="高端（3000元以上）" value="高端" />
            </el-select>
            </el-form-item>
            <!-- 提交按钮 -->
            <el-form-item>
              <el-button 
                type="primary" 
                icon="el-icon-magic-stick" 
                @click="getRecommendation"
                :loading="loading"
                size="large"
                class="submit-btn nordic-btn"
              >
                {{ loading ? '正在生成...' : '获取穿搭推荐' }}
              </el-button>
              
              <el-button 
                icon="el-icon-refresh" 
                @click="resetForm"
                plain
                class="nordic-btn-plain"
              >
                重置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </div>

      <!-- 右侧：推荐结果 -->
      <div class="result-section">
        <el-card class="result-card" shadow="hover" style="background: #F8F5F0; border: 1px solid #E8E0D5;">
          <div slot="header" class="result-header" style="border-bottom: 1px solid #E8E0D5;">
            <span class="card-title" style="color: #6B4B32;">✨ AI穿搭推荐</span>
            <el-tag size="small" style="background: #E8D7C3; border-color: #D4C1A7; color: #6B4B32;">智能生成</el-tag>
          </div>

          <!-- 加载状态 -->
          <div v-if="loading" class="loading-container">
            <div style="text-align: center; padding: 40px 0;">
              <i class="el-icon-loading" style="font-size: 40px; color: #9A6E46;"></i>
              <p style="margin-top: 20px; color: #6B4B32;">正在生成推荐方案...</p>
              <p style="color: #9A6E46; font-size: 14px;">🤔 AI正在分析您的需求...</p>
            </div>
          </div>

          <!-- 结果展示 -->
          <div v-else-if="recommendResult" class="result-content">
            <!-- 推荐方案 -->
            <div class="recommendation-section">
              <h3 style="color: #6B4B32; border-left: 4px solid #9A6E46;">🎯 推荐方案</h3>
              <div class="recommendation-content" style="background: #F0EAE0; border: 1px solid #E8E0D5; color: #5A4528;">
                <pre style="white-space: pre-wrap; margin: 0;">{{ recommendResult.recommendation }}</pre>
              </div>
            </div>

            <!-- 推荐理由 -->
            <div class="reason-section">
              <h3 style="color: #6B4B32; border-left: 4px solid #9A6E46;">💡 推荐理由</h3>
              <p style="white-space: pre-wrap; color: #5A4528; background: #F0EAE0; padding: 15px; border-radius: 6px; border: 1px solid #E8E0D5;">
                {{ recommendResult.reason }}
              </p>
            </div>

            <!-- 风格建议 -->
            <div class="tips-section">
              <el-row :gutter="20">
                <el-col :span="12">
                  <div class="tip-card" style="background: #F0EAE0; border: 1px solid #E8E0D5;">
                    <h4 style="color: #9A6E46;">👗 风格建议</h4>
                    <p style="color: #5A4528;">{{ recommendResult.styleTips }}</p>
                  </div>
                </el-col>
                <el-col :span="12">
                  <div class="tip-card" style="background: #F0EAE0; border: 1px solid #E8E0D5;">
                    <h4 style="color: #9A6E46;">🌡️ 温度适配</h4>
                    <p style="color: #5A4528;">{{ recommendResult.temperatureAdvice }}</p>
                  </div>
                </el-col>
              </el-row>
            </div>
          </div>

          <!-- 初始状态 -->
          <div v-else class="empty-result">
            <div style="text-align: center; padding: 40px 0;">
              <i class="el-icon-info" style="font-size: 40px; color: #9A6E46;"></i>
              <p style="margin-top: 20px; color: #6B4B32;">等待输入</p>
              <p style="color: #9A6E46; margin-top: 10px;">
                请填写左侧的穿搭需求信息<br>
                AI将为您生成个性化的穿搭方案
              </p>
            </div>
          </div>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script>
import request from '@/utils/request'
import { getAIRecommendation } from "@/api/recommend"

export default {
  name: 'AIClosetRecommend',
  data() {
    return {
      loading: false,
      formData: {
        occasion: '商务晚宴',
        age: 25,
        bodyType: '梨型身材',
        temperature: 22,
        gender: '女性',
        stylePreference: '简约风'
      },
      recommendResult: null
    }
  },
  methods: {
    async getRecommendation() {
      if (!this.validateForm()) {
        return
      }

      this.loading = true
      this.recommendResult = null

      try {
        const response = await request({
          url: '/wardrobe/recommend/ai',
          method: 'post',
          data: this.formData,
          timeout:80000
        })
        
        if (response.code === 200) {
          this.recommendResult = response.data
          this.$message.success('推荐生成成功！')
        } else {
          this.$message.error('推荐失败：' + response.msg)
        }
      } catch (error) {
        console.error('获取推荐失败:', error)
        this.$message.error('网络错误，请稍后重试')
        
        // 临时使用模拟数据
        this.recommendResult = {
          recommendation: '👔 推荐穿搭方案：\n\n• 上衣：黑色西装/深色礼服衬衫\n• 下装：黑色西裤/及膝A字裙\n• 外套：西装外套/小香风外套\n• 鞋子：黑色皮鞋/尖头高跟鞋\n• 配饰：简约手表 + 珍珠/钻石饰品\n• 材质建议：选择棉麻、真丝等透气材质\n• 颜色建议：浅色系更凉爽\n• 身材建议：上浅下深，突出上半身，A字裙/阔腿裤平衡比例\n• 风格建议：年轻时尚，可以尝试流行元素\n• 颜色推荐：明亮色系、流行色',
          reason: '基于您的个人特征为您定制：\n\n📊 分析维度：\n• 年龄 25 岁：选择适合年龄段的风格\n• 梨型身材 身材：建议A字裙/阔腿裤平衡比例\n• 22℃ 天气：☀️ 温暖舒适：适合薄外套，早晚温差注意\n• 商务晚宴 场合：确保场合适宜性\n\n🎯 推荐逻辑：\n结合温度适配、身材优化、场合匹配等多维度算法',
          styleTips: '💡 穿搭小贴士：\n• 选择合身不紧身的剪裁，舒适度很重要\n• 注意色彩搭配，全身不超过3个主色\n• 色彩建议：黑白灰：经典百搭，适合所有场合',
          temperatureAdvice: '☀️ 温暖舒适：适合薄外套，早晚温差注意'
        }
      } finally {
        this.loading = false
      }
    },

    validateForm() {
      const requiredFields = ['occasion', 'age', 'bodyType', 'temperature']
      for (const field of requiredFields) {
        if (!this.formData[field] && this.formData[field] !== 0) {
          this.$message.warning(`请填写${field === 'temperature' ? '温度' : field}`)
          return false
        }
      }
      return true
    },

    resetForm() {
      this.formData = {
        occasion: '',
        age: null,
        bodyType: '',
        temperature: null,
        gender: '女性',
        stylePreference: ''
      }
      this.recommendResult = null
    },

    getTempTagType(temp) {
      if (temp >= 30) return 'danger'
      if (temp >= 20) return 'warning'
      if (temp >= 10) return ''
      if (temp >= 0) return 'info'
      return 'primary'
    },

    getTempAdvice(temp) {
      if (temp >= 30) return '炎热：轻薄透气'
      if (temp >= 20) return '温暖：薄外套'
      if (temp >= 10) return '凉爽：保暖外套'
      if (temp >= 0) return '寒冷：厚外套'
      return '严寒：羽绒服'
    }
  }
}
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  background: linear-gradient(135deg, #F8F5F0 0%, #a2bfbe89 100%);
  min-height: calc(100vh - 84px);
}

.page-header {
  margin-bottom: 30px;
  text-align: center;
  
  h1 {
    margin: 0;
    font-size: 28px;
    color: #332d28da;
    font-weight: 600;
  }
  
  .subtitle {
    margin-top: 8px;
    color: #282523c1;
    font-size: 14px;
  }
}

.recommend-container {
  display: flex;
  gap: 20px;
  
  @media (max-width: 1200px) {
    flex-direction: column;
  }
}

.input-section {
  flex: 1;
  min-width: 400px;
}

.result-section {
  flex: 2;
  min-width: 500px;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #2d2b29c7;
}

.full-width {
  width: 100%;
}

.temperature-input {
  display: flex;
  align-items: center;
  
  .temp-number {
    flex: 1;
  }
  
  .temp-unit {
    margin-left: 10px;
    color: #958e88;
    font-size: 14px;
  }
}

.temp-tips {
  margin-top: 8px;
}

/* 北欧棕色奶油风格按钮 */
.nordic-btn {
  background-color: #6b645dcf !important;
  border-color: #433d38c8 !important;
  color: white !important;
  font-weight: 500;
  
  &:hover {
    background-color: #4a4541ce !important;
    border-color: #2a2725c7 !important;
  }
  
  &:active {
    background-color: #2a2522cc !important;
    border-color: #35312fe5 !important;
  }
}

.nordic-btn-plain {
  border-color: #363431d6 !important;
  color: #3a3836c0 !important;
  
  &:hover {
    background-color: #F8F5F0 !important;
    border-color: #4d4946df !important;
    color: #43413fd2 !important;
  }
}

.submit-btn {
  width: 200px;
  font-size: 16px;
}

.result-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.loading-container,
.empty-result {
  padding: 40px 0;
}

.recommendation-section,
.reason-section,
.tips-section {
  margin-bottom: 24px;
  
  h3, h4 {
    margin-bottom: 12px;
  }
  
  h3 {
    font-size: 18px;
    padding-left: 10px;
  }
  
  h4 {
    font-size: 16px;
  }
}

.recommendation-content {
  border-radius: 6px;
  padding: 16px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
}

.tip-card {
  border-radius: 8px;
  padding: 16px;
  height: 100%;
}

/* 表单标签颜色 */
::v-deep .el-form-item__label {
  color: #453e39d6 !important;
}

/* 输入框边框颜色 */
::v-deep .el-input__inner {
  border-color: #a09c96cf !important;
  
  &:focus {
    border-color: #96938fd1 !important;
    box-shadow: 0 0 0 2px rgba(153, 151, 150, 0.2) !important;
  }
}

/* 选择器颜色 */
::v-deep .el-select .el-input__inner {
  border-color: #d6d1cc !important;
}

/* 数字输入框按钮颜色 */
::v-deep .el-input-number__increase,
::v-deep .el-input-number__decrease {
  background-color: #c3c1be !important;
  border-color: #cac6bf !important;
  color: #615f5cd6 !important;
  
  &:hover {
    background-color: #dedad7 !important;
  }
}
</style>