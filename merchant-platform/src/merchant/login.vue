<template>
  <div class="login-wrap">
    <Toast ref="toastRef" />
    <div class="login-card">
      <h2>商家后台登录</h2>
      <div class="form-item">
        <label>手机号</label>
        <input v-model="form.phone" placeholder="请输入手机号" />
      </div>
      <div class="form-item">
        <label>登录密码</label>
        <input v-model="form.password" type="password" placeholder="输入密码" />
      </div>
      <div class="form-item code-row">
        <input v-model="form.smsCode" placeholder="短信验证码" />
        <button class="code-btn" :disabled="countDown > 0" @click="sendCode">
          {{ countDown > 0 ? `${countDown}s后重发` : '获取验证码' }}
        </button>
      </div>
      <button class="login-btn" @click="login">登录</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { merchantLogin } from '@/api/goods'
import Toast from '@/components/Toast.vue'

const router = useRouter()
const toastRef = ref<any>(null)
const toast = (msg: string, type: string = 'error') => toastRef.value?.show(msg, type)
const countDown = ref(0)
const form = ref({
  phone: '',
  password: '',
  smsCode: ''
})

const sendCode = () => {
  if (!/^1\d{10}$/.test(form.value.phone)) {
    toast('请输入正确手机号', 'error')
    return
  }
  toast('验证码已发送（模拟，输入任意6位数字即可）', 'info')
  countDown.value = 60
  const timer = setInterval(() => {
    countDown.value--
    if (countDown.value <= 0) clearInterval(timer)
  }, 1000)
}

const login = async () => {
  if (!form.value.phone || !form.value.password || !form.value.smsCode) {
    toast('手机号、密码、验证码不能为空', 'error')
    return
  }
  if (form.value.password.length < 6) {
    toast('密码至少6位', 'error')
    return
  }
  try {
    const res = await merchantLogin({
      phone: form.value.phone,
      password: form.value.password,
      smsCode: form.value.smsCode
    })
    localStorage.setItem('merchantToken', res.token)
    localStorage.setItem('merchantInfo', JSON.stringify(res.merchantInfo))
    if (res.merchantStatus === 0) {
      router.push('/register')
    } else {
      router.push('/product-manage')
    }
  } catch {}
}
</script>

<style scoped>
.login-wrap {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F7F7F9;
}
.login-card {
  width: 380px;
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
  font-size: 14px;
  color: #2D2D2D;
}
.form-item input:focus {
  outline: none;
  border-color: #0E7490;
}
.login-btn {
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
.login-btn:hover {
  opacity: 0.92;
}
</style>
