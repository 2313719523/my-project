<template>
  <div class="app-container server-monitor-wrapper">
    <el-row :gutter="20">
      <el-col :span="12" v-for="(item, index) in statCards" :key="index" class="card-box">
        <div class="luxury-card frosted-glass">
          <div class="card-header">
            <i :class="item.icon"></i>
            <span>{{ item.title }}</span>
          </div>
          <div class="card-content-grid">
            <div class="stat-item" v-for="stat in item.data" :key="stat.label">
              <span class="label">{{ stat.label }}</span>
              <span class="value" :class="stat.class">{{ stat.value }}<small>{{ stat.unit }}</small></span>
            </div>
          </div>
          <div class="luxury-progress" :style="{ width: item.usage + '%' }"></div>
        </div>
      </el-col>

      <el-col :span="12" class="card-box">
        <div class="luxury-card frosted-glass info-card">
          <div class="card-header"><i class="el-icon-monitor"></i> 运行环境</div>
          <ul class="info-list" v-if="server.sys">
            <li><span>服务器名称</span><p>{{ server.sys.computerName }}</p></li>
            <li><span>操作系统</span><p>{{ server.sys.osName }} ({{ server.sys.osArch }})</p></li>
            <li><span>服务器IP</span><p class="tag-ip">{{ server.sys.computerIp }}</p></li>
          </ul>
        </div>
      </el-col>

      <el-col :span="12" class="card-box">
        <div class="luxury-card frosted-glass info-card">
          <div class="card-header"><i class="el-icon-coffee-cup"></i> JVM状态</div>
          <ul class="info-list" v-if="server.jvm">
            <li><span>Java版本</span><p>{{ server.jvm.version }}</p></li>
            <li><span>运行时长</span><p>{{ server.jvm.runTime }}</p></li>
            <li><span>项目路径</span><p class="path-text">{{ server.sys ? server.sys.userDir : '' }}</p></li>
          </ul>
        </div>
      </el-col>

      <el-col :span="24" class="card-box">
        <div class="luxury-card frosted-glass disk-section">
          <div class="card-header"><i class="el-icon-receiving"></i> 存储分布</div>
          <div class="disk-grid">
            <div class="disk-item" v-for="(sysFile, index) in server.sysFiles" :key="index">
              <div class="disk-info">
                <span class="dir">{{ sysFile.dirName }}</span>
                <span class="percent" :class="{'text-danger': sysFile.usage > 80}">{{ sysFile.usage }}%</span>
              </div>
              <el-progress :percentage="parseFloat(sysFile.usage)" :show-text="false" :stroke-width="4" color="#434343"></el-progress>
              <div class="disk-detail">{{ sysFile.used }} / {{ sysFile.total }}</div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getServer } from "@/api/monitor/server"

export default {
  name: "Server",
  data() {
    return {
      server: []
    }
  },
  computed: {
    statCards() {
      if (!this.server.cpu || !this.server.mem) return [];
      return [
        {
          title: '处理器 (CPU)',
          icon: 'el-icon-cpu',
          usage: this.server.cpu.used,
          data: [
            { label: '核心数', value: this.server.cpu.cpuNum, unit: '核' },
            { label: '用户率', value: this.server.cpu.used, unit: '%' },
            { label: '系统率', value: this.server.cpu.sys, unit: '%' },
            { label: '空闲率', value: this.server.cpu.free, unit: '%' }
          ]
        },
        {
          title: '内存 (Memory)',
          icon: 'el-icon-tickets',
          usage: this.server.mem.usage,
          data: [
            { label: '总内存', value: this.server.mem.total, unit: 'G' },
            { label: '已使用', value: this.server.mem.used, unit: 'G', class: this.server.mem.usage > 80 ? 'text-danger' : '' },
            { label: '剩余', value: this.server.mem.free, unit: 'G' },
            { label: 'JVM已用', value: this.server.jvm.used, unit: 'M' }
          ]
        }
      ]
    }
  },
  created() {
    this.getList();
    this.openLoading();
  },
  methods: {
    getList() {
      getServer().then(response => {
        this.server = response.data;
        this.$modal.closeLoading();
      });
    },
    openLoading() {
      this.$modal.loading("正在同步云端监控数据...");
    }
  }
}
</script>

<style lang="scss" scoped>
.server-monitor-wrapper {
  padding: 24px;
  // 背景改为和你首页背景类似的暖白/米色调
  background: #fdfcfb; 
  min-height: calc(100vh - 84px);

  .frosted-glass {
    // 增加白度，让卡片更干净
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(12px);
    border: 1px solid rgba(235, 235, 235, 0.6);
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.02);
  }

  .luxury-card {
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 20px;
    transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    position: relative;
    overflow: hidden;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 10px 30px 0 rgba(0, 0, 0, 0.05);
    }

    .card-header {
      display: flex;
      align-items: center;
      font-size: 15px;
      font-weight: 500;
      color: #1a1a1a; // 对应你首页文字的深石墨色
      margin-bottom: 24px;
      letter-spacing: 1px;
      
      i { 
        margin-right: 12px; 
        color: #c5a391; // 改为淡淡的肉桂金点缀
        font-size: 18px; 
      }
    }
  }

  .card-content-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;

    .stat-item {
      display: flex;
      flex-direction: column;
      .label { 
        font-size: 11px; 
        color: #999; 
        margin-bottom: 8px;
        text-transform: uppercase;
      }
      .value { 
        font-size: 26px; 
        font-family: "Helvetica Neue", sans-serif;
        font-weight: 300; // 细体字更显高级
        color: #2c2c2c;
        small { font-size: 12px; margin-left: 4px; color: #666; }
      }
    }
  }

  .luxury-progress {
    position: absolute;
    bottom: 0;
    left: 0;
    height: 3px;
    // 进度条改为石墨灰渐变
    background: linear-gradient(90deg, #2c3e50 0%, #434343 100%);
    transition: width 1.2s ease-in-out;
  }

  .info-list {
    list-style: none;
    padding: 0;
    margin: 0;
    li {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 0;
      border-bottom: 1px solid rgba(0,0,0,0.03);
      &:last-child { border: none; }
      span { font-size: 13px; color: #888; }
      p { 
        font-size: 13px; 
        color: #333; 
        font-weight: 400; 
        margin: 0;
      }
      .tag-ip { 
        background: #f5f5f5; 
        color: #666; 
        padding: 2px 10px; 
        border-radius: 20px;
        font-size: 11px;
      }
    }
  }

  .disk-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    gap: 24px;
    .disk-item {
      background: rgba(250, 250, 250, 0.5);
      padding: 18px;
      border-radius: 8px;
      border: 1px solid rgba(0,0,0,0.02);
      
      .disk-info {
        display: flex;
        justify-content: space-between;
        margin-bottom: 12px;
        .dir { font-weight: 500; font-size: 13px; color: #333; }
        .percent { font-size: 12px; color: #666; }
      }
      .disk-detail { 
        font-size: 11px; 
        color: #bbb; 
        margin-top: 10px; 
      }
    }
  }

  .text-danger { color: #b03030 !important; }
}
</style>