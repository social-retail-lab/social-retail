<template>
  <div class="goods-page">
    <div class="page-header">
      <h2>商品管理</h2>
      <button class="add-btn" @click="showAddModal = true">+ 添加商品</button>
    </div>

    <div class="filter-bar">
      <input v-model="keyword" placeholder="商品名称搜索" class="search-input" @keyup.enter="searchGoods" />
      <select v-model="categoryId" class="filter-select">
        <option value="">全部分类</option>
        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
      </select>
      <select v-model="status" class="filter-select">
        <option value="">全部状态</option>
        <option value="ON_SHELF">上架中</option>
        <option value="OFF_SHELF">已下架</option>
        <option value="WAIT_AUDIT">审核中</option>
      </select>
      <button class="search-btn" @click="searchGoods">搜索</button>
    </div>

    <div class="goods-list">
      <div v-for="goods in goodsList" :key="goods.productId" class="goods-card">
        <div class="goods-image">
          <img :src="goods.mainImage" :alt="goods.title" />
        </div>
        <div class="goods-info">
          <h3 class="goods-title">{{ goods.title }}</h3>
          <p class="goods-desc">{{ goods.description }}</p>
          <div class="goods-price">
            <span class="price">¥{{ goods.price.toFixed(2) }}</span>
            <span v-if="goods.originalPrice" class="original-price">¥{{ goods.originalPrice.toFixed(2) }}</span>
          </div>
          <div class="goods-meta">
            <span class="meta-item">库存: {{ goods.stock }}</span>
            <span class="meta-item">销量: {{ goods.sales }}</span>
            <span :class="['status-tag', goods.status]">{{ getStatusText(goods.status) }}</span>
          </div>
          <div class="goods-actions">
            <button class="action-btn edit" @click="editGoods(goods)">编辑</button>
            <button v-if="goods.status === 'ON_SHELF'" class="action-btn off" @click="toggleShelf(goods, 'OFF_SHELF')">下架</button>
            <button v-else-if="goods.status === 'OFF_SHELF'" class="action-btn on" @click="toggleShelf(goods, 'ON_SHELF')">上架</button>
            <button class="action-btn delete" @click="deleteGoods(goods)">删除</button>
          </div>
        </div>
      </div>
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
            <label>商品描述</label>
            <textarea v-model="form.description" placeholder="请输入商品描述"></textarea>
          </div>
          <div class="form-item">
            <label>商品分类</label>
            <select v-model="form.categoryId">
              <option value="">请选择分类</option>
              <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
            </select>
          </div>
          <div class="form-row">
            <div class="form-item">
              <label>商品价格</label>
              <input v-model.number="form.price" type="number" placeholder="请输入价格" />
            </div>
            <div class="form-item">
              <label>原价</label>
              <input v-model.number="form.originalPrice" type="number" placeholder="请输入原价" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-item">
              <label>库存数量</label>
              <input v-model.number="form.stock" type="number" placeholder="请输入库存" />
            </div>
            <div class="form-item">
              <label>商品图片</label>
              <input v-model="form.mainImage" placeholder="请输入图片URL" />
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
import { ref, reactive } from 'vue'

const showAddModal = ref(false)
const editingGoods = ref<any>(null)

const keyword = ref('')
const categoryId = ref('')
const status = ref('')

const categories = ref([
  { id: 1, name: '生鲜食品' },
  { id: 2, name: '日用百货' },
  { id: 3, name: '美妆护肤' },
  { id: 4, name: '数码电子' },
  { id: 5, name: '服装鞋帽' }
])

const form = reactive({
  title: '',
  description: '',
  categoryId: '',
  price: 0,
  originalPrice: 0,
  stock: 0,
  mainImage: ''
})

const goodsList = ref([
  {
    productId: 1001,
    title: '精品红富士苹果',
    description: '新鲜采摘，脆甜多汁，产地直发',
    categoryId: 1,
    price: 19.9,
    originalPrice: 29.9,
    stock: 200,
    sales: 1560,
    status: 'ON_SHELF',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=fresh%20red%20apple%20fruit&image_size=square'
  },
  {
    productId: 1002,
    title: '进口车厘子5斤装',
    description: '智利进口，果大饱满，甜度高',
    categoryId: 1,
    price: 89.9,
    originalPrice: 129.9,
    stock: 50,
    sales: 890,
    status: 'ON_SHELF',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=cherries%20fruit%20box&image_size=square'
  },
  {
    productId: 1003,
    title: '蒙牛纯牛奶24盒',
    description: '优质奶源，营养健康',
    categoryId: 1,
    price: 59.9,
    originalPrice: 69.9,
    stock: 100,
    sales: 2340,
    status: 'ON_SHELF',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=milk%20carton%20package&image_size=square'
  },
  {
    productId: 1004,
    title: '维达抽纸24包',
    description: '四层加厚，柔软亲肤',
    categoryId: 2,
    price: 45.9,
    originalPrice: 59.9,
    stock: 150,
    sales: 3120,
    status: 'OFF_SHELF',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=tissue%20paper%20package&image_size=square'
  },
  {
    productId: 1005,
    title: '进口牛肉礼盒',
    description: '澳洲进口，原切牛肉，品质保证',
    categoryId: 1,
    price: 199.0,
    originalPrice: 268.0,
    stock: 30,
    sales: 450,
    status: 'WAIT_AUDIT',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=beef%20meat%20gift%20box&image_size=square'
  },
  {
    productId: 1006,
    title: '可口可乐24罐',
    description: '经典口味，畅爽解渴',
    categoryId: 1,
    price: 42.0,
    originalPrice: 49.9,
    stock: 80,
    sales: 1890,
    status: 'ON_SHELF',
    mainImage: 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=coca%20cola%20cans&image_size=square'
  }
])

const getStatusText = (status: string) => {
  const map: Record<string, string> = {
    ON_SHELF: '上架中',
    OFF_SHELF: '已下架',
    WAIT_AUDIT: '审核中'
  }
  return map[status] || status
}

const searchGoods = () => {
  let list = goodsList.value
  if (keyword.value) {
    list = list.filter(g => g.title.includes(keyword.value))
  }
  if (categoryId.value) {
    list = list.filter(g => String(g.categoryId) === categoryId.value)
  }
  if (status.value) {
    list = list.filter(g => g.status === status.value)
  }
  goodsList.value = list
}

const editGoods = (goods: any) => {
  editingGoods.value = goods
  form.title = goods.title
  form.description = goods.description
  form.categoryId = String(goods.categoryId)
  form.price = goods.price
  form.originalPrice = goods.originalPrice || 0
  form.stock = goods.stock
  form.mainImage = goods.mainImage
  showAddModal.value = true
}

const deleteGoods = (goods: any) => {
  if (confirm(`确定要删除商品「${goods.title}」吗？`)) {
    const index = goodsList.value.findIndex(g => g.productId === goods.productId)
    if (index > -1) {
      goodsList.value.splice(index, 1)
    }
  }
}

const toggleShelf = (goods: any, newStatus: string) => {
  goods.status = newStatus
}

const closeModal = () => {
  showAddModal.value = false
  editingGoods.value = null
  form.title = ''
  form.description = ''
  form.categoryId = ''
  form.price = 0
  form.originalPrice = 0
  form.stock = 0
  form.mainImage = ''
}

const submitGoods = () => {
  if (!form.title || !form.price || !form.stock) {
    alert('商品名称、价格、库存不能为空')
    return
  }
  if (editingGoods.value) {
    editingGoods.value.title = form.title
    editingGoods.value.description = form.description
    editingGoods.value.categoryId = Number(form.categoryId)
    editingGoods.value.price = form.price
    editingGoods.value.originalPrice = form.originalPrice
    editingGoods.value.stock = form.stock
    editingGoods.value.mainImage = form.mainImage
  } else {
    goodsList.value.unshift({
      productId: Date.now(),
      title: form.title,
      description: form.description,
      categoryId: Number(form.categoryId),
      price: form.price,
      originalPrice: form.originalPrice,
      stock: form.stock,
      sales: 0,
      status: 'WAIT_AUDIT',
      mainImage: form.mainImage || 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=product%20placeholder&image_size=square'
    })
  }
  closeModal()
}
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
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}

.goods-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.goods-image {
  width: 100%;
  height: 180px;
  overflow: hidden;
}

.goods-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.goods-info {
  padding: 16px;
}

.goods-title {
  font-size: 15px;
  font-weight: 600;
  color: #1D2129;
  margin-bottom: 6px;
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
  margin-bottom: 10px;
}

.price {
  font-size: 18px;
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

.status-tag.ON_SHELF {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.OFF_SHELF {
  background: #F2F3F5;
  color: #86909C;
}

.status-tag.WAIT_AUDIT {
  background: #FFF7E6;
  color: #FA8C16;
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
  background: white;
  border-radius: 8px;
  overflow: hidden;
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

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 20px;
  border-top: 1px solid #f0f0f0;
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