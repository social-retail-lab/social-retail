<template>
  <div class="onboarding-wrap">
    <div class="onboarding-card">
      <h2>商家入驻申请</h2>
      <div v-if="rejectedRemark" class="reject-banner">
        上次申请被驳回：{{ rejectedRemark }}，请修改后重新提交
      </div>
      <div class="form-item">
        <label>入驻类型</label>
        <div class="type-row">
          <label class="type-option">
            <input type="radio" v-model="form.applyType" :value="1" />
            <span>个人入驻</span>
          </label>
          <label class="type-option">
            <input type="radio" v-model="form.applyType" :value="2" />
            <span>企业入驻</span>
          </label>
        </div>
      </div>
      <div class="form-item" v-if="form.applyType === 2">
        <label>企业名称</label>
        <input v-model="form.companyName" placeholder="请输入企业全称" />
      </div>
      <div class="form-item">
        <label>店铺名称</label>
        <input v-model="form.shopName" placeholder="请输入店铺名称" />
      </div>
      <div class="form-item">
        <label>联系人姓名</label>
        <input v-model="form.contactName" placeholder="请输入联系人姓名" />
      </div>
      <div class="form-item">
        <label>联系电话</label>
        <input v-model="form.contactPhone" placeholder="请输入手机号" />
      </div>
      <div class="form-item">
        <label>店铺地址</label>
        <input v-model="form.shopAddress" placeholder="请输入店铺详细地址" />
      </div>
      <div class="form-item" v-if="form.applyType === 2">
        <label>营业执照编号</label>
        <input v-model="form.licenseNumber" placeholder="请输入营业执照编号" />
      </div>
      <div class="form-item" v-if="form.applyType === 2">
        <label>食品经营许可证编号（选填）</label>
        <input v-model="form.foodPermitNumber" placeholder="如有请填写" />
      </div>
      <button class="submit-btn" :disabled="submitting" @click="handleSubmit">
        {{ submitting ? '提交中...' : '提交入驻申请' }}
      </button>
      <div class="tip">
        <span @click="handleLogout">退出登录</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { submitMerchantApplication, getApplicationStatus } from '@/api/order'

const router = useRouter()
const submitting = ref(false)
const rejectedRemark = ref('')

const form = ref({
  applyType: 1,
  shopName: '',
  contactName: '',
  contactPhone: '',
  shopAddress: '',
  companyName: '',
  licenseNumber: '',
  foodPermitNumber: ''
})

onMounted(async () => {
  try {
    const res = await getApplicationStatus()
    if (res.code === 0 && res.data) {
      if (res.data.auditStatus === 0) {
        router.replace('/pending-review')
        return
      }
      if (res.data.auditStatus === 2) {
        rejectedRemark.value = res.data.auditRemark || '审核未通过'
        form.value.shopName = res.data.shopName || ''
        form.value.contactName = res.data.contactName || ''
        form.value.contactPhone = res.data.contactPhone || ''
        form.value.shopAddress = res.data.shopAddress || ''
      }
    }
  } catch {
    // ignore
  }
})

const handleSubmit = async () => {
  const f = form.value
  if (!f.shopName || !f.contactName || !f.contactPhone || !f.shopAddress) {
    alert('请填写所有必填项')
    return
  }
  if (!/^1\d{10}$/.test(f.contactPhone)) {
    alert('请输入正确的手机号')
    return
  }
  if (f.applyType === 2 && (!f.companyName || !f.licenseNumber)) {
    alert('企业入驻必须填写企业名称和营业执照编号')
    return
  }
  submitting.value = true
  try {
    const payload: any = {
      applyType: f.applyType,
      shopName: f.shopName,
      contactName: f.contactName,
      contactPhone: f.contactPhone,
      shopAddress: f.shopAddress
    }
    if (f.applyType === 2) {
      payload.companyName = f.companyName
      payload.licenseNumber = f.licenseNumber
      if (f.foodPermitNumber) payload.foodPermitNumber = f.foodPermitNumber
    }
    const res = await submitMerchantApplication(payload)
    if (res.code === 0) {
      alert('入驻申请提交成功，请等待审核')
      router.replace('/pending-review')
    } else {
      alert(res.message || '提交失败')
    }
  } catch (err: any) {
    alert(err.message || '提交失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}

const handleLogout = () => {
  localStorage.removeItem('merchantToken')
  localStorage.removeItem('merchantStatus')
  localStorage.removeItem('merchantInfo')
  router.replace('/login')
}
</script>

<style scoped>
.onboarding-wrap {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  padding: 40px 16px;
  background: #F7F7F9;
}
.onboarding-card {
  width: 100%;
  max-width: 460px;
  padding: 36px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #2D2D2D;
  font-size: 22px;
}
.reject-banner {
  background: #FFF2F0;
  border: 1px solid #FFCCC7;
  border-radius: 4px;
  padding: 10px 12px;
  margin-bottom: 16px;
  font-size: 13px;
  color: #CF1322;
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
.form-item input[type="text"],
.form-item input:not([type]) {
  width: 100%;
  box-sizing: border-box;
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  color: #2D2D2D;
}
.form-item input:focus {
  outline: none;
  border-color: #0E7490;
}
.type-row {
  display: flex;
  gap: 24px;
}
.type-option {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #2D2D2D;
}
.type-option input {
  margin: 0;
}
.submit-btn {
  width: 100%;
  padding: 11px;
  background: #E66100;
  color: white;
  border: none;
  border-radius: 4px;
  margin-top: 8px;
  cursor: pointer;
  font-size: 15px;
}
.submit-btn:hover {
  opacity: 0.92;
}
.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.tip {
  margin-top: 16px;
  text-align: center;
  font-size: 14px;
}
.tip span {
  color: #8C8C8C;
  cursor: pointer;
}
.tip span:hover {
  color: #E66100;
}
</style>
