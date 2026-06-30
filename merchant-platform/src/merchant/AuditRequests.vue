<template>
  <div class="audit-requests">
    <Toast ref="toastRef" />
    <h2>审核请求</h2>

    <div v-if="loading" class="loading">加载中...</div>
    <div v-else-if="list.length === 0" class="empty">暂无审核请求</div>
    <div v-else>
      <div class="list-card" v-for="item in list" :key="item.requestId + '_' + item.requestType">
        <div class="card-row">
          <div class="card-info">
            <span class="req-type">{{ requestTypeText(item.requestType) }}</span>
            <span class="req-time">{{ item.createTime || item.requestTime }}</span>
          </div>
          <span :class="statusClass(item.auditStatus)">{{ auditText(item.auditStatus) }}</span>
        </div>
        <div class="card-row" v-if="item.auditStatus !== 0 && item.auditRemark">
          <span class="remark-label">审核意见：</span>
          <span class="remark-text">{{ item.auditRemark }}</span>
        </div>
        <div class="card-actions">
          <button class="btn-detail" @click="openDetail(item)">详情</button>
          <button v-if="item.auditStatus === 0" class="btn-withdraw" @click="doWithdraw(item)">撤回</button>
        </div>
      </div>

      <!-- 分页 -->
      <div class="page" v-if="total > pageSize">
        <button :disabled="page === 1" @click="page--; fetchList()">上一页</button>
        <span>第{{ page }}页 / 共{{ total }}条</span>
        <button :disabled="page * pageSize >= total" @click="page++; fetchList()">下一页</button>
      </div>
    </div>

    <!-- 详情弹窗 - 新旧对照 -->
    <div v-if="showDetail" class="modal-overlay" @click.self="showDetail = false">
      <div class="modal">
        <h3>审核详情 - {{ requestTypeText(detailItem?.requestType) }}</h3>
        <div class="compare">
          <div class="compare-col">
            <h4 class="old-label">原信息</h4>
            <div class="compare-item" v-for="(val, key) in detailOld" :key="key">
              <label>{{ fieldLabel(String(key)) }}</label>
              <span>{{ val || '-' }}</span>
            </div>
          </div>
          <div class="compare-col">
            <h4 class="new-label">新信息</h4>
            <div class="compare-item" v-for="(val, key) in detailNew" :key="key">
              <label>{{ fieldLabel(String(key)) }}</label>
              <span class="highlight">{{ val || '-' }}</span>
            </div>
          </div>
        </div>
        <div v-if="detailItem?.auditRemark" class="detail-remark">
          <strong>审核意见：</strong>{{ detailItem.auditRemark }}
        </div>
        <div class="modal-ft">
          <button class="btn-cancel" @click="showDetail = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Toast from '@/components/Toast.vue'
import request from '@/utils/request'

const toastRef = ref<any>(null)
const loading = ref(true)
const list = ref<any[]>([])
const page = ref(1)
const pageSize = 10
const total = ref(0)

const showDetail = ref(false)
const detailItem = ref<any>(null)
const detailOld = ref<Record<string, any>>({})
const detailNew = ref<Record<string, any>>({})

const requestTypeText = (t: string) => {
  const map: Record<string, string> = {
    'PRODUCT_PUBLISH': '商品发布',
    'PRODUCT_EDIT': '商品编辑',
    'INFO_CHANGE': '商家信息更改',
    'QUALIFICATION_UPGRADE': '企业资质升级'
  }
  return map[t] || t
}

const auditText = (s: number) => {
  const map: Record<number, string> = { 0: '待审核', 1: '已通过', 2: '已驳回' }
  return map[s] || '未知'
}

const statusClass = (s: number) => {
  if (s === 0) return 'status-pending'
  if (s === 1) return 'status-pass'
  return 'status-reject'
}

const fieldLabel = (key: string) => {
  const map: Record<string, string> = {
    merchantName: '店铺名称', shopName: '店铺名称',
    contactName: '联系人', contactPhone: '联系电话',
    shopAddress: '店铺地址', businessHours: '营业时间',
    introduction: '店铺简介', title: '商品名称',
    description: '商品描述', minPrice: '最低价格',
    maxPrice: '最高价格', categoryId: '分类ID',
    categoryName: '分类名称', stock: '库存',
    mainImage: '主图', detailImages: '详情图',
    companyName: '企业名称', licenseNumber: '营业执照号',
    licenseImage: '营业执照', foodPermitNumber: '食品许可证号',
    foodPermitImage: '食品许可证'
  }
  return map[key] || key
}

async function fetchList() {
  loading.value = true
  try {
    const data = await request.get('/merchant/audit-requests', {
      params: { pageNum: page.value, pageSize }
    })
    list.value = data.list || []
    total.value = data.total || 0
  } catch (e: any) {
    toastRef.value?.show(e?.message || '获取失败', 'error')
  } finally {
    loading.value = false
  }
}

async function openDetail(item: any) {
  try {
    const data = await request.get(`/merchant/audit-requests/${item.requestId}/detail`, {
      params: { requestType: item.requestType }
    })
    detailItem.value = item
    detailOld.value = data.oldData || {}
    detailNew.value = data.newData || {}
    showDetail.value = true
  } catch (e: any) {
    toastRef.value?.show(e?.message || '获取详情失败', 'error')
  }
}

async function doWithdraw(item: any) {
  if (!confirm('确定要撤回该审核请求吗？')) return
  try {
    await request.post(`/merchant/audit-requests/${item.requestId}/withdraw`, {
      requestType: item.requestType
    })
    toastRef.value?.show('撤回成功', 'success')
    fetchList()
  } catch (e: any) {
    toastRef.value?.show(e?.message || '撤回失败', 'error')
  }
}

onMounted(fetchList)
</script>

<style scoped>
.audit-requests { max-width: 800px; }
h2 { margin-bottom: 16px; color: #1D2129; }
.loading, .empty { color: #86909C; padding: 40px; text-align: center; }
.list-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 12px;
}
.card-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}
.card-info { display: flex; gap: 16px; align-items: center; }
.req-type { font-weight: 600; color: #1D2129; font-size: 14px; }
.req-time { color: #86909C; font-size: 13px; }
.status-pending { color: #FF7D00; font-weight: 600; font-size: 13px; }
.status-pass { color: #00B42A; font-weight: 600; font-size: 13px; }
.status-reject { color: #F53F3F; font-weight: 600; font-size: 13px; }
.remark-label { color: #86909C; font-size: 13px; }
.remark-text { color: #4E5969; font-size: 13px; }
.card-actions { display: flex; gap: 8px; margin-top: 10px; }
.btn-detail { padding: 4px 14px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
.btn-withdraw { padding: 4px 14px; background: #F53F3F; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
.page { display: flex; gap: 12px; align-items: center; margin-top: 16px; color: #4E5969; font-size: 14px; }
.page button { padding: 4px 12px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; background: #fff; color: #4E5969; }
.page button:disabled { opacity: 0.4; cursor: not-allowed; }

/* 详情弹窗 */
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.4); display: flex; justify-content: center; align-items: center; z-index: 100; }
.modal { background: #fff; border-radius: 8px; padding: 24px; width: 700px; max-height: 80vh; overflow-y: auto; }
.modal h3 { margin-bottom: 16px; color: #1D2129; }
.compare { display: flex; gap: 20px; }
.compare-col { flex: 1; }
.compare-col h4 { margin-bottom: 8px; font-size: 14px; }
.old-label { color: #86909C; }
.new-label { color: #165DFF; }
.compare-item { display: flex; padding: 4px 0; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
.compare-item label { width: 90px; color: #86909C; flex-shrink: 0; }
.compare-item span { color: #1D2129; }
.compare-item .highlight { color: #165DFF; font-weight: 500; }
.detail-remark { margin-top: 12px; padding: 10px; background: #FFF7E6; border-radius: 4px; font-size: 13px; color: #4E5969; }
.modal-ft { margin-top: 16px; display: flex; justify-content: flex-end; }
.btn-cancel { padding: 6px 16px; background: #E5E6EB; color: #4E5969; border: none; border-radius: 4px; cursor: pointer; }
</style>
