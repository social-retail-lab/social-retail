<template>
  <div class="page">
    <div class="search-bar">
      <input v-model="keyword" placeholder="商家ID/名称" @keyup.enter="search" />
      <select v-model="statusFilter">
        <option value="">全部状态</option>
        <option value="1">营业中</option>
        <option value="2">休息中</option>
        <option value="3">已关店</option>
        <option value="4">已封禁</option>
      </select>
      <button @click="search">搜索</button>
    </div>

    <table>
      <thead>
        <tr>
          <th>商家ID</th>
          <th>商家名称</th>
          <th>联系人</th>
          <th>电话</th>
          <th>商品数</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="m in list" :key="m.merchantId">
          <td>{{ m.merchantId }}</td>
          <td>{{ m.merchantName }}</td>
          <td>{{ m.contactName }}</td>
          <td>{{ m.contactPhone }}</td>
          <td>{{ m.productCount }}</td>
          <td><span :class="'status-' + m.status">{{ m.statusText }}</span></td>
          <td>
            <button @click="openDetail(m.merchantId)">详情</button>
            <button v-if="m.status !== 4" class="ban-btn" @click="banMerchant(m.merchantId)">封禁</button>
            <button v-else @click="unbanMerchant(m.merchantId)">解封</button>
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
        <h3>商家详情</h3>
        <div v-if="detail">
          <div class="info-row"><label>商家ID：</label><span>{{ detail.merchantId }}</span></div>
          <div class="info-row"><label>名称：</label><span>{{ detail.merchantName }}</span></div>
          <div class="info-row"><label>联系人：</label><span>{{ detail.contactName }}</span></div>
          <div class="info-row"><label>电话：</label><span>{{ detail.contactPhone }}</span></div>
          <div class="info-row"><label>地址：</label><span>{{ detail.shopAddress }}</span></div>
          <div class="info-row"><label>营业时间：</label><span>{{ detail.businessHours || '-' }}</span></div>
          <div class="info-row"><label>简介：</label><span>{{ detail.introduction || '-' }}</span></div>
          <div class="info-row"><label>状态：</label><span>{{ detail.statusText }}</span></div>
          <div class="info-row"><label>商品数：</label><span>{{ detail.stats?.productCount || 0 }}</span></div>
          <div class="info-row"><label>创建时间：</label><span>{{ detail.createTime }}</span></div>
          <div v-if="detail.qualification">
            <div class="info-row"><label>营业执照号：</label><span>{{ detail.qualification.licenseNumber || '-' }}</span></div>
            <div class="info-row"><label>食品许可证号：</label><span>{{ detail.qualification.foodPermitNumber || '-' }}</span></div>
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
import { getMerchantList, getMerchantDetail, updateMerchantStatus } from '@/api/admin'

const keyword = ref('')
const statusFilter = ref('')
const page = ref(1)
const pageSize = 10
const total = ref(0)
const list = ref<any[]>([])

const showDetail = ref(false)
const detail = ref<any>(null)

onMounted(() => load())

function search() { page.value = 1; load() }

async function load() {
  try {
    const res = await getMerchantList({
      keyword: keyword.value || undefined,
      status: statusFilter.value !== '' ? Number(statusFilter.value) : undefined,
      pageNum: page.value,
      pageSize
    })
    list.value = res.list || []
    total.value = res.total || 0
  } catch {}
}

async function openDetail(id: number) {
  try {
    detail.value = await getMerchantDetail(id)
    showDetail.value = true
  } catch {}
}

async function banMerchant(id: number) {
  const reason = prompt('封禁原因：')
  if (!reason) return
  try {
    await updateMerchantStatus(id, { status: 4, reason })
    alert('封禁成功')
    load()
  } catch {}
}

async function unbanMerchant(id: number) {
  try {
    await updateMerchantStatus(id, { status: 1, reason: '解封' })
    alert('解封成功')
    load()
  } catch {}
}
</script>

<style scoped>
.page { padding: 20px; }
.search-bar { display: flex; gap: 10px; margin-bottom: 12px; }
input, select, button { padding: 7px 10px; border-radius: 4px; border: 1px solid #ddd; font-size: 14px; }
button { cursor: pointer; background: #165DFF; color: #fff; border: none; }
.ban-btn { background: #F53F3F; margin-left: 4px; }
table { width: 100%; border-collapse: collapse; background: #fff; }
table th, table td { padding: 8px; text-align: center; border: 1px solid #eee; font-size: 14px; }
.status-1 { color: #00B42A; }
.status-2 { color: #FF7D00; }
.status-3 { color: #86909C; }
.status-4 { color: #F53F3F; }
.page-wrap { display: flex; gap: 12px; align-items: center; margin-top: 10px; color: #595959; }
.mask { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.dialog { width: 500px; max-height: 70vh; overflow-y: auto; background: white; padding: 24px; border-radius: 8px; }
.info-row { padding: 8px 0; border-bottom: 1px solid #f0f0f0; display: flex; }
.info-row label { width: 110px; color: #86909C; font-size: 14px; }
.info-row span { color: #1D2129; font-size: 14px; }
.btns { display: flex; justify-content: flex-end; margin-top: 16px; }
</style>
