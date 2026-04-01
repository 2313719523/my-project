<template>
  <div class="app-container cache-monitor-wrapper">
    <div class="welcome-section">
      <h2 class="page-title">数据中枢监控 <span class="sub-title">/ Redis Analytics</span></h2>
    </div>

    <el-row :gutter="30">
      <el-col :span="24" class="card-box">
        <div class="luxury-board frosted-glass">
          <div class="board-header"><i class="el-icon-monitor"></i> 核心运行状态</div>
          <div class="info-grid luxury-text">
            <div class="info-item"><span>Redis版本</span><p>{{ cache.info ? cache.info.redis_version : '-' }}</p></div>
            <div class="info-item"><span>运行模式</span><p>{{ cache.info ? (cache.info.redis_mode == "standalone" ? "单机" : "集群") : '-' }}</p></div>
            <div class="info-item"><span>Key数量</span><p class="highlight-key">{{ cache.dbSize || '-' }}</p></div>
            <div class="info-item"><span>使用内存</span><p>{{ cache.info ? cache.info.used_memory_human : '-' }}</p></div>
          </div>
        </div>
      </el-col>

      <el-col :span="12" class="card-box">
        <div class="luxury-board frosted-glass chart-board">
          <div class="board-header"><i class="el-icon-pie-chart"></i> 指令调度分布</div>
          <div class="chart-container">
            <div ref="commandstats" style="height: 360px" />
          </div>
        </div>
      </el-col>

      <el-col :span="12" class="card-box">
        <div class="luxury-board frosted-glass chart-board">
          <div class="board-header"><i class="el-icon-odometer"></i> 存储水位监控</div>
          <div class="chart-container">
            <div ref="usedmemory" style="height: 360px" />
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getCache } from "@/api/monitor/cache"
import * as echarts from "echarts"

export default {
  name: "Cache",
  data() {
    return {
      commandstats: null,
      usedmemory: null,
      cache: []
    }
  },
  created() {
    this.getList()
    this.openLoading()
  },
  methods: {
    getList() {
      getCache().then((response) => {
        this.cache = response.data
        this.$modal.closeLoading()

        this.$nextTick(() => {
          this.initCharts(response.data)
        })

        window.addEventListener("resize", () => {
          this.commandstats && this.commandstats.resize()
          this.usedmemory && this.usedmemory.resize()
        })
      })
    },
    initCharts(data) {
      // 大牌色系：香槟金、石墨黑、莫兰迪紫、冷灰
      const luxuryColors = ['#c5a391', '#1a1a1a', '#e6e6f2', '#fbc2eb', '#d4d9e1'];

      // 1. 命令统计图（重塑为环形图）
      this.commandstats = echarts.init(this.$refs.commandstats)
      this.commandstats.setOption({
        color: luxuryColors,
        tooltip: { trigger: "item", formatter: "{b} : {c} ({d}%)", backgroundColor: 'rgba(0,0,0,0.7)', textStyle: { color: '#fff' } },
        legend: { orient: 'vertical', left: '10%', top: 'center', itemWidth: 8, itemHeight: 8, textStyle: { color: '#999', fontSize: 11 } },
        series: [
          {
            name: "命令",
            type: "pie",
            radius: ["40%", "75%"], // 空心环形
            center: ["60%", "50%"],
            data: data.commandStats,
            avoidLabelOverlap: false,
            itemStyle: { borderRadius: 6, borderColor: '#fff', borderWidth: 2 },
            label: { show: false, position: 'center' },
            emphasis: { label: { show: true, fontSize: 16, fontWeight: 'bold', color: '#333' } },
            labelLine: { show: false },
            animationType: 'scale',
            animationEasing: 'elasticOut'
          }
        ]
      })

      // 2. 内存仪表盘（重塑为极简水位圆弧）
      this.usedmemory = echarts.init(this.$refs.usedmemory)
      this.usedmemory.setOption({
        series: [{
          type: 'gauge',
          startAngle: 180,
          endAngle: 0,
          min: 0,
          max: 100,
          radius: '95%',
          center: ['50%', '75%'],
          progress: { show: true, width: 6, itemStyle: { color: '#1a1a1a' } }, // 极简细线
          axisLine: { lineStyle: { width: 6, color: [[1, '#f0f0f0']] } },
          axisTick: { show: false },
          splitLine: { show: false },
          axisLabel: { show: false },
          anchor: { show: false },
          title: { show: true, offsetCenter: [0, '20%'], fontSize: 12, color: '#999', letterSpacing: 1 },
          detail: {
            valueAnimation: true,
            offsetCenter: [0, '-15%'],
            fontSize: 36,
            fontWeight: '300', // 细体字更高级
            color: '#1a1a1a',
            formatter: () => this.cache.info.used_memory_human
          },
          data: [{
            value: (parseFloat(this.cache.info.used_memory) / (parseFloat(this.cache.info.maxmemory) || 1024 * 1024 * 1024) * 100).toFixed(2),
            name: 'MEM UTILIZATION'
          }]
        }]
      })
    },
    openLoading() {
      this.$modal.loading("正在同步云端监控数据...")
    }
  }
}
</script>

<style lang="scss" scoped>
.cache-monitor-wrapper {
  padding: 30px;
  background: #fdfcfb; // 暖白奶油底色，和你首页一致
  min-height: calc(100vh - 84px);

  .welcome-section {
    margin-bottom: 25px;
    .page-title { color: #333; font-size: 24px; font-weight: 800; 
      .sub-title { color: #888; font-size: 14px; margin-left: 10px; } 
    }
  }

  .frosted-glass {
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    // 极轻的投影，营造悬浮感
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.02);
  }

  .luxury-board {
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 20px;
    position: relative;
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 8px 30px 0 rgba(0, 0, 0, 0.05);
      transform: translateY(-2px);
    }
    
    .board-header {
      display: flex;
      align-items: center;
      font-size: 15px;
      font-weight: 500;
      color: #1a1a1a;
      margin-bottom: 24px;
      letter-spacing: 1px;
      text-transform: uppercase; // 增加大牌感
      
      i { margin-right: 12px; color: #c5a391; font-size: 18px; }
    }
  }

  .info-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    .info-item {
      padding: 20px 15px;
      background: rgba(250, 250, 250, 0.3);
      border-radius: 8px;
      text-align: center;
      // 增加内部投影，模仿凹陷质感
      box-shadow: inset 0 2px 4px 0 rgba(0,0,0,0.01); 

      span { font-size: 11px; color: #999; display: block; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 1px;}
      p { font-size: 18px; color: #1a1a1a; font-weight: 600; margin: 0; font-family: "Helvetica Neue", sans-serif;}
      .highlight-key { color: #c5a391; font-size: 20px; font-weight: 700; }
    }
  }

  .chart-board {
    background: rgba(255,255,255,0.95); // 图表卡片稍微纯净一点
  }

  .chart-container {
    background: transparent;
    border-radius: 8px;
    padding: 10px;
  }
}
</style>