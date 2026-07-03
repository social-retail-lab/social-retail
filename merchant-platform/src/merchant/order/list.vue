<template>
  <div class="order-page">
    <div class="page-header">
      <h1>订单管理</h1>
      <div class="header-right">
        <input v-model="searchKeyword" placeholder="搜索订单号/手机号" class="search-input" />
        <button @click="search" class="search-btn">搜索</button>
      </div>
    </div>

    <div class="tabs">
      <button 
        v-for="tab in tabs" 
        :key="tab.value" 
        :class="['tab-btn', { active: activeTab === tab.value }]"
        @click="activeTab = tab.value"
      >
        {{ tab.label }}
      </button>
    </div>

    <div class="order-list">
      <div v-for="order in orderList" :key="order.orderId" class="order-card">
        <div class="order-header">
          <div class="order-info">
            <span class="order-sn">订单号: {{ order.orderSn }}</span>
            <span :class="['status-tag', getStatusClass(order.status)]">{{ order.statusText }}</span>
          </div>
          <span class="order-time">{{ order.createTime }}</span>
        </div>

        <div class="order-items">
          <div v-for="item in order.orderItems" :key="item.id" class="order-item">
            <img :src="item.productImage || 'https://via.placeholder.com/80'" class="product-image" />
            <div class="product-info">
              <div class="product-name">{{ item.productName }}</div>
              <div class="product-spec">{{ item.skuSpecs }}</div>
              <div class="product-price">
                <span class="price">¥{{ (item.price || 0).toFixed(2) }}</span>
                <span class="quantity">x{{ item.quantity }}</span>
              </div>
            </div>
          </div>
        </div>

        <div class="order-footer">
          <div class="order-total">
            共{{ order.itemCount || 0 }}件商品，合计: <span class="total-price">¥{{ (order.payAmount || 0).toFixed(2) }}</span>
            <span class="delivery-type">{{ order.deliveryTypeText }}</span>
          </div>
          <div class="order-actions">
            <button v-if="order.status === 1" class="action-btn primary" @click="handleAcceptOrder(order)">接单</button>
            <button v-if="order.status === 2" class="action-btn primary" @click="handlePrepareOrder(order)">备货</button>
            <button v-if="order.status === 3 && order.deliveryType === 1" class="action-btn info" @click="viewDelivery(order)">查看配送</button>
            <button v-if="order.status === 3 && order.deliveryType === 2" class="action-btn primary" @click="handleConfirmPickup(order)">确认自提</button>
            <button v-if="order.status === 4" class="action-btn success" @click="viewDetail(order)">查看详情</button>
            <button v-if="order.status === 1" class="action-btn cancel" @click="handleCancelOrder(order)">取消订单</button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="orderList.length === 0" class="empty-state">
      <div class="empty-icon">📦</div>
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
import { getOrderList, getOrderDetail, acceptOrder, prepareOrder, cancelOrder as cancelOrderApi, confirmPickupCode } from '@/api/order'

interface OrderItem {
  id: number
  skuId: number
  productName: string
  productImage: string
  skuSpecs: string
  price: number
  quantity: number
}

interface Order {
  orderId: number
  orderSn: string
  totalAmount: number
  payAmount: number
  deliveryType: number
  deliveryTypeText: string
  status: number
  statusText: string
  itemCount: number
  buyerNickname: string
  buyerPhone: string
  pickupPointName: string
  createTime: string
  orderItems: OrderItem[]
}

const activeTab = ref('ALL')
const searchKeyword = ref('')
const currentPage = ref(1)
const totalPages = ref(1)
const totalCount = ref(0)
const pageSize = ref(10)

const tabs = [
  { label: '全部', value: 'ALL', status: undefined, deliveryType: undefined },
  { label: '待接单', value: 'WAIT_ACCEPT', status: 1, deliveryType: undefined },
  { label: '已接单', value: 'ACCEPTED', status: 2, deliveryType: undefined },
  { label: '配送中', value: 'SHIPPING', status: 3, deliveryType: 1 },
  { label: '待自提', value: 'WAIT_PICKUP', status: 3, deliveryType: 2 },
  { label: '已完成', value: 'COMPLETED', status: 4, deliveryType: undefined },
  { label: '已取消', value: 'CANCELLED', status: 5, deliveryType: undefined }
]

const orderList = ref<Order[]>([])

const getStatusClass = (status: number) => {
  if (status === 1) return 'WAIT_ACCEPT'
  if (status === 2) return 'ACCEPTED'
  if (status === 3) return 'SHIPPING'
  if (status === 4) return 'COMPLETED'
  if (status === 5) return 'CANCELLED'
  return ''
}

const loadData = async () => {
  const tab = tabs.find(t => t.value === activeTab.value)
  const params: any = {
    pageNum: currentPage.value,
    pageSize: pageSize.value
  }
  if (tab && tab.status !== undefined) {
    params.status = tab.status
  }
  if (tab && tab.deliveryType !== undefined) {
    params.deliveryType = tab.deliveryType
  }
  if (searchKeyword.value) {
    params.orderSn = searchKeyword.value
  }
  try {
    const res = await getOrderList(params)
    console.log('[订单列表] 原始响应:', JSON.stringify(res))
    if (res.code === 0) {
      const list = res.data?.list || res.data?.records || (Array.isArray(res.data) ? res.data : [])
      console.log('[订单列表] 解析后 list count=', list.length, 'total=', res.data?.total)
      orderList.value = list
      totalCount.value = res.data?.total || list.length
      totalPages.value = Math.max(1, Math.ceil(totalCount.value / pageSize.value))
    } else {
      console.error('[订单列表] 接口错误:', res.code, res.message)
      alert('获取订单列表失败: ' + (res.message || '未知错误'))
    }
  } catch (e: any) {
    console.error('[订单列表] 请求异常:', e.message || e)
  }
}

const search = () => {
  currentPage.value = 1
  loadData()
}

const handleAcceptOrder = async (order: Order) => {
  if (confirm(`确认接单订单 ${order.orderSn} 吗？`)) {
    const res = await acceptOrder(order.orderId)
    if (res.code === 0) {
      alert(`订单 ${order.orderSn} 已接单`)
      loadData()
    }
  }
}

const handlePrepareOrder = async (order: Order) => {
  if (confirm(`确认开始备货订单 ${order.orderSn} 吗？`)) {
    const res = await prepareOrder(order.orderId)
    if (res.code === 0) {
      if (order.deliveryType === 2) {
        alert(`订单 ${order.orderSn} 已生成取货码`)
      } else {
        alert(`订单 ${order.orderSn} 已创建配送单`)
      }
      loadData()
    }
  }
}

const viewDelivery = async (order: Order) => {
  const res = await getOrderDetail(order.orderId)
  if (res.code === 0) {
    const data = res.data
    alert(`订单 ${order.orderSn} 配送信息：\n骑手：${data.riderName || '待分配'}\n电话：${data.riderPhone || '-'}\n状态：${data.deliveryStatus || '配送中'}`)
  }
}

const viewDetail = async (order: Order) => {
  const res = await getOrderDetail(order.orderId)
  if (res.code === 0) {
    const data = res.data
    alert(`订单详情：\n订单号：${data.orderSn}\n金额：¥${data.payAmount}\n状态：${data.statusText}`)
  }
}

const handleConfirmPickup = async (order: Order) => {
  const pickupCode = prompt(`请输入订单 ${order.orderSn} 的自提码（6位数字，万能测试码：111111）：`)
  if (!pickupCode) return
  if (!/^\d{6}$/.test(pickupCode)) {
    alert('请输入6位数字自提码')
    return
  }
  const res = await confirmPickupCode(order.orderId, pickupCode)
  if (res.code === 0) {
    alert(`订单 ${order.orderSn} 已完成自提`)
    loadData()
  } else {
    alert(res.message || '自提码验证失败')
  }
}

const handleCancelOrder = async (order: Order) => {
  const reason = prompt('请输入取消原因：')
  if (reason) {
    const res = await cancelOrderApi(order.orderId, reason)
    if (res.code === 0) {
      alert(`订单 ${order.orderSn} 已取消，原因：${reason}`)
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
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 22px;
  color: #2D2D2D;
}

.header-right {
  display: flex;
  gap: 10px;
}

.search-input {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  width: 250px;
  font-size: 14px;
}

.search-btn {
  padding: 8px 20px;
  background: #E66100;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.tab-btn {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  background: white;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  color: #595959;
  display: flex;
  align-items: center;
  gap: 4px;
}

.tab-btn.active {
  background: #E66100;
  color: white;
  border-color: #E66100;
}

.badge {
  background: #FF4D4F;
  color: white;
  font-size: 12px;
  padding: 1px 6px;
  border-radius: 10px;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.order-card {
  background: white;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.order-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.order-sn {
  font-size: 14px;
  color: #2D2D2D;
}

.status-tag {
  font-size: 12px;
  padding: 3px 8px;
  border-radius: 4px;
}

.status-tag.WAIT_ACCEPT { background: #FFF7E6; color: #E67E22; }
.status-tag.ACCEPTED { background: #E6F7FF; color: #1890FF; }
.status-tag.SHIPPING { background: #F6FFED; color: #52C41A; }
.status-tag.COMPLETED { background: #F6FFED; color: #52C41A; }
.status-tag.CANCELLED { background: #F5F5F5; color: #999; }

.order-time {
  font-size: 12px;
  color: #8C8C8C;
}

.order-items {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.order-item {
  display: flex;
  gap: 12px;
}

.product-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.product-name {
  font-size: 14px;
  color: #2D2D2D;
}

.product-spec {
  font-size: 12px;
  color: #8C8C8C;
}

.product-price {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price {
  color: #E66100;
  font-weight: bold;
}

.quantity {
  font-size: 12px;
  color: #8C8C8C;
}

.order-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}

.order-total {
  font-size: 14px;
  color: #595959;
  display: flex;
  align-items: center;
  gap: 12px;
}

.total-price {
  color: #E66100;
  font-weight: bold;
  font-size: 16px;
}

.delivery-type {
  font-size: 12px;
  color: #86909C;
  padding: 2px 8px;
  background: #F2F3F5;
  border-radius: 4px;
}

.order-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 6px 14px;
  border: none;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}

.action-btn.primary {
  background: #E66100;
  color: white;
}

.action-btn.cancel {
  background: #F5F5F5;
  color: #595959;
}

.action-btn.info {
  background: #1890FF;
  color: white;
}

.action-btn.success {
  background: #52C41A;
  color: white;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 14px;
  color: #8C8C8C;
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
  color: #595959;
}
</style>