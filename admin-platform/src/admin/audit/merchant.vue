<template>
  <div class="register-box">
    <h2>商家入驻审核列表</h2>
    <div class="search-bar">
      <input placeholder="店铺名称/联系人" v-model="keyword" />
      <select v-model="auditStatusFilter">
        <option value="">全部状态</option>
        <option value="0">待审核</option>
        <option value="1">审核通过</option>
        <option value="2">审核驳回</option>
      </select>
      <button @click="getList">查询</button>
    </div>
    <table border="1">
      <thead>
        <tr>
          <th>申请ID</th>
          <th>店铺名</th>
          <th>入驻类型</th>
          <th>联系人</th>
          <th>手机号</th>
          <th>审核状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.applyId">
          <td>{{ item.applyId }}</td>
          <td>{{ item.shopName }}</td>
          <td>{{ item.applyTypeText || (item.applyType === 1 ? '个人' : '企业') }}</td>
          <td>{{ item.contactName }}</td>
          <td>{{ item.contactPhone }}</td>
          <td>{{ auditMap[item.auditStatus] || '待审核' }}</td>
          <td>
            <button v-if="item.auditStatus === 0" @click="openDialog(item)">审核</button>
            <button v-else class="btn-done" disabled>已审核</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="page">
      <button :disabled="page === 1" @click="page--; getList()">上一页</button>
      <span>第{{ page }}页 / 共{{ total }}条</span>
      <button :disabled="page * pageSize >= total" @click="page++; getList()">下一页</button>
    </div>

    <!-- 审核弹窗 -->
    <div v-if="showMask" class="mask" @click.self="showMask = false">
      <div class="dialog">
        <h3>商家资质审核</h3>
        <div v-if="currentItem">
          <p><b>申请ID：</b>{{ currentItem.applyId }}</p>
          <p><b>店铺名：</b>{{ currentItem.shopName }}</p>
          <p><b>入驻类型：</b>{{ currentItem.applyTypeText || (currentItem.applyType === 1 ? '个人' : '企业') }}</p>
          <p><b>联系人：</b>{{ currentItem.contactName }}</p>
          <p><b>联系电话：</b>{{ currentItem.contactPhone }}</p>
          <p><b>店铺地址：</b>{{ currentItem.shopAddress }}</p>
          <p><b>身份证正面：</b><a :href="currentItem.idCardFront" target="_blank">查看</a></p>
          <p><b>身份证反面：</b><a :href="currentItem.idCardBack" target="_blank">查看</a></p>
          <p v-if="currentItem.licenseImage"><b>营业执照：</b><a :href="currentItem.licenseImage" target="_blank">查看</a></p>
          <p v-if="currentItem.foodPermitImage"><b>食品许可证：</b><a :href="currentItem.foodPermitImage" target="_blank">查看</a></p>
        </div>
        <div class="form-item">
          <label>审核结果</label>
          <select v-model="curAuditStatus">
            <option value="1">审核通过</option>
            <option value="2">驳回申请</option>
          </select>
        </div>
        <div class="form-item">
          <label>审核备注</label>
          <input v-model="remark" placeholder="填写审核意见" />
        </div>
        <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:20px">
          <button @click="showMask = false">取消</button>
          <button style="background:#165DFF;color:#fff" @click="submitAudit">确认提交</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { getMerchantAuditList, auditMerchant } from '@/api/admin'

const keyword = ref('')
const auditStatusFilter = ref('')
const page = ref(1)
const pageSize = 10
const total = ref(0)
const tableList = ref<any[]>([])
const auditMap: Record<string, string> = { '0': '待审核', '1': '通过', '2': '驳回' }

const showMask = ref(false)
const currentItem = ref<any>(null)
const curApplyId = ref(0)
const curAuditStatus = ref(1)
const remark = ref('')

const getList = async () => {
  try {
    const data = await getMerchantAuditList({
      keyword: keyword.value || undefined,
      auditStatus: auditStatusFilter.value !== '' ? Number(auditStatusFilter.value) : undefined,
      pageNum: page.value,
      pageSize
    })
    tableList.value = data.list || []
    total.value = data.total || 0
  } catch (e: any) {
    alert(e.message)
  }
}

const openDialog = (row: any) => {
  currentItem.value = row
  curApplyId.value = row.applyId
  remark.value = ''
  curAuditStatus.value = 1
  showMask.value = true
}

const submitAudit = async () => {
  try {
    await auditMerchant(curApplyId.value, {
      auditStatus: curAuditStatus.value,
      auditRemark: remark.value
    })
    alert('审核完成')
    showMask.value = false
    getList()
  } catch (e: any) {
    alert(e.message)
  }
}

getList()
</script>

<style scoped>
.register-box {
  width: 1000px;
  margin: 40px auto;
  padding: 30px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #1D2129;
}
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
input, select, button {
  padding: 7px 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
button {
  background: #165DFF;
  color: #fff;
  border: none;
  cursor: pointer;
}
.btn-done {
  background: #C9CDD4 !important;
  color: #fff !important;
  cursor: not-allowed !important;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
}
table th, table td {
  padding: 8px;
  text-align: center;
  border: 1px solid #eee;
  color: #4E5969;
}
.page {
  display: flex;
  gap: 12px;
  align-items: center;
  color: #4E5969;
}
.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
}
.dialog {
  background: #fff;
  padding: 24px;
  border-radius: 8px;
  min-width: 500px;
}
.form-item {
  margin-bottom: 16px;
}
label {
  display: block;
  margin-bottom: 6px;
  color: #4E5969;
}
input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
</style>
