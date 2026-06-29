<template>
<div class="audit-page">
  <h2>商家入驻审核</h2>
  <!-- 搜索栏 -->
  <div class="search-bar">
    <input v-model="keyword" placeholder="搜索店铺名称/联系人" />
    <select v-model="auditStatus">
      <option value="">全部状态</option>
      <option value="0">待审核</option>
      <option value="1">审核通过</option>
      <option value="2">审核驳回</option>
    </select>
    <button @click="getMerchantList">查询</button>
  </div>

  <!-- 表格 -->
  <table border="1" width="100%" style="margin:16px 0;">
    <thead>
      <tr>
        <th>申请ID</th>
        <th>公司名称</th>
        <th>店铺名</th>
        <th>联系人</th>
        <th>联系电话</th>
        <th>审核状态</th>
        <th>操作</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="item in list" :key="item.applyId">
        <td>{{ item.applyId }}</td>
        <td>{{ item.companyName }}</td>
        <td>{{ item.shopName }}</td>
        <td>{{ item.contactName }}</td>
        <td>{{ item.contactPhone }}</td>
        <td>{{ statusMap[item.auditStatus] }}</td>
        <td v-if="item.auditStatus === 0">
          <button @click="openDetail(item)">查看资质</button>
          <button @click="handleAudit(item.applyId, 1)">通过</button>
          <button @click="openReject(item.applyId)">驳回</button>
        </td>
        <td v-else>已处理</td>
      </tr>
    </tbody>
  </table>

  <!-- 分页 -->
  <div class="page">
    <button :disabled="page === 1" @click="page--;getMerchantList">上一页</button>
    <span>第{{page}} / {{pages}} 页</span>
    <button :disabled="page >= pages" @click="page++;getMerchantList">下一页</button>
  </div>

  <!-- 资质弹窗 -->
  <div v-if="showDetail" class="mask" @click.self="showDetail=false">
    <div class="dialog">
      <h3>商家资质详情</h3>
      <p>营业执照号：{{ detail.licenseNumber }}</p>
      <img :src="detail.licenseImage" width="300" />
      <p>食品经营许可证：{{ detail.foodPermitNumber }}</p>
      <img :src="detail.foodPermitImage" width="300" />
      <button @click="showDetail=false">关闭</button>
    </div>
  </div>

  <!-- 驳回弹窗 -->
  <div v-if="showReject" class="mask" @click.self="showReject=false">
    <div class="dialog">
      <h3>填写驳回理由</h3>
      <textarea v-model="rejectReason" rows="4" style="width:100%"></textarea>
      <div style="margin-top:10px;">
        <button @click="submitReject">确认驳回</button>
        <button @click="showReject=false">取消</button>
      </div>
    </div>
  </div>
</div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { getMerchantAuditList, getMerchantDetail, auditMerchant } from '@/api/admin'

// 筛选条件
const keyword = ref('')
const auditStatus = ref('')
const page = ref(1)
const pageSize = ref(10)
const list = ref<any[]>([])
const total = ref(0)
const pages = ref(0)
const statusMap: Record<number, string> = {
  0: '待审核',
  1: '审核通过',
  2: '审核驳回'
}

// 弹窗控制
const showDetail = ref(false)
const showReject = ref(false)
const detail = ref({})
const currentApplyId = ref(0)
const rejectReason = ref('')

// 获取列表
const getMerchantList = async () => {
  const res = await getMerchantAuditList({
    keyword: keyword.value,
    auditStatus: auditStatus.value,
    pageNum: page.value,
    pageSize: pageSize.value
  })
  if (res.code === 0) {
    list.value = res.data.list
    total.value = res.data.total
    pages.value = Math.ceil(total.value / pageSize.value)
  }
}

// 查看资质详情
const openDetail = async (row: any) => {
  const res = await getMerchantDetail(row.applyId)
  if (res.code === 0) {
    detail.value = res.data
    showDetail.value = true
  }
}

// 通过审核
const handleAudit = async (applyId: number, auditStatus: number) => {
  await auditMerchant({ applyId, auditStatus, auditRemark: '资质齐全，准予入驻' })
  alert('审核通过')
  getMerchantList()
}

// 打开驳回弹窗
const openReject = (id: number) => {
  currentApplyId.value = id
  rejectReason.value = ''
  showReject.value = true
}

// 提交驳回
const submitReject = async () => {
  if (!rejectReason.value) {
    alert('请填写驳回理由')
    return
  }
  await auditMerchant({
    applyId: currentApplyId.value,
    auditStatus: 2,
    auditRemark: rejectReason.value
  })
  alert('已驳回')
  showReject.value = false
  getMerchantList()
}

// 页面加载自动查询
getMerchantList()
</script>

<style scoped>
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
input, select, button {
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
  width: 500px;
}
.page {
  display: flex;
  gap:10px;
  align-items: center;
}
</style>