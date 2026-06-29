<template>
<div class="product-audit">
  <h2>商品审核管理</h2>
  <div class="search-bar">
    <input v-model="keyword" placeholder="商品名称搜索" />
    <button @click="getProductList">查询</button>
  </div>

  <table border="1" width="100%" style="margin:16px 0;">
    <thead>
      <tr>
        <th>商品ID</th>
        <th>商品图</th>
        <th>商品名称</th>
        <th>所属商家</th>
        <th>售价</th>
        <th>审核状态</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="item in list" :key="item.productId">
        <td>{{ item.productId }}</td>
        <td><img :src="item.mainImage" width="80" /></td>
        <td>{{ item.title }}</td>
        <td>{{ item.merchantName }}</td>
        <td>{{ item.minPrice }} ~ {{ item.maxPrice }}</td>
        <td>{{ auditMap[item.auditStatus] }}</td>
        <td v-if="item.auditStatus === 0">
          <button @click="openProduct(item)">查看详情</button>
          <button @click="passAudit(item.productId)">通过</button>
          <button @click="openRejectDialog(item.productId)">驳回</button>
        </td>
        <td v-else>已审核</td>
      </tr>
    </tbody>
  </div>

  <div class="page">
    <button :disabled="page === 1" @click="page--;getProductList">上一页</button>
    <span>{{page}} / {{pages}}</span>
    <button :disabled="page >= pages" @click="page++;getProductList">下一页</button>
  </div>

  <!-- 商品详情弹窗 -->
  <div v-if="showDetail" class="mask" @click.self="showDetail=false">
    <div class="dialog" style="width:700px;">
      <h3>商品完整信息</h3>
      <p>商品标题：{{ detail.title }}</p>
      <p>副标题：{{ detail.subTitle }}</p>
      <p>分类：{{ detail.categoryNames.join(' / ') }}</p>
      <div>商品轮播图：
        <div style="display:flex;gap:8px;margin:8px 0;">
          <img v-for="img in detail.detailImages" :key="img" :src="img" width="120" />
        </div>
      </div>
      <p>商品详情：<div v-html="detail.detailDesc"></div></p>
      <button @click="showDetail=false">关闭</button>
    </div>
  </div>

  <!-- 驳回弹窗 -->
  <div v-if="showReject" class="mask" @click.self="showReject=false">
    <div class="dialog">
      <h3>填写驳回原因</h3>
      <textarea v-model="rejectText" rows="4" style="width:100%"></textarea>
      <div style="margin-top:10px;display:flex;gap:10px;">
        <button @click="submitReject">确认驳回</button>
        <button @click="showReject=false">取消</button>
      </div>
    </div>
  </div>
</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { getProductAuditList, getProductDetail, auditProduct } from '@/api/admin'

const keyword = ref('')
const page = ref(1)
const pageSize = ref(10)
const list = ref<any[]>([])
const total = ref(0)
const pages = ref(0)
const auditMap = {
  0: '待审核',
  1: '审核通过',
  2: '审核驳回'
}

// 弹窗变量
const showDetail = ref(false)
const showReject = ref(false)
const detail = ref({})
const currentPid = ref(0)
const rejectText = ref('')

// 获取商品审核列表
const getProductList = async () => {
  const res = await getProductAuditList({
    keyword: keyword.value,
    pageNum: page.value,
    pageSize: pageSize.value
  })
  if (res.code === 0) {
    list.value = res.data.list
    total.value = res.data.total
    pages.value = Math.ceil(total.value / pageSize.value)
  }
}

// 查看商品完整详情
const openProduct = async (row: any) => {
  const res = await getProductDetail(row.productId)
  if (res.code === 0) {
    detail.value = res.data
    showDetail.value = true
  }
}

// 审核通过
const passAudit = async (pid: number) => {
  await auditProduct({
    productId: pid,
    auditStatus: 1,
    auditRemark: '商品信息合规，审核通过'
  })
  alert('审核成功')
  getProductList()
}

// 打开驳回弹窗
const openRejectDialog = (pid: number) => {
  currentPid.value = pid
  rejectText.value = ''
  showReject.value = true
}

// 提交驳回
const submitReject = async () => {
  if (!rejectText.value) {
    alert('请填写驳回理由')
    return
  }
  await auditProduct({
    productId: currentPid.value,
    auditStatus: 2,
    auditRemark: rejectText.value
  })
  alert('已驳回')
  showReject.value = false
  getProductList()
}

getProductList()
</script>

<style scoped>
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
input, button {
  padding: 6px 10px;
}
.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}
.dialog {
  background: #fff;
  padding: 20px;
}
.page {
  display: flex;
  gap: 10px;
  align-items: center;
}
</style>