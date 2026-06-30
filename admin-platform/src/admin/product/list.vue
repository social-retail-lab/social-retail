<template>
  <div class="page">
    <div class="search-bar">
      <input v-model="keyword" placeholder="商品ID/名称" @keyup.enter="search" />
      <select v-model="categoryId">
        <option :value="0">全部分类</option>
        <option v-for="c in categories" :key="c.categoryId" :value="c.categoryId">{{ c.categoryName }}</option>
      </select>
      <select v-model="statusFilter">
        <option value="">全部状态</option>
        <option value="1">已上架</option>
        <option value="0">已下架</option>
      </select>
      <select v-model="auditFilter">
        <option value="">审核全部</option>
        <option value="0">待审核</option>
        <option value="1">通过</option>
        <option value="2">拒绝</option>
      </select>
      <button @click="search">搜索</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>商品ID</th>
          <th>标题</th>
          <th>主图</th>
          <th>上下架</th>
          <th>审核</th>
          <th>是否可拼团</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="p in list" :key="p.productId">
          <td>{{ p.productId }}</td>
          <td>{{ p.title }}</td>
          <td><img v-if="p.mainImage" :src="p.mainImage" width="50" /></td>
          <td>{{ p.statusText }}</td>
          <td>{{ p.auditStatusText }}</td>
          <td>{{ p.groupPurchase ? '是' : '否' }}</td>
          <td>
            <button @click="openDetail(p.productId)">详情</button>
            <button v-if="p.status === 1" class="off-btn" @click="offShelf(p.productId)">下架</button>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="page-wrap">
      <button :disabled="page === 1" @click="page--; load()">上一页</button>
      <span>第{{ page }}页 / 共{{ total }}条</span>
      <button :disabled="page * pageSize >= total" @click="page++; load()">下一页</button>
    </div>

    <!-- 详情弹窗 -->
    <div v-if="showDetail" class="mask" @click.self="showDetail = false">
      <div class="dialog">
        <h3>商品详情</h3>
        <div v-if="detail">
          <div class="info-row"><label>商品ID：</label><span>{{ detail.productId }}</span></div>
          <div class="info-row"><label>标题：</label><span>{{ detail.title }}</span></div>
          <div class="info-row"><label>副标题：</label><span>{{ detail.subTitle || '-' }}</span></div>
          <div class="info-row"><label>主图：</label><img v-if="detail.mainImage" :src="detail.mainImage" width="80" /></div>
          <div class="info-row"><label>分类：</label><span>{{ (detail.categoryNames || []).join(' / ') }}</span></div>
          <div class="info-row"><label>状态：</label><span>{{ detail.statusText }}</span></div>
          <div class="info-row"><label>审核：</label><span>{{ detail.auditStatusText }}</span></div>
          <div class="info-row"><label>审核备注：</label><span>{{ detail.auditRemark || '-' }}</span></div>
          <div class="info-row"><label>商家：</label><span>{{ detail.merchantName }}</span></div>
          <div class="info-row"><label>商家电话：</label><span>{{ detail.merchantPhone || '-' }}</span></div>
          <div class="info-row"><label>创建时间：</label><span>{{ detail.createTime }}</span></div>
          <div v-if="detail.skuList">
            <h4 style="margin:12px 0 4px">SKU列表</h4>
            <table>
              <thead><tr><th>规格</th><th>价格</th><th>库存</th><th>编码</th></tr></thead>
              <tbody>
                <tr v-for="s in detail.skuList" :key="s.skuId">
                  <td>{{ s.specs }}</td>
                  <td>¥{{ s.price }}</td>
                  <td>{{ s.stock }}</td>
                  <td>{{ s.skuCode || '-' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="btns">
          <button @click="showDetail = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getAllProducts, getProductDetailForAdmin, offShelfProduct, getAdminCategories } from '@/api/admin'

const keyword = ref('')
const categoryId = ref(0)
const statusFilter = ref('')
const auditFilter = ref('')
const page = ref(1)
const pageSize = 10
const total = ref(0)
const list = ref<any[]>([])
const categories = ref<any[]>([])

const showDetail = ref(false)
const detail = ref<any>(null)

onMounted(() => { loadCategories(); load() })

async function loadCategories() {
  try {
    const res = await getAdminCategories()
    categories.value = (res as any).list || res || []
  } catch {}
}

function search() { page.value = 1; load() }

async function load() {
  try {
    const res = await getAllProducts({
      keyword: keyword.value || undefined,
      categoryId: categoryId.value > 0 ? categoryId.value : undefined,
      status: statusFilter.value !== '' ? Number(statusFilter.value) : undefined,
      auditStatus: auditFilter.value !== '' ? Number(auditFilter.value) : undefined,
      pageNum: page.value,
      pageSize
    })
    list.value = res.list || []
    total.value = res.total || 0
  } catch {}
}

async function openDetail(id: number) {
  try {
    detail.value = await getProductDetailForAdmin(id)
    showDetail.value = true
  } catch {}
}

async function offShelf(id: number) {
  if (!confirm('确认强制下架该商品？重新上架需审核。')) return
  try {
    await offShelfProduct(id, { reason: '管理员下架' })
    alert('下架成功')
    load()
  } catch {}
}
</script>

<style scoped>
.page { padding: 20px; }
.search-bar { display: flex; gap: 10px; margin-bottom: 12px; flex-wrap: wrap; }
input, select, button { padding: 7px 10px; border-radius: 4px; border: 1px solid #ddd; font-size: 14px; }
button { cursor: pointer; background: #165DFF; color: #fff; border: none; }
.off-btn { background: #F53F3F; margin-left: 4px; }
table { width: 100%; border-collapse: collapse; background: #fff; }
table th, table td { padding: 8px; text-align: center; border: 1px solid #eee; font-size: 14px; }
.page-wrap { display: flex; gap: 12px; align-items: center; margin-top: 10px; color: #595959; }
.mask { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.dialog { width: 600px; max-height: 80vh; overflow-y: auto; background: white; padding: 24px; border-radius: 8px; }
.info-row { padding: 8px 0; border-bottom: 1px solid #f0f0f0; display: flex; align-items: center; }
.info-row label { width: 100px; color: #86909C; font-size: 14px; }
.info-row span { color: #1D2129; font-size: 14px; }
.btns { display: flex; justify-content: flex-end; margin-top: 16px; }
h4 { margin: 12px 0 4px; font-size: 14px; color: #1D2129; }
</style>
