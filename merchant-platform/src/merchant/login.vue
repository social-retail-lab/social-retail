<template>
  <div class="login-wrap">
    <div class="login-card">
      <h2>商家后台登录</h2>
      <div class="form-item">
        <label>商家手机号</label>
        <input v-model="form.phone" placeholder="请输入入驻手机号" />
      </div>
      <div class="form-item">
        <label>登录密码</label>
        <input v-model="form.password" type="password" placeholder="输入密码" />
      </div>
      <button class="login-btn" @click="login">登录</button>
      <div class="tip">
        暂无账号？<span @click="$router.push('/register')">立即注册</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { merchantLogin } from '@/api/order'

const router = useRouter()
const form = ref({
  phone: '',
  password: ''
})

const login = async () => {
  if (!form.value.phone || !form.value.password) {
    alert('手机号和密码不能为空')
    return
  }
  const res = await merchantLogin({ ...form.value, smsCode: '123456' })
  if (res.code === 0) {
    localStorage.setItem('merchantToken', res.data.token)
    localStorage.setItem('merchantName', res.data.merchantName || '我的店铺')
    localStorage.setItem('merchantInfo', JSON.stringify(res.data))
    router.push('/goods')
  } else {
    alert(res.message)
  }
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