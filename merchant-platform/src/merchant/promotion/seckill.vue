<template>
  <div class="seckill-page">
    <!-- ==================== 秒杀活动选择 ==================== -->
    <div class="section-card">
      <h2 class="section-title">秒杀活动</h2>
      <div class="activity-selector">
        <label class="selector-label">选择活动：</label>
        <select v-model="selectedActivityId" class="selector-input" @change="onActivityChange">
          <option :value="null" disabled>请选择秒杀活动</option>
          <option v-for="item in activities" :key="item.id" :value="item.id">
            {{ item.title }}（{{ formatDate(item.startTime) }} ~ {{ formatDate(item.endTime) }}）
          </option>
        </select>
      </div>
    </div>

    <!-- ==================== 已选活动的商品列表 ==================== -->
    <div v-if="selectedActivityId" class="section-card">
      <div class="section-header">
        <h2 class="section-title">我的秒杀商品</h2>
        <button class="btn-primary" @click="openAddModal">添加商品</button>
      </div>

      <div class="table-container">
        <div v-if="productsLoading" class="empty-state">
          <div class="empty-text">加载中...</div>
        </div>
        <table v-else-if="products.length > 0" class="data-table">
          <thead>
            <tr>
              <th>商品ID</th>
              <th>商品名称</th>
              <th>SKU 码</th>
              <th>秒杀价</th>
              <th>秒杀库存</th>
              <th>已售</th>
              <th>限购</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="p in products" :key="p.productId">
              <td>{{ p.productId }}</td>
              <td>{{ p.productName || '-' }}</td>
              <td>{{ p.skuId }}</td>
              <td>¥{{ formatAmount(p.seckillPrice) }}</td>
              <td>{{ p.seckillStock }}</td>
              <td>{{ p.soldCount ?? 0 }}</td>
              <td>{{ p.limitQuantity ?? 1 }}</td>
              <td>
                <button class="btn-link" @click="openEditModal(p)">编辑</button>
                <button class="btn-link btn-danger" @click="handleRemove(p)">移除</button>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="empty-state">
          <div class="empty-icon">⚡</div>
          <div class="empty-text">暂无秒杀商品，点击"添加商品"参与</div>
        </div>
      </div>
    </div>

    <!-- ==================== 添加/编辑商品弹窗 ==================== -->
    <div v-if="showFormModal" class="modal-mask" @click.self="showFormModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingProduct ? '编辑秒杀商品' : '添加秒杀商品' }}</h3>
          <button class="close-btn" @click="showFormModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label>商品ID</label>
            <input v-model.number="form.productId" type="number" min="1" placeholder="请输入商品ID" :disabled="!!editingProduct" />
          </div>
          <div class="form-item">
            <label>SKU 码</label>
            <input v-model="form.skuId" type="text" placeholder="请输入SKU码（可含字母、数字、-）" :disabled="!!editingProduct" />
          </div>
          <div class="form-item">
            <label>秒杀价</label>
            <input v-model.number="form.seckillPrice" type="number" min="0" step="0.01" placeholder="请输入秒杀价格" />
          </div>
          <div class="form-item">
            <label>秒杀库存</label>
            <input v-model.number="form.seckillStock" type="number" min="1" placeholder="请输入秒杀库存" />
          </div>
          <div class="form-item">
            <label>限购数量</label>
            <input v-model.number="form.limitQuantity" type="number" min="1" placeholder="默认 1" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showFormModal = false">取消</button>
          <button class="confirm-btn" @click="saveProduct">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import {
  getSeckillActivities,
  getSeckillProducts,
  addSeckillProduct,
  updateSeckillProduct,
  deleteSeckillProduct
} from '@/api/order'

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

// ==================== 秒杀活动列表 ====================
interface SeckillActivity {
  id: number
  title: string
  startTime: string
  endTime: string
  status: number
}

const activities = ref<SeckillActivity[]>([])
const selectedActivityId = ref<number | null>(null)

const loadActivities = async () => {
  try {
    const res = await getSeckillActivities()
    if (res.code === 0) {
      // 只展示已发布（status=1）的活动
      activities.value = (res.data || []).filter((item: SeckillActivity) => item.status === 1)
    } else {
      activities.value = []
    }
  } catch {
    activities.value = []
  }
}

const onActivityChange = () => {
  loadProducts()
}

// ==================== 秒杀商品 ====================
interface SeckillProduct {
  id: number
  productId: number
  productName?: string
  skuId: string
  seckillPrice: number
  seckillStock: number
  soldCount: number
  limitQuantity: number
}

const products = ref<SeckillProduct[]>([])
const productsLoading = ref(false)

const loadProducts = async () => {
  if (!selectedActivityId.value) return
  productsLoading.value = true
  try {
    const res = await getSeckillProducts(selectedActivityId.value)
    if (res.code === 0) {
      products.value = res.data || []
    } else {
      products.value = []
    }
  } catch {
    products.value = []
  } finally {
    productsLoading.value = false
  }
}

// ==================== 表单弹窗 ====================
const showFormModal = ref(false)
const editingProduct = ref<SeckillProduct | null>(null)

interface ProductForm {
  productId: number | null
  skuId: string | null
  seckillPrice: number | null
  seckillStock: number | null
  limitQuantity: number
}

const form = reactive<ProductForm>({
  productId: null,
  skuId: null,
  seckillPrice: null,
  seckillStock: null,
  limitQuantity: 1
})

const resetForm = () => {
  form.productId = null
  form.skuId = null
  form.seckillPrice = null
  form.seckillStock = null
  form.limitQuantity = 1
}

const openAddModal = () => {
  editingProduct.value = null
  resetForm()
  showFormModal.value = true
}

const openEditModal = (product: SeckillProduct) => {
  editingProduct.value = product
  form.productId = product.productId
  form.skuId = product.skuId
  form.seckillPrice = product.seckillPrice
  form.seckillStock = product.seckillStock
  form.limitQuantity = product.limitQuantity ?? 1
  showFormModal.value = true
}

const saveProduct = async () => {
  if (!form.productId) {
    alert('请输入商品ID')
    return
  }
  if (!form.skuId || !form.skuId.trim()) {
    alert('请输入SKU码')
    return
  }
  if (form.seckillPrice === null || form.seckillPrice < 0) {
    alert('请输入有效的秒杀价')
    return
  }
  if (!form.seckillStock || form.seckillStock < 1) {
    alert('请输入有效的秒杀库存')
    return
  }
  if (!form.limitQuantity || form.limitQuantity < 1) {
    alert('请输入有效的限购数量')
    return
  }

  try {
    if (editingProduct.value) {
      await updateSeckillProduct(editingProduct.value.id, {
        seckillPrice: form.seckillPrice!,
        seckillStock: form.seckillStock!,
        limitQuantity: form.limitQuantity
      })
    } else {
      await addSeckillProduct(selectedActivityId.value!, {
        productId: form.productId,
        skuId: form.skuId,
        seckillPrice: form.seckillPrice!,
        seckillStock: form.seckillStock!,
        limitQuantity: form.limitQuantity
      })
    }
    showFormModal.value = false
    editingProduct.value = null
    loadProducts()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '保存失败')
  }
}

const handleRemove = async (product: SeckillProduct) => {
  if (!confirm(`确定移除商品 ${product.productId} 吗？`)) return
  try {
    await deleteSeckillProduct(product.id)
    loadProducts()
  } catch (e: any) {
    alert(e?.response?.data?.msg || '移除失败')
  }
}

onMounted(() => {
  loadActivities()
})
</script>

<style scoped>
.seckill-page {
  padding: 20px;
  max-width: 1100px;
  margin: 0 auto;
}

/* Section */
.section-card {
  background: white;
  border-radius: 8px;
  padding: 20px 24px;
  margin-bottom: 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.section-title {
  font-size: 18px;
  color: #1D2129;
  margin: 0 0 16px 0;
  font-weight: 600;
}

.section-header .section-title {
  margin-bottom: 0;
}

/* Activity Selector */
.activity-selector {
  display: flex;
  align-items: center;
  gap: 10px;
}

.selector-label {
  font-size: 14px;
  color: #4E5969;
  white-space: nowrap;
}

.selector-input {
  flex: 1;
  max-width: 500px;
  padding: 8px 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 13px;
  color: #1D2129;
}

/* Table */
.table-container {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 10px 12px;
  text-align: left;
  border-bottom: 1px solid #F2F3F5;
  font-size: 13px;
}

.data-table th {
  background: #F7F8FA;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  color: #1D2129;
}

.btn-link {
  background: none;
  border: none;
  color: #165DFF;
  cursor: pointer;
  font-size: 13px;
  padding: 0;
  margin-right: 10px;
}

.btn-link:hover {
  text-decoration: underline;
}

.btn-danger {
  color: #FF4D4F;
}

.btn-primary {
  padding: 8px 16px;
  background: #165DFF;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 13px;
  cursor: pointer;
}

.btn-primary:hover {
  background: #4080FF;
}

/* Empty */
.empty-state {
  text-align: center;
  padding: 48px 20px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-text {
  font-size: 14px;
  color: #86909C;
}

/* Modal */
.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  width: 500px;
  max-height: 80vh;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
}

.modal-header h3 {
  font-size: 16px;
  color: #1D2129;
  margin: 0;
}

.close-btn {
  font-size: 20px;
  background: none;
  border: none;
  cursor: pointer;
  color: #86909C;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
  flex: 1;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 14px 20px;
  border-top: 1px solid #f0f0f0;
}

.cancel-btn {
  padding: 8px 16px;
  background: #F2F3F5;
  color: #4E5969;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.confirm-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

/* Form */
.form-item {
  margin-bottom: 14px;
}

.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 13px;
  color: #4E5969;
  font-weight: 500;
}

.form-item input,
.form-item select {
  width: 100%;
  box-sizing: border-box;
  padding: 8px 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 13px;
}
</style>
