<template>
  <div class="reg-wrap">
    <div class="reg-card">
      <h2>商家账号注册</h2>
      <div class="form-item">
        <label>手机号</label>
        <input v-model="form.phone" placeholder="请输入手机号" />
      </div>
      <div class="form-item code-row">
        <input v-model="form.code" placeholder="短信验证码" />
        <button class="code-btn" :disabled="countDown > 0">
          {{ countDown > 0 ? `${countDown}s后重发` : '获取验证码' }}
        </button>
      </div>
      <div class="form-item">
        <label>设置登录密码</label>
        <input v-model="form.password" type="password" placeholder="6位以上密码" />
      </div>
      <div class="form-item">
        <label>确认密码</label>
        <input v-model="form.confirmPwd" type="password" placeholder="再次输入密码" />
      </div>
      <button class="reg-btn" :disabled="submitting" @click="submitReg">
        {{ submitting ? '注册中...' : '注册' }}
      </button>
      <div class="tip">
        已有账号？<span @click="$router.push('/login')">返回登录</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { merchantLogin } from '@/api/order'

const router = useRouter()
const countDown = ref(0)
const submitting = ref(false)
const form = ref({
  phone: '',
  code: '',
  password: '',
  confirmPwd: ''
})

// 倒计时获取验证码
const sendCode = () => {
  if (!/^1\d{10}$/.test(form.value.phone)) {
    alert('请输入正确手机号')
    return
  }
  alert('验证码已发送（模拟）')
  countDown.value = 60
  const timer = setInterval(() => {
    countDown.value--
    if (countDown.value <= 0) clearInterval(timer)
  }, 1000)
}

// 提交注册（自动登录后跳转入驻申请）
const submitReg = async () => {
  const val = form.value
  if (!val.phone || !val.code || !val.password) {
    alert('手机号、验证码、密码不能为空')
    return
  }
  if (val.password.length < 6) {
    alert('密码至少6位')
    return
  }
  if (val.password !== val.confirmPwd) {
    alert('两次密码不一致')
    return
  }
  submitting.value = true
  try {
    const res = await merchantLogin({ phone: val.phone, password: val.password, smsCode: '123456' })
    if (res.code === 0) {
      localStorage.setItem('merchantToken', res.data.token)
      localStorage.setItem('merchantStatus', String(res.data.merchantStatus ?? 0))
      localStorage.setItem('merchantInfo', JSON.stringify(res.data))
      alert('注册成功，请提交入驻申请')
      router.replace('/onboarding')
    } else {
      alert(res.message || '注册失败')
    }
  } catch (err: any) {
    alert(err.message || '注册失败，请稍后重试')
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.reg-wrap {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F7F7F9;
}
.reg-card {
  width: 380px;
  padding: 36px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0.06);
}
h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #2D2D2D;
}
.form-item {
  margin-bottom: 16px;
}
.code-row {
  display: flex;
  gap: 12px;
}
.code-row input {
  flex: 1;
}
.code-btn {
  white-space: nowrap;
  padding: 0 12px;
  background: #0E7490;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #595959;
}
.form-item input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
}
.form-item input:focus {
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