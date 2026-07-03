<template>
  <div class="coupon-page">
    <div class="page-header">
      <h1>优惠券管理</h1>
    </div>

    <!-- Tab 切换 -->
    <div class="tab-bar">
      <button
        :class="['tab-btn', { active: activeTab === 'coupon' }]"
        @click="activeTab = 'coupon'"
      >平台优惠券</button>
      <button
        :class="['tab-btn', { active: activeTab === 'promotion' }]"
        @click="activeTab = 'promotion'"
      >大促满减活动</button>
    </div>

    <!-- ==================== 平台优惠券 Tab ==================== -->
    <div v-if="activeTab === 'coupon'">
      <div class="filter-bar">
        <div class="filter-left">
          <input v-model="couponSearch.keyword" placeholder="优惠券名称搜索" class="search-input" />
          <select v-model="couponSearch.status" class="filter-select">
            <option value="">全部状态</option>
            <option value="ACTIVE">启用</option>
            <option value="DISABLED">禁用</option>
          </select>
        </div>
        <button class="search-btn" @click="loadCouponList">搜索</button>
        <button class="create-btn" @click="openCouponDialog()">新建优惠券</button>
      </div>

      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>名称</th>
              <th>面值</th>
              <th>最低消费</th>
              <th>发行量</th>
              <th>已领取</th>
              <th>领取门槛</th>
              <th>有效期</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in couponList" :key="item.id">
              <td>{{ item.title }}</td>
              <td>¥{{ formatAmount(item.discountAmount) }}</td>
              <td>¥{{ formatAmount(item.minConsume) }}</td>
              <td>{{ item.totalCount }}</td>
              <td>{{ item.receivedCount || 0 }}</td>
              <td>{{ memberLevelLabel(item.memberLevelRequired) }}</td>
              <td>
                <template v-if="item.validityType === 2">领取后{{ item.validityDays }}天过期</template>
                <template v-else>{{ formatDate(item.validStart) }}<br />{{ formatDate(item.validEnd) }}</template>
              </td>
              <td>
                <span :class="['status-tag', item.status === 'ACTIVE' ? 'enabled' : 'disabled']">
                  {{ item.status === 'ACTIVE' ? '启用' : '禁用' }}
                </span>
              </td>
              <td class="actions">
                <button class="action-btn view" @click="openCouponDialog(item)">编辑</button>
                <button v-if="item.status === 'ACTIVE'" class="action-btn warn" @click="handleDisableCoupon(item)">禁用</button>
                <button v-if="item.status !== 'ACTIVE'" class="action-btn view" @click="handleEnableCoupon(item)">启用</button>
                <button class="action-btn warn" @click="handleDeleteCoupon(item)">删除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="couponList.length === 0" class="empty-state">
        <div class="empty-icon">🎫</div>
        <div class="empty-text">暂无优惠券</div>
      </div>

      <div class="pagination">
        <button :disabled="couponPage.page <= 1" @click="couponPage.page--; loadCouponList()" class="page-btn">上一页</button>
        <span class="page-info">第{{ couponPage.page }}页 / 共{{ couponTotalPages }}页</span>
        <button :disabled="couponPage.page >= couponTotalPages" @click="couponPage.page++; loadCouponList()" class="page-btn">下一页</button>
      </div>
    </div>

    <!-- ==================== 大促满减活动 Tab ==================== -->
    <div v-if="activeTab === 'promotion'">
      <div class="filter-bar">
        <button class="create-btn" @click="openPromotionDialog()">新建活动</button>
      </div>

      <div class="promotion-grid">
        <div v-for="item in promotionList" :key="item.id" class="promotion-card" :class="{ closed: item.status === 'CLOSED' }">
          <div class="promotion-card-header" @click="togglePromotionExpand(item)">
            <div class="promotion-info">
              <div class="promotion-name">{{ item.title }}</div>
              <div class="promotion-time">{{ formatDate(item.startTime) }} ~ {{ formatDate(item.endTime) }}</div>
            </div>
            <div class="promotion-card-right">
              <span :class="['status-tag', item.status === 'PUBLISHED' ? 'enabled' : item.status === 'DRAFT' ? 'draft' : 'disabled']">
                {{ item.status === 'PUBLISHED' ? '进行中' : item.status === 'DRAFT' ? '草稿' : '已关闭' }}
              </span>
              <span class="expand-icon">{{ item._expanded ? '▲' : '▼' }}</span>
            </div>
          </div>
          <div v-if="item._expanded" class="promotion-card-body">
            <div class="gradient-title">梯度详情</div>
            <table class="data-table gradient-table">
              <thead>
                <tr>
                  <th>满金额（元）</th>
                  <th>减金额（元）</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(t, ti) in item.tiers" :key="ti">
                  <td>¥{{ formatAmount(t.minAmount) }}</td>
                  <td>¥{{ formatAmount(t.discountAmount) }}</td>
                </tr>
              </tbody>
            </table>
            <div class="card-actions">
              <button
                v-if="item.status === 'DRAFT'"
                class="action-btn view"
                @click="openPromotionDialog(item)"
              >编辑</button>
              <button
                v-if="item.status === 'DRAFT'"
                class="action-btn publish"
                @click="handlePublishPromotion(item)"
              >发布</button>
              <button
                v-if="item.status === 'PUBLISHED'"
                class="action-btn warn"
                @click="handleClosePromotion(item)"
              >关闭活动</button>
              <button
                v-if="item.status === 'CLOSED'"
                class="action-btn warn"
                @click="handleDeletePromotion(item)"
              >删除</button>
            </div>
          </div>
        </div>
      </div>

      <div v-if="promotionList.length === 0" class="empty-state">
        <div class="empty-icon">📢</div>
        <div class="empty-text">暂无大促活动</div>
      </div>
    </div>

    <!-- ==================== 优惠券弹窗 ==================== -->
    <div v-if="couponDialog.visible" class="dialog-overlay" @click.self="couponDialog.visible = false">
      <div class="dialog">
        <div class="dialog-header">
          <h2>{{ couponDialog.isEdit ? '编辑优惠券' : '新建优惠券' }}</h2>
          <button class="dialog-close" @click="couponDialog.visible = false">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-item">
            <label>优惠券名称</label>
            <input v-model="couponDialog.form.title" class="form-input" placeholder="请输入优惠券名称" />
          </div>
          <div class="form-item">
            <label>优惠金额</label>
            <input v-model.number="couponDialog.form.discountAmount" type="number" class="form-input" placeholder="请输入优惠金额" />
          </div>
          <div class="form-item">
            <label>最低使用标准</label>
            <input v-model.number="couponDialog.form.minConsume" type="number" class="form-input" placeholder="最低消费金额" />
          </div>
          <div class="form-item">
            <label>发行总量</label>
            <input v-model.number="couponDialog.form.totalCount" type="number" class="form-input" placeholder="请输入发行总量" />
          </div>
          <div class="form-item">
            <label>每人限领</label>
            <input v-model.number="couponDialog.form.perUserLimit" type="number" class="form-input" placeholder="每人限领数量" />
          </div>
          <div class="form-item">
            <label>有效期类型</label>
            <select v-model="couponDialog.form.validityType" class="form-input">
              <option :value="1">固定时间段</option>
              <option :value="2">领取后N天失效</option>
            </select>
          </div>
          <template v-if="couponDialog.form.validityType === 1">
            <div class="form-item">
              <label>有效期开始</label>
              <input v-model="couponDialog.form.validStart" type="datetime-local" class="form-input" />
            </div>
            <div class="form-item">
              <label>有效期结束</label>
              <input v-model="couponDialog.form.validEnd" type="datetime-local" class="form-input" />
            </div>
          </template>
          <template v-else>
            <div class="form-item">
              <label>有效天数</label>
              <input v-model.number="couponDialog.form.validityDays" type="number" class="form-input" placeholder="领取后N天内的23:59:59失效" />
            </div>
          </template>
          <div class="form-item">
            <label>积分兑换</label>
            <input v-model.number="couponDialog.form.exchangePoints" type="number" class="form-input" placeholder="0表示免费领取" />
          </div>
          <div class="form-item">
            <label>会员等级门槛</label>
            <select v-model.number="couponDialog.form.memberLevelRequired" class="form-input">
              <option :value="1">普通会员及以上</option>
              <option :value="2">银卡会员及以上</option>
              <option :value="3">金卡会员及以上</option>
              <option :value="4">钻石会员及以上</option>
            </select>
          </div>
        </div>
        <div class="dialog-footer">
          <button class="cancel-btn" @click="couponDialog.visible = false">取消</button>
          <button class="confirm-btn" @click="handleSaveCoupon">保存</button>
        </div>
      </div>
    </div>

    <!-- ==================== 大促活动弹窗 ==================== -->
    <div v-if="promotionDialog.visible" class="dialog-overlay" @click.self="promotionDialog.visible = false">
      <div class="dialog dialog-wide">
        <div class="dialog-header">
          <h2>{{ promotionDialog.isEdit ? '编辑活动' : '新建活动' }}</h2>
          <button class="dialog-close" @click="promotionDialog.visible = false">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-item">
            <label>活动名称</label>
            <input v-model="promotionDialog.form.title" class="form-input" placeholder="请输入活动名称" />
          </div>
          <div class="form-row">
            <div class="form-item flex-1">
              <label>开始时间</label>
              <input v-model="promotionDialog.form.startTime" type="datetime-local" class="form-input" />
            </div>
            <div class="form-item flex-1">
              <label>结束时间</label>
              <input v-model="promotionDialog.form.endTime" type="datetime-local" class="form-input" />
            </div>
          </div>
          <div class="form-item">
            <label>梯度设置</label>
          </div>
          <div v-for="(g, gi) in promotionDialog.form.tiers" :key="gi" class="gradient-row">
            <div class="gradient-field">
              <span class="gradient-label">满</span>
              <input v-model.number="g.minAmount" type="number" class="form-input gradient-input" placeholder="金额" />
              <span class="gradient-label">减</span>
              <input v-model.number="g.discountAmount" type="number" class="form-input gradient-input" placeholder="金额" />
              <button class="gradient-delete-btn" @click="removeGradient(gi)">删除</button>
            </div>
          </div>
          <button class="add-gradient-btn" @click="addGradient">+ 添加梯度</button>
        </div>
        <div class="dialog-footer">
          <button class="cancel-btn" @click="promotionDialog.visible = false">取消</button>
          <button class="confirm-btn" @click="handleSavePromotion">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import {
  getCouponList,
  createCoupon,
  updateCoupon,
  deleteCoupon,
  disableCoupon,
  enableCoupon,
  getPromotionList,
  createPromotion,
  closePromotion,
  publishPromotion,
  deletePromotion
} from '@/api/marketing'

// ==================== 通用 ====================
const activeTab = ref('coupon')

// ==================== 工具函数 ====================
const formatAmount = (val: any): string => {
  const num = Number(val)
  return isNaN(num) ? '0.00' : num.toFixed(2)
}

const formatDate = (val: string): string => {
  if (!val) return ''
  try {
    const d = new Date(val)
    if (isNaN(d.getTime())) return val
    const y = d.getFullYear()
    const m = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    return `${y}-${m}-${day}`
  } catch {
    return val
  }
}

const memberLevelLabel = (level: number): string => {
  const map: Record<number, string> = {
    1: '普通会员',
    2: '银卡会员',
    3: '金卡会员',
    4: '钻石会员'
  }
  return map[level] || '不限'
}

// ==================== 平台优惠券 ====================
interface CouponItem {
  id: number
  title: string
  type: string
  discountAmount: number
  minConsume: number
  totalCount: number
  receivedCount: number
  perUserLimit: number
  validStart: string
  validEnd: string
  exchangePoints: number
  memberLevelRequired: number
  status: string
}

const couponSearch = reactive({
  keyword: '',
  type: '',
  status: ''
})

const couponPage = reactive({
  page: 1,
  pageSize: 10
})

const couponTotal = ref(0)
const couponList = ref<CouponItem[]>([])

const couponTotalPages = computed(() => {
  const total = Math.ceil(couponTotal.value / couponPage.pageSize)
  return total > 0 ? total : 1
})

const couponDialog = reactive({
  visible: false,
  isEdit: false,
  editId: null as number | null,
  form: {
    title: '',
    type: 'FIXED',
    discountAmount: 0,
    minConsume: 0.01,
    totalCount: 0,
    perUserLimit: 1,
    validStart: '',
    validEnd: '',
    exchangePoints: 0,
    memberLevelRequired: 1
  }
})

const loadCouponList = async () => {
  const params: any = {
    page: couponPage.page,
    pageSize: couponPage.pageSize
  }
  if (couponSearch.keyword) params.keyword = couponSearch.keyword
  if (couponSearch.status) params.status = couponSearch.status === 'ACTIVE' ? 1 : 0
  if (couponSearch.type) params.type = couponSearch.type === 'FIXED' ? 1 : 2
  try {
    const res = await getCouponList(params)
    if (res.code === 0) {
      const list = (res.data.list || res.data || []).map((item: any) => ({
        ...item,
        type: (item.type === 1 || item.type === 'FIXED') ? 'FIXED' : 'FULL_REDUCTION',
        status: (item.status === 1 || item.status === 'ACTIVE') ? 'ACTIVE' : 'DISABLED'
      }))
      couponList.value = list
      couponTotal.value = res.data.total || list.length
    }
  } catch {
    couponList.value = []
  }
}

const openCouponDialog = (item?: CouponItem) => {
  if (item) {
    couponDialog.isEdit = true
    couponDialog.editId = item.id
    couponDialog.form = {
      title: item.title,
      type: item.type,
      discountAmount: item.discountAmount,
      minConsume: item.minConsume,
      totalCount: item.totalCount,
      perUserLimit: item.perUserLimit,
      validStart: item.validStart,
      validEnd: item.validEnd,
      validityType: item.validityType || 1,
      validityDays: item.validityDays || 7,
      exchangePoints: item.exchangePoints || 0,
      memberLevelRequired: item.memberLevelRequired || 1
    }
  } else {
    couponDialog.isEdit = false
    couponDialog.editId = null
    couponDialog.form = {
      title: '',
      type: 'FIXED',
      discountAmount: 0,
      minConsume: 0.01,
      totalCount: 0,
      perUserLimit: 1,
      validStart: '',
      validEnd: '',
      validityType: 1,
      validityDays: 7,
      exchangePoints: 0,
      memberLevelRequired: 1
    }
  }
  couponDialog.visible = true
}

const handleSaveCoupon = async () => {
  // 固定时间段校验
  if (couponDialog.form.validityType === 1 && couponDialog.form.validStart && couponDialog.form.validEnd) {
    if (new Date(couponDialog.form.validEnd) <= new Date(couponDialog.form.validStart)) {
      alert('结束时间必须晚于开始时间')
      return
    }
  }

  const data: any = { ...couponDialog.form }
  data.discountAmount = Number(data.discountAmount) || 0
  data.minConsume = Number(data.minConsume) || 0.01
  data.totalCount = Number(data.totalCount) || 0
  data.perUserLimit = Number(data.perUserLimit) || 1
  data.exchangePoints = Number(data.exchangePoints) || 0

  try {
    if (couponDialog.isEdit && couponDialog.editId !== null) {
      await updateCoupon(couponDialog.editId, data)
    } else {
      await createCoupon(data)
    }
    couponDialog.visible = false
    loadCouponList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '保存失败')
  }
}

const handleDeleteCoupon = async (item: CouponItem) => {
  if (confirm(`确定删除优惠券"${item.title}"吗？`)) {
    try {
      await deleteCoupon(item.id)
      loadCouponList()
    } catch (e: any) {
      alert(e?.response?.data?.msg || '删除失败')
    }
  }
}

const handleDisableCoupon = async (item: CouponItem) => {
  if (confirm(`确定禁用优惠券"${item.title}"吗？`)) {
    try {
      await disableCoupon(item.id)
      loadCouponList()
    } catch (e: any) {
      alert(e?.response?.data?.msg || '禁用失败')
    }
  }
}

const handleEnableCoupon = async (item: CouponItem) => {
  try {
    await enableCoupon(item.id)
    loadCouponList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '启用失败')
  }
}

// ==================== 大促满减活动 ====================
interface TierItem {
  minAmount: number
  discountAmount: number
}

interface PromotionItem {
  id: number
  title: string
  startTime: string
  endTime: string
  status: string
  tiers: TierItem[]
  _expanded?: boolean
}

const promotionList = ref<PromotionItem[]>([])

const promotionDialog = reactive({
  visible: false,
  isEdit: false,
  editId: null as number | null,
  form: {
    title: '',
    startTime: '',
    endTime: '',
    tiers: [] as TierItem[]
  }
})

const loadPromotionList = async () => {
  try {
    const res = await getPromotionList()
    if (res.code === 0) {
      const list = (res.data.list || res.data || []).map((item: any) => ({
        ...item,
        status: mapPromotionStatus(item.status),
        _expanded: false
      }))
      promotionList.value = list
    }
  } catch {
    promotionList.value = []
  }
}

const togglePromotionExpand = (item: PromotionItem) => {
  item._expanded = !item._expanded
}

const openPromotionDialog = (item?: PromotionItem) => {
  if (item) {
    promotionDialog.isEdit = true
    promotionDialog.editId = item.id
    promotionDialog.form = {
      title: item.title,
      startTime: item.startTime,
      endTime: item.endTime,
      tiers: item.tiers ? item.tiers.map(t => ({ ...t })) : []
    }
  } else {
    promotionDialog.isEdit = false
    promotionDialog.editId = null
    promotionDialog.form = {
      title: '',
      startTime: '',
      endTime: '',
      tiers: [{ minAmount: 0, discountAmount: 0 }]
    }
  }
  promotionDialog.visible = true
}

const addGradient = () => {
  promotionDialog.form.tiers.push({ minAmount: 0, discountAmount: 0 })
}

const removeGradient = (index: number) => {
  if (promotionDialog.form.tiers.length > 1) {
    promotionDialog.form.tiers.splice(index, 1)
  }
}

const handleSavePromotion = async () => {
  // 时间校验
  if (promotionDialog.form.startTime && promotionDialog.form.endTime) {
    if (new Date(promotionDialog.form.endTime) <= new Date(promotionDialog.form.startTime)) {
      alert('结束时间必须晚于开始时间')
      return
    }
  }

  const data = {
    promotion: {
      title: promotionDialog.form.title,
      startTime: promotionDialog.form.startTime,
      endTime: promotionDialog.form.endTime
    },
    tiers: promotionDialog.form.tiers.map(t => ({
      minAmount: Number(t.minAmount) || 0,
      discountAmount: Number(t.discountAmount) || 0
    }))
  }

  try {
    await createPromotion(data)
    promotionDialog.visible = false
    loadPromotionList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '创建失败')
  }
}

const handleClosePromotion = async (item: PromotionItem) => {
  if (confirm(`确定关闭活动"${item.title}"吗？关闭后不可恢复。`)) {
    try {
      await closePromotion(item.id)
      loadPromotionList()
    } catch (e: any) {
      alert(e?.response?.data?.msg || '关闭失败')
    }
  }
}

const handlePublishPromotion = async (item: PromotionItem) => {
  if (confirm(`确定发布活动"${item.title}"吗？发布后将同步到商家端且不可编辑。`)) {
    try {
      await publishPromotion(item.id)
      loadPromotionList()
    } catch (e: any) {
      alert(e?.response?.data?.msg || '发布失败')
    }
  }
}

const handleDeletePromotion = async (item: PromotionItem) => {
  if (confirm(`确定删除活动"${item.title}"吗？此操作不可恢复。`)) {
    try {
      await deletePromotion(item.id)
      loadPromotionList()
    } catch (e: any) {
      alert(e?.response?.data?.msg || '删除失败')
    }
  }
}

const mapPromotionStatus = (s: number | string): string => {
  const num = Number(s)
  if (num === 1) return 'PUBLISHED'
  if (num === 2) return 'CLOSED'
  return 'DRAFT'
}

onMounted(() => {
  loadCouponList()
  loadPromotionList()
})
</script>

<style scoped>
.coupon-page {
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

/* Tab */
.tab-bar {
  display: flex;
  gap: 0;
  margin-bottom: 20px;
  border-bottom: 2px solid #E5E6EB;
}

.tab-btn {
  padding: 10px 24px;
  border: none;
  background: none;
  font-size: 14px;
  color: #4E5969;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
  transition: all 0.2s;
}

.tab-btn.active {
  color: #165DFF;
  border-bottom-color: #165DFF;
  font-weight: 600;
}

.tab-btn:hover {
  color: #165DFF;
}

/* Filter */
.filter-bar {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.filter-left {
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
  font-size: 14px;
}

.create-btn {
  padding: 8px 20px;
  background: #00B42A;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

/* Table */
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

.type-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
  background: #E6F7FF;
  color: #1890FF;
}

.status-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.enabled {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.disabled {
  background: #FFF2F0;
  color: #FF4D4F;
  border: 1px solid #FFCCC7;
}
.status-tag.draft {
  background: #FFF7E6;
  color: #FA8C16;
  border: 1px solid #FFD591;
}

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

.action-btn.publish {
  background: #FF5722;
  color: #fff;
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
  font-size: 14px;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #4E5969;
}

/* ==================== 大促活动卡片 ==================== */
.promotion-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.promotion-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  overflow: hidden;
}

.promotion-card.closed {
  opacity: 0.6;
}

.promotion-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  cursor: pointer;
  transition: background 0.2s;
}

.promotion-card-header:hover {
  background: #F7F8FA;
}

.promotion-info {
  flex: 1;
}

.promotion-name {
  font-size: 16px;
  font-weight: 600;
  color: #1D2129;
  margin-bottom: 4px;
}

.promotion-time {
  font-size: 13px;
  color: #86909C;
}

.promotion-card-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.expand-icon {
  font-size: 12px;
  color: #86909C;
}

.promotion-card-body {
  padding: 0 20px 20px 20px;
  border-top: 1px solid #f0f0f0;
}

.gradient-title {
  font-size: 14px;
  font-weight: 600;
  color: #1D2129;
  margin: 16px 0 10px 0;
}

.gradient-table {
  margin-bottom: 16px;
}

.gradient-table th,
.gradient-table td {
  padding: 8px 16px;
}

.card-actions {
  display: flex;
  gap: 8px;
}

/* ==================== 弹窗 ==================== */
.dialog-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.dialog {
  background: white;
  border-radius: 8px;
  width: 520px;
  max-height: 80vh;
  overflow-y: auto;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

.dialog-wide {
  width: 600px;
}

.dialog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  border-bottom: 1px solid #f0f0f0;
}

.dialog-header h2 {
  font-size: 16px;
  color: #1D2129;
  font-weight: 600;
}

.dialog-close {
  background: none;
  border: none;
  font-size: 18px;
  color: #86909C;
  cursor: pointer;
  padding: 0;
}

.dialog-close:hover {
  color: #1D2129;
}

.dialog-body {
  padding: 20px 24px;
}

.form-item {
  margin-bottom: 16px;
}

.form-item label {
  display: block;
  font-size: 14px;
  color: #4E5969;
  margin-bottom: 6px;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  color: #1D2129;
  box-sizing: border-box;
}

.form-input:focus {
  outline: none;
  border-color: #165DFF;
}

.form-row {
  display: flex;
  gap: 16px;
}

.flex-1 {
  flex: 1;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 24px;
  border-top: 1px solid #f0f0f0;
}

.cancel-btn {
  padding: 8px 20px;
  border: 1px solid #dcdcdc;
  background: white;
  border-radius: 4px;
  font-size: 14px;
  color: #4E5969;
  cursor: pointer;
}

.confirm-btn {
  padding: 8px 20px;
  background: #165DFF;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 14px;
  cursor: pointer;
}

/* ==================== 梯度设置 ==================== */
.gradient-row {
  margin-bottom: 8px;
}

.gradient-field {
  display: flex;
  align-items: center;
  gap: 8px;
}

.gradient-label {
  font-size: 14px;
  color: #4E5969;
}

.gradient-input {
  width: 120px !important;
}

.gradient-delete-btn {
  padding: 6px 12px;
  border: 1px solid #FF4D4F;
  background: white;
  color: #FF4D4F;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.gradient-delete-btn:hover {
  background: #FFF2F0;
}

.add-gradient-btn {
  padding: 6px 16px;
  border: 1px dashed #165DFF;
  background: white;
  color: #165DFF;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
  margin-top: 4px;
}

.add-gradient-btn:hover {
  background: #F2F7FF;
}
</style>
