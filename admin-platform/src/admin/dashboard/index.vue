<template>
  <div class="dashboard-page">
    <div class="page-header">
      <h1>运营看板</h1>
      <button class="refresh-btn" :disabled="refreshing" @click="refresh">{{ refreshing ? '加载中...' : '刷新数据' }}</button>
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
      <!-- 商家销售额排行 - 横向条形图（按月显示前五） -->
      <div class="chart-box">
        <div class="chart-title-row">
          <h3>店铺销售前五排行</h3>
          <div class="month-tabs">
            <button
              v-for="m in availableMonths"
              :key="m"
              :class="['month-tab', { active: activeMonth === m }]"
              @click="switchMonth(m)"
            >{{ formatMonthLabel(m) }}</button>
          </div>
        </div>
        <div class="bar-chart" ref="rankChartRef"></div>
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
        <div class="chart-title-row">
          <h3>平台抽成收入</h3>
          <div class="month-tabs">
            <button :class="['month-tab', { active: activePeriod === 'month' }]" @click="activePeriod = 'month'">近一月</button>
            <button :class="['month-tab', { active: activePeriod === 'quarter' }]" @click="activePeriod = 'quarter'">近一季度</button>
            <button :class="['month-tab', { active: activePeriod === 'year' }]" @click="activePeriod = 'year'">近一年</button>
          </div>
        </div>
        <div class="commission-cards">
          <div class="comm-card">
            <div class="comm-val">¥{{ fmt(curCommission.commission) }}</div>
            <div class="comm-label">佣金收入</div>
            <div class="comm-growth">
              <span class="growth-label">环比</span>
              <span :class="growthClass(curGrowth.prevGrowth)">{{ formatGrowth(curGrowth.prevGrowth) }}</span>
            </div>
            <div class="comm-growth">
              <span class="growth-label">同比</span>
              <span :class="growthClass(curGrowth.yoyGrowth)">{{ formatGrowth(curGrowth.yoyGrowth) }}</span>
            </div>
          </div>
          <div class="comm-card">
            <div class="comm-val">¥{{ fmt(curCommission.subsidy) }}</div>
            <div class="comm-label">平台补贴</div>
          </div>
          <div class="comm-card">
            <div class="comm-val">¥{{ fmt(curCommission.netIncome) }}</div>
            <div class="comm-label">净收入</div>
            <div class="comm-growth">
              <span class="growth-label">环比</span>
              <span :class="growthClass(curGrowth.prevGrowth)">{{ formatGrowth(curGrowth.prevGrowth) }}</span>
            </div>
            <div class="comm-growth">
              <span class="growth-label">同比</span>
              <span :class="growthClass(curGrowth.yoyGrowth)">{{ formatGrowth(curGrowth.yoyGrowth) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 售后申请率折线图 -->
    <div class="chart-box">
      <h3>售后申请率趋势</h3>
      <div class="as-chart" ref="asChartRef"></div>
      <div class="as-compare">
        <span>本月 {{ asData.currentMonth }}：<b>{{ asData.currentRate }}</b></span>
        <span class="as-compare-sep">|</span>
        <span>上月：<b>{{ asData.prevRate }}</b></span>
        <span class="as-compare-sep">|</span>
        <span>环比
          <b :class="asGrowthClass">{{ asData.growth }}</b>
        </span>
      </div>
    </div>

    <div class="stats-grid" style="grid-template-columns: repeat(1, 1fr);">
      <div class="stat-card" style="border-top-color: #A0B4C8;">
        <div class="stat-val">{{ afterSaleOverall.rating }}★</div>
        <div class="stat-label">总体评价星级</div>
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
import { ref, reactive, onMounted, nextTick, computed } from 'vue'
import * as echarts from 'echarts'
import request from '@/utils/request'

const refreshing = ref(false)
const overview = reactive({ totalSales: '0', totalOrders: 0, totalUsers: 0, individualMerchants: 0, enterpriseMerchants: 0, totalMerchants: 0, avgOrderValue: '0' })
const merchantTrend = ref<any[]>([])
const merchantTiers = reactive({ micro: 0, tail: 0, waist: 0, head: 0 })
const commission = reactive<Record<string, any>>({ month: {}, quarter: {}, year: {} })
const activePeriod = ref('month')
const curCommission = computed(() => commission[activePeriod.value] || { commission: '0', subsidy: '0', netIncome: '0' })
const curGrowth = computed(() => ({
  prevGrowth: commission[activePeriod.value]?.prevGrowth || '暂无数据',
  yoyGrowth: commission[activePeriod.value]?.yoyGrowth || '暂无数据'
}))
const categoryProportion = ref<any[]>([])

const asChartRef = ref<HTMLElement | null>(null)
let asChartInstance: echarts.ECharts | null = null

const afterSaleOverall = reactive({ rate: '0%', rating: '0.0' })
const asData = reactive({ monthly: [] as any[], currentRate: '0%', prevRate: '暂无数据', growth: '0%', currentMonth: '' })

const asGrowthClass = computed(() => {
  const g = asData.growth
  if (!g || g === '暂无数据' || g === '0%') return 'growth-na'
  if (g === '新增' || g.startsWith('-')) return 'growth-down'
  return 'growth-up'
})

// 月度排行数据
const monthRankData = ref<any>({ months: [], monthRankList: [] })
const activeMonth = ref('')
const availableMonths = ref<string[]>([])

const trendChartRef = ref<HTMLElement | null>(null)
const tiersChartRef = ref<HTMLElement | null>(null)
const catChartRef = ref<HTMLElement | null>(null)
const rankChartRef = ref<HTMLElement | null>(null)
let trendChart: echarts.ECharts | null = null
let tiersChart: echarts.ECharts | null = null
let catChart: echarts.ECharts | null = null
let rankChart: echarts.ECharts | null = null

const fmt = (v: any) => (Number(v) || 0).toFixed(2)

const formatGrowth = (v: string) => {
  if (!v || v === '暂无数据') return '暂无数据'
  if (v === '新增') return '新增'
  const num = parseFloat(v)
  if (isNaN(num)) return v
  return (num >= 0 ? '↑' : '↓') + Math.abs(num).toFixed(2) + '%'
}

const growthClass = (v: string) => {
  if (!v || v === '暂无数据') return 'growth-na'
  if (v === '新增') return 'growth-up'
  const num = parseFloat(v)
  if (isNaN(num)) return 'growth-na'
  return num >= 0 ? 'growth-up' : 'growth-down'
}

const formatMonthLabel = (m: string) => {
  const parts = m.split('-')
  if (parts.length === 2) return `${parseInt(parts[1])}月`
  return m
}

const switchMonth = (m: string) => {
  activeMonth.value = m
  renderRankChart()
}

const fetchAll = async () => {
  refreshing.value = true
  try {
    const [ov, mr, mt, tr, cm, cp, ar, mrt] = await Promise.all([
      request.get('/admin/dashboard/overview'),
      request.get('/admin/dashboard/merchant-rank'),
      request.get('/admin/dashboard/merchant-trend'),
      request.get('/admin/dashboard/merchant-tiers'),
      request.get('/admin/dashboard/commission'),
      request.get('/admin/dashboard/category-proportion'),
      request.get('/admin/dashboard/after-sale-rate'),
      request.get('/admin/dashboard/merchant-rating')
    ])
    if (ov.code === 0) Object.assign(overview, ov.data)
    if (mr.code === 0) {
      monthRankData.value = mr.data
      availableMonths.value = mr.data.months || []
      if (availableMonths.value.length > 0 && !activeMonth.value) {
        activeMonth.value = availableMonths.value[0]
      }
    }
    if (mt.code === 0) merchantTrend.value = mt.data || []
    if (tr.code === 0) Object.assign(merchantTiers, tr.data)
    if (cm.code === 0) {
      commission.month = cm.data.month || {}
      commission.quarter = cm.data.quarter || {}
      commission.year = cm.data.year || {}
    }
    if (cp.code === 0) categoryProportion.value = cp.data || []
    if (ar.code === 0) {
      Object.assign(asData, ar.data)
      nextTick(() => renderAsChart())
    }
    if (mrt.code === 0) afterSaleOverall.rating = (mrt.data.overallRating || 0).toFixed(1)
  } catch { /* */ }
  refreshing.value = false
  await nextTick()
  renderCharts()
}

const getCurrentMonthRank = () => {
  const list = monthRankData.value.monthRankList || []
  const found = list.find((m: any) => m.month === activeMonth.value)
  return found ? (found.rankList || []) : []
}

const renderCharts = () => {
  renderRankChart()
  // 入驻趋势折线图
  if (trendChartRef.value && merchantTrend.value.length > 0) {
    if (!trendChart) trendChart = echarts.init(trendChartRef.value)
    trendChart.setOption({
      tooltip: { trigger: 'axis' },
      grid: { left: 40, right: 10, top: 10, bottom: 50 },
      xAxis: { type: 'category', data: merchantTrend.value.map(d => d.month), axisLabel: { rotate: 45, fontSize: 10 } },
      yAxis: { type: 'value', name: '商家数', minInterval: 1 },
      series: [{ type: 'line', data: merchantTrend.value.map(d => d.count), color: '#409EFF', smooth: true, areaStyle: { color: 'rgba(64,158,255,0.15)' } }]
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
          { name: '头部商家(>10万)', value: merchantTiers.head },
          { name: '腰部商家(1万~10万)', value: merchantTiers.waist },
          { name: '尾部商家(1千~1万)', value: merchantTiers.tail },
          { name: '小微商家(试运营期)', value: merchantTiers.micro }
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

const renderRankChart = () => {
  const rankList = getCurrentMonthRank()
  if (!rankChartRef.value || rankList.length === 0) return
  if (!rankChart) rankChart = echarts.init(rankChartRef.value)

  // 横向条形图，数据倒序（第一名在上），统一单色
  const names = rankList.slice().reverse().map((r: any) => r.merchantName)
  const values = rankList.slice().reverse().map((r: any) => Number(r.totalSales) || 0)
  const barColor = '#7C9CBF'

  rankChart.setOption({
    tooltip: {
      trigger: 'axis',
      axisPointer: { type: 'shadow' },
      formatter: (params: any) => {
        const p = params[0]
        return `${p.name}<br/>销售额: ¥${p.value.toFixed(2)}`
      }
    },
    grid: { left: 100, right: 60, top: 10, bottom: 20 },
    xAxis: {
      type: 'value',
      name: '销售额(¥)',
      axisLabel: {
        formatter: (v: number) => '¥' + (v >= 10000 ? (v / 10000).toFixed(1) + '万' : v.toFixed(0))
      }
    },
    yAxis: {
      type: 'category',
      data: names,
      axisLabel: { fontSize: 13, fontWeight: 'bold', color: '#606266' },
      axisLine: { show: false },
      axisTick: { show: false }
    },
    series: [{
      type: 'bar',
      data: values.map((v: number) => ({
        value: v,
        itemStyle: {
          color: barColor,
          borderRadius: [0, 4, 4, 0]
        }
      })),
      barWidth: 24,
      label: {
        show: true,
        position: 'right',
        fontSize: 12,
        color: '#909399',
        formatter: (p: any) => '¥' + p.value.toFixed(2)
      },
      emphasis: {
        itemStyle: { color: '#5A7FA0' }
      }
    }]
  }, true)
}

const renderAsChart = () => {
  if (!asChartRef.value || !asData.monthly.length) return
  if (!asChartInstance) asChartInstance = echarts.init(asChartRef.value)
  const months = asData.monthly.map((m: any) => m.month)
  const rates = asData.monthly.map((m: any) => parseFloat(m.rate) || 0)
  asChartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      formatter: (p: any) => `${p[0].name}<br/>售后申请率: ${p[0].value}%`
    },
    grid: { left: 50, right: 30, top: 20, bottom: 30 },
    xAxis: {
      type: 'category',
      data: months,
      axisLabel: { fontSize: 12, color: '#909399' }
    },
    yAxis: {
      type: 'value',
      name: '%',
      min: 0,
      axisLabel: { fontSize: 12, color: '#909399' }
    },
    series: [{
      type: 'line',
      data: rates,
      smooth: true,
      lineStyle: { color: '#B8860B', width: 2 },
      itemStyle: { color: '#B8860B' },
      areaStyle: { color: 'rgba(184,134,11,0.08)' },
      symbolSize: 6
    }]
  }, true)
}


const refresh = () => fetchAll()

onMounted(() => {
  fetchAll()
  window.addEventListener('resize', () => {
    trendChart?.resize()
    tiersChart?.resize()
    catChart?.resize()
    rankChart?.resize()
    asChartInstance?.resize()
  })
})
</script>

<style scoped>
.dashboard-page { padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h1 { margin: 0; font-size: 20px; color: #303133; }
.refresh-btn {
  padding: 6px 18px;
  background: #7C9CBF;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}
.refresh-btn:hover { background: #5A7FA0; }
.refresh-btn:disabled { opacity: 0.6; cursor: not-allowed; }
.stats-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 14px; margin-bottom: 24px; }
.stat-card { background: #fff; border-radius: 8px; padding: 16px 20px; text-align: center; border-top: 3px solid #A0B4C8; }
.stat-val { font-size: 24px; font-weight: 700; margin-bottom: 4px; color: #303133; }
.stat-label { color: #909399; font-size: 13px; }
.stat-sub { font-size: 11px; color: #b0b3bb; margin-top: 2px; }
.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px; }
.chart-box { background: #fff; border-radius: 8px; padding: 18px; min-height: 300px; }
.chart-box h3 { margin: 0 0 12px; font-size: 15px; color: #606266; }
.line-chart, .pie-chart { width: 100%; height: 300px; }
.bar-chart { width: 100%; height: 350px; }
.chart-title-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.chart-title-row h3 { margin: 0; }
.month-tabs { display: flex; gap: 6px; }
.month-tab {
  padding: 4px 14px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  background: #fff;
  font-size: 13px;
  color: #606266;
  cursor: pointer;
  transition: all 0.2s;
}
.month-tab:hover { border-color: #7C9CBF; color: #7C9CBF; }
.month-tab.active { background: #7C9CBF; color: #fff; border-color: #7C9CBF; }
.sort-btn {
  padding: 4px 14px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  background: #fff;
  font-size: 13px;
  color: #606266;
  cursor: pointer;
  transition: all 0.2s;
}
.sort-btn:hover { border-color: #7C9CBF; color: #7C9CBF; }
.stat-overall { font-size: 13px; color: #909399; margin-bottom: 8px; }
.commission-cards { display: flex; gap: 12px; justify-content: center; margin-top: 20px; }
.comm-card { flex: 1; text-align: center; padding: 20px 12px; border-radius: 8px; background: #fff; border-top: 3px solid #C0C0C0; }
.comm-val { font-size: 22px; font-weight: 700; color: #303133; }
.comm-label { font-size: 13px; margin-top: 4px; color: #909399; }
.comm-growth { display: flex; justify-content: center; align-items: center; gap: 4px; margin-top: 6px; font-size: 12px; }
.growth-label { color: #909399; }
.growth-up { color: #52C41A; font-weight: 600; }
.growth-down { color: #FF4D4F; font-weight: 600; }
.growth-na { color: #C0C4CC; }
.as-chart { width: 100%; height: 260px; margin-bottom: 8px; }
.as-compare { display: flex; justify-content: center; align-items: center; gap: 12px; font-size: 13px; color: #606266; padding: 8px 0; border-top: 1px solid #ebeef5; }
.as-compare b { font-weight: 600; }
.as-compare-sep { color: #DCDFE6; }
</style>
