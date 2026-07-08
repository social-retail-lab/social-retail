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
          <th>执照编号</th>
          <th>审核状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.applyId">
          <td>{{ item.applyId }}</td>
          <td>{{ item.shopName }}</td>
          <td>{{ item.merchantType || item.applyTypeText || (item.applyType === 1 ? '企业商家' : '个人商家') }}</td>
          <td>{{ item.contactName }}</td>
          <td>{{ maskPhone(item.contactPhone) }}</td>
          <td>{{ item.licenseNumber || '-' }}</td>
          <td>{{ auditMap[item.auditStatus] }}</td>
          <td>
            <button class="btn-detail" @click="openDetail(item)">查看详情</button>
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

    <!-- 查看详情弹窗 -->
    <div v-if="detailVisible" class="mask" @click.self="detailVisible = false">
      <div class="detail-dialog">
        <h3>入驻申请详情</h3>
        <div class="detail-grid">
          <div class="detail-item"><label>申请ID</label><span>{{ detailItem.applyId }}</span></div>
          <div class="detail-item"><label>店铺名称</label><span>{{ detailItem.shopName }}</span></div>
          <div class="detail-item"><label>商家类型</label><span>{{ detailItem.merchantType || detailItem.applyTypeText || (detailItem.applyType === 1 ? '企业商家' : '个人商家') }}</span></div>
          <div class="detail-item"><label>公司名称</label><span>{{ detailItem.companyName || '-' }}</span></div>
          <div class="detail-item"><label>联系人</label><span>{{ detailItem.contactName }}</span></div>
          <div class="detail-item"><label>手机号</label><span>{{ detailItem.contactPhone }}</span></div>
          <div class="detail-item"><label>营业执照编号</label><span>{{ detailItem.licenseNumber || '-' }}</span></div>
          <div class="detail-item"><label>食品许可证编号</label><span>{{ detailItem.foodPermitNumber || '-' }}</span></div>
          <div class="detail-item"><label>申请时间</label><span>{{ detailItem.applyTime || '-' }}</span></div>
          <div class="detail-item"><label>审核状态</label><span>{{ auditMap[detailItem.auditStatus] }}</span></div>
        </div>
        <div class="detail-images">
          <div class="img-block" v-if="detailItem.licenseImage">
            <label>营业执照</label>
            <img :src="detailItem.licenseImage" class="detail-img" @click="previewImage(detailItem.licenseImage)" />
          </div>
          <div class="img-block" v-if="detailItem.foodPermitImage">
            <label>食品许可证</label>
            <img :src="detailItem.foodPermitImage" class="detail-img" @click="previewImage(detailItem.foodPermitImage)" />
          </div>
          <div class="img-block" v-if="detailItem.idCardFront">
            <label>身份证正面</label>
            <img :src="detailItem.idCardFront" class="detail-img" @click="previewImage(detailItem.idCardFront)" />
          </div>
          <div class="img-block" v-if="detailItem.idCardBack">
            <label>身份证反面</label>
            <img :src="detailItem.idCardBack" class="detail-img" @click="previewImage(detailItem.idCardBack)" />
          </div>
        </div>
        <div class="dialog-btns">
          <template v-if="detailItem.auditStatus === 0">
            <button class="btn-approve" @click="openDialog(detailItem)">审核</button>
          </template>
          <button class="btn-cancel" @click="detailVisible = false">关闭</button>
        </div>
      </div>
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

    <!-- 图片预览 -->
    <div v-if="previewVisible" class="mask preview-mask" @click.self="previewVisible = false">
      <img :src="previewUrl" class="preview-img" />
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

const detailVisible = ref(false)
const detailItem = ref<any>({})
const previewVisible = ref(false)
const previewUrl = ref('')

const maskPhone = (phone: string) => {
  if (!phone || phone.length < 7) return phone || '-'
  return phone.slice(0, 3) + '****' + phone.slice(-4)
}

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

const openDetail = (row: any) => {
  detailItem.value = row
  detailVisible.value = true
}

const previewImage = (url: string) => {
  previewUrl.value = url
  previewVisible.value = true
}

const openDialog = (row:any)=>{
  if (showMask.value) return
  curApplyId.value = row.applyId
  curAuditStatus.value = 1
  remark.value = ''
  detailVisible.value = false
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
  width: 960px;
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
.btn-detail {
  background: #F2F3F5;
  color: #4E5969;
  margin-right: 6px;
}
.btn-detail:hover {
  background: #E5E6EB;
}
.btn-approve {
  background: #52C41A;
  color: #fff;
}
.btn-cancel {
  background: #f5f5f5;
  color: #666;
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
  font-size: 13px;
}
table th {
  background: #E5E6EB;
  font-weight: 600;
  font-size: 15px;
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
  z-index: 1000;
}
.dialog {
  background: #fff;
  padding: 24px;
  border-radius: 8px;
  min-width: 500px;
}
.detail-dialog {
  background: #fff;
  padding: 24px;
  border-radius: 8px;
  width: 680px;
  max-height: 85vh;
  overflow-y: auto;
}
.detail-dialog h3 {
  margin: 0 0 16px;
  font-size: 17px;
}
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px 24px;
  margin-bottom: 16px;
}
.detail-item {
  display: flex;
  flex-direction: column;
}
.detail-item label {
  font-size: 12px;
  color: #999;
  margin-bottom: 2px;
}
.detail-item span {
  font-size: 14px;
  color: #333;
  word-break: break-all;
}
.detail-images {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 16px;
}
.img-block {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.img-block label {
  font-size: 12px;
  color: #999;
  margin-bottom: 6px;
}
.detail-img {
  width: 220px;
  height: 140px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e8e8e8;
  cursor: pointer;
}
.dialog-btns {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
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
.preview-mask { z-index: 1100; }
.preview-img { max-width: 80vw; max-height: 80vh; border-radius: 8px; }
</style>
