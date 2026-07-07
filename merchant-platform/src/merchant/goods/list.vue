<template>
  <div class="goods-page">
    <div class="page-header">
      <h2>商品管理</h2>
      <button class="add-btn" @click="openAddModal">+ 添加商品</button>
    </div>

    <div class="filter-bar">
      <input v-model="keyword" placeholder="商品名称 / SKU编码搜索" class="search-input" @keyup.enter="searchGoods" />
      <select v-model="categoryId1" class="filter-select" @change="onFilterLevel1Change">
        <option value="">一级分类</option>
        <option v-for="cat in level1Categories" :key="cat.categoryId" :value="cat.categoryId">{{ cat.categoryName }}</option>
      </select>
      <select v-model="categoryId2" class="filter-select">
        <option value="">二级分类</option>
        <option v-for="cat in level2Categories" :key="cat.categoryId" :value="cat.categoryId">{{ cat.categoryName }}</option>
      </select>
      <select v-model="filterStatus" class="filter-select">
        <option value="">全部状态</option>
        <option value="1">上架中</option>
        <option value="0">已下架</option>
      </select>
      <select v-model="filterAuditStatus" class="filter-select">
        <option value="">全部审核</option>
        <option value="0">待审核</option>
        <option value="1">已通过</option>
        <option value="2">已驳回</option>
      </select>
      <button class="search-btn" @click="searchGoods">搜索</button>
    </div>

    <div class="goods-list">
      <div v-for="goods in goodsList" :key="goods.productId" class="goods-card">
        <div class="goods-id">ID: {{ goods.productId }}</div>
        <div class="goods-image">
          <img :src="goods.mainImage" :alt="goods.title" />
        </div>
        <div class="goods-info">
          <h3 class="goods-title">{{ goods.title }}</h3>
          <div class="goods-price">
            <span class="price">¥{{ (goods.minPrice || 0).toFixed(2) }}</span>
          </div>
          <div class="goods-meta">
            <span class="meta-item">库存: {{ goods.totalStock || 0 }}</span>
            <span class="meta-item">销量: 0</span>
            <span :class="['status-tag', getStatusTag(goods).class]">{{ getStatusTag(goods).text }}</span>
          </div>
          <div v-if="goods.auditStatus === 2 && goods.auditRemark" class="audit-remark">
            驳回原因：{{ goods.auditRemark }}
          </div>
          <div class="goods-actions">
            <template v-if="goods.auditStatus === 0">
              <!-- 审核中：无按钮 -->
            </template>
            <template v-else-if="goods.auditStatus === 2">
              <button class="action-btn edit" @click="editGoods(goods)">重新提交审核</button>
            </template>
            <template v-else>
              <button v-if="goods.status === 1" class="action-btn off" @click="toggleShelf(goods)">下架</button>
              <button v-else class="action-btn on" @click="toggleShelf(goods)">上架</button>
              <button class="action-btn edit" @click="editGoods(goods)">编辑</button>
            </template>
          </div>
        </div>
      </div>
    </div>

    <div v-if="totalCount > pageSize" class="pagination">
      <button :disabled="currentPage <= 1" @click="prevPage">上一页</button>
      <span>{{ currentPage }} / {{ totalPages }}</span>
      <button :disabled="currentPage >= totalPages" @click="nextPage">下一页</button>
    </div>

    <div v-if="showAddModal" class="modal-mask" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingGoods ? '编辑商品' : '添加商品' }}</h3>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label>商品名称</label>
            <input v-model="form.title" placeholder="请输入商品名称" />
          </div>
          <div class="form-item">
            <label>副标题</label>
            <input v-model="form.subTitle" placeholder="请输入副标题" />
          </div>
          <div class="form-row">
            <div class="form-item">
              <label>一级分类</label>
              <select v-model="form.categoryId1" @change="onFormLevel1Change">
                <option :value="0">请选择一级分类</option>
                <option v-for="cat in level1Categories" :key="cat.categoryId" :value="cat.categoryId">{{ cat.categoryName }}</option>
            </select>
          </div>
          <div class="form-item">
            <label>二级分类</label>
            <select v-model="form.categoryId2">
              <option :value="0">请选择二级分类</option>
              <option v-for="cat in formLevel2Categories" :key="cat.categoryId" :value="cat.categoryId">{{ cat.categoryName }}</option>
              </select>
            </div>
          </div>
          <div class="form-item">
            <label>品牌名称</label>
            <div class="brand-search">
              <input
                v-model="brandKeyword"
                type="text"
                placeholder="输入关键字搜索品牌（非必填）"
                @input="onBrandSearch"
                @focus="onBrandSearch"
                @blur="onBrandBlur"
              />
              <ul v-if="brandOptions.length > 0" class="brand-dropdown">
                <li
                  v-for="b in brandOptions"
                  :key="b.brandId"
                  @mousedown.prevent="selectBrand(b)"
                >{{ b.brandName }}</li>
              </ul>
            </div>
          </div>
          <div class="form-item">
            <label>商品主图</label>
            <div class="upload-area">
              <input type="file" accept="image/*" @change="onMainImageChange" />
              <span v-if="uploadingMainImage" class="upload-tip">上传中...</span>
              <img v-if="form.mainImage" :src="form.mainImage" class="upload-preview" />
            </div>
          </div>
          <div class="form-item">
            <label>商品详情图</label>
            <div class="upload-area">
              <input type="file" accept="image/*" multiple @change="onDetailImagesChange" />
              <span v-if="uploadingDetailImages" class="upload-tip">上传中...</span>
              <div class="detail-images-preview">
                <img v-for="(url, idx) in form.detailImages" :key="idx" :src="url" class="upload-preview" />
              </div>
            </div>
          </div>
          <div class="form-item">
            <label>商品详情描述</label>
            <textarea v-model="form.detailDesc" placeholder="请输入商品详情描述"></textarea>
          </div>
          <div class="form-item">
            <label>销售方式</label>
            <div class="radio-group">
              <label><input type="radio" v-model="form.saleType" :value="1" /> 仅自提</label>
              <label><input type="radio" v-model="form.saleType" :value="2" /> 仅配送</label>
              <label><input type="radio" v-model="form.saleType" :value="3" /> 均可</label>
            </div>
          </div>
          <div class="form-item">
            <label>SKU列表</label>
            <div class="sku-list">
              <div v-for="(sku, idx) in form.skus" :key="idx" class="sku-row">
                <input v-model="sku.specs" placeholder="规格" />
                <input v-model.number="sku.price" type="number" placeholder="价格" />
                <input v-model.number="sku.stock" type="number" placeholder="库存" />
                <input v-model="sku.skuCode" placeholder="SKU编码" />
                <button class="sku-remove-btn" @click="removeSku(idx)">×</button>
              </div>
              <button class="sku-add-btn" @click="addSku">+ 添加SKU</button>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="closeModal">取消</button>
          <button class="confirm-btn" @click="submitGoods">{{ editingGoods ? '保存修改' : '提交审核' }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { getGoodsList, getGoodsDetail, getCategories, searchBrands, createGoods, updateGoods, updateGoodsStatus, uploadImage } from '@/api/goods'

// ---------- filter state ----------
const keyword = ref('')
const categoryId1 = ref('')
const categoryId2 = ref('')
const filterStatus = ref('')
const filterAuditStatus = ref('')
const currentPage = ref(1)
const pageSize = 15
const totalCount = ref(0)
const totalPages = computed(() => Math.max(1, Math.ceil(totalCount.value / pageSize)))

// ---------- data ----------
const goodsList = ref<any[]>([])
const level1Categories = ref<any[]>([])
const level2Categories = ref<any[]>([])

// ---------- modal state ----------
const showAddModal = ref(false)
const editingGoods = ref<any>(null)
const uploadingMainImage = ref(false)
const uploadingDetailImages = ref(false)
const formLevel2Categories = ref<any[]>([])
const brandKeyword = ref('')
const brandOptions = ref<any[]>([])
const selectedBrandId = ref<number | null>(null)

const emptySku = () => ({ specs: '', price: 0, stock: 0, skuCode: '' })

const form = reactive({
  title: '',
  subTitle: '',
  categoryId1: 0,
  categoryId2: 0,
  brandName: '',
  mainImage: '',
  detailImages: [] as string[],
  detailDesc: '',
  saleType: 3,
  skus: [emptySku()] as { specs: string; price: number; stock: number; skuCode: string }[]
})

// ---------- status tag helper ----------
const getStatusTag = (product: any) => {
  if (product.auditStatus === 0) return { text: '待审核', class: 'pending' }
  if (product.auditStatus === 2) return { text: '审核驳回', class: 'rejected' }
  if (product.status === 1) return { text: '已上架', class: 'onshelf' }
  return { text: '已下架', class: 'offshelf' }
}

// ---------- API calls ----------
const loadData = async () => {
  const params: any = { pageNum: currentPage.value, pageSize }
  if (keyword.value) params.keyword = keyword.value
  if (categoryId2.value) params.categoryId = categoryId2.value
  else if (categoryId1.value) params.categoryId = categoryId1.value
  if (filterStatus.value !== '') params.status = filterStatus.value
  if (filterAuditStatus.value !== '') params.auditStatus = filterAuditStatus.value

  try {
    const res = await getGoodsList(params)
    if (res.code === 0) {
      goodsList.value = res.data.list || []
      totalCount.value = res.data.total || 0
      console.log('[商品列表] 加载成功, count=', goodsList.value.length, 'total=', totalCount.value)
    } else {
      console.error('[商品列表] 接口返回错误:', res.message)
    }
  } catch (e: any) {
    console.error('[商品列表] 加载失败:', e.message || e)
  }
}

const loadCategories = async (parentId?: number) => {
  try {
    const res = await getCategories(parentId)
    if (res.code === 0) {
      if (parentId === undefined || parentId === 0) {
        level1Categories.value = res.data || []
        console.log('[分类] 一级分类加载成功, count=', level1Categories.value.length)
      } else {
        level2Categories.value = res.data || []
        console.log('[分类] 二级分类加载成功, count=', level2Categories.value.length)
      }
    } else {
      console.error('[分类] 接口返回错误:', res.message)
    }
  } catch (e: any) {
    console.error('[分类] 加载失败:', e.message || e)
  }
}

const loadFormLevel2Categories = async (parentId: number) => {
  if (!parentId) {
    formLevel2Categories.value = []
    return
  }
  const res = await getCategories(parentId)
  if (res.code === 0) {
    formLevel2Categories.value = res.data || []
  }
}

// ---------- brand search ----------
let brandSearchTimer: any = null
const onBrandSearch = () => {
  clearTimeout(brandSearchTimer)
  brandSearchTimer = setTimeout(async () => {
    const kw = brandKeyword.value.trim()
    try {
      const res = await searchBrands(kw || undefined)
      if (res.code === 0) {
        brandOptions.value = res.data || []
      }
    } catch { brandOptions.value = [] }
  }, 200)
}
const selectBrand = (b: any) => {
  brandKeyword.value = b.brandName
  selectedBrandId.value = b.brandId
  form.brandName = b.brandName
  brandOptions.value = []
}
const onBrandBlur = () => {
  setTimeout(() => {
    brandOptions.value = []
    // 未从下拉列表选择则清空输入
    if (!selectedBrandId.value || brandKeyword.value !== form.brandName) {
      brandKeyword.value = ''
      selectedBrandId.value = null
      form.brandName = ''
    }
  }, 150)
}

// ---------- filter handlers ----------
const searchGoods = () => {
  currentPage.value = 1
  loadData()
}

const onFilterLevel1Change = () => {
  categoryId2.value = ''
  if (categoryId1.value) {
    loadCategories(Number(categoryId1.value))
  } else {
    level2Categories.value = []
  }
}

const onFormLevel1Change = () => {
  form.categoryId2 = 0
  loadFormLevel2Categories(form.categoryId1)
}

// ---------- pagination ----------
const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    loadData()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    loadData()
  }
}

// ---------- actions ----------
const openAddModal = () => {
  editingGoods.value = null
  resetForm()
  showAddModal.value = true
}

const editGoods = async (goods: any) => {
  // 先获取商品详情（包含完整字段）
  try {
    const detailRes = await getGoodsDetail(goods.productId)
    if (detailRes.code === 0) {
      const detail = detailRes.data
      editingGoods.value = detail
      form.title = detail.title || ''
      form.subTitle = detail.subTitle || ''
      form.categoryId1 = detail.categoryIds ? detail.categoryIds[0] || 0 : (detail.categoryId1 || 0)
      form.categoryId2 = detail.categoryIds ? detail.categoryIds[1] || 0 : (detail.categoryId2 || 0)
      form.brandName = detail.brandName || ''
      brandKeyword.value = detail.brandName || ''
      selectedBrandId.value = detail.brandId || null
      form.mainImage = detail.mainImage || ''
      form.detailImages = detail.detailImages || []
      form.detailDesc = detail.detailDesc || ''
      form.saleType = detail.saleType || 3
      form.skus = (detail.skuList && detail.skuList.length > 0)
        ? detail.skuList.map((s: any) => ({ specs: s.specs || '', price: s.price || 0, stock: s.stock || 0, skuCode: s.skuCode || '' }))
        : [emptySku()]

      if (form.categoryId1) {
        await loadFormLevel2Categories(form.categoryId1)
      }
    }
  } catch (e: any) {
    console.error('[编辑商品] 获取详情失败:', e.message || e)
    alert('获取商品详情失败')
    return
  }

  showAddModal.value = true
}

const toggleShelf = async (goods: any) => {
  const newStatus = goods.status === 1 ? 0 : 1
  const res = await updateGoodsStatus(goods.productId, newStatus)
  if (res.code === 0) {
    goods.status = newStatus
  }
}

const submitGoods = async () => {
  if (!form.title || !form.mainImage) {
    alert('商品名称和主图不能为空')
    return
  }
  if (!form.categoryId1) {
    alert('请选择一级分类')
    return
  }
  if (!form.skus || form.skus.length === 0 || !form.skus[0].specs) {
    alert('请至少添加一个SKU')
    return
  }

  const data: any = {
    title: form.title,
    subTitle: form.subTitle || undefined,
    categoryIds: [form.categoryId1, form.categoryId2].filter(Boolean),
    brandId: selectedBrandId.value || undefined,
    brandName: form.brandName || undefined,
    mainImage: form.mainImage,
    detailImages: form.detailImages.length > 0 ? form.detailImages : undefined,
    detailDesc: form.detailDesc || undefined,
    saleType: form.saleType,
    skuList: form.skus.filter(s => s.specs).map(s => ({
      specs: s.specs,
      price: s.price,
      stock: s.stock,
      skuCode: s.skuCode || undefined
    }))
  }

  if (editingGoods.value) {
    const res = await updateGoods(editingGoods.value.productId, data)
    if (res.code === 0) {
      closeModal()
      loadData()
    }
  } else {
    const res = await createGoods(data)
    if (res.code === 0) {
      closeModal()
      loadData()
    }
  }
}

const closeModal = () => {
  showAddModal.value = false
  editingGoods.value = null
  resetForm()
}

const resetForm = () => {
  form.title = ''
  form.subTitle = ''
  form.categoryId1 = 0
  form.categoryId2 = 0
  form.brandName = ''
  form.mainImage = ''
  form.detailImages = []
  form.detailDesc = ''
  form.saleType = 3
  form.skus = [emptySku()]
  formLevel2Categories.value = []
  brandKeyword.value = ''
  brandOptions.value = []
  selectedBrandId.value = null
}

// ---------- SKU ----------
const addSku = () => {
  form.skus.push(emptySku())
}

const removeSku = (idx: number) => {
  if (form.skus.length <= 1) return
  form.skus.splice(idx, 1)
}

// ---------- file upload ----------
const onMainImageChange = async (e: Event) => {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  uploadingMainImage.value = true
  try {
    const res = await uploadImage(file, 'product')
    if (res.code === 0) {
      form.mainImage = res.data.url
    }
  } finally {
    uploadingMainImage.value = false
    input.value = ''
  }
}

const onDetailImagesChange = async (e: Event) => {
  const input = e.target as HTMLInputElement
  const files = input.files
  if (!files || files.length === 0) return
  uploadingDetailImages.value = true
  try {
    for (let i = 0; i < files.length; i++) {
      const res = await uploadImage(files[i], 'product')
      if (res.code === 0) {
        form.detailImages.push(res.data.url)
      }
    }
  } finally {
    uploadingDetailImages.value = false
    input.value = ''
  }
}

// ---------- init ----------
onMounted(() => {
  loadData()
  loadCategories()
})
</script>

<style scoped>
.goods-page {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  font-size: 20px;
  color: #1D2129;
}

.add-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  padding: 16px;
  background: white;
  border-radius: 8px;
}

.search-input {
  flex: 1;
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.filter-select {
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.search-btn {
  padding: 10px 20px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.goods-list {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
}

.goods-card {
  background: white;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}

.goods-id {
  padding: 4px 8px 0;
  font-size: 10px;
  color: #C9CDD4;
}

.goods-image {
  width: 100%;
  height: 130px;
  overflow: hidden;
}

.goods-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.goods-info {
  padding: 12px;
}

.goods-title {
  font-size: 13px;
  font-weight: 600;
  color: #1D2129;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.goods-desc {
  font-size: 12px;
  color: #86909C;
  margin-bottom: 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.goods-price {
  margin-bottom: 6px;
}

.price {
  font-size: 15px;
  font-weight: bold;
  color: #FF4D4F;
}

.original-price {
  font-size: 13px;
  color: #86909C;
  text-decoration: line-through;
  margin-left: 8px;
}

.goods-meta {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.meta-item {
  font-size: 12px;
  color: #86909C;
}

.status-tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.onshelf {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.offshelf {
  background: #F2F3F5;
  color: #86909C;
}

.status-tag.pending {
  background: #FFF7E6;
  color: #FA8C16;
}

.status-tag.rejected {
  background: #FFF2F0;
  color: #FF4D4F;
}

.audit-remark {
  font-size: 12px;
  color: #FF4D4F;
  margin-bottom: 12px;
  padding: 4px 8px;
  background: #FFF2F0;
  border-radius: 4px;
}

.goods-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  flex: 1;
  padding: 6px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.action-btn.edit {
  background: #E6F7FF;
  color: #1890FF;
}

.action-btn.on {
  background: #F6FFED;
  color: #52C41A;
}

.action-btn.off {
  background: #FFF7E6;
  color: #FA8C16;
}

.action-btn.delete {
  background: #FFF2F0;
  color: #FF4D4F;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 24px;
  padding: 16px;
}

.pagination button {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.pagination button:disabled {
  background: #C9CDD4;
  cursor: not-allowed;
}

.pagination span {
  font-size: 14px;
  color: #4E5969;
}

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
  width: 600px;
  max-height: 80vh;
  background: white;
  border-radius: 8px;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
  position: sticky;
  top: 0;
  background: white;
  z-index: 1;
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
}

.form-item {
  margin-bottom: 16px;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #4E5969;
}

.form-item input, .form-item textarea, .form-item select {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.form-item textarea {
  height: 80px;
  resize: vertical;
}

.radio-group {
  display: flex;
  gap: 20px;
}

.radio-group label {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
  color: #4E5969;
  margin-bottom: 0;
}

.radio-group input[type="radio"] {
  width: auto;
}

.upload-area {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.upload-tip {
  font-size: 12px;
  color: #165DFF;
}

.upload-preview {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 4px;
  border: 1px solid #dcdcdc;
}

.detail-images-preview {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.sku-list {
  border: 1px solid #f0f0f0;
  border-radius: 4px;
  padding: 12px;
}

.sku-row {
  display: flex;
  gap: 8px;
  margin-bottom: 8px;
  align-items: center;
}

.sku-row input {
  flex: 1;
  min-width: 0;
}

.sku-remove-btn {
  width: 28px;
  height: 28px;
  background: #FFF2F0;
  color: #FF4D4F;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  line-height: 28px;
  text-align: center;
  flex-shrink: 0;
}

.sku-add-btn {
  padding: 6px 12px;
  background: #E6F7FF;
  color: #1890FF;
  border: 1px dashed #1890FF;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.brand-search {
  position: relative;
}

.brand-search input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.brand-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  max-height: 180px;
  overflow-y: auto;
  background: #fff;
  border: 1px solid #dcdcdc;
  border-top: none;
  border-radius: 0 0 4px 4px;
  z-index: 100;
  list-style: none;
  padding: 0;
  margin: 0;
}

.brand-dropdown li {
  padding: 8px 12px;
  cursor: pointer;
  font-size: 14px;
  color: #1D2129;
}

.brand-dropdown li:hover {
  background: #E6F7FF;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 20px;
  border-top: 1px solid #f0f0f0;
  position: sticky;
  bottom: 0;
  background: white;
}

.cancel-btn {
  padding: 8px 16px;
  background: #F2F3F5;
  color: #4E5969;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.confirm-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
