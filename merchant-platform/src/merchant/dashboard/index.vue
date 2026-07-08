<template>
  <div class="dashboard-page">
    <div class="page-header">
      <h1>店铺看板</h1>
      <el-button type="primary" :loading="refreshing" @click="refresh">刷新数据</el-button>
    </div>

    <!-- 核心指标 -->
    <div class="stats-grid">
      <div class="stat-card sales">
        <div class="stat-val">¥{{ fmt(metrics.todaySales) }}</div>
        <div class="stat-label">今日销售额</div>
      </div>
      <div class="stat-card orders">
        <div class="stat-val">{{ metrics.todayOrders }}</div>
        <div class="stat-label">今日订单量</div>
      </div>
      <div class="stat-card products">
        <div class="stat-val">{{ metrics.activeProducts }}</div>
        <div class="stat-label">在售商品数</div>
      </div>
    </div>

    <!-- 商品销量排行 -->
    <div class="chart-box">
      <h3>近7天商品销量排行 TOP5</h3>
      <div v-if="productRank.length === 0" class="chart-empty">暂无数据</div>
      <div class="bar-chart" ref="barChartRef" v-else></div>
    </div>

    <!-- 销售趋势 -->
    <div class="chart-box">
      <h3>销售趋势</h3>
      <el-radio-group v-model="trendType" size="small" style="margin-bottom:12px">
        <el-radio-button value="daily">近7天</el-radio-button>
        <el-radio-button value="weekly">近8周</el-radio-button>
      </el-radio-group>
      <div v-if="noTrendData" class="chart-empty">暂无数据</div>
      <div class="line-chart" ref="lineChartRef" v-else></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch, nextTick } from 'vue'
import * as echarts from 'echarts'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'

const refreshing = ref(false)
const metrics = reactive({ todaySales: '0.00', todayOrders: 0, activeProducts: 0 })
const productRank = ref<any[]>([])
const salesTrend = reactive({ daily: [] as any[], weekly: [] as any[] })
const trendType = ref('daily')
const noTrendData = ref(false)

const barChartRef = ref<HTMLElement | null>(null)
const lineChartRef = ref<HTMLElement | null>(null)
let barChart: echarts.ECharts | null = null
let lineChart: echarts.ECharts | null = null

const fmt = (v: any) => (Number(v) || 0).toFixed(2)

const fetchAll = async () => {
  refreshing.value = true
  try {
    const [m, r, t] = await Promise.all([
      request.get('/merchant/dashboard/metrics'),
      request.get('/merchant/dashboard/product-rank'),
      request.get('/merchant/dashboard/sales-trend')
    ])
    if (m.code === 0) Object.assign(metrics, m.data)
    if (r.code === 0) productRank.value = r.data || []
    if (t.code === 0) {
      salesTrend.daily = t.data.daily || []
      salesTrend.weekly = t.data.weekly || []
    }
  } catch (e: any) {
    console.error('[店铺看板] 数据加载失败:', e)
    ElMessage.warning('看板数据加载失败，请稍后重试')
  }
  refreshing.value = false
  await nextTick()
  renderCharts()
}

const renderCharts = () => {
  // 横向柱状图
  if (barChartRef.value && productRank.value.length > 0) {
    if (!barChart) barChart = echarts.init(barChartRef.value)
    barChart.setOption({
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      grid: { left: 120, right: 40, top: 10, bottom: 10 },
      xAxis: { type: 'value', name: '销量(件)' },
      yAxis: { type: 'category', inverse: true, data: productRank.value.map(p => p.productName), axisLabel: { width: 100, overflow: 'truncate' } },
      series: [{ type: 'bar', data: productRank.value.map(p => p.totalQty), color: '#409EFF', barMaxWidth: 28, label: { show: true, position: 'right' } }]
    }, true)
  }
  // 折线图
  const data = trendType.value === 'daily' ? salesTrend.daily : salesTrend.weekly
  const label = trendType.value === 'daily' ? 'date' : 'week'
  noTrendData.value = data.length === 0
  if (data.length > 0 && lineChartRef.value) {
    if (!lineChart) lineChart = echarts.init(lineChartRef.value)

    // 日期格式化："07-06" → "7.6"，并拼接首尾展示区间
    const formatDate = (d: string) => {
      if (!d) return ''
      const parts = d.split('-')
      if (parts.length === 2) return parseInt(parts[0]) + '.' + parseInt(parts[1])
      return d
    }
    const labels = data.map(d => formatDate(d[label]))
    const rangeLabel = labels.length > 0 ? labels[0] + '~' + labels[labels.length - 1] : ''

    lineChart.setOption({
      tooltip: { trigger: 'axis' },
      grid: { left: 50, right: 20, top: 10, bottom: 40 },
      xAxis: {
        type: 'category',
        data: labels,
        axisLabel: { rotate: 0, fontSize: 10 },
        name: trendType.value === 'daily' ? rangeLabel : '',
        nameLocation: 'middle',
        nameGap: 28,
        nameTextStyle: { fontSize: 12, color: '#666', fontWeight: 500 }
      },
      yAxis: { type: 'value', name: '销售额(元)' },
      series: [{ type: 'line', data: data.map(d => Number(d.amount)), color: '#67C23A', smooth: true, areaStyle: { opacity: 0.15 } }]
    }, true)
  }
}

watch(trendType, () => { nextTick(renderCharts) })

const refresh = () => fetchAll()

onMounted(() => {
  fetchAll()
  window.addEventListener('resize', () => { barChart?.resize(); lineChart?.resize() })
})
</script>

<style scoped>
.dashboard-page { padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h1 { margin: 0; font-size: 20px; }
.stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
.stat-card { background: #fff; border-radius: 8px; padding: 20px 24px; border-left: 4px solid #ddd; }
.stat-card.sales { border-color: #409EFF; }
.stat-card.orders { border-color: #67C23A; }
.stat-card.products { border-color: #E6A23C; }
.stat-val { font-size: 28px; font-weight: 700; margin-bottom: 4px; }
.stat-label { color: #909399; font-size: 14px; }
.chart-box { background: #fff; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
.chart-box h3 { margin: 0 0 12px; font-size: 16px; }
.bar-chart, .line-chart { width: 100%; height: 320px; }
.chart-empty { height: 200px; display: flex; align-items: center; justify-content: center; color: #999; }
</style>
