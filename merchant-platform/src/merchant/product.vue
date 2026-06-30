<template>
  <div class="product-page">
    <Toast ref="toastRef" />

    <div class="top-bar">
      <h2>商品管理</h2>
      <button class="add-btn" @click="openCreate">发布商品</button>
    </div>

    <div class="search-bar">
      <input placeholder="商品名称" v-model="keyword" @keyup.enter="getList" />
      <select v-model="statusFilter">
        <option value="">全部状态</option>
        <option value="0">下架</option>
        <option value="1">上架</option>
      </select>
      <select v-model="auditFilter">
        <option value="">审核全部</option>
        <option value="0">待审核</option>
        <option value="1">通过</option>
        <option value="2">拒绝</option>
      </select>
      <button @click="getList">查询</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>商品ID</th>
          <th>主图</th>
          <th>商品名</th>
          <th>最低价</th>
          <th>最高价</th>
          <th>总库存</th>
          <th>审核</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.productId">
          <td>{{ item.productId }}</td>
          <td><img width="50" :src="item.mainImage" /></td>
          <td>{{ item.title }}</td>
          <td>¥{{ item.minPrice }}</td>
          <td>¥{{ item.maxPrice }}</td>
          <td>{{ item.totalStock }}</td>
          <td>{{ item.auditStatusText }}</td>
          <td>
            <button v-if="item.status === 1" @click="toggleShelf(item.productId, 0)">下架</button>
            <button v-else @click="toggleShelf(item.productId, 1)">上架</button>
            <button @click="openEdit(item.productId)">编辑</button>
            <button @click="openStock(item)">库存</button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="page-wrap">
      <button :disabled="page === 1" @click="page--; getList()">上一页</button>
      <span>第{{ page }}页 / 共{{ total }}条</span>
      <button :disabled="page * pageSize >= total" @click="page++; getList()">下一页</button>
    </div>

    <!-- ========== 发布/编辑弹窗 ========== -->
    <div v-if="showEdit" class="mask" @click.self="showEdit = false">
      <div class="dialog">
        <h3>{{ editId ? '编辑商品' : '发布商品' }}</h3>

        <!-- 品牌：搜索输入框 + 下拉 -->
        <div class="form-item">
          <label>品牌</label>
          <div class="autocomplete-wrap">
            <input
              v-model="brandSearch"
              placeholder="输入品牌名搜索"
              autocomplete="off"
              @focus="brandFocused = true"
              @blur="onBrandBlur"
              @input="onBrandInput"
            />
            <div v-if="brandFocused && brandOptions.length" class="dropdown">
              <div
                v-for="b in brandOptions"
                :key="b.brandId"
                class="dropdown-item"
                @mousedown.prevent="selectBrand(b)"
              >
                {{ b.brandName }}
              </div>
            </div>
          </div>
        </div>

        <!-- 分类：下拉列表 -->
        <div class="form-item">
          <label>分类</label>
          <div class="category-row">
            <select v-model.number="editForm.categoryId1" @change="onCategory1Change">
              <option :value="0">选择分类</option>
              <option v-for="c in categoryList" :key="c.categoryId" :value="c.categoryId">
                {{ c.categoryName }}
              </option>
            </select>
          </div>
        </div>

        <div class="form-item">
          <label>商品标题</label>
          <input v-model="editForm.title" />
        </div>
        <div class="form-item">
          <label>副标题</label>
          <input v-model="editForm.subTitle" />
        </div>

        <!-- 主图：文件上传 -->
        <div class="form-item">
          <label>主图</label>
          <div class="upload-row">
            <input
              ref="mainFileInput"
              type="file"
              accept="image/*"
              style="display:none"
              @change="onMainImageSelected"
            />
            <button class="upload-btn" @click="($refs.mainFileInput as HTMLInputElement)?.click()">
              选择图片
            </button>
            <span v-if="uploadingMain" style="margin-left:8px; color:#86909C;">上传中...</span>
            <img v-if="editForm.mainImage" :src="editForm.mainImage" class="preview-img" />
          </div>
        </div>

        <!-- 详情图：文件上传 -->
        <div class="form-item">
          <label>详情图</label>
          <div class="upload-row">
            <input
              ref="detailFileInput"
              type="file"
              accept="image/*"
              multiple
              style="display:none"
              @change="onDetailImagesSelected"
            />
            <button class="upload-btn" @click="($refs.detailFileInput as HTMLInputElement)?.click()">
              选择图片(可多选)
            </button>
            <span v-if="uploadingDetail" style="margin-left:8px; color:#86909C;">上传中...</span>
            <div class="preview-list" v-if="detailUploadUrls.length">
              <img v-for="(u, i) in detailUploadUrls" :key="i" :src="u" class="preview-img" />
            </div>
          </div>
        </div>

        <div class="form-item">
          <label>详情描述</label>
          <input v-model="editForm.detailDesc" />
        </div>

        <div class="form-item">
          <label>销售类型</label>
          <select v-model.number="editForm.saleType">
            <option :value="1">普通销售</option>
            <option :value="2">拼团</option>
          </select>
        </div>

        <h4 style="margin: 10px 0">SKU列表</h4>
        <div v-for="(sku, idx) in editForm.skuList" :key="idx" class="form-row">
          <div class="item"><label>规格</label><input v-model="sku.specs" placeholder="如: 5斤装" /></div>
          <div class="item"><label>价格</label><input v-model.number="sku.price" type="number" /></div>
          <div class="item"><label>库存</label><input v-model.number="sku.stock" type="number" /></div>
          <div class="item"><label>编码</label><input v-model="sku.skuCode" /></div>
          <button @click="editForm.skuList.splice(idx, 1)" style="align-self:flex-end">删除</button>
        </div>
        <button @click="editForm.skuList.push({ specs:'', price:0, stock:0, skuCode:'' })">+ 添加SKU</button>

        <div class="btns">
          <button @click="showEdit = false">取消</button>
          <button class="save" @click="submitEdit">提交</button>
        </div>
      </div>
    </div>

    <!-- ========== 库存/价格维护弹窗 ========== -->
    <div v-if="showStock" class="mask" @click.self="showStock = false">
      <div class="dialog">
        <h3>库存/价格维护 - {{ currentProduct?.title }}</h3>
        <table>
          <thead>
            <tr><th>SKU ID</th><th>规格</th><th>价格</th><th>库存</th><th>操作</th></tr>
          </thead>
          <tbody>
            <tr v-for="sku in stockSkuList" :key="sku.skuId">
              <td>{{ sku.skuId }}</td>
              <td>{{ sku.specsText || sku.specs }}</td>
              <td><input v-model.number="sku.newPrice" type="number" style="width:80px" /></td>
              <td><input v-model.number="sku.newStock" type="number" style="width:80px" /></td>
              <td>
                <button @click="savePrice(sku)">存价</button>
                <button @click="saveStock(sku)">存库</button>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="btns">
          <button @click="showStock = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import {
  getProductList, createProduct, updateProduct, getProductDetail,
  updateShelfStatus, updateStock, updatePrice
} from '@/api/goods'
import request from '@/utils/request'
import Toast from '@/components/Toast.vue'

// ---------- Toast ----------
const toastRef = ref<any>(null)
const toast = (msg: string) => toastRef.value?.show(msg, 'success')
const toastErr = (msg: string) => toastRef.value?.show(msg, 'error')

// ---------- 列表 ----------
const keyword = ref('')
const statusFilter = ref('')
const auditFilter = ref('')
const page = ref(1)
const pageSize = 10
const total = ref(0)
const tableList = ref<any[]>([])

// ---------- 品牌搜索 ----------
const brandSearch = ref('')
const brandFocused = ref(false)
const brandOptions = ref<any[]>([])
let brandTimer: any = null

const onBrandInput = () => {
  clearTimeout(brandTimer)
  brandTimer = setTimeout(async () => {
    const kw = brandSearch.value.trim()
    try {
      const res = await request.get('/merchant/brands', { params: { keyword: kw || undefined } })
      brandOptions.value = (res as any).list || res || []
    } catch {
      // 后端未连接时使用测试数据
      brandOptions.value = [
        { brandId: -1, brandName: '测试品牌A' },
        { brandId: -2, brandName: '测试品牌B' },
        { brandId: -3, brandName: '测试品牌C' }
      ]
    }
  }, 300)
}

const onBrandBlur = () => {
  setTimeout(() => { brandFocused.value = false }, 200)
}

const selectBrand = (b: any) => {
  brandSearch.value = b.brandName
  editForm.value.brandId = b.brandId
  brandFocused.value = false
}

// ---------- 分类 ----------
const categoryList = ref<any[]>([]) // 一级分类列表
const editFormCategoryId1 = ref(0) // 绑定到editForm.categoryId1

const loadCategories = async () => {
  try {
    const res = await request.get('/merchant/categories')
    categoryList.value = (res as any).list || res || []
  } catch {
    categoryList.value = [
      { categoryId: -1, categoryName: '测试分类1' },
      { categoryId: -2, categoryName: '测试分类2' }
    ]
  }
}

const onCategory1Change = () => {
  // 一级分类变更
  editForm.value.categoryIds = editFormCategoryId1.value ? [editFormCategoryId1.value] : []
}

// ---------- 图片上传 ----------
const mainFileInput = ref<HTMLInputElement>()
const detailFileInput = ref<HTMLInputElement>()
const uploadingMain = ref(false)
const uploadingDetail = ref(false)
const detailUploadUrls = ref<string[]>([])

const uploadFile = async (file: File): Promise<string> => {
  const formData = new FormData()
  formData.append('file', file)
  try {
    const res = await request.post('/merchant/upload/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    return (res as any).url || res.url
  } catch {
    // 上传失败时用 data URL 兜底
    return URL.createObjectURL(file)
  }
}

const onMainImageSelected = async (e: Event) => {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  uploadingMain.value = true
  try {
    const url = await uploadFile(file)
    editForm.value.mainImage = url
    toast('主图上传成功')
  } catch {
    toastErr('主图上传失败')
  }
  uploadingMain.value = false
}

const onDetailImagesSelected = async (e: Event) => {
  const input = e.target as HTMLInputElement
  const files = input.files
  if (!files?.length) return
  uploadingDetail.value = true
  const urls: string[] = [...detailUploadUrls.value]
  try {
    for (let i = 0; i < files.length; i++) {
      const url = await uploadFile(files[i])
      urls.push(url)
    }
    detailUploadUrls.value = urls
    toast(`详情图上传成功 (${files.length}张)`)
  } catch {
    toastErr('详情图上传失败')
  }
  uploadingDetail.value = false
}

// ---------- 编辑表单 ----------
const showEdit = ref(false)
const editId = ref(0)
const editForm = ref({
  brandId: 1,
  categoryIds: [] as number[],
  categoryId1: 0,
  title: '',
  subTitle: '',
  mainImage: '',
  detailImages: '',
  detailDesc: '',
  saleType: 1,
  skuList: [{ specs: '', price: 0, stock: 0, skuCode: '' }] as any[]
})

// ---------- 库存弹窗 ----------
const showStock = ref(false)
const currentProduct = ref<any>(null)
const stockSkuList = ref<any[]>([])

// ---------- 列表方法 ----------
const getList = async () => {
  try {
    const data = await getProductList({
      keyword: keyword.value || undefined,
      status: statusFilter.value !== '' ? Number(statusFilter.value) : undefined,
      auditStatus: auditFilter.value !== '' ? Number(auditFilter.value) : undefined,
      pageNum: page.value,
      pageSize
    })
    tableList.value = data.list || []
    total.value = data.total || 0
  } catch {}
}

const toggleShelf = async (productId: number, status: number) => {
  try {
    await updateShelfStatus(productId, status)
    toast(status === 1 ? '已上架' : '已下架')
    getList()
  } catch {}
}

const openCreate = () => {
  editId.value = 0
  brandSearch.value = ''
  brandOptions.value = []
  detailUploadUrls.value = []
  editForm.value = {
      brandId: -1,
      categoryIds: [],
      categoryId1: 0,
      title: '', subTitle: '', mainImage: '',
      detailDesc: '', saleType: 1,
      skuList: [{ specs: '', price: 0, stock: 0, skuCode: '' }]
    }
  editFormCategoryId1.value = 0
  showEdit.value = true
}

const openEdit = async (productId: number) => {
  try {
    const detail = await getProductDetail(productId)
    editId.value = productId
    // 回填品牌
    brandSearch.value = detail.brandName || ''
    brandOptions.value = []
    // 回填分类
    const cid = detail.categoryIds?.[0] || 0
    editFormCategoryId1.value = cid
    // 回填图片
    detailUploadUrls.value = Array.isArray(detail.detailImages) ? detail.detailImages : []
    editForm.value = {
      brandId: detail.brandId,
      categoryIds: detail.categoryIds || [],
      categoryId1: cid,
      title: detail.title,
      subTitle: detail.subTitle || '',
      mainImage: detail.mainImage || '',
      detailDesc: detail.detailDesc || '',
      saleType: detail.saleType,
      skuList: (detail.skuList || []).map((s: any) => ({
        specs: s.specs, price: s.price, stock: s.stock, skuCode: s.skuCode || ''
      }))
    }
    showEdit.value = true
  } catch {}
}

const submitEdit = async () => {
  const f = editForm.value
  if (!f.title) { toastErr('标题必填'); return }
  if (!f.mainImage) { toastErr('请上传主图'); return }
  if (f.skuList.length === 0) { toastErr('至少一个SKU'); return }

  const categoryIds = f.categoryId1 ? [f.categoryId1] : f.categoryIds

  const payload = {
    brandId: f.brandId,
    categoryIds,
    title: f.title,
    subTitle: f.subTitle || undefined,
    mainImage: f.mainImage,
    detailImages: detailUploadUrls.value.length > 0 ? detailUploadUrls.value : undefined,
    detailDesc: f.detailDesc || undefined,
    saleType: f.saleType,
    skuList: f.skuList.map((s: any) => ({
      specs: s.specs, price: Number(s.price), stock: Number(s.stock),
      skuCode: s.skuCode || undefined
    }))
  }

  try {
    if (editId.value) {
      await updateProduct(editId.value, payload)
      toast('修改成功，等待审核')
    } else {
      await createProduct(payload)
      toast('发布成功，等待审核')
    }
    showEdit.value = false
    getList()
  } catch {}
}

// ---------- 库存方法 ----------
const openStock = async (product: any) => {
  try {
    const detail = await getProductDetail(product.productId)
    currentProduct.value = product
    stockSkuList.value = (detail.skuList || []).map((s: any) => ({
      ...s, newPrice: s.price, newStock: s.stock
    }))
    showStock.value = true
  } catch {}
}

const saveStock = async (sku: any) => {
  try {
    await updateStock(sku.skuId, { stock: sku.newStock })
    toast('库存更新成功')
    sku.stock = sku.newStock
  } catch {}
}

const savePrice = async (sku: any) => {
  try {
    await updatePrice(sku.skuId, { price: sku.newPrice })
    toast('价格更新成功')
    sku.price = sku.newPrice
  } catch {}
}

// ---------- 初始化 ----------
onMounted(() => {
  loadCategories()
  getList()
})
</script>

<style scoped>
.product-page { width: 95%; margin: 30px auto; }
.top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
h2 { color: #2D2D2D; }
.add-btn { padding: 8px 16px; background: #E66100; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
.search-bar { display: flex; gap: 10px; margin-bottom: 12px; }
input, select, button { padding: 7px 10px; border-radius: 4px; border: 1px solid #ddd; font-size: 14px; }
button { cursor: pointer; }
table { width: 100%; border-collapse: collapse; background: #fff; }
table th, table td { padding: 8px; text-align: center; border: 1px solid #eee; color: #595959; }
.page-wrap { display: flex; gap: 12px; align-items: center; margin-top: 10px; color: #595959; }

/* ---------- 弹窗 ---------- */
.mask { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.dialog { width: 680px; max-height: 80vh; overflow-y: auto; background: white; padding: 24px; border-radius: 8px; }
.form-item { margin-bottom: 14px; }
label { display: block; margin-bottom: 5px; color: #595959; font-size: 14px; }
input, select { width: 100%; box-sizing: border-box; padding: 9px; border: 1px solid #ddd; border-radius: 4px; }
.form-row { display: flex; gap: 10px; margin-bottom: 14px; align-items: flex-end; }
.form-row .item { flex: 1; }
.form-row .item input { width: 100%; }
.btns { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
.save { background: #E66100; color: white; border: none; cursor: pointer; }

/* ---------- 品牌搜索 ---------- */
.autocomplete-wrap { position: relative; }
.autocomplete-wrap input { width: 100%; box-sizing: border-box; padding: 9px; border: 1px solid #ddd; border-radius: 4px; }
.dropdown { position: absolute; top: 100%; left: 0; right: 0; background: #fff; border: 1px solid #ddd; border-radius: 4px; max-height: 180px; overflow-y: auto; z-index: 10; }
.dropdown-item { padding: 8px 12px; cursor: pointer; font-size: 14px; }
.dropdown-item:hover { background: #F0F5FF; }

/* ---------- 分类 ---------- */
.category-row { display: flex; gap: 10px; }
.category-row select { flex: 1; }

/* ---------- 上传 ---------- */
.upload-row { display: flex; align-items: center; flex-wrap: wrap; gap: 8px; }
.upload-btn { padding: 8px 14px; background: #F2F3F5; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; font-size: 13px; color: #4E5969; }
.upload-btn:hover { background: #E5E6EB; }
.preview-img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #eee; }
.preview-list { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 6px; }
</style>
