<template>
  <div class="product-audit">
    <h2>商品审核管理</h2>
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
          <td>{{ item.shopName }}</td>
          <td>{{ auditMap[item.auditStatus] }}</td>
          <td><button @click="openAudit(item)">审核</button></td>
        </tr>
      </tbody>
    </table>
    <div class="page-wrap">
      <button :disabled="page ===1" @click="page--">上一页</button>
      <span>第{{page}}页</span>
      <button @click="page++">下一页</button>
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
import { ref } from 'vue'
import { getProductAuditList, auditProduct } from '@/api/admin'
const keyword = ref('')
const auditStatus = ref('')
const page = ref(1)
const tableList = ref([
  {productId:1001,mainImage:"https://picsum.photos/100",title:"精品苹果",shopName:"鲜果店",auditStatus:0}
])
const auditMap = {'0':'待审核','1':'通过','2':'驳回'}
const showMask = ref(false)
const pid = ref(0)
const status = ref(1)
const remark = ref('')

const getList = async ()=>{
  const res = await getProductAuditList({keyword,auditStatus,page})
  tableList.value = res.data
}
const openAudit = (row:any)=>{
  pid.value = row.productId
  showMask.value = true
}
const submit = async ()=>{
  await auditProduct({productId:pid.value,auditStatus:status.value,auditRemark:remark.value})
  alert('审核完成')
  showMask.value = false
  getList()
}
getList()
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
.page-wrap {
  display: flex;
  gap: 12px;
  align-items: center;
  color: #4E5969;
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
.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 14px;
}
.form-row .item {
  flex: 1;
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