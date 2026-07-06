<template>
  <div class="distribution-page">
    <div class="page-header">
      <h1>分销设置</h1>
      <p class="subtitle">设置商品分销比例，吸引分销员推广</p>
    </div>

    <!-- 设置区域 -->
    <div class="setting-card">
      <h3>添加分销商品</h3>
      <div class="setting-form">
        <div class="form-item">
          <label>商品ID</label>
          <input v-model="productId" type="number" placeholder="请输入已上架的商品ID" class="input" />
          <button class="btn-search" @click="searchProduct">查找</button>
        </div>
        <div v-if="selectedProduct" class="found-product">
          <span class="found-label">已找到商品：</span>
          <span class="found-name">{{ selectedProduct.title }}</span>
        </div>
        <div v-if="selectError" class="error-text">{{ selectError }}</div>

        <div class="form-item slider-item" v-if="selectedProduct">
          <label>分销比例</label>
          <div class="slider-wrapper">
            <button class="slider-btn" @click="ratio = Math.max(1, ratio - 1)" :disabled="ratio <= 1">−</button>
            <div class="slider-track-wrapper">
              <input type="range" v-model.number="ratio" min="1" max="50" step="1" class="slider" />
              <div class="slider-ticks">
                <span v-for="t in [1, 10, 20, 30, 40, 50]" :key="t" class="tick" :style="{ left: ((t - 1) / 49 * 100) + '%' }">{{ t }}%</span>
              </div>
            </div>
            <button class="slider-btn" @click="ratio = Math.min(50, ratio + 1)" :disabled="ratio >= 50">+</button>
          </div>
          <div class="ratio-display">
            <span class="ratio-value">{{ ratio }}</span>
            <span class="ratio-unit">%</span>
          </div>
        </div>

        <button class="btn-add" @click="addProduct" :disabled="!selectedProduct">添加到分销列表</button>
      </div>
    </div>

    <!-- 已设置列表 -->
    <div class="list-card">
      <h3>已设置分销商品 <span class="count">({{ distributionList.length }})</span></h3>
      <table class="data-table" v-if="distributionList.length > 0">
        <thead>
          <tr>
            <th>商品ID</th>
            <th>商品名称</th>
            <th>分销比例</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in distributionList" :key="item.productId">
            <td>{{ item.productId }}</td>
            <td>{{ item.productName }}</td>
            <td>
              <div class="ratio-cell">
                <button class="mini-btn" @click="adjustRatio(item, -1)" :disabled="(item.commissionRate || item.ratio) <= 1">−</button>
                <span class="ratio-text">{{ item.commissionRate || item.ratio }}%</span>
                <button class="mini-btn" @click="adjustRatio(item, 1)" :disabled="(item.commissionRate || item.ratio) >= 50">+</button>
              </div>
            </td>
            <td>
              <button class="btn-remove" @click="removeProduct(item)">移除</button>
            </td>
          </tr>
        </tbody>
      </table>
      <div v-else class="empty-state">
        <div class="empty-icon">📦</div>
        <div class="empty-text">暂无分销商品，请在上方添加</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

interface DistributionItem {
  id: number
  productId: number
  productName: string
  commissionRate: number
  status: number
}

const productId = ref('')
const ratio = ref(5)
const selectedProduct = ref<any>(null)
const selectError = ref('')
const distributionList = ref<DistributionItem[]>([])

// 加载分销商品列表
const loadList = async () => {
  try {
    const res = await request.get('/merchant/distribution/products')
    if (res.code === 0) {
      distributionList.value = res.data || []
    }
  } catch (e: any) {
    console.error('[分销] 加载列表失败:', e.message)
  }
}

const searchProduct = async () => {
  selectError.value = ''
  selectedProduct.value = null
  const id = Number(productId.value)
  if (!id || id <= 0) {
    selectError.value = '请输入有效的商品ID'
    return
  }
  try {
    const res = await request.get(`/merchant/distribution/product-info/${id}`)
    if (res.code === 0) {
      selectedProduct.value = res.data
    } else {
      selectError.value = res.message || '未找到该商品'
    }
  } catch {
    selectError.value = '查询商品失败，请检查商品ID'
  }
}

const addProduct = async () => {
  if (!selectedProduct.value) return
  try {
    const res = await request.post('/merchant/distribution/products', {
      productId: selectedProduct.value.id,
      commissionRate: ratio.value
    })
    if (res.code === 0) {
      selectedProduct.value = null
      productId.value = ''
      ratio.value = 5
      await loadList()
    } else {
      alert(res.message || '添加失败')
    }
  } catch (e: any) {
    alert('添加失败: ' + (e.message || '网络错误'))
  }
}

const adjustRatio = async (item: DistributionItem, delta: number) => {
  const newRate = Math.max(1, Math.min(50, item.commissionRate + delta))
  try {
    const res = await request.put(`/merchant/distribution/products/${item.id}`, {
      commissionRate: newRate
    })
    if (res.code === 0) {
      item.commissionRate = newRate
    }
  } catch (e: any) {
    console.error('[分销] 更新比例失败:', e.message)
  }
}

const removeProduct = async (item: DistributionItem) => {
  if (!confirm(`确认移除商品 "${item.productName}" 的分销设置？`)) return
  try {
    const res = await request.delete(`/merchant/distribution/products/${item.id}`)
    if (res.code === 0) {
      distributionList.value = distributionList.value.filter(d => d.id !== item.id)
    }
  } catch (e: any) {
    alert('删除失败: ' + (e.message || '网络错误'))
  }
}

onMounted(loadList)
</script>

<style scoped>
.distribution-page { padding: 20px; max-width: 1000px; margin: 0 auto; }
.page-header { margin-bottom: 24px; }
.page-header h1 { font-size: 22px; color: #2D2D2D; margin: 0; }
.subtitle { font-size: 13px; color: #999; margin: 4px 0 0; }

.setting-card, .list-card { background: white; border-radius: 8px; padding: 24px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.setting-card h3, .list-card h3 { font-size: 16px; color: #2D2D2D; margin: 0 0 20px; }
.count { font-weight: normal; color: #999; font-size: 14px; }

.setting-form { display: flex; flex-direction: column; gap: 16px; }
.form-item { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
.form-item label { font-size: 14px; color: #555; min-width: 70px; }
.input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 160px; font-size: 14px; }
.btn-search { padding: 8px 16px; background: #E66100; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }

.found-product { background: #F6FFED; padding: 8px 12px; border-radius: 4px; font-size: 13px; }
.found-label { color: #999; }
.found-name { color: #333; font-weight: 600; }
.error-text { color: #FF4D4F; font-size: 13px; }

.slider-item { flex-direction: column; align-items: flex-start; gap: 8px; }
.slider-wrapper { display: flex; align-items: center; gap: 12px; width: 100%; }

.slider-btn { width: 36px; height: 36px; border: 1px solid #ddd; background: white; border-radius: 4px; cursor: pointer; font-size: 18px; display: flex; align-items: center; justify-content: center; color: #555; }
.slider-btn:hover { background: #f5f5f5; }
.slider-btn:disabled { opacity: 0.4; cursor: default; }

.slider-track-wrapper { flex: 1; position: relative; }
.slider { width: 100%; height: 6px; -webkit-appearance: none; appearance: none; background: #e0e0e0; border-radius: 3px; outline: none; }
.slider::-webkit-slider-thumb { -webkit-appearance: none; width: 22px; height: 22px; background: #E66100; border-radius: 50%; cursor: pointer; border: 2px solid white; box-shadow: 0 1px 4px rgba(0,0,0,0.2); }
.slider-ticks { position: relative; height: 18px; margin-top: 4px; }
.tick { position: absolute; transform: translateX(-50%); font-size: 10px; color: #bbb; }

.ratio-display { display: flex; align-items: baseline; gap: 4px; margin-left: 70px; }
.ratio-value { font-size: 28px; font-weight: bold; color: #E66100; }
.ratio-unit { font-size: 16px; color: #E66100; font-weight: 600; }

.btn-add { padding: 10px 24px; background: #E66100; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; align-self: flex-start; }
.btn-add:disabled { opacity: 0.5; cursor: default; }

.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { padding: 10px 14px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
.data-table th { background: #fafafa; color: #555; font-weight: 600; }
.data-table td { color: #333; }

.ratio-cell { display: flex; align-items: center; justify-content: center; gap: 8px; }
.mini-btn { width: 26px; height: 26px; border: 1px solid #ddd; background: white; border-radius: 4px; cursor: pointer; font-size: 14px; color: #555; }
.mini-btn:hover { background: #f5f5f5; }
.ratio-text { font-size: 15px; font-weight: 600; color: #E66100; min-width: 40px; }

.btn-remove { padding: 4px 12px; background: #FFF2F0; color: #FF4D4F; border: 1px solid #FFCCC7; border-radius: 4px; cursor: pointer; font-size: 12px; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 40px 0; }
.empty-icon { font-size: 40px; margin-bottom: 10px; }
.empty-text { font-size: 13px; color: #999; }
</style>
