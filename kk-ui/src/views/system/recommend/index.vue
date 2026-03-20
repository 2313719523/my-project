<template>
  <div class="app-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h1>🤖 AI智能穿搭推荐</h1>
      <p class="subtitle">基于本地规则引擎的个性化穿搭方案</p>
    </div>

    <div class="recommend-container">
      <!-- 左侧：输入表单 -->
      <div class="input-section">
        <el-card class="form-card" shadow="hover">
          <div slot="header">
            <span class="card-title">🔍 输入穿搭需求</span>
          </div>
          
          <el-form ref="form" :model="formData" label-width="120px">
            <!-- 场合选择 -->
            <el-form-item label="场合" prop="occasion" required>
              <el-select v-model="formData.occasion" placeholder="请选择场合" class="full-width">
                <el-option label="商务晚宴" value="商务晚宴" />
                <el-option label="商务会议" value="商务会议" />
                <el-option label="日常办公" value="日常办公" />
                <el-option label="朋友聚会" value="朋友聚会" />
                <el-option label="约会" value="约会" />
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
                <el-tag :type="getTempTagType(formData.temperature)" size="small">
                  {{ getTempAdvice(formData.temperature) }}
                </el-tag>
              </div>
            </el-form-item>

            <!-- 性别选择 -->
            <el-form-item label="性别" prop="gender">
              <el-radio-group v-model="formData.gender">
                <el-radio label="女性">女性</el-radio>
                <el-radio label="男性">男性</el-radio>
              </el-radio-group>
            </el-form-item>

            <!-- 提交按钮 -->
            <el-form-item>
              <el-button 
                type="primary" 
                icon="el-icon-magic-stick" 
                @click="getRecommendation"
                :loading="loading"
                size="large"
                class="submit-btn"
              >
                {{ loading ? '正在生成...' : '获取穿搭推荐' }}
              </el-button>
              
              <el-button 
                icon="el-icon-refresh" 
                @click="resetForm"
                plain
              >
                重置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </div>

      <!-- 右侧：推荐结果 -->
      <div class="result-section">
        <el-card class="result-card" shadow="hover">
          <div slot="header" class="result-header">
            <span class="card-title">✨ AI穿搭推荐</span>
            <el-tag type="success" size="small">智能生成</el-tag>
          </div>

          <!-- 加载状态 -->
          <div v-if="loading" class="loading-container">
            <div style="text-align: center; padding: 40px 0;">
              <i class="el-icon-loading" style="font-size: 40px; color: #409eff;"></i>
              <p style="margin-top: 20px; color: #606266;">正在生成推荐方案...</p>
              <p style="color: #909399; font-size: 14px;">🤔 AI正在分析您的需求...</p>
            </div>
          </div>

          <!-- 结果展示 -->
          <div v-else-if="recommendResult" class="result-content">
            <!-- 推荐方案 -->
            <div class="recommendation-section">
              <h3>🎯 推荐方案</h3>
              <div class="recommendation-content">
                <pre style="white-space: pre-wrap;">{{ recommendResult.recommendation }}</pre>
              </div>
            </div>

            <!-- 推荐理由 -->
            <div class="reason-section">
              <h3>💡 推荐理由</h3>
              <p style="white-space: pre-wrap;">{{ recommendResult.reason }}</p>
            </div>

            <!-- 风格建议 -->
            <div class="tips-section">
              <el-row :gutter="20">
                <el-col :span="12">
                  <div class="tip-card">
                    <h4>👗 风格建议</h4>
                    <p>{{ recommendResult.styleTips }}</p>
                  </div>
                </el-col>
                <el-col :span="12">
                  <div class="tip-card">
                    <h4>🌡️ 温度适配</h4>
                    <p>{{ recommendResult.temperatureAdvice }}</p>
                  </div>
                </el-col>
              </el-row>
            </div>
          </div>

          <!-- 初始状态 -->
          <div v-else class="empty-result">
            <div style="text-align: center; padding: 40px 0;">
              <i class="el-icon-info" style="font-size: 40px; color: #909399;"></i>
              <p style="margin-top: 20px; color: #606266;">等待输入</p>
              <p style="color: #909399; margin-top: 10px;">
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

export default {
  name: 'AiRecommend',
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
    // 获取推荐
    async getRecommendation() {
      // 表单验证
      if (!this.validateForm()) {
        return
      }

      this.loading = true
      this.recommendResult = null

      try {
        const response = await request({
          url: '/wardrobe/recommend/ai',
          method: 'post',
          data: this.formData
        })
        
        if (response.code === 200) {
          this.recommendResult = response.data
          this.$message.success('推荐生成成功！')
        } else {
          this.$message.error(response.msg || '推荐失败')
        }
      } catch (error) {
        console.error('获取推荐失败:', error)
        this.$message.error('网络错误，请稍后重试')
        
        // 临时使用模拟数据
        this.recommendResult = {
          recommendation: '👔 上衣：黑色西装\n👖 下装：黑色西裤\n👞 鞋子：黑色皮鞋\n🧥 外套：西装外套\n💎 配饰：简约手表',
          reason: '商务晚宴需要正式着装，黑色系显得专业稳重',
          styleTips: '建议选择合身的剪裁，避免过于宽松',
          temperatureAdvice: '22℃适合西装外套，内搭衬衫即可'
        }
      } finally {
        this.loading = false
      }
    },

    // 表单验证
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

    // 重置表单
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

    // 获取温度标签类型
    getTempTagType(temp) {
      if (temp >= 30) return 'danger'
      if (temp >= 20) return 'warning'
      if (temp >= 10) return ''
      if (temp >= 0) return 'info'
      return 'primary'
    },

    // 获取温度建议
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
  background: #f5f7fa;
  min-height: calc(100vh - 84px);
}

.page-header {
  margin-bottom: 30px;
  text-align: center;
  
  h1 {
    margin: 0;
    font-size: 28px;
    color: #303133;
    font-weight: 600;
  }
  
  .subtitle {
    margin-top: 8px;
    color: #606266;
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
  color: #303133;
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
    color: #909399;
    font-size: 14px;
  }
}

.temp-tips {
  margin-top: 8px;
}

.submit-btn {
  width: 200px;
  font-size: 16px;
  font-weight: 500;
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
    color: #303133;
  }
  
  h3 {
    font-size: 18px;
    border-left: 4px solid #409eff;
    padding-left: 10px;
  }
  
  h4 {
    font-size: 16px;
    color: #409eff;
  }
}

.recommendation-content {
  background: #f8f9fa;
  border: 1px solid #e4e7ed;
  border-radius: 4px;
  padding: 16px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
}

.tip-card {
  background: #f8f9fa;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  padding: 16px;
  height: 100%;
}
</style>