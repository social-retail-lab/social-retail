<template>
  <div class="store-info">
    <Toast ref="toastRef" />
    <h2>商家信息</h2>
    <div v-if="loading" style="color:#86909C;padding:20px;">加载中...</div>
    <div v-else-if="merchant" class="info-card">
      <div class="field"><label>店铺名称</label><span>{{ merchant.merchantName }}</span></div>
      <div class="field"><label>联系人</label><span>{{ merchant.contactName }}</span></div>
      <div class="field"><label>联系电话</label><span>{{ merchant.contactPhone }}</span></div>
      <div class="field"><label>店铺地址</label><span>{{ merchant.shopAddress }}</span></div>
      <div class="field"><label>营业时间</label><span>{{ merchant.businessHours || '未设置' }}</span></div>
      <div class="field"><label>店铺简介</label><span>{{ merchant.introduction || '未设置' }}</span></div>
      <div class="field"><label>状态</label><span :class="statusClass(merchant.status)">{{ merchant.statusText }}</span></div>
      <div class="field"><label>创建时间</label><span>{{ merchant.createTime }}</span></div>

      <!-- 操作按钮 -->
      <div class="action-bar">
        <button class="btn-primary" @click="openInfoEdit">修改信息</button>
        <button v-if="merchant.applyType === 1" class="btn-warning" @click="openUpgrade">升级企业资质</button>
        <button v-if="merchant.status === 1" class="btn-pause" @click="togglePause">暂时歇业</button>
        <button v-if="merchant.status === 5" class="btn-resume" @click="togglePause">重新营业</button>
      </div>

      <!-- 被封禁时申诉 -->
      <div v-if="merchant.status === 4" class="appeal-section">
        <h4>账号已封禁</h4>
        <textarea v-model="appealReason" placeholder="请输入申诉理由" rows="3" />
        <button @click="submitAppeal">提交申诉</button>
      </div>
    </div>

    <!-- 修改信息弹窗 -->
    <div v-if="showInfoEdit" class="modal-overlay" @click.self="showInfoEdit=false">
      <div class="modal">
        <h3>修改商家信息</h3>
        <div class="form-item"><label>店铺名称</label><input v-model="editForm.merchantName" /></div>
        <div class="form-item"><label>联系人</label><input v-model="editForm.contactName" /></div>
        <div class="form-item"><label>联系电话</label><input v-model="editForm.contactPhone" /></div>
        <div class="form-item"><label>店铺地址</label><input v-model="editForm.shopAddress" /></div>
        <div class="form-item"><label>营业时间</label><input v-model="editForm.businessHours" /></div>
        <div class="form-item"><label>店铺简介</label><textarea v-model="editForm.introduction" rows="2" /></div>
        <div class="modal-ft">
          <button class="btn-cancel" @click="showInfoEdit=false">取消</button>
          <button class="btn-primary" @click="submitInfoEdit">提交申请（需审核）</button>
        </div>
      </div>
    </div>

    <!-- 升级企业资质弹窗 -->
    <div v-if="showUpgrade" class="modal-overlay" @click.self="showUpgrade=false">
      <div class="modal">
        <h3>升级企业资质</h3>
        <div class="form-item"><label>企业名称</label><input v-model="upgradeForm.companyName" /></div>
        <div class="form-item"><label>营业执照号</label><input v-model="upgradeForm.licenseNumber" /></div>
        <div class="form-item">
          <label>营业执照图片</label>
          <input type="file" accept="image/*" style="display:none" ref="licenseFileInput" @change="onLicenseUpload" />
          <button @click="($refs.licenseFileInput as HTMLInputElement)?.click()">选择图片上传</button>
          <img v-if="upgradeForm.licenseImage" :src="upgradeForm.licenseImage" class="preview-img" />
        </div>
        <div class="form-item"><label>食品许可证号</label><input v-model="upgradeForm.foodPermitNumber" /></div>
        <div class="form-item">
          <label>食品许可证</label>
          <input type="file" accept="image/*" style="display:none" ref="foodFileInput" @change="onFoodPermitUpload" />
          <button @click="($refs.foodFileInput as HTMLInputElement)?.click()">选择图片上传</button>
          <img v-if="upgradeForm.foodPermitImage" :src="upgradeForm.foodPermitImage" class="preview-img" />
        </div>
        <div class="form-item"><label>联系人</label><input v-model="upgradeForm.contactName" /></div>
        <div class="form-item"><label>联系电话</label><input v-model="upgradeForm.contactPhone" /></div>
        <div class="form-item"><label>店铺地址</label><input v-model="upgradeForm.shopAddress" /></div>
        <div class="form-item"><label>店铺名称</label><input v-model="upgradeForm.shopName" /></div>
        <div class="modal-ft">
          <button class="btn-cancel" @click="showUpgrade=false">取消</button>
          <button class="btn-primary" @click="submitUpgrade">提交申请（需审核）</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Toast from '@/components/Toast.vue'
import request from '@/utils/request'

const toastRef = ref<any>(null)
const merchant = ref<any>(null)
const loading = ref(true)
const appealReason = ref('')
const showInfoEdit = ref(false)
const showUpgrade = ref(false)
const editForm = ref({ merchantName:'', contactName:'', contactPhone:'', shopAddress:'', businessHours:'', introduction:'' })
const upgradeForm = ref({ companyName:'', licenseNumber:'', licenseImage:'', foodPermitNumber:'', foodPermitImage:'', contactName:'', contactPhone:'', shopAddress:'', shopName:'' })

const statusClass = (s: number) => {
  if (s === 1) return 'status-active'
  if (s === 4) return 'status-banned'
  if (s === 5) return 'status-pause'
  return 'status-other'
}

onMounted(async () => {
  try {
    merchant.value = await request.get('/merchant/info')
  } catch (e: any) {
    toastRef.value?.show('获取商家信息失败', 'error')
  } finally {
    loading.value = false
  }
})

async function submitAppeal() {
  try {
    const res = await request.post('/merchant/auth/appeal', { reason: appealReason.value })
    toastRef.value?.show(res.message || '申诉成功', 'success')
    merchant.value = await request.get('/merchant/info')
  } catch (e: any) {
    toastRef.value?.show(e?.message || '申诉失败', 'error')
  }
}

function openInfoEdit() {
  editForm.value = {
    merchantName: merchant.value.merchantName || '',
    contactName: merchant.value.contactName || '',
    contactPhone: merchant.value.contactPhone || '',
    shopAddress: merchant.value.shopAddress || '',
    businessHours: merchant.value.businessHours || '',
    introduction: merchant.value.introduction || ''
  }
  showInfoEdit.value = true
}

async function submitInfoEdit() {
  try {
    const res = await request.post('/merchant/info/change', editForm.value)
    toastRef.value?.show(res.message || '信息修改申请已提交', 'success')
    showInfoEdit.value = false
  } catch (e: any) {
    toastRef.value?.show(e?.message || '提交失败', 'error')
  }
}

function openUpgrade() {
  upgradeForm.value = { companyName:'', licenseNumber:'', licenseImage:'', foodPermitNumber:'', foodPermitImage:'', contactName:'', contactPhone:'', shopAddress:'', shopName:'' }
  showUpgrade.value = true
}

async function onLicenseUpload(e: any) {
  const file = e.target.files?.[0]
  if (!file) return
  const fd = new FormData(); fd.append('file', file)
  try {
    const res = await request.upload ? request.upload('/merchant/upload/image', fd) : await request.post('/merchant/upload/image', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
    upgradeForm.value.licenseImage = res.url || res
  } catch { toastRef.value?.show('上传失败', 'error') }
}

async function onFoodPermitUpload(e: any) {
  const file = e.target.files?.[0]
  if (!file) return
  const fd = new FormData(); fd.append('file', file)
  try {
    const res = await request.post('/merchant/upload/image', fd, { headers: { 'Content-Type': 'multipart/form-data' } })
    upgradeForm.value.foodPermitImage = res.url || res
  } catch { toastRef.value?.show('上传失败', 'error') }
}

async function submitUpgrade() {
  if (!upgradeForm.value.licenseNumber || !upgradeForm.value.licenseImage) {
    toastRef.value?.show('企业资质必须提供营业执照', 'error'); return
  }
  try {
    const res = await request.post('/merchant/qualification/upgrade', upgradeForm.value)
    toastRef.value?.show(res.message || '升级申请已提交', 'success')
    showUpgrade.value = false
  } catch (e: any) {
    toastRef.value?.show(e?.message || '提交失败', 'error')
  }
}

async function togglePause() {
  try {
    const res = await request.patch('/merchant/pause')
    toastRef.value?.show(res.message || '操作成功', 'success')
    merchant.value = await request.get('/merchant/info')
  } catch (e: any) {
    toastRef.value?.show(e?.message || '操作失败', 'error')
  }
}
</script>

<style scoped>
.store-info { max-width: 700px; }
h2 { margin-bottom: 16px; color: #1D2129; }
.info-card { background: #fff; border-radius: 8px; padding: 20px; }
.field { display: flex; padding: 10px 0; border-bottom: 1px solid #f0f0f0; }
.field label { width: 100px; color: #86909C; font-size: 14px; flex-shrink: 0; }
.field span { color: #1D2129; font-size: 14px; }
.status-active { color: #00B42A; font-weight: 600; }
.status-banned { color: #F53F3F; font-weight: 600; }
.status-pause { color: #FF7D00; font-weight: 600; }
.status-other { color: #FF7D00; }
.action-bar { margin-top: 16px; display: flex; gap: 10px; flex-wrap: wrap; }
.btn-primary { padding: 6px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-warning { padding: 6px 16px; background: #FF7D00; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-pause { padding: 6px 16px; background: #86909C; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-resume { padding: 6px 16px; background: #00B42A; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; }
.btn-cancel { padding: 6px 16px; background: #E5E6EB; color: #4E5969; border: none; border-radius: 4px; cursor: pointer; }
.appeal-section { margin-top: 20px; padding: 16px; background: #FFF7E6; border-radius: 6px; border: 1px solid #FFE4BA; }
.appeal-section h4 { color: #FF7D00; margin-bottom: 8px; }
.appeal-section textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: vertical; }
.appeal-section button { margin-top: 8px; padding: 6px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.4); display: flex; justify-content: center; align-items: center; z-index: 100; }
.modal { background: #fff; border-radius: 8px; padding: 24px; width: 480px; max-height: 80vh; overflow-y: auto; }
.modal h3 { margin-bottom: 16px; }
.form-item { margin-bottom: 12px; }
.form-item label { display: block; margin-bottom: 4px; color: #4E5969; font-size: 13px; }
.form-item input, .form-item textarea { width: 100%; padding: 6px 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
.form-item button { margin-top: 4px; padding: 4px 12px; background: #E5E6EB; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
.preview-img { max-width: 200px; max-height: 100px; margin: 4px 0; display: block; }
.modal-ft { margin-top: 16px; display: flex; gap: 8px; justify-content: flex-end; }
</style>
