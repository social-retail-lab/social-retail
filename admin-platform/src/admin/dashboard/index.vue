<template>
  <div class="dashboard-page">
    <div class="page-header">
      <h1>运营看板</h1>
      <el-button type="primary" :loading="refreshing" @click="refresh">刷新数据</el-button>
    </div>

    <!-- 大盘指标 -->
    <div class="stats-grid">
      <div class="stat-card"><div class="stat-val">¥{{ fmt(overview.totalSales) }}</div><div class="stat-label">总销售额</div></div>
      <div class="stat-card"><div class="stat-val">{{ overview.totalOrders }}</div><div class="stat-label">总订单数</div></div>
      <div class="stat-card"><div class="stat-val">{{ overview.totalUsers }}</div><div class="stat-label">总用户数</div></div>
      <div class="stat-card">
        <div class="stat-val">{{ overview.totalMerchants }}</div>
        <div class="stat-label">总商家数</div>
        <div class="stat-sub">个体: {{ overview.individualMerchants }} / 企业: {{ overview.enterpriseMerchants }}</div>
      </div>
      <div class="stat-card"><div class="stat-val">¥{{ fmt(overview.avgOrderValue) }}</div><div class="stat-label">客单价</div></div>
    </div>

    <div class="two-col">
      <!-- 商家销售额排行 -->
      <div class="chart-box">
        <h3>商家销售额排行 Top10</h3>
        <el-table :data="merchantRank" size="small" max-height="420">
          <el-table-column type="index" label="排名" width="60" />
          <el-table-column prop="merchantName" label="商家" />
          <el-table-column prop="totalSales" label="销售额">
            <template #default="{ row }">¥{{ fmt(row.totalSales) }}</template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 商家入驻趋势 -->
      <div class="chart-box">
        <h3>商家入驻趋势</h3>
        <div class="line-chart" ref="trendChartRef"></div>
      </div>
    </div>

    <div class="two-col">
      <!-- 商家分层 -->
      <div class="chart-box">
        <h3>商家分层统计</h3>
        <div class="pie-chart" ref="tiersChartRef"></div>
      </div>

      <!-- 平台抽成收入 -->
      <div class="chart-box">
        <h3>平台抽成收入</h3>
        <div class="commission-cards">
          <div class="comm-card income"><div class="comm-val">¥{{ fmt(commission.commission) }}</div><div class="comm-label">佣金收入</div></div>
          <div class="comm-card subsidy"><div class="comm-val">¥{{ fmt(commission.subsidy) }}</div><div class="comm-label">平台补贴</div></div>
          <div class="comm-card net"><div class="comm-val">¥{{ fmt(commission.netIncome) }}</div><div class="comm-label">净收入</div></div>
        </div>
      </div>
    </div>

    <!-- 类目占比 -->
    <div class="chart-box">
      <h3>类目销售额占比</h3>
      <div class="pie-chart" ref="catChartRef"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick } from 'vue'
import * as echarts from 'echarts'
import request from '@/utils/request'

const refreshing = ref(false)
const overview = reactive({ totalSales: '0', totalOrders: 0, totalUsers: 0, individualMerchants: 0, enterpriseMerchants: 0, totalMerchants: 0, avgOrderValue: '0' })
const merchantRank = ref<any[]>([])
const merchantTrend = ref<any[]>([])
const merchantTiers = reactive({ head: 0, waist: 0, tail: 0 })
const commission = reactive({ commission: '0', subsidy: '0', netIncome: '0' })
const categoryProportion = ref<any[]>([])

const trendChartRef = ref<HTMLElement | null>(null)
const tiersChartRef = ref<HTMLElement | null>(null)
const catChartRef = ref<HTMLElement | null>(null)
let trendChart: echarts.ECharts | null = null
let tiersChart: echarts.ECharts | null = null
let catChart: echarts.ECharts | null = null

const fmt = (v: any) => (Number(v) || 0).toFixed(2)

const fetchAll = async () => {
  refreshing.value = true
  try {
    const [ov, mr, mt, tr, cm, cp] = await Promise.all([
      request.get('/admin/dashboard/overview'),
      request.get('/admin/dashboard/merchant-rank'),
      request.get('/admin/dashboard/merchant-trend'),
      request.get('/admin/dashboard/merchant-tiers'),
      request.get('/admin/dashboard/commission'),
      request.get('/admin/dashboard/category-proportion')
    ])
    if (ov.code === 0) Object.assign(overview, ov.data)
    if (mr.code === 0) merchantRank.value = mr.data || []
    if (mt.code === 0) merchantTrend.value = mt.data || []
    if (tr.code === 0) Object.assign(merchantTiers, tr.data)
    if (cm.code === 0) Object.assign(commission, cm.data)
    if (cp.code === 0) categoryProportion.value = cp.data || []
  } catch { /* */ }
  refreshing.value = false
  await nextTick()
  renderCharts()
}

const renderCharts = () => {
  // 入驻趋势折线图
  if (trendChartRef.value && merchantTrend.value.length > 0) {
    if (!trendChart) trendChart = echarts.init(trendChartRef.value)
    trendChart.setOption({
      tooltip: { trigger: 'axis' },
      grid: { left: 40, right: 10, top: 10, bottom: 50 },
      xAxis: { type: 'category', data: merchantTrend.value.map(d => d.month), axisLabel: { rotate: 45, fontSize: 10 } },
      yAxis: { type: 'value', name: '商家数', minInterval: 1 },
      series: [{ type: 'line', data: merchantTrend.value.map(d => d.count), color: '#409EFF', smooth: true, areaStyle: { opacity: 0.15 } }]
    }, true)
  }
  // 商家分层饼图
  if (tiersChartRef.value) {
    if (!tiersChart) tiersChart = echarts.init(tiersChartRef.value)
    tiersChart.setOption({
      tooltip: { trigger: 'item' },
      legend: { bottom: 0 },
      series: [{
        type: 'pie', radius: ['35%', '60%'], center: ['50%', '45%'],
        data: [
          { name: '头部商家(>1万)', value: merchantTiers.head },
          { name: '腰部商家(1千~1万)', value: merchantTiers.waist },
          { name: '尾部商家(<1千)', value: merchantTiers.tail }
        ],
        itemStyle: { borderColor: '#fff', borderWidth: 2 },
        label: { formatter: '{b}\n{d}%' }
      }]
    }, true)
  }
  // 类目饼图
  if (catChartRef.value && categoryProportion.value.length > 0) {
    if (!catChart) catChart = echarts.init(catChartRef.value)
    catChart.setOption({
      tooltip: { trigger: 'item', formatter: '{b}: ¥{c} ({d}%)' },
      legend: { type: 'scroll', bottom: 0 },
      series: [{
        type: 'pie', radius: ['35%', '60%'], center: ['50%', '45%'],
        data: categoryProportion.value.map(c => ({ name: c.name, value: Number(c.amount) })),
        label: { formatter: '{b}\n{d}%' }
      }]
    }, true)
  }
}

const refresh = () => fetchAll()

onMounted(() => {
  fetchAll()
  window.addEventListener('resize', () => { trendChart?.resize(); tiersChart?.resize(); catChart?.resize() })
})
</script>

<style scoped>
.dashboard-page { padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h1 { margin: 0; font-size: 20px; }
.stats-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 14px; margin-bottom: 24px; }
.stat-card { background: #fff; border-radius: 8px; padding: 16px 20px; text-align: center; border-top: 3px solid #409EFF; }
.stat-val { font-size: 24px; font-weight: 700; margin-bottom: 4px; }
.stat-label { color: #909399; font-size: 13px; }
.stat-sub { font-size: 11px; color: #b0b3bb; margin-top: 2px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px; }
.chart-box { background: #fff; border-radius: 8px; padding: 18px; min-height: 300px; }
.chart-box h3 { margin: 0 0 12px; font-size: 15px; }
.line-chart, .pie-chart { width: 100%; height: 300px; }
.commission-cards { display: flex; gap: 12px; justify-content: center; margin-top: 40px; }
.comm-card { flex: 1; text-align: center; padding: 24px 12px; border-radius: 8px; color: #fff; }
.comm-card.income { background: linear-gradient(135deg, #409EFF, #337ECC); }
.comm-card.subsidy { background: linear-gradient(135deg, #E6A23C, #CC8A2C); }
.comm-card.net { background: linear-gradient(135deg, #67C23A, #529B2E); }
.comm-val { font-size: 22px; font-weight: 700; }
.comm-label { font-size: 13px; margin-top: 4px; opacity: 0.9; }
</style>
