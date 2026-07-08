<template>
  <div class="login-wrap">
    <div class="login-card">
      <h2>社交新零售管理后台</h2>
      <div class="form-item">
        <label>账号</label>
        <input v-model="username" placeholder="请输入管理员账号" />
      </div>
      <div class="form-item">
        <label>密码</label>
        <input v-model="password" type="password" placeholder="请输入登录密码" />
      </div>
      <button class="login-btn" @click="handleLogin">登录</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { adminLogin } from '@/api/admin'

const router = useRouter()
const username = ref('')
const password = ref('')

const handleLogin = async () => {
  if (!username.value || !password.value) {
    alert('账号密码不能为空')
    return
  }
  const res = await adminLogin({ username: username.value, password: password.value })
  if (res.code === 0) {
    localStorage.setItem('adminToken', res.data.token)
    localStorage.setItem('adminType', res.data.role || 'OPERATION')
    localStorage.setItem('adminInfo', JSON.stringify(res.data))
    router.push('/dashboard')
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
  background: #F2F3F5;
}
.login-card {
  width: 380px;
  padding: 36px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
h2 {
  text-align: center;
  margin-bottom: 24px;
  color: #1D2129;
  font-size: 22px;
}
.form-item {
  margin-bottom: 16px;
}
.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #4E5969;
}
.form-item input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}
.form-item input:focus {
  outline: none;
  border-color: #165DFF;
}
.login-btn {
  width: 100%;
  padding: 11px;
  background: #165DFF;
  color: #fff;
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