<template>
  <div class="login-page">
    <div class="login-bg-overlay"></div>
    
    <div class="login-container">
      <div class="glass-card info-card">
        <div class="card-top">
          <div class="weather-box">
            <div class="sun-icon"></div>
            <span class="temp">26°C Sunny</span>
          </div>
          <div class="time-group">
            <div class="time-big">{{ currentTime }}</div>
            <div class="date-text">{{ currentDate }}</div>
          </div>
        </div>
        
        <div class="welcome-section">
          <h2 class="greeting">{{ greetingText }}</h2>
          <p class="brand-slogan">MAISON DE LUXE<br/>EST. 2026</p>
        </div>

        <div class="system-status">
          <span class="status-dot"></span> SYSTEM ONLINE
        </div>
      </div>

      <div class="glass-card login-card-main">
        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
          <div class="form-header">
            <h3 class="title">SIGN IN</h3>
            <p class="subtitle">身份验证</p>
          </div>
          
          <el-form-item prop="username">
            <el-input v-model="loginForm.username" type="text" placeholder="账号">
              <i slot="prefix" class="el-icon-user" />
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input v-model="loginForm.password" type="password" placeholder="密码" @keyup.enter.native="handleLogin">
              <i slot="prefix" class="el-icon-lock" />
            </el-input>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled" class="code-item">
            <el-input v-model="loginForm.code" placeholder="验证码" @keyup.enter.native="handleLogin">
              <i slot="prefix" class="el-icon-key" />
            </el-input>
            <div class="login-code">
              <img :src="codeUrl" @click="getCode" class="login-code-img"/>
            </div>
          </el-form-item>

          <div class="form-footer-tools">
            <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
            <router-link v-if="register" class="reg-link" :to="'/register'">注册账号</router-link>
          </div>

          <el-button :loading="loading" type="primary" class="submit-btn" @click.native.prevent="handleLogin">
            <span class="btn-text">{{ loading ? 'VERIFYING' : 'ENTER SYSTEM' }}</span>
          </el-button>
        </el-form>
      </div>
    </div>

    <div class="el-login-footer">
      <span>{{ footerContent }}</span>
    </div>
  </div>
</template>

<script>
import { getCodeImg } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from '@/utils/jsencrypt'
import defaultSettings from '@/settings'

export default {
  name: "Login",
  data() {
    return {
      footerContent: defaultSettings.footerContent,
      currentTime: '',
      currentDate: '',
      greetingText: 'Good Day',
      codeUrl: "",
      loginForm: { username: "admin", password: "admin123", rememberMe: true, code: "", uuid: "" },
      loginRules: {
        username: [{ required: true, trigger: "blur", message: "请输入账号" }],
        password: [{ required: true, trigger: "blur", message: "请输入密码" }],
        code: [{ required: true, trigger: "change", message: "请输入验证码" }]
      },
      loading: false,
      captchaEnabled: true,
      register: false
    }
  },
  created() {
    this.updateTime();
    setInterval(this.updateTime, 1000);
    this.getCode();
    this.getCookie();
  },
  methods: {
    updateTime() {
      const now = new Date();
      this.currentTime = now.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' });
      this.currentDate = now.toLocaleDateString('zh-CN', { month: 'short', day: 'numeric', weekday: 'short' });
      const hour = now.getHours();
      if(hour < 12) this.greetingText = 'Bonjour';
      else if(hour < 18) this.greetingText = 'Good Afternoon';
      else this.greetingText = 'Good Evening';
    },
    getCode() {
      getCodeImg().then(res => {
        this.captchaEnabled = res.captchaEnabled === undefined ? true : res.captchaEnabled;
        if (this.captchaEnabled) {
          this.codeUrl = "data:image/gif;base64," + res.img;
          this.loginForm.uuid = res.uuid;
        }
      });
    },
    getCookie() {
      const username = Cookies.get("username");
      const password = Cookies.get("password");
      const rememberMe = Cookies.get('rememberMe');
      if (username !== undefined) {
        this.loginForm.username = username;
        this.loginForm.password = decrypt(password);
        this.loginForm.rememberMe = Boolean(rememberMe);
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true;
          if (this.loginForm.rememberMe) {
            Cookies.set("username", this.loginForm.username, { expires: 30 });
            Cookies.set("password", encrypt(this.loginForm.password), { expires: 30 });
            Cookies.set('rememberMe', this.loginForm.rememberMe, { expires: 30 });
          }
          this.$store.dispatch("Login", this.loginForm).then(() => {
            this.$router.push({ path: "/" }).catch(()=>{});
          }).catch(() => {
            this.loading = false;
            if (this.captchaEnabled) this.getCode();
          });
        }
      });
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import "~@/assets/styles/variables.scss";

.login-page {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: url("../assets/images/login-bg7.jpg") center/cover no-repeat;
}

.login-bg-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.2);
}

.login-container {
  display: flex;
  z-index: 10;
  width: 820px;
  min-height: 520px;
  box-shadow: 0 30px 60px rgba(0,0,0,0.25);
  border-radius: 20px;
  overflow: hidden;
}

/* 调小毛玻璃模糊度，更清透 */
.glass-card {
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

.info-card {
  flex: 0 0 280px;
  background: rgba(255, 255, 255, 0.05);
  padding: 40px 30px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  color: #fff;
  border-right: 1px solid rgba(255, 255, 255, 0.1);

  .sun-icon {
    width: 30px; height: 30px; background: #ffcf4b; border-radius: 50%;
    box-shadow: 0 0 20px rgba(255, 207, 75, 0.6); margin-bottom: 8px;
  }
  .temp { font-size: 11px; opacity: 0.8; letter-spacing: 1px; text-transform: uppercase; }
  .time-big { font-size: 42px; font-weight: 200; margin-top: 10px; }
  .date-text { font-size: 12px; opacity: 0.5; margin-top: 5px; }
  .greeting { font-size: 28px; font-family: "Didot", serif; font-weight: 300; margin-bottom: 8px; }
  .brand-slogan { font-size: 10px; letter-spacing: 4px; opacity: 0.4; line-height: 2; }
  .system-status {
    font-size: 9px; letter-spacing: 2px; opacity: 0.6;
    .status-dot {
      display: inline-block; width: 5px; height: 5px; background: #beff4d;
      border-radius: 50%; margin-right: 8px; box-shadow: 0 0 8px #beff4d;
    }
  }
}

.login-card-main {
  flex: 1;
  background: rgba(255, 255, 255, 0.12);
  padding: 50px 60px;

  .form-header {
    margin-bottom: 35px;
    .title { color: #fff; font-size: 20px; font-weight: 300; letter-spacing: 6px; }
    .subtitle { color: rgba(255,255,255,0.3); font-size: 11px; margin-top: 8px; letter-spacing: 1px; }
  }

  ::v-deep .el-input {
    margin-bottom: 12px;
    .el-input__inner {
      background: rgba(255, 255, 255, 0.06) !important;
      border: 1px solid rgba(255,255,255,0.08) !important;
      color: #fff !important;
      height: 46px;
      border-radius: 8px;
      &:focus { border-color: rgba(255,255,255,0.3) !important; }
    }
    .el-input__prefix { color: rgba(255,255,255,0.6); }
  }

  .form-footer-tools {
    display: flex; justify-content: space-between; margin: 5px 0 30px;
    ::v-deep .el-checkbox__label { color: rgba(255,255,255,0.4); font-size: 12px; }
    .reg-link { color: rgba(255,255,255,0.4); font-size: 12px; text-decoration: none; }
  }

  /* 登录按钮：奢华质感设计 */
  .submit-btn {
    width: 100%; height: 50px; 
    background: #fff !important; 
    border: none !important;
    color: $espresso !important; 
    border-radius: 8px;
    position: relative;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    
    .btn-text {
      letter-spacing: 4px; 
      font-size: 13px; 
      font-weight: 600;
    }

    &::before {
      content: '';
      position: absolute;
      top: 0; left: -100%;
      width: 100%; height: 100%;
      background: linear-gradient(90deg, transparent, rgba(255,255,255,0.5), transparent);
      transition: 0.6s;
    }

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 12px 24px rgba(0,0,0,0.2);
      background: $bone !important;
      
      .btn-text { letter-spacing: 6px; } // 悬浮时字间距拉开

      &::before { left: 100%; }
    }
    
    &:active { transform: translateY(0); }
  }
}

.code-item {
  ::v-deep .el-input { width: 55% !important; float: left; }
  .login-code { width: 40%; float: right; img { width: 100%; height: 46px; border-radius: 8px; opacity: 0.9; } }
}

.el-login-footer {
  position: absolute; bottom: 20px; width: 100%; text-align: center;
  color: rgba(255,255,255,0.2); font-size: 10px; letter-spacing: 1px;
}

@media (max-width: 900px) {
  .info-card { display: none; }
  .login-container { width: 400px; }
}
</style>