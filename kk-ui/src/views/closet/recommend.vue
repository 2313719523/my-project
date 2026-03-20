<template>
  <div class="luxury-container">
    <div class="ambient-glow"></div>
    
    <div class="content-wrapper">
      <header class="hero-header">
        <div class="brand-eyebrow">PERSONAL STYLING CURATION</div>
        <h1 class="main-title">智能衣橱灵感</h1>
        <div class="title-accent"></div>
        <p class="desc-text">融合气候感知与美学算法的私人订制方案</p>
      </header>

      <div class="main-grid">
        <div class="config-panel">
          <div class="panel-inner">
            <div class="section-tag">Parameters / 需求输入</div>
            
            <!-- 使用 recommend1.vue 的表单结构，但样式保持当前 -->
            <el-form ref="form" :model="formData" label-position="top">
              <!-- 场合选择 -->
              <el-form-item label="场合" prop="occasion" required>
                <el-select v-model="formData.occasion" placeholder="请选择场合" class="custom-select">
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
                  class="custom-input"
                />
              </el-form-item>

              <!-- 身高体重 -->
              <div class="input-row">
                <el-form-item label="身高(cm)" prop="height">
                  <el-input-number 
                    v-model="formData.height" 
                    :min="140" 
                    :max="220" 
                    controls-position="right"
                    class="custom-input"
                  />
                </el-form-item>
                <el-form-item label="体重(kg)" prop="weight">
                  <el-input-number 
                    v-model="formData.weight" 
                    :min="35" 
                    :max="150" 
                    controls-position="right"
                    class="custom-input"
                  />
                </el-form-item>
              </div>

              <!-- 尺码偏好 -->
              <el-form-item label="尺码偏好" prop="sizePreference">
                <el-select v-model="formData.sizePreference" placeholder="选择尺码" class="custom-select">
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
                <el-select v-model="formData.bodyType" placeholder="请选择身材类型" class="custom-select">
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
                    class="custom-input temp-number"
                  />
                  <span class="temp-unit">°C</span>
                </div>
                <div class="temp-tips" v-if="formData.temperature !== null">
                  <span class="temp-tag" :class="getTempTagType(formData.temperature)">
                    {{ getTempAdvice(formData.temperature) }}
                  </span>
                </div>
              </el-form-item>

              <!-- 性别选择 -->
              <el-form-item label="性别" prop="gender">
                <el-radio-group v-model="formData.gender" class="luxury-radio">
                  <el-radio label="女性">F</el-radio>
                  <el-radio label="男性">M</el-radio>
                </el-radio-group>
              </el-form-item>

              <!-- 风格偏好 -->
              <el-form-item label="风格偏好">
                <el-select v-model="formData.stylePreference" placeholder="选择风格偏好" class="custom-select">
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
                <el-select v-model="formData.budget" placeholder="选择预算范围" class="custom-select">
                  <el-option label="平价（300元以下）" value="平价" />
                  <el-option label="中等（300-1000元）" value="中等" />
                  <el-option label="轻奢（1000-3000元）" value="轻奢" />
                  <el-option label="高端（3000元以上）" value="高端" />
                </el-select>
              </el-form-item>

              <!-- 提交按钮 -->
              <div class="actions">
                <button class="primary-btn" @click.prevent="getRecommendation" :disabled="loading">
                  <span v-if="!loading">GENERATE STYLE</span>
                  <span v-else><i class="el-icon-loading"></i> ANALYZING</span>
                </button>
                <button class="reset-btn" @click.prevent="resetForm">RESET</button>
              </div>
            </el-form>
          </div>
        </div>

        <div class="display-panel">
  <div class="panel-inner result-area">
    <div v-if="loading" class="loader-state">
      <div class="line-loader"></div>
      <p>正在为您构思最佳方案...</p>
    </div>

    <div v-else-if="recommendResult" class="result-view animate-fade-in">
      <div class="result-header">
        <div class="status-indicator">PROPOSAL READY</div>
        <h2> AI 穿搭推荐</h2>
      </div>

      <div class="recommendation-section">
        <div class="label"> 推荐方案</div>
        <div class="content-text">{{ recommendResult.recommendation }}</div>
      </div>

      <div class="logic-box">
        <div class="label"> 推荐理由</div>
        <p>{{ recommendResult.reason }}</p>
      </div>

      <div class="details-grid">
        <div class="detail-item">
          <div class="label"><i class="el-icon-collection-tag"></i> 搭配细节</div>
          <p>{{ recommendResult.styleTips }}</p>
        </div>
        <div class="detail-item">
          <div class="label"><i class="el-icon-wind-power"></i> 气候适配</div>
          <p>{{ recommendResult.temperatureAdvice }}</p>
        </div>
      </div>
    </div>

    <div v-else class="placeholder-state">
      <div class="mouse-container">
        <div class="mouse">
          <div class="mouse-wheel"></div>
        </div>
      </div>
      
      <div class="style-quote">
        "Style is a way to say who you are without having to speak."
      </div>
      
      <h3 class="inspire-title">开启您的今日穿搭灵感之旅</h3>
      <p class="inspire-desc">请在左侧填写信息，AI 将为您智能匹配衣橱资源</p>
    </div>
  </div>
</div>
      </div>
    </div>
  </div>
</template>

<template>
  <div class="luxury-container">
    <div class="ambient-glow"></div>
    
    <div class="content-wrapper">
      <header class="hero-header">
        <div class="brand-eyebrow">PERSONAL STYLING CURATION</div>
        <h1 class="main-title">智能衣橱灵感</h1>
        <div class="title-accent"></div>
        <p class="desc-text">融合气候感知与美学算法的私人订制方案</p>
      </header>

      <div class="main-grid">
        <div class="config-panel">
          <div class="panel-inner">
            <div class="section-tag">Parameters / 需求输入</div>
            
            <el-form ref="form" :model="formData" label-position="top">
              <el-form-item label="场合" prop="occasion" required>
                <el-select v-model="formData.occasion" placeholder="请选择场合" class="custom-select">
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

              <el-form-item label="年龄" prop="age" required>
                <el-input-number 
                  v-model="formData.age" 
                  :min="16" 
                  :max="60" 
                  controls-position="right"
                  class="custom-input"
                />
              </el-form-item>

              <div class="input-row">
                <el-form-item label="身高(cm)" prop="height">
                  <el-input-number 
                    v-model="formData.height" 
                    :min="165" 
                    :max="220" 
                    controls-position="right"
                    class="custom-input"
                  />
                </el-form-item>
                <el-form-item label="体重(kg)" prop="weight">
                  <el-input-number 
                    v-model="formData.weight" 
                    :min="55" 
                    :max="150" 
                    controls-position="right"
                    class="custom-input"
                  />
                </el-form-item>
              </div>

              <el-form-item label="尺码偏好" prop="sizePreference">
                <el-select v-model="formData.sizePreference" placeholder="选择尺码" class="custom-select">
                  <el-option label="XS/S (偏小)" value="偏小" />
                  <el-option label="M (标准)" value="标准" />
                  <el-option label="L/XL (偏大)" value="偏大" />
                  <el-option label="宽松款" value="宽松" />
                  <el-option label="修身款" value="修身" />
                  <el-option label="紧身款" value="紧身" />
                </el-select>
              </el-form-item>

              <el-form-item label="身材类型" prop="bodyType" required>
                <el-select v-model="formData.bodyType" placeholder="请选择身材类型" class="custom-select">
                  <el-option label="梨型身材" value="梨型身材" />
                  <el-option label="苹果型身材" value="苹果型身材" />
                  <el-option label="沙漏型身材" value="沙漏型身材" />
                  <el-option label="矩形身材" value="矩形身材" />
                </el-select>
              </el-form-item>

              <el-form-item label="温度(℃)" prop="temperature" required>
                <div class="temperature-input">
                  <el-input-number 
                    v-model="formData.temperature" 
                    :min="-20" 
                    :max="40" 
                    controls-position="right"
                    class="custom-input temp-number"
                  />
                  <span class="temp-unit">°C</span>
                </div>
                <div class="temp-tips" v-if="formData.temperature !== null">
                  <span class="temp-tag" :class="getTempTagType(formData.temperature)">
                    {{ getTempAdvice(formData.temperature) }}
                  </span>
                </div>
              </el-form-item>

              <el-form-item label="性别" prop="gender">
                <el-radio-group v-model="formData.gender" class="luxury-radio">
                  <el-radio label="女性">F</el-radio>
                  <el-radio label="男性">M</el-radio>
                </el-radio-group>
              </el-form-item>

              <el-form-item label="风格偏好">
                <el-select v-model="formData.stylePreference" placeholder="选择风格偏好" class="custom-select">
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

              <el-form-item label="预算范围">
                <el-select v-model="formData.budget" placeholder="选择预算范围" class="custom-select">
                  <el-option label="平价（300元以下）" value="平价" />
                  <el-option label="中等（300-1000元）" value="中等" />
                  <el-option label="轻奢（1000-3000元）" value="轻奢" />
                  <el-option label="高端（3000元以上）" value="高端" />
                </el-select>
              </el-form-item>

              <div class="actions">
                <button class="primary-btn" @click.prevent="getRecommendation" :disabled="loading">
                  <span v-if="!loading">GENERATE STYLE</span>
                  <span v-else><i class="el-icon-loading"></i> ANALYZING</span>
                </button>
                <button class="reset-btn" @click.prevent="resetForm">RESET</button>
              </div>
            </el-form>
          </div>
        </div>

        <div class="display-panel">
          <div class="panel-inner result-area">
            <div v-if="loading" class="loader-state">
              <div class="line-loader"></div>
              <p>正在为您构思最佳方案...</p>
            </div>

            <div v-else-if="recommendResult" class="result-view animate-fade-in">
              <div class="result-header">
                <div class="status-indicator">PROPOSAL READY</div>
                <h2>AI穿搭推荐</h2>
              </div>

              <div class="recommendation-section">
                <div class="label"><i class="el-icon-collection-tag"></i> 推荐方案</div>
                <div class="content-text">{{ recommendResult.recommendation }}</div>
              </div>

              <div class="logic-box">
                <div class="label"><i class="el-icon-chat-dot-round"></i> 推荐理由</div>
                <p>{{ recommendResult.reason }}</p>
              </div>

              <div class="details-grid">
                <div class="detail-item">
                  <div class="label"><i class="el-icon-collection-tag"></i> 搭配细节</div>
                  <p>{{ recommendResult.styleTips }}</p>
                </div>
                <div class="detail-item">
                  <div class="label"><i class="el-icon-wind-power"></i> 气候适配</div>
                  <p>{{ recommendResult.temperatureAdvice }}</p>
                </div>
              </div>
            </div>

            <div v-else class="placeholder-state">
              <div class="mouse-container">
                <div class="mouse">
                  <div class="mouse-wheel"></div>
                </div>
              </div>
              
              <div class="style-quote">
                "Style is a way to say who you are without having to speak."
              </div>
              
              <div class="inspire-title">开启您的今日穿搭灵感之旅</div>
              <div class="inspire-desc">请在左侧填写信息，AI将为您智能匹配衣橱资源</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
$gold-accent: #c5a059;
$pure-white: #ffffff;
$off-white: #fcfcfc;
$text-black: #1a1a1a;
$text-grey: #999999;
$border-light: #f0f0f0;

.luxury-container {
  min-height: 100vh;
  background: #fdfdfd;
  color: $text-black;
  padding: 60px 20px;
  position: relative;
  overflow: hidden;
  font-family: "Optima", "Didot", "Source Han Serif CN", serif;
}

.ambient-glow {
  position: absolute;
  top: -10%;
  right: -5%;
  width: 800px;
  height: 800px;
  background: radial-gradient(circle, rgba(197, 160, 89, 0.03) 0%, transparent 60%);
  pointer-events: none;
}

.content-wrapper {
  max-width: 1300px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

.hero-header {
  text-align: center;
  margin-bottom: 70px;
  
  .brand-eyebrow {
    font-size: 11px;
    letter-spacing: 5px;
    color: $gold-accent;
    margin-bottom: 15px;
    font-weight: 600;
  }
  
  .main-title {
    font-size: 40px;
    font-weight: 300;
    letter-spacing: 6px;
    margin: 0;
    color: #000;
  }
  
  .title-accent {
    width: 25px;
    height: 1px;
    background: $gold-accent;
    margin: 20px auto;
  }
  
  .desc-text {
    font-size: 13px;
    color: $text-grey;
    letter-spacing: 1.5px;
  }
}

.main-grid {
  display: flex;
  gap: 1px; 
  background: $border-light;
  border: 1px solid $border-light;
  box-shadow: 0 40px 100px rgba(0, 0, 0, 0.04);
}

.config-panel, .display-panel {
  background: $pure-white;
  padding: 50px;
}

.config-panel { flex: 0 0 420px; }

.display-panel {
  flex: 1;
  height: 100%;
  padding: 20px;
  background-color: #fcfaf7;
  border-radius: 12px;
  box-shadow: inset 0 0 40px rgba(0, 0, 0, 0.02);
}

.panel-inner {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.section-tag {
  font-size: 10px;
  color: #bbb;
  margin-bottom: 40px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

::v-deep .el-form-item {
  margin-bottom: 30px;
  .el-form-item__label {
    color: #888 !important;
    font-size: 11px !important;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    padding: 0 !important;
    margin-bottom: 8px !important;
  }
}

::v-deep .el-input__inner, ::v-deep .el-input-number__inner {
  background: transparent !important;
  border: none !important;
  border-bottom: 1px solid #eee !important;
  border-radius: 0 !important;
  color: #222 !important;
  padding: 0 !important;
  font-size: 15px;
  transition: border-color 0.4s;
  
  &:focus { border-bottom-color: $gold-accent !important; }
}

.input-row {
  display: flex;
  gap: 30px;
  .el-form-item { flex: 1; }
}

.temperature-input {
  display: flex;
  align-items: center;
  gap: 10px;
}

.temp-unit {
  font-size: 12px;
  color: $gold-accent;
  font-weight: 600;
}

.temp-tips {
  margin-top: 8px;
}

.temp-tag {
  display: inline-block;
  padding: 4px 10px;
  font-size: 11px;
  border-radius: 3px;
  background: #E8D7C3;
  border: 1px solid #D4C1A7;
  color: #6B4B32;
  font-weight: 500;
}

.actions {
  margin-top: 50px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.primary-btn {
  background: #000;
  color: #fff;
  border: none;
  padding: 20px;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 3px;
  cursor: pointer;
  transition: 0.3s;
  &:hover { background: $gold-accent; }
  &:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }
}

.reset-btn {
  background: transparent;
  border: 1px solid #eee;
  color: #999;
  padding: 12px;
  font-size: 10px;
  letter-spacing: 2px;
  text-transform: uppercase;
  cursor: pointer;
  &:hover { color: #000; border-color: #000; }
}

.placeholder-state {
  text-align: center;
  padding: 60px 20px;

  .mouse-container {
    display: flex;
    justify-content: center;
    margin-bottom: 30px;

    .mouse {
      width: 26px;
      height: 44px;
      border: 2px solid $gold-accent;
      border-radius: 20px;
      position: relative;

      .mouse-wheel {
        width: 4px;
        height: 8px;
        background: $gold-accent;
        border-radius: 2px;
        position: absolute;
        top: 8px;
        left: 50%;
        transform: translateX(-50%);
        animation: scroll 2s infinite;
      }
    }
  }

  .style-quote {
    font-family: "Optima", "Didot", serif;
    font-style: italic;
    font-size: 18px;
    color: #8c8379;
    margin-bottom: 40px;
    letter-spacing: 0.5px;
    position: relative;
    display: inline-block;
    
    &::after {
      content: '';
      display: block;
      width: 30px;
      height: 1px;
      background: $gold-accent;
      margin: 15px auto 0;
    }
  }

  .inspire-title {
    font-size: 20px;
    color: #4a4540;
    font-weight: 500;
    margin-bottom: 12px;
  }

  .inspire-desc {
    font-size: 14px;
    color: #a69e96;
    letter-spacing: 1px;
  }
}

.result-view {
  background: #ffffff;
  padding: 40px;
  border-radius: 4px;
  border: 1px solid #eeebe6;
  box-shadow: 0 10px 30px rgba(107, 75, 50, 0.05);

  .result-header {
    border-bottom: 1px solid #f0ede9;
    padding-bottom: 20px;
    margin-bottom: 30px;

    .status-indicator {
      font-size: 10px;
      letter-spacing: 2px;
      color: $gold-accent;
      font-weight: bold;
      margin-bottom: 8px;
    }

    h2 {
      font-size: 24px;
      color: #333;
      margin: 0;
    }
  }

  .label {
    font-size: 13px;
    font-weight: 600;
    color: #8c8379;
    margin-bottom: 12px;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    i { margin-right: 8px; color: $gold-accent; }
  }

  .recommendation-section {
    margin-bottom: 35px;
    .content-text {
      font-size: 22px;
      color: #4a4540;
      line-height: 1.5;
      font-weight: 300;
      background: linear-gradient(to bottom, transparent 60%, #f1f8fa 60%);
    }
  }

  .logic-box {
    background: #fdfcfb;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 30px;
    p { font-size: 15px; color: #666; line-height: 1.8; margin: 0; }
  }

  .details-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    
    .detail-item {
      padding: 15px;
      border: 1px dashed #e8e0d5;
      border-radius: 6px;
      p { font-size: 14px; color: #777; margin: 0; }
    }
  }
}

.loader-state {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  .line-loader {
    width: 40px;
    height: 2px;
    background: $gold-accent;
    margin: 0 auto 20px;
    position: relative;
    overflow: hidden;
    &::after {
      content: '';
      position: absolute;
      left: -100%;
      width: 100%;
      height: 100%;
      background: #4a4540;
      animation: loadingLine 1.5s infinite;
    }
  }
  p { font-size: 11px; letter-spacing: 2px; color: #aaa; margin-top: 20px; }
}

@keyframes scroll {
  0% { opacity: 1; transform: translate(-50%, 0); }
  100% { opacity: 0; transform: translate(-50%, 15px); }
}

.animate-fade-in {
  animation: fadeIn 0.8s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes loadingLine {
  to { left: 100%; }
}

::v-deep .el-input-number__increase, ::v-deep .el-input-number__decrease { display: none; }
::v-deep .el-radio__input .el-radio__inner { border-color: #bbb; }
::v-deep .el-radio__input.is-checked .el-radio__inner { border-color: $gold-accent; background: $gold-accent; }
</style>

<script>
import request from '@/utils/request'

export default {
  name: 'LuxuryRecommend',
  data() {
    return {
      loading: false,
      formData: {
        occasion: '商务晚宴',
        age: 25,
        height: null,
        weight: null,
        sizePreference: '',
        bodyType: '梨型身材',
        temperature: 22,
        gender: '女性',
        stylePreference: '简约风',
        budget: ''
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
          this.showSuccess('推荐生成成功！')
        } else {
          this.showError('推荐失败：' + response.msg)
        }
      } catch (error) {
        console.error('获取推荐失败:', error)
        this.showError('网络错误，请稍后重试')
        
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
          this.showWarning(`请填写${field === 'temperature' ? '温度' : field}`)
          return false
        }
      }
      return true
    },

    resetForm() {
      this.formData = {
        occasion: '',
        age: null,
        height: null,
        weight: null,
        sizePreference: '',
        bodyType: '',
        temperature: null,
        gender: '女性',
        stylePreference: '',
        budget: ''
      }
      this.recommendResult = null
    },

    getTempTagType(temp) {
      return 'temp-tag'
    },

    getTempAdvice(temp) {
      if (temp >= 30) return '炎热：轻薄透气'
      if (temp >= 20) return '温暖：薄外套'
      if (temp >= 10) return '凉爽：保暖外套'
      if (temp >= 0) return '寒冷：厚外套'
      return '严寒：羽绒服'
    },

    showSuccess(message) {
      this.$message({
        message: message,
        type: 'success',
        customClass: 'luxury-message'
      })
    },

    showError(message) {
      this.$message({
        message: message,
        type: 'error',
        customClass: 'luxury-message'
      })
    },

    showWarning(message) {
      this.$message({
        message: message,
        type: 'warning',
        customClass: 'luxury-message'
      })
    }
  }
}
</script>