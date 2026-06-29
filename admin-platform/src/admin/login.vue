<template>
  <div class="login-container">
    <div class="login-box">
      <h2>社交新零售管理后台</h2>
      <!-- 管理员身份下拉 -->
      <div class="form-item">
        <label>管理员类型</label>
        <select v-model="loginForm.adminType" class="select-input">
          <option value="SYSTEM">系统管理员</option>
          <option value="OPERATION">运营管理员</option>
        </select>
      </div>
      <!-- 账号 -->
      <div class="form-item">
        <input
          v-model="loginForm.username"
          placeholder="请输入账号"
          type="text"
        />
      </div>
      <!-- 密码 -->
      <div class="form-item">
        <input
          v-model="loginForm.password"
          placeholder="请输入密码"
          type="password"
        />
      </div>
      <button class="login-btn" @click="handleLogin">登录</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
// 导入两个身份的登录接口
import { systemAdminLogin, operationAdminLogin } from '@/api/admin'

const router = useRouter()

// 表单数据
const loginForm = ref({
  adminType: 'SYSTEM',
  username: '',
  password: ''
})

// 登录逻辑
const handleLogin = async () => {
  const { adminType, username, password } = loginForm.value
  if (!username || !password) {
    alert('账号密码不能为空')
    return
  }
  let res
  // 根据身份调用对应接口
  if (adminType === 'SYSTEM') {
    res = await systemAdminLogin({ username, password })
  } else {
    res = await operationAdminLogin({ username, password })
  }

  // 判断登录成功（统一code=0为成功）
  if (res.code === 0) {
    // 本地存储token + 管理员身份，全局权限判断用
    localStorage.setItem('adminToken', res.data.token)
    localStorage.setItem('adminType', adminType)
    localStorage.setItem('adminInfo', JSON.stringify(res.data.adminInfo))
    // 跳首页
    router.push('/dashboard')
  } else {
    alert(res.message || '登录失败')
  }
}
</script>

<style scoped>
.login-container {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: background: #f5f5f5;
}
.login-box {
  width: 400px;
  padding: 40px;
  background: #fff;
  border-radius: 8px;
}
.form-item {
  margin-bottom: 16px;
}
.form-item label {
  display: block;
  margin-bottom: 6px;
}
.form-item input, .select-input {
  width: 100%;
  padding: 10px;
  box-sizing: border-box;
  border: 1px #ddd solid;
  border-radius: 4px;
}
.login-btn {
  width: 100%;
  padding: 12px;
  background: #409eff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>