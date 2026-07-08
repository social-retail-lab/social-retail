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
        <!-- 收缩状态：一行显示 -->
        <div class="order-collapsed" @click="toggleExpand(order.orderId)">
          <span class="col-sn">{{ order.orderSn }}</span>
          <span :class="['col-status', 'status-tag', getStatusClass(order.status)]">{{ order.statusText || getStatusText(order.status, order.deliveryType) }}</span>
          <span class="col-amount">¥{{ (order.payAmount || 0).toFixed(2) }}</span>
          <span class="col-time">{{ order.createTime }}</span>
          <span class="col-expand">{{ expandedOrders[order.orderId] ? '▲' : '▼' }}</span>
        </div>

        <!-- 展开状态：完整卡片 -->
        <div v-if="expandedOrders[order.orderId]" class="order-expanded">
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
              <button v-if="order.status === 1" class="action-btn cancel" @click="handleCancelOrder(order)">取消订单</button>
              <button class="action-btn detail" @click="openDetail(order)">查看详情</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="orderList.length === 0 && !loading" class="empty-state">
      <div class="empty-text">暂无订单</div>
    </div>

    <!-- 订单详情弹窗 -->
    <div v-if="showDetail" class="modal-mask" @click.self="showDetail = false">
      <div class="modal-box">
        <div class="modal-header">
          <h2>订单详情</h2>
          <button class="close-btn" @click="showDetail = false">×</button>
        </div>
        <div v-if="detailLoading" class="modal-loading">加载中...</div>
        <div v-else-if="detailData">
          <div class="detail-section">
            <h3>订单信息</h3>
            <div class="detail-grid">
              <div class="detail-item"><span class="key">订单号：</span><span class="val">{{ detailData.orderSn }}</span></div>
              <div class="detail-item"><span class="key">订单状态：</span><span :class="['status-tag', getStatusClass(detailData.status)]">{{ detailData.statusText || getStatusText(detailData.status, detailData.deliveryType) }}</span></div>
              <div class="detail-item"><span class="key">配送方式：</span><span class="val">{{ detailData.deliveryTypeText || (detailData.deliveryType === 1 ? '配送' : '自提') }}</span></div>
              <div class="detail-item"><span class="key">下单时间：</span><span class="val">{{ detailData.createTime }}</span></div>
              <div class="detail-item"><span class="key">支付金额：</span><span class="val price">¥{{ (detailData.payAmount || 0).toFixed(2) }}</span></div>
              <div class="detail-item"><span class="key">支付方式：</span><span class="val">{{ getPayMethodText(detailData.payMethod) }}</span></div>
            </div>
          </div>
          <div class="detail-section" v-if="detailData.orderItems && detailData.orderItems.length > 0">
            <h3>商品明细</h3>
            <div class="detail-items">
              <div v-for="item in detailData.orderItems" :key="item.id" class="detail-product">
                <img :src="item.productImage || 'https://via.placeholder.com/60'" class="dp-img" />
                <div class="dp-info">
                  <div class="dp-name">{{ item.productName }}</div>
                  <div class="dp-spec">{{ item.skuSpecs }}</div>
                </div>
                <div class="dp-right">
                  <span class="dp-price">¥{{ (item.price || 0).toFixed(2) }}</span>
                  <span class="dp-qty">x{{ item.quantity }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-else class="modal-loading">暂无数据</div>
      </div>
    </div>

    <div class="pagination">
      <button :disabled="currentPage <= 1" @click="currentPage--; loadData()" class="page-btn">上一页</button>
      <span class="page-info">第{{ currentPage }}页 / 共{{ totalPages }}页</span>
      <button :disabled="currentPage >= totalPages" @click="currentPage++; loadData()" class="page-btn">下一页</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
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
const loading = ref(false)
const expandedOrders = reactive<Record<number, boolean>>({})

const toggleExpand = (orderId: number) => {
  expandedOrders[orderId] = !expandedOrders[orderId]
}

const getStatusClass = (status: number) => {
  if (status === 0) return 'WAIT_PAY'
  if (status === 1) return 'WAIT_ACCEPT'
  if (status === 2) return 'ACCEPTED'
  if (status === 3) return 'IN_PROGRESS'
  if (status === 4) return 'COMPLETED'
  if (status === 5) return 'CANCELLED'
  if (status === 6) return 'CLOSED'
  return ''
}

const getStatusText = (status: number, deliveryType?: number) => {
  if (status === 0) return '待支付'
  if (status === 1) return '待商家接单'
  if (status === 2) return '商家已接单'
  if (status === 3) return deliveryType === 2 ? '待自提' : '配送中'
  if (status === 4) return '已完成'
  if (status === 5) return '已取消'
  if (status === 6) return '已关闭'
  return '未知'
}

const getPayMethodText = (payMethod: number) => {
  if (payMethod === 1) return '微信支付'
  if (payMethod === 2) return '支付宝'
  if (payMethod === 3) return '银行卡'
  if (payMethod === 0) return '未支付'
  return payMethod != null ? `方式${payMethod}` : '-'
}

const loadData = async () => {
  loading.value = true
  const tab = tabs.find(t => t.value === activeTab.value)
  const params: any = {
    pageNum: currentPage.value,
    pageSize: pageSize.value
  }
  if (tab && tab.status !== undefined) params.status = tab.status
  if (tab && tab.deliveryType !== undefined) params.deliveryType = tab.deliveryType
  if (searchKeyword.value) params.orderSn = searchKeyword.value
  try {
    const res = await getOrderList(params)
    if (res.code === 0) {
      const list = res.data?.list || res.data?.records || (Array.isArray(res.data) ? res.data : [])
      // 待接单(1)和待备货(2)置顶
      list.sort((a: any, b: any) => {
        const aPriority = (a.status === 1 || a.status === 2) ? 0 : 1
        const bPriority = (b.status === 1 || b.status === 2) ? 0 : 1
        if (aPriority !== bPriority) return aPriority - bPriority
        return 0
      })
      orderList.value = list
      // 待接单和待备货默认展开
      list.forEach((o: any) => {
        if (o.status === 1 || o.status === 2) {
          expandedOrders[o.orderId] = true
        }
      })
      totalCount.value = res.data?.total || list.length
      totalPages.value = Math.max(1, Math.ceil(totalCount.value / pageSize.value))
    } else {
      alert('获取订单列表失败: ' + (res.message || '未知错误'))
    }
  } catch (e: any) {
    console.error('[订单列表] 请求异常:', e.message || e)
  } finally {
    loading.value = false
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

const showDetail = ref(false)
const detailLoading = ref(false)
const detailData = ref<any>(null)

const openDetail = async (order: Order) => {
  showDetail.value = true
  detailLoading.value = true
  detailData.value = null
  try {
    const res = await getOrderDetail(order.orderId)
    if (res.code === 0) {
      detailData.value = res.data
    }
  } catch (e: any) {
    console.error('[订单详情] 加载失败:', e.message)
  } finally {
    detailLoading.value = false
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

watch(activeTab, () => {
  currentPage.value = 1
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
}

.tab-btn.active {
  background: #E66100;
  color: white;
  border-color: #E66100;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.order-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  overflow: hidden;
}

/* 收缩行 */
.order-collapsed {
  display: flex;
  align-items: center;
  padding: 14px 20px;
  cursor: pointer;
  transition: background 0.15s;
  gap: 24px;
}

.order-collapsed:hover {
  background: #fafafa;
}

.col-sn {
  flex: 0 0 200px;
  font-size: 14px;
  color: #2D2D2D;
  font-family: monospace;
}

.col-status {
  flex: 0 0 100px;
}

.col-amount {
  flex: 0 0 120px;
  font-size: 15px;
  color: #E66100;
  font-weight: 600;
}

.col-time {
  flex: 1;
  font-size: 13px;
  color: #8C8C8C;
}

.col-expand {
  flex: 0 0 30px;
  text-align: center;
  font-size: 12px;
  color: #999;
}

/* 展开区域 */
.order-expanded {
  border-top: 1px solid #f0f0f0;
  padding: 16px 20px;
}

.status-tag {
  font-size: 12px;
  padding: 3px 8px;
  border-radius: 4px;
}

.status-tag.WAIT_PAY { background: #FFF2F0; color: #FF4D4F; }
.status-tag.WAIT_ACCEPT { background: #FFF2F0; color: #FF4D4F; }
.status-tag.ACCEPTED { background: #E6F7FF; color: #1890FF; }
.status-tag.IN_PROGRESS { background: #E6F7FF; color: #1890FF; }
.status-tag.COMPLETED { background: #F6FFED; color: #52C41A; }
.status-tag.CANCELLED { background: #F5F5F5; color: #999; }
.status-tag.CLOSED { background: #F5F5F5; color: #999; }

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
  font-size: 18px;
  font-weight: 700;
  color: #FF4D4F;
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

.action-btn.detail {
  background: #fff;
  color: #595959;
  border: 1px solid #dcdcdc;
}

.action-btn.detail:hover {
  border-color: #E66100;
  color: #E66100;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
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

/* 详情弹窗 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 8px; padding: 24px; width: 640px; max-height: 80vh; overflow-y: auto; }
.modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.modal-header h2 { font-size: 17px; margin: 0; }
.close-btn { background: none; border: none; font-size: 22px; color: #999; cursor: pointer; }
.modal-loading { text-align: center; padding: 40px; color: #999; font-size: 14px; }

.detail-section { margin-bottom: 20px; }
.detail-section h3 { font-size: 14px; color: #333; margin-bottom: 10px; padding-bottom: 6px; border-bottom: 1px solid #f0f0f0; }
.detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 20px; }
.detail-item { display: flex; font-size: 13px; }
.detail-item .key { color: #86909C; min-width: 70px; }
.detail-item .val { color: #1D2129; }
.detail-item .val.price { color: #E66100; font-weight: 600; }

.detail-items { display: flex; flex-direction: column; gap: 10px; }
.detail-product { display: flex; gap: 12px; align-items: center; padding: 8px; background: #fafafa; border-radius: 6px; }
.dp-img { width: 60px; height: 60px; object-fit: cover; border-radius: 6px; }
.dp-info { flex: 1; }
.dp-name { font-size: 13px; color: #333; }
.dp-spec { font-size: 12px; color: #999; margin-top: 4px; }
.dp-right { text-align: right; }
.dp-price { color: #E66100; font-weight: 600; font-size: 13px; }
.dp-qty { font-size: 18px; font-weight: 700; color: #FF4D4F; margin-left: 8px; }
</style>
