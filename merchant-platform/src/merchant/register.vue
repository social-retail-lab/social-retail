<template>
  <div class="reg-wrap">
    <Toast ref="toastRef" />

    <!-- ========== 状态提示 ========== -->
    <div class="reg-card">
      <!-- 待审核 -->
      <div v-if="appStatus === 'pending'" class="status-box pending">
        <div class="status-icon">&#9203;</div>
        <h3>已提交入驻申请，待审核</h3>
        <p>申请时间：{{ applyInfo?.applyTime }}</p>
        <p class="tip">请耐心等待管理员审核</p>
        <button class="logout-btn" @click="goLogin">返回登录</button>
      </div>

      <!-- 已通过 -->
      <div v-if="appStatus === 'approved'" class="status-box success">
        <div class="status-icon">&#9989;</div>
        <h3>入驻申请已通过</h3>
        <p>{{ applyInfo?.auditRemark }}</p>
        <button class="logout-btn" @click="goLogin">返回登录</button>
      </div>

      <!-- 已拒绝 -->
      <div v-if="appStatus === 'rejected'" class="status-box rejected">
        <div class="status-icon">&#10060;</div>
        <h3>入驻申请已被打回</h3>
        <p>拒绝原因：{{ applyInfo?.auditRemark || '未填写原因' }}</p>
        <button class="resubmit-btn" @click="appStatus = 'editing'">重新提交申请</button>
      </div>

      <!-- ========== 入驻表单 ========== -->
      <div v-if="appStatus === 'editing' || appStatus === 'loading' || appStatus === 'checking'">
        <h2>商家入驻申请</h2>

        <!-- 入驻类型 -->
        <div class="form-item">
          <label>入驻类型</label>
          <select v-model="form.applyType">
            <option :value="1">个人商家</option>
            <option :value="2">企业商家</option>
          </select>
        </div>

        <div class="form-item">
          <label>商家名称</label>
          <input v-model="form.companyName" placeholder="请输入商家名称" />
        </div>
        <div class="form-item">
          <label>店铺名称</label>
          <input v-model="form.shopName" placeholder="请输入店铺名称" />
        </div>
        <div class="form-item">
          <label>联系人</label>
          <input v-model="form.contactName" placeholder="请输入联系人姓名" />
        </div>
        <div class="form-item">
          <label>联系电话</label>
          <input v-model="form.contactPhone" placeholder="请输入联系电话" />
        </div>
        <div class="form-item">
          <label>店铺地址</label>
          <input v-model="form.shopAddress" placeholder="请输入店铺地址" />
        </div>

        <!-- 身份证正面：上传图片 -->
        <div class="form-item">
          <label>身份证正面</label>
          <div class="upload-row">
            <input type="file" accept="image/*" style="display:none" ref="idFrontInput" @change="uploadIdFront" />
            <button class="upload-btn" @click="idFrontInput?.click()">选择图片上传</button>
            <span v-if="uploading.idFront" class="upload-tip">上传中...</span>
            <img v-if="form.idCardFront" :src="form.idCardFront" class="preview-sm" />
          </div>
        </div>

        <!-- 身份证反面：上传图片 -->
        <div class="form-item">
          <label>身份证反面</label>
          <div class="upload-row">
            <input type="file" accept="image/*" style="display:none" ref="idBackInput" @change="uploadIdBack" />
            <button class="upload-btn" @click="idBackInput?.click()">选择图片上传</button>
            <span v-if="uploading.idBack" class="upload-tip">上传中...</span>
            <img v-if="form.idCardBack" :src="form.idCardBack" class="preview-sm" />
          </div>
        </div>

        <!-- 企业专用：营业执照 -->
        <template v-if="form.applyType === 2">
          <div class="form-item">
            <label>营业执照注册号 <span class="required">*</span></label>
            <input v-model="form.licenseNumber" placeholder="请输入营业执照注册号（必填）" />
          </div>
          <div class="form-item">
            <label>营业执照图片 <span class="required">*</span></label>
            <div class="upload-row">
              <input type="file" accept="image/*" style="display:none" ref="licenseInput" @change="uploadLicense" />
              <button class="upload-btn" @click="licenseInput?.click()">选择图片上传</button>
              <span v-if="uploading.license" class="upload-tip">上传中...</span>
              <img v-if="form.licenseImage" :src="form.licenseImage" class="preview-sm" />
            </div>
          </div>
        </template>

        <!-- 食品经营许可证号（选填） -->
        <div class="form-item">
          <label>食品经营许可证号（选填）</label>
          <input v-model="form.foodPermitNumber" placeholder="请输入食品经营许可证号" />
        </div>

        <!-- 食品经营许可证图片（选填，上传） -->
        <div class="form-item">
          <label>食品许可证图片（选填）</label>
          <div class="upload-row">
            <input type="file" accept="image/*" style="display:none" ref="foodPermitInput" @change="uploadFoodPermit" />
            <button class="upload-btn" @click="foodPermitInput?.click()">选择图片上传</button>
            <span v-if="uploading.foodPermit" class="upload-tip">上传中...</span>
            <img v-if="form.foodPermitImage" :src="form.foodPermitImage" class="preview-sm" />
          </div>
        </div>

        <button class="reg-btn" @click="submitReg" :disabled="submitting">
          {{ submitting ? '提交中...' : '提交申请' }}
        </button>
        <div class="tip"><span @click="goLogin">返回登录</span></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { submitApplication, getApplicationStatus } from '@/api/goods'
import request from '@/utils/request'
import Toast from '@/components/Toast.vue'

const router = useRouter()
const toastRef = ref<any>(null)
const toast = (msg: string, type: string = 'success') => toastRef.value?.show(msg, type)

// 状态：loading=加载中, editing=编辑, pending=待审核, approved=已通过, rejected=已打回
const appStatus = ref('checking')
const applyInfo = ref<any>(null)
const submitting = ref(false)

// 文件上传 refs
const idFrontInput = ref<HTMLInputElement | null>(null)
const idBackInput = ref<HTMLInputElement | null>(null)
const licenseInput = ref<HTMLInputElement | null>(null)
const foodPermitInput = ref<HTMLInputElement | null>(null)

const uploading = reactive({
  idFront: false, idBack: false, license: false, foodPermit: false
})

const form = ref({
  applyType: 1,
  companyName: '',
  shopName: '',
  contactName: '',
  contactPhone: '',
  shopAddress: '',
  idCardFront: '',
  idCardBack: '',
  licenseNumber: '',
  licenseImage: '',
  foodPermitNumber: '',
  foodPermitImage: ''
})

// 通用文件上传
const uploadFile = async (file: File): Promise<string> => {
  const fd = new FormData()
  fd.append('file', file)
  try {
    const res = await request.post('/merchant/upload/image', fd, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    return (res as any).url || res.url
  } catch {
    toast('图片上传失败', 'error')
    throw new Error('upload failed')
  }
}

const uploadIdFront = async (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  uploading.idFront = true
  try { form.value.idCardFront = await uploadFile(file); toast('上传成功', 'success') }
  catch {}
  uploading.idFront = false
}

const uploadIdBack = async (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  uploading.idBack = true
  try { form.value.idCardBack = await uploadFile(file); toast('上传成功', 'success') }
  catch {}
  uploading.idBack = false
}

const uploadLicense = async (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  uploading.license = true
  try { form.value.licenseImage = await uploadFile(file); toast('上传成功', 'success') }
  catch {}
  uploading.license = false
}

const uploadFoodPermit = async (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  uploading.foodPermit = true
  try { form.value.foodPermitImage = await uploadFile(file); toast('上传成功', 'success') }
  catch {}
  uploading.foodPermit = false
}

const goLogin = () => router.push('/login')

// 检查入驻状态
const checkStatus = async () => {
  try {
    const info = await getApplicationStatus()
    if (!info) {
      appStatus.value = 'editing'
      return
    }
    applyInfo.value = info
    if (info.auditStatus === 0) {
      appStatus.value = 'pending'
    } else if (info.auditStatus === 1) {
      appStatus.value = 'approved'
    } else if (info.auditStatus === 2) {
      appStatus.value = 'rejected'
    }
  } catch {
    // 接口不通时直接展示表单
    appStatus.value = 'editing'
  }
}

const submitReg = async () => {
  const f = form.value
  if (!f.companyName || !f.shopName || !f.contactName || !f.contactPhone || !f.shopAddress) {
    toast('请填写完整信息', 'error')
    return
  }
  if (!f.idCardFront || !f.idCardBack) {
    toast('请上传身份证正反面', 'error')
    return
  }
  if (f.applyType === 2 && (!f.licenseNumber || !f.licenseImage)) {
    toast('企业入驻必须提供营业执照信息', 'error')
    return
  }

  submitting.value = true
  try {
    const payload: any = {
      applyType: f.applyType,
      companyName: f.companyName,
      shopName: f.shopName,
      contactName: f.contactName,
      contactPhone: f.contactPhone,
      shopAddress: f.shopAddress,
      idCardFront: f.idCardFront,
      idCardBack: f.idCardBack
    }
    if (f.applyType === 2) {
      payload.licenseNumber = f.licenseNumber
      payload.licenseImage = f.licenseImage
    }
    if (f.foodPermitNumber) payload.foodPermitNumber = f.foodPermitNumber
    if (f.foodPermitImage) payload.foodPermitImage = f.foodPermitImage

    const res = await submitApplication(payload)
    toast('已提交入驻申请，待审核', 'success')
    applyInfo.value = res
    appStatus.value = 'pending'
  } catch {}
  submitting.value = false
}

onMounted(checkStatus)
</script>

<style scoped>
.reg-wrap {
  width: 100vw; min-height: 100vh;
  display: flex; align-items: flex-start; justify-content: center;
  background: #F7F7F9; padding: 40px 0;
}
.reg-card {
  width: 520px; padding: 36px;
  background: #FFFFFF; border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}

/* 状态提示框 */
.status-box { text-align: center; padding: 30px 0; }
.status-icon { font-size: 48px; margin-bottom: 12px; }
.status-box h3 { font-size: 18px; margin-bottom: 8px; color: #2D2D2D; }
.status-box p { font-size: 14px; color: #595959; margin-bottom: 6px; }
.status-box .tip { font-size: 13px; color: #86909C; margin: 16px 0; }
.pending { border: 2px solid #FF7D00; border-radius: 8px; margin-bottom: 20px; }
.pending h3 { color: #FF7D00; }
.success { border: 2px solid #00B42A; border-radius: 8px; margin-bottom: 20px; }
.success h3 { color: #00B42A; }
.rejected { border: 2px solid #E34D59; border-radius: 8px; margin-bottom: 20px; }
.rejected h3 { color: #E34D59; }
.logout-btn, .resubmit-btn {
  margin-top: 16px; padding: 9px 28px;
  border: none; border-radius: 4px; cursor: pointer; font-size: 14px;
}
.logout-btn { background: #F2F3F5; color: #4E5969; }
.resubmit-btn { background: #E66100; color: #fff; }

h2 { text-align: center; margin-bottom: 24px; color: #2D2D2D; }
.required { color: #E34D59; }
.form-item { margin-bottom: 16px; }
.form-item label {
  display: block; margin-bottom: 6px; font-size: 14px; color: #595959;
}
.form-item input, .form-item select {
  width: 100%; box-sizing: border-box; padding: 10px 12px;
  border: 1px solid #dcdcdc; border-radius: 4px; font-size: 14px;
}

/* 上传 */
.upload-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.upload-btn {
  padding: 8px 14px; background: #F2F3F5; border: 1px solid #ddd;
  border-radius: 4px; cursor: pointer; font-size: 13px; color: #4E5969;
}
.upload-btn:hover { background: #E5E6EB; }
.upload-tip { font-size: 13px; color: #86909C; }
.preview-sm {
  width: 60px; height: 60px; object-fit: cover;
  border-radius: 4px; border: 1px solid #eee;
}
.reg-btn {
  width: 100%; padding: 12px; margin-top: 8px;
  background: #E66100; color: #fff; border: none; border-radius: 4px;
  cursor: pointer; font-size: 15px;
}
.reg-btn:disabled { opacity: 0.5; cursor: not-allowed; }
.reg-btn:hover:not(:disabled) { opacity: 0.92; }
.tip { margin-top: 16px; text-align: center; font-size: 14px; color: #8C8C8C; }
.tip span { color: #E66100; cursor: pointer; }
</style>
