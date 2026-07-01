<template>
  <div class="dashboard-page">
    <div class="page-header">
      <h1>运营看板</h1>
      <div class="header-date">{{ currentDate }}</div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">📊</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalOrders }}</div>
          <div class="stat-label">总订单数</div>
        </div>
        <div class="stat-trend up">↑ 12.5%</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">💰</div>
        <div class="stat-info">
          <div class="stat-value">¥{{ stats.totalGMV.toFixed(2) }}</div>
          <div class="stat-label">总GMV</div>
        </div>
        <div class="stat-trend up">↑ 8.3%</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">👥</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalUsers }}</div>
          <div class="stat-label">总用户数</div>
        </div>
        <div class="stat-trend up">↑ 5.2%</div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">🏪</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.activeMerchants }}</div>
          <div class="stat-label">活跃商家</div>
        </div>
        <div class="stat-trend down">↓ 2.1%</div>
      </div>
    </div>

    <div class="content-grid">
      <div class="chart-card">
        <div class="card-header">
          <h3>订单趋势</h3>
          <select v-model="timeRange" class="range-select">
            <option value="7">近7天</option>
            <option value="30">近30天</option>
          </select>
        </div>
        <div class="chart-content">
          <div class="bar-chart">
            <div v-for="(item, index) in orderTrend" :key="index" class="bar-item">
              <div class="bar-wrapper">
                <div class="bar" :style="{ height: (item.count / maxOrderCount * 100) + '%' }"></div>
              </div>
              <div class="bar-label">{{ item.date }}</div>
            </div>
          </div>
        </div>
      </div>

      <div class="chart-card">
        <div class="card-header">
          <h3>商品分类销售</h3>
        </div>
        <div class="chart-content">
          <div class="pie-chart">
            <div v-for="(item, index) in categorySales" :key="index" class="pie-item">
              <div class="pie-dot" :style="{ background: item.color }"></div>
              <div class="pie-info">
                <span class="pie-name">{{ item.name }}</span>
                <span class="pie-value">{{ item.value }}%</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="content-grid">
      <div class="table-card">
        <div class="card-header">
          <h3>今日订单</h3>
        </div>
        <div class="table-content">
          <table class="data-table">
            <thead>
              <tr>
                <th>订单号</th>
                <th>用户</th>
                <th>商家</th>
                <th>金额</th>
                <th>状态</th>
                <th>时间</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="order in todayOrders" :key="order.orderId">
                <td>{{ order.orderSn }}</td>
                <td>{{ order.userName }}</td>
                <td>{{ order.merchantName }}</td>
                <td>¥{{ order.amount.toFixed(2) }}</td>
                <td><span :class="['status-tag', order.status]">{{ getStatusText(order.status) }}</span></td>
                <td>{{ order.createTime }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="table-card">
        <div class="card-header">
          <h3>待审核商家</h3>
        </div>
        <div class="table-content">
          <table class="data-table">
            <thead>
              <tr>
                <th>商家名称</th>
                <th>联系人</th>
                <th>手机号</th>
                <th>申请时间</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="merchant in pendingMerchants" :key="merchant.id">
                <td>{{ merchant.name }}</td>
                <td>{{ merchant.contact }}</td>
                <td>{{ merchant.phone }}</td>
                <td>{{ merchant.applyTime }}</td>
                <td><span class="status-tag WAIT_AUDIT">待审核</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getDashboardData } from '@/api/dashboard'

const currentDate = ref(new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' }))
const timeRange = ref('7')

const stats = ref({
  totalOrders: 0,
  totalGMV: 0,
  totalUsers: 0,
  activeMerchants: 0
})

const orderTrend = ref<any[]>([])

const maxOrderCount = computed(() => {
  if (orderTrend.value.length === 0) return 1
  return Math.max(...orderTrend.value.map(o => o.count))
})

const categorySales = ref<any[]>([])

const todayOrders = ref<any[]>([])

const pendingMerchants = ref<any[]>([])

const getStatusText = (status: string) => {
  const map: Record<string, string> = {
    WAIT_PAY: '待支付',
    WAIT_SHIP: '待发货',
    SHIPPING: '配送中',
    WAIT_PICKUP: '待自提',
    COMPLETED: '已完成'
  }
  return map[status] || status
}

const loadDashboard = async () => {
  const res = await getDashboardData()
  if (res.code === 0) {
    const data = res.data
    stats.value = data.stats || stats.value
    orderTrend.value = data.orderTrend || orderTrend.value
    categorySales.value = data.categorySales || categorySales.value
    todayOrders.value = data.todayOrders || todayOrders.value
    pendingMerchants.value = data.pendingMerchants || pendingMerchants.value
  }
}

onMounted(() => {
  loadDashboard()
})
</script>

<style scoped>
.dashboard-page {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 22px;
  color: #1D2129;
}

.header-date {
  font-size: 14px;
  color: #86909C;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.stat-icon {
  font-size: 32px;
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F2F3F5;
  border-radius: 8px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #1D2129;
}

.stat-label {
  font-size: 12px;
  color: #86909C;
  margin-top: 4px;
}

.stat-trend {
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 4px;
}

.stat-trend.up {
  background: #F6FFED;
  color: #52C41A;
}

.stat-trend.down {
  background: #FFF2F0;
  color: #FF4D4F;
}

.content-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.chart-card, .table-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.card-header h3 {
  font-size: 16px;
  color: #1D2129;
  margin: 0;
}

.range-select {
  padding: 4px 8px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 12px;
}

.chart-content {
  padding-top: 10px;
}

.bar-chart {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 200px;
  padding-bottom: 10px;
}

.bar-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
}

.bar-wrapper {
  width: 30px;
  height: 180px;
  background: #F2F3F5;
  border-radius: 4px;
  display: flex;
  align-items: flex-end;
}

.bar {
  width: 100%;
  background: #165DFF;
  border-radius: 4px;
  transition: height 0.3s ease;
}

.bar-label {
  font-size: 11px;
  color: #86909C;
  margin-top: 8px;
}

.pie-chart {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.pie-item {
  display: flex;
  align-items: center;
  gap: 10px;
}

.pie-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.pie-info {
  flex: 1;
  display: flex;
  justify-content: space-between;
}

.pie-name {
  font-size: 14px;
  color: #1D2129;
}

.pie-value {
  font-size: 14px;
  color: #86909C;
}

.table-content {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th, .data-table td {
  padding: 10px 12px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
  font-size: 13px;
}

.data-table th {
  background: #F2F3F5;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  color: #1D2129;
}

.status-tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.WAIT_PAY { background: #FFF7E6; color: #E67E22; }
.status-tag.WAIT_SHIP { background: #E6F7FF; color: #1890FF; }
.status-tag.SHIPPING { background: #E6F7FF; color: #1890FF; }
.status-tag.WAIT_PICKUP { background: #FFF7E6; color: #E67E22; }
.status-tag.COMPLETED { background: #F6FFED; color: #52C41A; }
.status-tag.WAIT_AUDIT { background: #FFF7E6; color: #E67E22; }
</style>