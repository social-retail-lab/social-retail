<template>
  <div class="reg-wrap">
    <Toast ref="toastRef" />
    <div class="reg-card">
      <h2>商家入驻申请</h2>

      <div class="form-item">
        <label>入驻类型</label>
        <select v-model="form.applyType">
          <option :value="1">个人商家</option>
          <option :value="2">企业商家</option>
        </select>
      </div>

      <div class="form-item">
        <label>公司/商家名称</label>
        <input v-model="form.companyName" placeholder="请输入商家名称" />
      </div>

      <div class="form-item">
        <label>店铺名称</label>
        <input v-model="form.shopName" placeholder="请输入店铺名称" />
      </div>

      <div class="form-item">
        <label>联系人</label>
        <input v-model="form.contactName" placeholder="请输入联系人" />
      </div>

      <div class="form-item">
        <label>联系电话</label>
        <input v-model="form.contactPhone" placeholder="请输入联系电话" />
      </div>

      <div class="form-item">
        <label>店铺地址</label>
        <input v-model="form.shopAddress" placeholder="请输入店铺地址" />
      </div>

      <div class="form-item">
        <label>身份证正面 (图片URL)</label>
        <input v-model="form.idCardFront" placeholder="请填入身份证正面图片URL" />
      </div>

      <div class="form-item">
        <label>身份证反面 (图片URL)</label>
        <input v-model="form.idCardBack" placeholder="请填入身份证反面图片URL" />
      </div>

      <template v-if="form.applyType === 2">
        <div class="form-item">
          <label>营业执照注册号 <span style="color:red">*</span></label>
          <input v-model="form.licenseNumber" placeholder="请输入营业执照注册号（必填）" />
        </div>
        <div class="form-item">
          <label>营业执照图片URL <span style="color:red">*</span></label>
          <input v-model="form.licenseImage" placeholder="请填入营业执照图片URL（必填）" />
        </div>
      </template>

      <div class="form-item">
        <label>食品经营许可证号（选填）</label>
        <input v-model="form.foodPermitNumber" placeholder="请输入食品经营许可证号" />
      </div>
      <div class="form-item">
        <label>食品许可证图片URL（选填）</label>
        <input v-model="form.foodPermitImage" placeholder="请填入食品许可证图片URL" />
      </div>

      <button class="reg-btn" @click="submitReg">提交申请</button>
      <div class="tip">
        <span @click="$router.push('/login')">返回登录</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { submitApplication } from '@/api/goods'
import Toast from '@/components/Toast.vue'

const router = useRouter()
const toastRef = ref<any>(null)
const toast = (msg: string, type: string = 'error') => toastRef.value?.show(msg, type)

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

const submitReg = async () => {
  const f = form.value
  if (!f.companyName || !f.shopName || !f.contactName || !f.contactPhone || !f.shopAddress) {
    toast('请填写完整信息', 'error')
    return
  }
  if (!f.idCardFront || !f.idCardBack) {
    toast('请填写身份证正反面图片URL', 'error')
    return
  }
  if (f.applyType === 2 && (!f.licenseNumber || !f.licenseImage)) {
    toast('企业入驻必须提供营业执照信息', 'error')
    return
  }
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
    toast(`申请已提交！申请ID：${res.applyId}，状态：${res.auditStatusText}`, 'success')
    router.push('/login')
  } catch {}
}
</script>

<style scoped>
.reg-wrap {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  background: #F7F7F9;
  padding: 40px 0;
}
.reg-card {
  width: 480px;
  padding: 36px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #2D2D2D;
}
.form-item {
  margin-bottom: 16px;
}
.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #595959;
}
.form-item input, .form-item select {
  width: 100%;
  box-sizing: border-box;
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  color: #2D2D2D;
}
.form-item input:focus, .form-item select:focus {
  outline: none;
  border-color: #0E7490;
}
.reg-btn {
  width: 100%;
  padding: 12px;
  background: #E66100;
  color: #fff;
  border: none;
  border-radius: 4px;
  margin-top: 8px;
  cursor: pointer;
  font-size: 15px;
}
.reg-btn:hover {
  opacity: 0.92;
}
.tip {
  margin-top: 16px;
  text-align: center;
  font-size: 14px;
  color: #8C8C8C;
}
.tip span {
  color: #E66100;
  cursor: pointer;
}
</style>
