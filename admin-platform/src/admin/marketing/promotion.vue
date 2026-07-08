<template>
  <div class="promotion-page">
    <div class="page-header">
      <h1>大促满减活动</h1>
    </div>

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
              <tr><th>满金额（元）</th><th>减金额（元）</th></tr>
            </thead>
            <tbody>
              <tr v-for="(t, ti) in item.tiers" :key="ti">
                <td>¥{{ formatAmount(t.minAmount) }}</td>
                <td>¥{{ formatAmount(t.discountAmount) }}</td>
              </tr>
            </tbody>
          </table>
          <div class="card-actions">
            <button v-if="item.status === 'DRAFT'" class="action-btn view" @click="openPromotionDialog(item)">编辑</button>
            <button v-if="item.status === 'DRAFT'" class="action-btn publish" @click="handlePublishPromotion(item)">发布</button>
            <button v-if="item.status === 'PUBLISHED'" class="action-btn warn" @click="handleClosePromotion(item)">关闭活动</button>
            <button v-if="item.status === 'CLOSED'" class="action-btn warn" @click="handleDeletePromotion(item)">删除</button>
          </div>
        </div>
      </div>
    </div>

    <div v-if="promotionList.length === 0" class="empty-state">
      <div class="empty-text">暂无大促活动</div>
    </div>

    <!-- ==================== 弹窗 ==================== -->
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
          <div class="form-item"><label>梯度设置</label></div>
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
import { ref, reactive, onMounted } from 'vue'
import {
  getPromotionList,
  createPromotion,
  closePromotion,
  publishPromotion,
  deletePromotion
} from '@/api/marketing'

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
  } catch { return val }
}

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
  } catch { promotionList.value = [] }
}

const togglePromotionExpand = (item: PromotionItem) => { item._expanded = !item._expanded }

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
    promotionDialog.form = { title: '', startTime: '', endTime: '', tiers: [{ minAmount: 0, discountAmount: 0 }] }
  }
  promotionDialog.visible = true
}

const addGradient = () => { promotionDialog.form.tiers.push({ minAmount: 0, discountAmount: 0 }) }
const removeGradient = (index: number) => {
  if (promotionDialog.form.tiers.length > 1) promotionDialog.form.tiers.splice(index, 1)
}

const handleSavePromotion = async () => {
  if (promotionDialog.form.startTime && promotionDialog.form.endTime) {
    if (new Date(promotionDialog.form.endTime) <= new Date(promotionDialog.form.startTime)) {
      alert('结束时间必须晚于开始时间'); return
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
  } catch (e: any) { alert(e?.response?.data?.msg || '创建失败') }
}

const handleClosePromotion = async (item: PromotionItem) => {
  if (confirm(`确定关闭活动"${item.title}"吗？关闭后不可恢复。`)) {
    try { await closePromotion(item.id); loadPromotionList() } catch (e: any) { alert(e?.response?.data?.msg || '关闭失败') }
  }
}

const handlePublishPromotion = async (item: PromotionItem) => {
  if (confirm(`确定发布活动"${item.title}"吗？发布后将同步到商家端且不可编辑。`)) {
    try { await publishPromotion(item.id); loadPromotionList() } catch (e: any) { alert(e?.response?.data?.msg || '发布失败') }
  }
}

const handleDeletePromotion = async (item: PromotionItem) => {
  if (confirm(`确定删除活动"${item.title}"吗？此操作不可恢复。`)) {
    try { await deletePromotion(item.id); loadPromotionList() } catch (e: any) { alert(e?.response?.data?.msg || '删除失败') }
  }
}

const mapPromotionStatus = (s: number | string): string => {
  const num = Number(s)
  if (num === 1) return 'PUBLISHED'
  if (num === 2) return 'CLOSED'
  return 'DRAFT'
}

onMounted(loadPromotionList)
</script>

<style scoped>
.promotion-page { padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h1 { font-size: 22px; color: #1D2129; }
.filter-bar { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; }
.create-btn { padding: 8px 20px; background: #00B42A; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }

.promotion-grid { display: flex; flex-direction: column; gap: 12px; }
.promotion-card { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); overflow: hidden; }
.promotion-card.closed { opacity: 0.6; }
.promotion-card-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; cursor: pointer; transition: background 0.2s; }
.promotion-card-header:hover { background: #F7F8FA; }
.promotion-info { flex: 1; }
.promotion-name { font-size: 16px; font-weight: 600; color: #1D2129; margin-bottom: 4px; }
.promotion-time { font-size: 13px; color: #86909C; }
.promotion-card-right { display: flex; align-items: center; gap: 12px; }
.expand-icon { font-size: 12px; color: #86909C; }
.promotion-card-body { padding: 0 20px 20px 20px; border-top: 1px solid #f0f0f0; }
.gradient-title { font-size: 14px; font-weight: 600; color: #1D2129; margin: 16px 0 10px 0; }
.gradient-table { margin-bottom: 16px; width: 100%; border-collapse: collapse; }
.gradient-table th, .gradient-table td { padding: 8px 16px; text-align: left; border-bottom: 1px solid #f0f0f0; }
.gradient-table th { background: #E5E6EB; font-size: 15px; color: #4E5969; font-weight: 600; }
.card-actions { display: flex; gap: 8px; }

.status-tag { font-size: 12px; padding: 2px 8px; border-radius: 4px; }
.status-tag.enabled { background: #F6FFED; color: #52C41A; }
.status-tag.disabled { background: #FFF2F0; color: #FF4D4F; border: 1px solid #FFCCC7; }
.status-tag.draft { background: #FFF7E6; color: #FA8C16; border: 1px solid #FFD591; }

.action-btn { padding: 4px 10px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer; }
.action-btn.view { background: #F2F3F5; color: #4E5969; }
.action-btn.warn { background: #FFF2F0; color: #FF4D4F; }
.action-btn.publish { background: #FF5722; color: #fff; }
.empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 60px 0; background: white; border-radius: 8px; margin-top: 20px; }
.empty-text { font-size: 14px; color: #86909C; }

.dialog-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.45); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.dialog { background: white; border-radius: 8px; width: 520px; max-height: 80vh; overflow-y: auto; box-shadow: 0 4px 20px rgba(0,0,0,0.15); }
.dialog-wide { width: 600px; }
.dialog-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-bottom: 1px solid #f0f0f0; }
.dialog-header h2 { font-size: 16px; color: #1D2129; font-weight: 600; }
.dialog-close { background: none; border: none; font-size: 18px; color: #86909C; cursor: pointer; }
.dialog-body { padding: 20px 24px; }
.form-item { margin-bottom: 16px; }
.form-item label { display: block; font-size: 14px; color: #4E5969; margin-bottom: 6px; font-weight: 500; }
.form-input { width: 100%; padding: 8px 12px; border: 1px solid #dcdcdc; border-radius: 4px; font-size: 14px; color: #1D2129; box-sizing: border-box; }
.form-row { display: flex; gap: 16px; }
.flex-1 { flex: 1; }
.dialog-footer { display: flex; justify-content: flex-end; gap: 12px; padding: 16px 24px; border-top: 1px solid #f0f0f0; }
.cancel-btn { padding: 8px 20px; border: 1px solid #dcdcdc; background: white; border-radius: 4px; font-size: 14px; color: #4E5969; cursor: pointer; }
.confirm-btn { padding: 8px 20px; background: #165DFF; color: white; border: none; border-radius: 4px; font-size: 14px; cursor: pointer; }

.gradient-row { margin-bottom: 8px; }
.gradient-field { display: flex; align-items: center; gap: 8px; }
.gradient-label { font-size: 14px; color: #4E5969; }
.gradient-input { width: 120px !important; }
.gradient-delete-btn { padding: 6px 12px; border: 1px solid #FF4D4F; background: white; color: #FF4D4F; border-radius: 4px; font-size: 12px; cursor: pointer; }
.add-gradient-btn { padding: 6px 16px; border: 1px dashed #165DFF; background: white; color: #165DFF; border-radius: 4px; font-size: 13px; cursor: pointer; margin-top: 4px; }
</style>
