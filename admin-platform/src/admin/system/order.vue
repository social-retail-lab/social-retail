<template>
  <div class="order-page">
    <div class="page-header">
      <h1>订单管理</h1>
      <div class="header-right">
        <input v-model="searchKeyword" placeholder="搜索订单号/手机号" class="search-input" />
        <select v-model="statusFilter" class="filter-select">
          <option value="ALL">全部状态</option>
          <option value="WAIT_PAY">待支付</option>
          <option value="WAIT_SHIP">待发货</option>
          <option value="SHIPPING">配送中</option>
          <option value="COMPLETED">已完成</option>
          <option value="CANCELLED">已取消</option>
          <option value="REFUNDING">退款中</option>
        </select>
        <button @click="search" class="search-btn">搜索</button>
        <button @click="exportOrders" class="export-btn">导出订单</button>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-value">{{ stats.totalOrders }}</div>
        <div class="stat-label">总订单数</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">¥{{ stats.totalGMV.toFixed(2) }}</div>
        <div class="stat-label">总GMV</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.todayOrders }}</div>
        <div class="stat-label">今日订单</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.refundRate }}%</div>
        <div class="stat-label">退款率</div>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>订单号</th>
            <th>用户信息</th>
            <th>商家名称</th>
            <th>商品数量</th>
            <th>订单金额</th>
            <th>配送方式</th>
            <th>订单状态</th>
            <th>下单时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="order in orderList" :key="order.orderId">
            <td>{{ order.orderSn }}</td>
            <td>
              <div>{{ order.userName }}</div>
              <div class="text-sm">{{ order.userPhone }}</div>
            </td>
            <td>{{ order.merchantName }}</td>
            <td>{{ order.totalQuantity }}件</td>
            <td>¥{{ order.payAmount.toFixed(2) }}</td>
            <td><span :class="['type-tag', order.deliveryType]">{{ order.deliveryType === 'DELIVERY' ? '同城配送' : '门店自提' }}</span></td>
            <td><span :class="['status-tag', order.status]">{{ getStatusText(order.status) }}</span></td>
            <td>{{ order.createTime }}</td>
            <td class="actions">
              <button class="action-btn view" @click="viewDetail(order)">查看详情</button>
              <button v-if="order.status === 'REFUNDING'" class="action-btn warn" @click="handleRefundOrder(order)">处理退款</button>
              <button v-if="order.status === 'WAIT_PAY'" class="action-btn cancel" @click="closeOrder(order)">关闭订单</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="orderList.length === 0" class="empty-state">
      <div class="empty-icon">📋</div>
      <div class="empty-text">暂无订单</div>
    </div>

    <div class="pagination">
      <button :disabled="currentPage <= 1" @click="currentPage--" class="page-btn">上一页</button>
      <span class="page-info">第{{ currentPage }}页 / 共{{ totalPages }}页</span>
      <button :disabled="currentPage >= totalPages" @click="currentPage++" class="page-btn">下一页</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getOrderList, getOrderDetail, handleRefund, closeOrder as closeOrderApi } from '@/api/system'

interface Order {
  orderId: number
  orderSn: string
  userName: string
  userPhone: string
  merchantName: string
  totalQuantity: number
  payAmount: number
  deliveryType: string
  status: string
  createTime: string
}

const searchKeyword = ref('')
const statusFilter = ref('ALL')
const currentPage = ref(1)
const totalPages = ref(1)
const totalCount = ref(0)
const pageSize = ref(10)

const stats = ref({
  totalOrders: 0,
  totalGMV: 0,
  todayOrders: 0,
  refundRate: 0
})

const orderList = ref<Order[]>([])

const getStatusText = (status: string) => {
  const map: Record<string, string> = {
    WAIT_PAY: '待支付',
    WAIT_SHIP: '待发货',
    PREPARING: '备货中',
    SHIPPING: '配送中',
    WAIT_PICKUP: '待自提',
    COMPLETED: '已完成',
    CANCELLED: '已取消',
    REFUNDING: '退款中'
  }
  return map[status] || status
}

const loadData = async () => {
  const params: any = {
    page: currentPage.value,
    pageSize: pageSize.value
  }
  if (searchKeyword.value) {
    params.keyword = searchKeyword.value
  }
  if (statusFilter.value !== 'ALL') {
    params.status = statusFilter.value
  }
  const res = await getOrderList(params)
  if (res.code === 0) {
    orderList.value = res.data.list || res.data || []
    totalCount.value = res.data.total || orderList.value.length
    totalPages.value = Math.ceil(totalCount.value / pageSize.value)
  }
}

const search = () => {
  currentPage.value = 1
  loadData()
}

const exportOrders = () => {
  alert('订单导出功能开发中...')
}

const viewDetail = async (order: Order) => {
  const res = await getOrderDetail(order.orderId)
  if (res.code === 0) {
    const data = res.data
    alert(`订单详情：\n订单号：${data.orderSn}\n用户：${data.userName}\n商家：${data.merchantName}\n金额：¥${data.payAmount}\n状态：${getStatusText(data.status)}`)
  }
}

const handleRefundOrder = async (order: Order) => {
  if (confirm(`确认处理订单 ${order.orderSn} 的退款申请吗？`)) {
    const res = await handleRefund(order.orderId, { refundAmount: order.payAmount })
    if (res.code === 0) {
      alert(`订单 ${order.orderSn} 退款已处理`)
      loadData()
    }
  }
}

const closeOrder = async (order: Order) => {
  if (confirm(`确定关闭订单 ${order.orderSn} 吗？`)) {
    const res = await closeOrderApi(order.orderId, { reason: '用户取消' })
    if (res.code === 0) {
      alert(`订单 ${order.orderSn} 已关闭`)
      loadData()
    }
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.order-page {
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

.header-right {
  display: flex;
  gap: 10px;
  align-items: center;
}

.search-input {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  width: 200px;
  font-size: 14px;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.search-btn {
  padding: 8px 20px;
  background: #165DFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.export-btn {
  padding: 8px 20px;
  background: #6B7280;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.stats-row {
  display: flex;
  gap: 16px;
  margin-bottom: 20px;
}

.stat-card {
  flex: 1;
  background: white;
  padding: 16px;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #165DFF;
}

.stat-label {
  font-size: 12px;
  color: #86909C;
  margin-top: 4px;
}

.table-container {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th, .data-table td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
}

.data-table th {
  background: #F2F3F5;
  font-size: 14px;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  font-size: 14px;
  color: #1D2129;
}

.text-sm {
  font-size: 12px;
  color: #86909C;
}

.type-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.type-tag.DELIVERY { background: #E6F7FF; color: #1890FF; }
.type-tag.PICKUP { background: #FFF7E6; color: #E67E22; }

.status-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.WAIT_PAY { background: #FFF7E6; color: #E67E22; }
.status-tag.WAIT_SHIP { background: #E6F7FF; color: #1890FF; }
.status-tag.PREPARING { background: #F6FFED; color: #52C41A; }
.status-tag.SHIPPING { background: #E6F7FF; color: #1890FF; }
.status-tag.WAIT_PICKUP { background: #FFF7E6; color: #E67E22; }
.status-tag.COMPLETED { background: #F6FFED; color: #52C41A; }
.status-tag.CANCELLED { background: #F5F5F5; color: #86909C; }
.status-tag.REFUNDING { background: #FFF2F0; color: #FF4D4F; }

.actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 4px 10px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.action-btn.view {
  background: #F2F3F5;
  color: #4E5969;
}

.action-btn.warn {
  background: #FFF2F0;
  color: #FF4D4F;
}

.action-btn.cancel {
  background: #F5F5F5;
  color: #86909C;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  background: white;
  border-radius: 8px;
  margin-top: 20px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 14px;
  color: #86909C;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 30px;
}

.page-btn {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #4E5969;
}
</style>