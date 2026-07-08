<template>
  <div class="aftersale-page">
    <div class="page-header">
      <h1>售后管理</h1>
      <p class="subtitle">处理用户的退款/退货申请</p>
    </div>

    <div class="tabs">
      <button v-for="tab in tabs" :key="tab.value" :class="['tab-btn', { active: activeTab === tab.value }]"
        @click="activeTab = tab.value; loadData()">
        {{ tab.label }}
      </button>
    </div>

    <div class="list-section">
      <div v-for="item in list" :key="item.afterSaleId" class="after-sale-card" @click="openDetail(item)">
        <div class="card-left">
          <div class="order-sn">
            <span class="label">订单序号</span>
            <span class="value">{{ item.orderSn }}</span>
          </div>
          <div :class="['type-tag', item.type === 1 ? 'refund' : 'return']">
            {{ item.type === 1 ? '仅退款' : '退货退款' }}
          </div>
        </div>
        <div class="card-right">
          <span :class="['status-tag', getStatusClass(item.status)]">{{ getStatusText(item.status) }}</span>
          <span class="arrow">▶</span>
        </div>
      </div>

      <div v-if="list.length === 0" class="empty-state">
        <div class="empty-text">暂无售后请求</div>
      </div>
    </div>

    <div class="pagination" v-if="totalPages > 1">
      <button :disabled="pageNum <= 1" @click="pageNum--; loadData()">上一页</button>
      <span>第{{ pageNum }}页 / 共{{ totalPages }}页</span>
      <button :disabled="pageNum >= totalPages" @click="pageNum++; loadData()">下一页</button>
    </div>

    <!-- 售后详情对话框 -->
    <div v-if="showDetail" class="modal-mask" @click.self="showDetail = false">
      <div class="modal-box">
        <h2>售后详情</h2>
        <div class="detail-section">
          <div class="detail-row"><span class="d-label">售后ID：</span>{{ detail.afterSaleId }}</div>
          <div class="detail-row"><span class="d-label">订单序号：</span>{{ detail.orderSn }}</div>
          <div class="detail-row"><span class="d-label">售后类型：</span>{{ detail.type === 1 ? '仅退款' : '退货退款' }}</div>
          <div class="detail-row"><span class="d-label">退款金额：</span>¥{{ (detail.refundAmount || 0).toFixed(2) }}</div>
          <div class="detail-row"><span class="d-label">商品名称：</span>{{ detail.productName || '-' }}</div>
          <div class="detail-row"><span class="d-label">规格：</span>{{ detail.skuSpecs || '-' }}</div>
          <div class="detail-row"><span class="d-label">当前状态：</span>{{ getStatusText(detail.status) }}</div>
          <div class="detail-row"><span class="d-label">申请时间：</span>{{ detail.applyTime || '-' }}</div>
          <div class="detail-row" v-if="detail.reason"><span class="d-label">售后理由：</span>{{ detail.reason }}</div>
          <div class="detail-row evidence-row">
            <span class="d-label">买家证据：</span>
            <div v-if="evidenceImages.length > 0" class="evidence-imgs">
              <img
                v-for="(img, idx) in evidenceImages"
                :key="idx"
                :src="img"
                class="evidence-img"
                @click="previewImage(img)"
              />
            </div>
            <span v-else class="no-evidence">无</span>
          </div>
        </div>

        <!-- 订单信息 -->
        <div class="order-section" v-if="detail.order">
          <h3>订单信息</h3>
          <div class="detail-row"><span class="d-label">买家：</span>{{ detail.order.buyerNickname || '-' }}</div>
          <div class="detail-row"><span class="d-label">手机号：</span>{{ detail.order.buyerPhone || '-' }}</div>
          <div class="detail-row"><span class="d-label">支付金额：</span>¥{{ (detail.order.payAmount || 0).toFixed(2) }}</div>
          <div class="detail-row"><span class="d-label">收货地址：</span>{{ detail.order.address || '-' }}</div>
        </div>

        <!-- 审批操作 -->
        <div class="action-section" v-if="detail.status === 1">
          <div class="form-row">
            <label>处理备注：</label>
            <textarea v-model="auditRemark" rows="3" placeholder="请输入处理备注（拒绝时必填）"></textarea>
          </div>
          <div class="action-btns">
            <button class="btn-approve" @click="handleAudit(1)">通过</button>
            <button class="btn-reject" @click="handleAudit(2)">拒绝</button>
          </div>
        </div>
        <!-- 退货收货确认（仅退货退款 + 用户已退货状态） -->
        <div class="action-section" v-if="detail.type === 2 && detail.status === 3">
          <div class="form-row">
            <label>收货备注：</label>
            <textarea v-model="returnRemark" rows="2" placeholder="选填（收货异常时建议填写原因）"></textarea>
          </div>
          <div class="action-btns">
            <button class="btn-approve" @click="handleReturnConfirm(1)">确认收货</button>
            <button class="btn-reject" @click="handleReturnConfirm(2)">收货异常</button>
          </div>
        </div>
        <div class="action-section" v-if="detail.status !== 1 && !(detail.type === 2 && detail.status === 3)">
          <div class="detail-row" v-if="detail.auditRemark"><span class="d-label">处理备注：</span>{{ detail.auditRemark }}</div>
          <div class="detail-row" v-if="detail.auditTime"><span class="d-label">处理时间：</span>{{ detail.auditTime }}</div>
        </div>

        <div class="dialog-footer">
          <button class="btn-close" @click="showDetail = false">关闭</button>
        </div>
      </div>
    </div>

    <!-- 图片预览浮层 -->
    <div v-if="previewUrl" class="preview-mask" @click="previewUrl = ''">
      <img :src="previewUrl" class="preview-full" @click.stop />
      <span class="preview-close" @click="previewUrl = ''">✕</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getAfterSaleList, getAfterSaleDetail, auditAfterSale, confirmReturn } from '@/api/afterSale'

interface AfterSaleItem {
  afterSaleId: number
  orderId: number
  orderItemId: number
  orderSn: string
  type: number
  typeText: string
  refundAmount: number
  productName: string
  skuSpecs: string
  reason: string
  status: number
  applyTime: string
  auditRemark: string
  auditTime: string
  order?: any
}

const activeTab = ref('ALL')
const pageNum = ref(1)
const totalPages = ref(1)
const list = ref<AfterSaleItem[]>([])

const tabs = [
  { label: '全部', value: 'ALL', status: undefined },
  { label: '待处理', value: 'WAIT', status: 1 },
  { label: '已通过', value: 'APPROVED', status: 4 },
  { label: '已拒绝', value: 'REJECTED', status: 5 }
]

const showDetail = ref(false)
const detail = ref<AfterSaleItem>({} as AfterSaleItem)
const auditRemark = ref('')
const returnRemark = ref('')
const previewUrl = ref('')

// 解析 evidenceImages 字段（逗号分隔的 URL 字符串）
const evidenceImages = computed(() => {
  if (!detail.value || !(detail.value as any).evidenceImages) return []
  const raw = (detail.value as any).evidenceImages
  if (typeof raw === 'string') {
    return raw.split(',').map((u: string) => u.trim()).filter(Boolean)
  }
  if (Array.isArray(raw)) return raw
  return []
})

const previewImage = (url: string) => {
  previewUrl.value = url
}

const getStatusClass = (status: number) => {
  if (status === 1) return 'WAIT'
  if (status === 2 || status === 3) return 'WAIT'
  if (status === 4) return 'APPROVED'
  if (status === 5) return 'REJECTED'
  return ''
}

const getStatusText = (status: number) => {
  if (status === 1) return '待处理'
  if (status === 2) return '待退货'
  if (status === 3) return '已寄回'
  if (status === 4) return '已完成'
  if (status === 5) return '已拒绝'
  return '未知'
}

const loadData = async () => {
  const tab = tabs.find(t => t.value === activeTab.value)
  const params: any = { pageNum: pageNum.value, pageSize: 10 }
  if (tab && tab.status !== undefined) params.status = tab.status
  console.log('[售后管理] loadData 开始, params:', params)
  try {
    const res = await getAfterSaleList(params)
    console.log('[售后管理] 接口返回:', res)
    if (res.code === 0) {
      const data = res.data
      list.value = data.list || data.records || []
      console.log('[售后管理] 数据条数:', list.value.length)
      const total = data.total || list.value.length
      totalPages.value = Math.max(1, Math.ceil(total / 10))
    }
  } catch (e: any) {
    console.error('[售后管理] 请求异常:', e.message, e)
  }
}

const openDetail = async (item: AfterSaleItem) => {
  try {
    const res = await getAfterSaleDetail(item.afterSaleId)
    if (res.code === 0) {
      detail.value = res.data || item
    } else {
      detail.value = { ...item }
    }
  } catch (e: any) {
    detail.value = { ...item }
  }
  auditRemark.value = ''
  returnRemark.value = ''
  showDetail.value = true
}

const handleAudit = async (action: number) => {
  if (action === 2 && !auditRemark.value.trim()) {
    alert('拒绝时必须填写拒绝理由')
    return
  }
  const confirmMsg = action === 1 ? '确认通过该售后申请？' : '确认拒绝该售后申请？'
  if (!confirm(confirmMsg)) return
  try {
    const res = await auditAfterSale(detail.value.afterSaleId, {
      action,
      remark: auditRemark.value
    })
    if (res.code === 0) {
      alert(action === 1 ? '已通过售后申请' : '已拒绝售后申请')
      showDetail.value = false
      loadData()
    } else {
      alert(res.message || '操作失败')
    }
  } catch (e: any) {
    console.log('[售后审批] 请求异常:', e.message)
  }
}

const handleReturnConfirm = async (receivedStatus: number) => {
  const confirmMsg = receivedStatus === 1 ? '确认已收到退货商品？' : '确认为收货异常？'
  if (!confirm(confirmMsg)) return
  try {
    const res = await confirmReturn(detail.value.afterSaleId, {
      receivedStatus,
      remark: returnRemark.value
    })
    if (res.code === 0) {
      alert(receivedStatus === 1 ? '已确认收货，售后完成' : '已标记为收货异常')
      showDetail.value = false
      loadData()
    } else {
      alert(res.message || '操作失败')
    }
  } catch (e: any) {
    console.log('[退货确认] 请求异常:', e.message)
  }
}

onMounted(() => {
  console.log('[售后管理] 组件已挂载')
  loadData()
})
</script>

<style scoped>
.aftersale-page { padding: 20px; max-width: 1100px; margin: 0 auto; }
.page-header { margin-bottom: 20px; }
.page-header h1 { font-size: 22px; color: #2D2D2D; margin: 0; }
.subtitle { font-size: 13px; color: #999; margin: 4px 0 0; }

.tabs { display: flex; gap: 8px; margin-bottom: 20px; }
.tab-btn { padding: 8px 16px; border: 1px solid #dcdcdc; background: white; border-radius: 4px; cursor: pointer; font-size: 14px; color: #595959; }
.tab-btn.active { background: #E66100; color: white; border-color: #E66100; }

.list-section { display: flex; flex-direction: column; gap: 12px; }
.after-sale-card { background: white; border-radius: 8px; padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.04); cursor: pointer; transition: box-shadow 0.2s; }
.after-sale-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }

.card-left { display: flex; align-items: center; gap: 16px; }
.order-sn { display: flex; align-items: center; gap: 8px; }
.order-sn .label { font-size: 13px; color: #999; }
.order-sn .value { font-size: 15px; color: #2D2D2D; font-weight: 600; }

.type-tag { font-size: 12px; padding: 4px 10px; border-radius: 4px; }
.type-tag.refund { background: #FFF7E6; color: #E67E22; }
.type-tag.return { background: #E6F7FF; color: #1890FF; }

.card-right { display: flex; align-items: center; gap: 12px; }
.status-tag { font-size: 12px; padding: 3px 10px; border-radius: 4px; }
.status-tag.WAIT { background: #FFF7E6; color: #E67E22; }
.status-tag.APPROVED { background: #F6FFED; color: #52C41A; }
.status-tag.REJECTED { background: #FFF2F0; color: #FF4D4F; }
.arrow { font-size: 12px; color: #bbb; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 60px 0; }
.empty-icon { font-size: 48px; margin-bottom: 12px; }
.empty-text { font-size: 14px; color: #999; }

.pagination { display: flex; justify-content: center; gap: 16px; margin-top: 24px; align-items: center; font-size: 13px; color: #666; }
.pagination button { padding: 6px 14px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: 0.4; cursor: default; }

/* Dialog */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 8px; padding: 24px; width: 560px; max-height: 80vh; overflow-y: auto; }
.modal-box h2 { font-size: 18px; margin: 0 0 20px; color: #2D2D2D; }

.detail-section, .order-section { margin-bottom: 16px; }
.order-section h3 { font-size: 15px; color: #2D2D2D; margin: 0 0 10px; padding-bottom: 8px; border-bottom: 1px solid #f0f0f0; }

.detail-row { display: flex; margin-bottom: 8px; font-size: 13px; }
.d-label { color: #999; min-width: 80px; flex-shrink: 0; }

.action-section { margin-top: 16px; padding-top: 16px; border-top: 1px solid #f0f0f0; }
.form-row { margin-bottom: 12px; }
.form-row label { display: block; font-size: 13px; color: #555; margin-bottom: 6px; }
.form-row textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: none; font-size: 13px; box-sizing: border-box; }

.action-btns { display: flex; gap: 12px; }
.btn-approve { padding: 8px 24px; background: #52C41A; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-reject { padding: 8px 24px; background: #FF4D4F; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }

.dialog-footer { margin-top: 20px; text-align: center; }
.btn-close { padding: 8px 24px; background: #f5f5f5; color: #666; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; font-size: 14px; }

/* 证据图片 */
.evidence-row { align-items: flex-start; }
.evidence-imgs { display: flex; flex-wrap: wrap; gap: 8px; }
.evidence-img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #eee; cursor: pointer; transition: transform 0.2s; }
.evidence-img:hover { transform: scale(1.05); }
.no-evidence { font-size: 13px; color: #999; }

/* 图片预览蒙层 */
.preview-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.85); display: flex; justify-content: center; align-items: center; z-index: 2000; }
.preview-full { max-width: 90vw; max-height: 90vh; object-fit: contain; border-radius: 4px; }
.preview-close { position: absolute; top: 24px; right: 32px; font-size: 32px; color: #fff; cursor: pointer; }
</style>
