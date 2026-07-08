<template>
  <div class="product-audit">
    <h2>商品管理</h2>
    <div class="search-bar">
      <input placeholder="商品名称" v-model="keyword" />
      <select v-model="auditStatus">
        <option value="">全部</option>
        <option value="0">待审核</option>
        <option value="1">审核通过</option>
        <option value="2">驳回</option>
      </select>
      <button @click="getList">查询</button>
    </div>
    <table border="1">
      <thead>
        <tr>
          <th>商品ID</th>
          <th>商品图</th>
          <th>商品名称</th>
          <th>所属商家</th>
          <th>审核状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.productId">
          <td>{{ item.productId }}</td>
          <td><img width="60" :src="item.mainImage" /></td>
          <td>{{ item.title }}</td>
          <td>{{ item.merchantName }}</td>
          <td>{{ auditMap[item.auditStatus] }}</td>
          <td class="actions">
            <button :disabled="item.auditStatus !== 0" :class="['btn-audit', { disabled: item.auditStatus !== 0 }]" @click="openAudit(item)">审核</button>
            <button class="btn-off" @click="forceOffShelf(item)">强制下架</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="page-wrap">
      <button :disabled="page === 1" @click="page--">上一页</button>
      <span>第{{ page }}页 / 共{{ Math.ceil(total / 10) || 1 }}页</span>
      <button :disabled="page * 10 >= total" @click="page++">下一页</button>
    </div>

    <!-- 审核弹窗 -->
    <div v-if="showMask" class="mask" @click.self="showMask=false">
      <div class="dialog">
        <h3>商品审核操作</h3>
        <div class="form-item">
          <label>审核结果</label>
          <select v-model="status">
            <option value="1">通过</option>
            <option value="2">驳回</option>
          </select>
        </div>
        <div class="form-item">
          <label>审核意见</label>
          <input v-model="remark" />
        </div>
        <div class="btns">
          <button @click="showMask=false">取消</button>
          <button class="save" @click="submit">确认</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { getProductAuditList, auditProduct, offShelfProduct } from '@/api/audit'
const keyword = ref('')
const auditStatus = ref('')
const page = ref(1)
const total = ref(0)
const tableList = ref<any[]>([])
const auditMap:Record<string,string> = {'0':'待审核','1':'通过','2':'驳回'}
const showMask = ref(false)
const pid = ref(0)
const status = ref(1)
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
  const res = await getProductAuditList(params)
  if (res.code === 0) {
    tableList.value = res.data.list || res.data || []
    total.value = res.data.total || tableList.value.length
  }
}

watch(page, () => getList())
const openAudit = (row:any)=>{
  pid.value = row.productId
  status.value = 1
  remark.value = ''
  showMask.value = true
}
const submit = async ()=>{
  const res = await auditProduct(pid.value, {
    auditStatus: Number(status.value),
    auditRemark: remark.value
  })
  if (res.code === 0) {
    alert('审核完成')
    getList()
  }
  showMask.value = false
}

const forceOffShelf = async (row: any) => {
  if (!confirm(`确定强制下架商品「${row.title}」吗？下架后商家无法再次上架。`)) return
  const res = await offShelfProduct(row.productId, { reason: '管理员强制下架' })
  if (res.code === 0) {
    alert('已强制下架')
    getList()
  } else {
    alert(res.message || '操作失败')
  }
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.product-audit {
  width: 95%;
  margin: 30px auto;
}
h2 {
  color: #1D2129;
  margin-bottom: 16px;
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
table th {
  background: #E5E6EB;
  font-weight: 600;
  font-size: 15px;
}
.page-wrap {
  display: flex;
  gap: 12px;
  align-items: center;
  color: #4E5969;
}
.actions {
  display: flex;
  gap: 6px;
  justify-content: center;
}
.btn-audit { }
.btn-audit.disabled {
  background: #c0c4cc;
  cursor: not-allowed;
}
.btn-off {
  background: #FF4D4F;
}
.btn-off:hover {
  background: #e04345;
}
.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
}
.dialog {
  width: 700px;
  background: #fff;
  padding: 24px;
  border-radius: 8px;
}
.form-item {
  margin-bottom: 14px;
}
label {
  display: block;
  margin-bottom: 5px;
  color: #4E5969;
}
input {
  width: 100%;
  box-sizing: border-box;
  padding: 9px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
.btns {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}
.save {
  background: #165DFF;
  color: white;
  border: none;
  cursor: pointer;
}
</style>
