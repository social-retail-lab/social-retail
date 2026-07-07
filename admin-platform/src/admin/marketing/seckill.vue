<template>
  <div class="seckill-page">
    <div class="page-header">
      <h1>秒杀活动管理</h1>
      <button class="create-btn" @click="openDialog()">新建秒杀活动</button>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>活动名称</th>
            <th>开始时间</th>
            <th>结束时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.id">
            <td>{{ item.title }}</td>
            <td>{{ formatDateTime(item.startTime) }}</td>
            <td>{{ formatDateTime(item.endTime) }}</td>
            <td>
              <span :class="['status-tag', statusClass(item.status)]">
                {{ statusLabel(item.status) }}
              </span>
            </td>
            <td class="actions">
              <template v-if="item.status === 0">
                <button class="action-btn view" @click="openDialog(item)">编辑</button>
                <button class="action-btn publish" @click="handlePublish(item)">发布</button>
                <button class="action-btn warn" @click="handleDelete(item)">删除</button>
              </template>
              <template v-else-if="item.status === 1">
                <button class="action-btn view" @click="handleViewProducts(item)">查看商品</button>
                <button class="action-btn warn" @click="handleClose(item)">关闭</button>
              </template>
              <template v-else-if="item.status === 2">
                <button class="action-btn view" @click="handleViewProducts(item)">查看商品</button>
                <button class="action-btn warn" @click="handleDelete(item)">删除</button>
              </template>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="list.length === 0" class="empty-state">
      <div class="empty-text">暂无秒杀活动</div>
    </div>

    <div class="pagination">
      <button :disabled="page.page <= 1" @click="page.page--; loadList()" class="page-btn">上一页</button>
      <span class="page-info">第{{ page.page }}页 / 共{{ totalPages }}页</span>
      <button :disabled="page.page >= totalPages" @click="page.page++; loadList()" class="page-btn">下一页</button>
    </div>

    <!-- ==================== 新建/编辑弹窗 ==================== -->
    <div v-if="dialog.visible" class="dialog-overlay" @click.self="dialog.visible = false">
      <div class="dialog">
        <div class="dialog-header">
          <h2>{{ dialog.isEdit ? '编辑秒杀活动' : '新建秒杀活动' }}</h2>
          <button class="dialog-close" @click="dialog.visible = false">✕</button>
        </div>
        <div class="dialog-body">
          <div class="form-item">
            <label>活动名称</label>
            <input v-model="dialog.form.activityName" class="form-input" placeholder="请输入活动名称" />
          </div>
          <div class="form-item">
            <label>开始时间</label>
            <input v-model="dialog.form.startTime" class="form-input" placeholder="yyyy-MM-dd HH:mm:ss" />
          </div>
          <div class="form-item">
            <label>结束时间</label>
            <input v-model="dialog.form.endTime" class="form-input" placeholder="yyyy-MM-dd HH:mm:ss" />
          </div>
        </div>
        <div class="dialog-footer">
          <button class="cancel-btn" @click="dialog.visible = false">取消</button>
          <button class="confirm-btn" @click="handleSave">保存</button>
        </div>
      </div>
    </div>

    <!-- ==================== 商品列表弹窗 ==================== -->
    <div v-if="productDialog.visible" class="dialog-overlay" @click.self="productDialog.visible = false">
      <div class="dialog dialog-wide">
        <div class="dialog-header">
          <h2>活动商品 - {{ productDialog.activityTitle }}</h2>
          <button class="dialog-close" @click="productDialog.visible = false">✕</button>
        </div>
        <div class="dialog-body">
          <table v-if="productDialog.products.length > 0" class="data-table">
            <thead>
              <tr>
                <th>商品ID</th>
                <th>商品名称</th>
                <th>秒杀价</th>
                <th>秒杀库存</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="p in productDialog.products" :key="p.id || p.productId">
                <td>{{ p.productId }}</td>
                <td>{{ p.productName || '-' }}</td>
                <td>¥{{ formatAmount(p.seckillPrice) }}</td>
                <td>{{ p.seckillStock }}</td>
              </tr>
            </tbody>
          </table>
          <div v-else class="empty-state" style="margin-top:0;padding:30px 0;">
            <div class="empty-text">暂无商品</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import {
  getSeckillList,
  getSeckillDetail,
  createSeckill,
  updateSeckill,
  deleteSeckill
} from '@/api/marketing'
import request from '@/utils/request'

// ==================== 工具函数 ====================
const formatAmount = (val: any): string => {
  const num = Number(val)
  return isNaN(num) ? '0.00' : num.toFixed(2)
}

const formatDateTime = (val: string): string => {
  if (!val) return ''
  try {
    const d = new Date(val)
    if (isNaN(d.getTime())) return val
    const y = d.getFullYear()
    const m = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    const h = String(d.getHours()).padStart(2, '0')
    const min = String(d.getMinutes()).padStart(2, '0')
    const s = String(d.getSeconds()).padStart(2, '0')
    return `${y}-${m}-${day} ${h}:${min}:${s}`
  } catch {
    return val
  }
}

const statusLabel = (status: number): string => {
  if (status === 0) return '草稿'
  if (status === 1) return '进行中'
  if (status === 2) return '已关闭'
  return '未知'
}

const statusClass = (status: number): string => {
  if (status === 0) return 'draft'
  if (status === 1) return 'enabled'
  if (status === 2) return 'disabled'
  return ''
}

// ==================== 列表 ====================
interface SeckillItem {
  id: number
  title: string
  startTime: string
  endTime: string
  status: number
}

const list = ref<SeckillItem[]>([])
const total = ref(0)

const page = reactive({
  page: 1,
  pageSize: 10
})

const totalPages = computed(() => {
  const t = Math.ceil(total.value / page.pageSize)
  return t > 0 ? t : 1
})

const loadList = async () => {
  try {
    const res = await getSeckillList({
      page: page.page,
      pageSize: page.pageSize
    })
    if (res.code === 0) {
      const data = res.data.list || res.data || []
      list.value = data.map((item: any) => ({
        id: item.id,
        title: item.title || item.activityName || '',
        startTime: item.startTime || '',
        endTime: item.endTime || '',
        status: Number(item.status)
      }))
      total.value = res.data.total || data.length
    }
  } catch {
    list.value = []
  }
}

// ==================== 新建/编辑弹窗 ====================
const dialog = reactive({
  visible: false,
  isEdit: false,
  editId: null as number | null,
  form: {
    activityName: '',
    startTime: '',
    endTime: ''
  }
})

const openDialog = (item?: SeckillItem) => {
  if (item) {
    dialog.isEdit = true
    dialog.editId = item.id
    dialog.form = {
      activityName: item.title || '',
      startTime: item.startTime || '',
      endTime: item.endTime || ''
    }
  } else {
    dialog.isEdit = false
    dialog.editId = null
    dialog.form = {
      activityName: '',
      startTime: '',
      endTime: ''
    }
  }
  dialog.visible = true
}

const handleSave = async () => {
  // 时间校验
  if (dialog.form.startTime && dialog.form.endTime) {
    if (new Date(dialog.form.endTime) <= new Date(dialog.form.startTime)) {
      alert('结束时间必须晚于开始时间')
      return
    }
  }

  const data: any = {
    title: dialog.form.activityName,
    startTime: dialog.form.startTime,
    endTime: dialog.form.endTime
  }

  try {
    if (dialog.isEdit && dialog.editId !== null) {
      await updateSeckill(dialog.editId, data)
    } else {
      await createSeckill(data)
    }
    dialog.visible = false
    loadList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '保存失败')
  }
}

// ==================== 操作 ====================
const handlePublish = async (item: SeckillItem) => {
  const now = new Date()
  const startTime = new Date(item.startTime)
  if (startTime <= now) {
    alert('开始时间不可早于发布时间')
    return
  }

  if (!confirm(`确定发布活动"${item.title}"吗？`)) return

  try {
    await request.post(`/admin/seckill-activities/${item.id}/publish`)
    loadList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '发布失败')
  }
}

const handleClose = async (item: SeckillItem) => {
  if (!confirm(`确定关闭活动"${item.title}"吗？关闭后不可恢复。`)) return

  try {
    await request.post(`/admin/seckill-activities/${item.id}/close`)
    loadList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '关闭失败')
  }
}

const handleDelete = async (item: SeckillItem) => {
  if (!confirm(`确定删除活动"${item.title}"吗？此操作将同时删除关联商品，不可恢复。`)) return

  try {
    await deleteSeckill(item.id)
    loadList()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '删除失败')
  }
}

// ==================== 查看商品 ====================
const productDialog = reactive({
  visible: false,
  activityTitle: '',
  products: [] as any[]
})

const handleViewProducts = async (item: SeckillItem) => {
  productDialog.activityTitle = item.title
  try {
    const res = await request.get(`/admin/seckill-activities/${item.id}/products`)
    if (res.code === 0) {
      productDialog.products = res.data || []
    } else {
      productDialog.products = []
    }
  } catch {
    productDialog.products = []
  }
  productDialog.visible = true
}

onMounted(() => {
  loadList()
})
</script>

<style scoped>
.seckill-page {
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
  background: #E5E6EB;
  font-size: 15px;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  font-size: 14px;
  color: #1D2129;
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
</style>
