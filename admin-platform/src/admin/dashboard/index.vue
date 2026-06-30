<template>
  <div class="dashboard">
    <div class="header">
      <h2>社交新零售管理后台</h2>
      <div class="user-info">
        <span>管理员：{{ adminInfo?.realName || adminInfo?.username }}</span>
        <button @click="handleLogout">退出登录</button>
      </div>
    </div>
    <div class="nav">
      <router-link to="/dashboard">工作台</router-link>
      <router-link to="/merchant-audit">商家审核</router-link>
      <router-link to="/product-audit">商品审核</router-link>
    </div>
    <div class="content">
      <router-view />
      <div v-if="$route.path === '/dashboard'" class="welcome">
        <h3>欢迎使用管理系统</h3>
        <p>请使用左侧导航进入功能模块</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getAdminInfo, adminLogout } from '@/api/admin'

const router = useRouter()
const adminInfo = ref<any>(null)

onMounted(async () => {
  try {
    adminInfo.value = await getAdminInfo()
    localStorage.setItem('adminInfo', JSON.stringify(adminInfo.value))
  } catch {
    const cached = localStorage.getItem('adminInfo')
    if (cached) adminInfo.value = JSON.parse(cached)
  }
})

const handleLogout = async () => {
  try { await adminLogout() } catch {}
  localStorage.removeItem('adminToken')
  localStorage.removeItem('adminInfo')
  router.push('/login')
}
</script>

<style scoped>
.dashboard {
  width: 100vw;
  min-height: 100vh;
  background: #F2F3F5;
}
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 56px;
  background: #FFFFFF;
  box-shadow: 0 1px 4px rgba(0,0,0,0.08);
}
.header h2 {
  color: #1D2129;
  font-size: 18px;
  margin: 0;
}
.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #4E5969;
  font-size: 14px;
}
.user-info button {
  padding: 5px 12px;
  background: none;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  color: #E34D59;
}
.nav {
  display: flex;
  gap: 4px;
  padding: 10px 20px;
  background: #FFFFFF;
  border-bottom: 1px solid #eee;
}
.nav a {
  padding: 6px 16px;
  text-decoration: none;
  color: #4E5969;
  border-radius: 4px;
  font-size: 14px;
}
.nav a:hover, .nav a.router-link-active {
  background: #165DFF;
  color: #fff;
}
.content {
  padding: 0;
}
.welcome {
  text-align: center;
  margin-top: 120px;
  color: #86909C;
}
.welcome h3 {
  font-size: 22px;
  margin-bottom: 8px;
}
</style>
