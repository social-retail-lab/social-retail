<template>
  <div class="register-box">
    <h2>商家入驻审核列表</h2>
    <div class="search-bar">
      <input placeholder="店铺名称/联系人" v-model="keyword" />
      <select v-model="auditStatus">
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
          <th>商家类型</th>
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
          <td>{{ item.merchantType === 'PERSON' ? '个人商家' : '企业商家' }}</td>
          <td>{{ item.contactName }}</td>
          <td>{{ item.contactPhone }}</td>
          <td>{{ auditMap[item.auditStatus] }}</td>
          <td>
            <button
              :disabled="item.auditStatus !== 0"
              :class="{ disabled: item.auditStatus !== 0 }"
              @click="openDialog(item)"
            >审核</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="page">
      <button :disabled="page === 1" @click="page--">上一页</button>
      <span>第{{ page }}页 / 共{{ Math.ceil(total / 10) || 1 }}页</span>
      <button :disabled="page * 10 >= total" @click="page++">下一页</button>
    </div>

    <!-- 审核弹窗 -->
    <div v-if="showMask" class="mask" @click.self="showMask = false">
      <div class="dialog">
        <h3>商家资质审核</h3>
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
import { ref, watch, onMounted } from 'vue'
import { getMerchantApplies, auditMerchantApply } from '@/api/audit'
const keyword = ref('')
const auditStatus = ref('')
const page = ref(1)
const total = ref(0)
const tableList = ref<any[]>([])
const auditMap:Record<string,string> = {'0':'待审核','1':'通过','2':'驳回'}
const showMask = ref(false)
const curApplyId = ref(0)
const curAuditStatus = ref(1)
const remark = ref('')

const getList = async ()=>{
  const params: any = {
    pageNum: page.value,
    pageSize: 10
  }
  if (keyword.value) {
    params.keyword = keyword.value
  }
  if (auditStatus.value !== '') {
    params.auditStatus = Number(auditStatus.value)
  }
  const res = await getMerchantApplies(params)
  if (res.code === 0) {
    tableList.value = res.data.list || res.data || []
    total.value = res.data.total || tableList.value.length
  }
}

watch(page, () => getList())

const openDialog = (row:any)=>{
  curApplyId.value = row.applyId
  curAuditStatus.value = 1
  remark.value = ''
  showMask.value = true
}
const submitAudit = async ()=>{
  const res = await auditMerchantApply(curApplyId.value, {
    auditStatus: Number(curAuditStatus.value),
    auditRemark: remark.value
  })
  if (res.code === 0) {
    alert('审核完成')
    getList()
  }
  showMask.value = false
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.register-box {
  width: 900px;
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
button.disabled {
  background: #c0c4cc;
  cursor: not-allowed;
}
button:disabled {
  background: #c0c4cc;
  cursor: not-allowed;
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
