<template>
  <div class="order-page">
    <div class="page-header">
      <h1>订单管理</h1>
      <div class="header-right">
        <input v-model="searchKeyword" placeholder="搜索订单号" class="search-input" />
        <select v-model="statusFilter" class="filter-select">
          <option value="">全部状态</option>
          <option value="0">待支付</option>
          <option value="1">待接单</option>
          <option value="2">已接单</option>
          <option value="3">配送中</option>
          <option value="4">已完成</option>
          <option value="5">已取消</option>
          <option value="6">已关闭</option>
        </select>
        <button @click="search" class="search-btn">搜索</button>
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
          <tr v-for="order in orderList" :key="order.id || order.orderSn">
            <td class="td-sn">{{ order.orderSn }}</td>
            <td>
              <div>{{ order.userName || ('用户' + order.userId) }}</div>
              <div class="text-sm">{{ order.userPhone || '-' }}</div>
            </td>
            <td>{{ order.merchantName || ('商家' + order.merchantId) }}</td>
            <td>{{ order.totalQuantity || 0 }}件</td>
            <td>¥{{ (order.payAmount || 0).toFixed(2) }}</td>
            <td><span :class="['type-tag', getDeliveryTypeKey(order.deliveryType)]">{{ getDeliveryText(order.deliveryType) }}</span></td>
            <td><span :class="['status-tag', getStatusClass(order.status)]">{{ getStatusText(order.status) }}</span></td>
            <td>{{ order.createTime }}</td>
            <td class="actions">
              <button class="action-btn view" @click="viewDetail(order)">查看详情</button>
              <button v-if="order.status === 0" class="action-btn cancel" @click="closeOrder(order)">关闭订单</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="orderList.length === 0" class="empty-state">
      <div class="empty-text">暂无订单</div>
    </div>

    <div class="pagination">
      <button :disabled="currentPage <= 1" @click="currentPage--; loadData()" class="page-btn">上一页</button>
      <span class="page-info">第{{ currentPage }}页 / 共{{ totalPages }}页</span>
      <button :disabled="currentPage >= totalPages" @click="currentPage++; loadData()" class="page-btn">下一页</button>
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
              <div class="detail-item"><span class="key">订单状态：</span><span :class="['status-tag', getStatusClass(detailData.status)]">{{ getStatusText(detailData.status) }}</span></div>
              <div class="detail-item"><span class="key">用户：</span><span class="val">{{ detailData.userName || ('用户' + detailData.userId) }}</span></div>
              <div class="detail-item"><span class="key">手机：</span><span class="val">{{ detailData.userPhone || '-' }}</span></div>
              <div class="detail-item"><span class="key">商家：</span><span class="val">{{ detailData.merchantName || ('商家' + detailData.merchantId) }}</span></div>
              <div class="detail-item"><span class="key">金额：</span><span class="val price">¥{{ (detailData.payAmount || 0).toFixed(2) }}</span></div>
              <div class="detail-item"><span class="key">配送方式：</span><span class="val">{{ getDeliveryText(detailData.deliveryType) }}</span></div>
              <div class="detail-item"><span class="key">下单时间：</span><span class="val">{{ detailData.createTime }}</span></div>
            </div>
          </div>
          <div class="detail-section" v-if="detailData.orderItems && detailData.orderItems.length > 0">
            <h3>商品明细（{{ detailData.orderItems.length }}件）</h3>
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getOrderList, getOrderDetail, closeOrder as closeOrderApi } from '@/api/system'

interface Order {
  id: number
  orderSn: string
  userId: number
  userName: string
  userPhone: string
  merchantId: number
  merchantName: string
  totalQuantity: number
  payAmount: number
  deliveryType: number
  status: number
  createTime: string
  orderItems: any[]
}

const searchKeyword = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const totalPages = ref(1)
const totalCount = ref(0)
const pageSize = ref(10)

const orderList = ref<Order[]>([])

const getStatusText = (status: number) => {
  const map: Record<number, string> = {
    0: '待支付',
    1: '待接单',
    2: '已接单',
    3: '配送中',
    4: '已完成',
    5: '已取消',
    6: '已关闭',
    7: '已退款'
  }
  return map[status] ?? `状态${status}`
}

const getStatusClass = (status: number) => {
  if (status === 0) return 'WAIT_PAY'
  if (status === 1) return 'WAIT_ACCEPT'
  if (status === 2) return 'ACCEPTED'
  if (status === 3) return 'SHIPPING'
  if (status === 4) return 'COMPLETED'
  if (status === 5) return 'CANCELLED'
  if (status === 6) return 'CLOSED'
  if (status === 7) return 'REFUNDED'
  return ''
}

const getDeliveryText = (type: number) => {
  if (type === 1) return '同城配送'
  if (type === 2) return '门店自提'
  return type ? `方式${type}` : '-'
}

const getDeliveryTypeKey = (type: number) => {
  if (type === 1) return 'DELIVERY'
  if (type === 2) return 'PICKUP'
  return ''
}

const loadData = async () => {
  const params: any = {
    page: currentPage.value,
    pageSize: pageSize.value
  }
  if (searchKeyword.value) {
    params.keyword = searchKeyword.value
  }
  if (statusFilter.value !== '') {
    params.status = statusFilter.value
  }
  try {
    const res = await getOrderList(params)
    if (res.code === 0) {
      const data = res.data
      orderList.value = data.list || data.records || (Array.isArray(data) ? data : [])
      totalCount.value = data.total || orderList.value.length
      totalPages.value = Math.max(1, Math.ceil(totalCount.value / pageSize.value))
    }
  } catch (e) {
    console.error('[平台订单] 加载失败:', e)
  }
}

const search = () => {
  currentPage.value = 1
  loadData()
}

const showDetail = ref(false)
const detailLoading = ref(false)
const detailData = ref<any>(null)

const viewDetail = async (order: Order) => {
  showDetail.value = true
  detailLoading.value = true
  detailData.value = null
  try {
    const res = await getOrderDetail(order.id || order.orderSn)
    if (res.code === 0) {
      // 后端返回 { order: {...}, items: [...] } 包装结构
      const data = res.data
      if (data.order) {
        detailData.value = {
          ...data.order,
          orderItems: data.items || []
        }
      } else {
        detailData.value = data
      }
    }
  } catch (e) {
    console.error('[平台订单详情] 加载失败:', e)
  } finally {
    detailLoading.value = false
  }
}

const closeOrder = async (order: Order) => {
  if (confirm(`确定关闭订单 ${order.orderSn} 吗？`)) {
    const res = await closeOrderApi(order.id || order.orderSn, { reason: '平台关闭' })
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
.order-page { padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h1 { font-size: 22px; color: #1D2129; }
.header-right { display: flex; gap: 10px; align-items: center; }
.search-input { padding: 8px 16px; border: 1px solid #dcdcdc; border-radius: 4px; width: 200px; font-size: 14px; }
.filter-select { padding: 8px 12px; border: 1px solid #dcdcdc; border-radius: 4px; font-size: 14px; }
.search-btn { padding: 8px 20px; background: #165DFF; color: white; border: none; border-radius: 4px; cursor: pointer; }

.table-container { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #f0f0f0; }
.data-table th { background: #E5E6EB; font-size: 15px; color: #4E5969; font-weight: 600; }
.data-table td { font-size: 14px; color: #1D2129; }
.td-sn { font-family: monospace; }

.text-sm { font-size: 12px; color: #86909C; }

.type-tag { font-size: 12px; padding: 2px 8px; border-radius: 4px; }
.type-tag.DELIVERY { background: #E6F7FF; color: #1890FF; }
.type-tag.PICKUP { background: #FFF7E6; color: #E67E22; }

.status-tag { font-size: 12px; padding: 2px 8px; border-radius: 4px; }
.status-tag.WAIT_PAY { background: #FFF7E6; color: #E67E22; }
.status-tag.WAIT_ACCEPT { background: #FFF2F0; color: #FF4D4F; }
.status-tag.ACCEPTED { background: #E6F7FF; color: #1890FF; }
.status-tag.SHIPPING { background: #E6F7FF; color: #1890FF; }
.status-tag.COMPLETED { background: #F6FFED; color: #52C41A; }
.status-tag.CANCELLED { background: #F5F5F5; color: #86909C; }
.status-tag.CLOSED { background: #F5F5F5; color: #86909C; }
.status-tag.REFUNDED { background: #FFF2F0; color: #FF4D4F; }

.actions { display: flex; gap: 8px; }
.action-btn { padding: 4px 10px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer; }
.action-btn.view { background: #F2F3F5; color: #4E5969; }
.action-btn.cancel { background: #F5F5F5; color: #86909C; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 60px 0; background: white; border-radius: 8px; margin-top: 20px; }
.empty-text { font-size: 14px; color: #86909C; }

.pagination { display: flex; justify-content: center; align-items: center; gap: 16px; margin-top: 30px; }
.page-btn { padding: 8px 16px; border: 1px solid #dcdcdc; background: white; border-radius: 4px; cursor: pointer; }
.page-btn:disabled { opacity: 0.5; cursor: not-allowed; }
.page-info { font-size: 14px; color: #4E5969; }

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
.dp-qty { font-size: 12px; color: #999; margin-left: 8px; }
</style>
