<template>
  <div class="layout">
    <aside class="sidebar">
      <div class="logo">商家控制台</div>
      <nav>
        <router-link to="/store-info" class="nav-item">商家信息</router-link>
        <router-link to="/product-manage" class="nav-item">商品列表</router-link>
        <router-link to="/orders" class="nav-item">订单处理</router-link>
        <router-link to="/business-data" class="nav-item">经营数据</router-link>
        <router-link to="/audit-requests" class="nav-item">审核请求</router-link>
      </nav>
      <div class="sidebar-footer">
        <button @click="handleLogout">退出登录</button>
      </div>
    </aside>
    <main class="main">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

function handleLogout() {
  localStorage.removeItem('merchantToken')
  router.push('/login')
}
</script>

<style scoped>
.layout {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  width: 200px;
  background: #FFFFFF;
  border-right: 1px solid #E5E6EB;
  display: flex;
  flex-direction: column;
  padding: 0;
  flex-shrink: 0;
}
.logo {
  padding: 20px 16px;
  font-size: 16px;
  font-weight: 600;
  color: #1D2129;
  border-bottom: 1px solid #E5E6EB;
}
nav {
  flex: 1;
  padding: 8px 0;
}
.nav-item {
  display: block;
  padding: 10px 16px;
  text-decoration: none;
  color: #4E5969;
  font-size: 14px;
  transition: background 0.2s;
  border-left: 3px solid transparent;
}
.nav-item:hover {
  background: #F2F3F5;
}
.nav-item.router-link-active {
  background: #E8F3FF;
  color: #165DFF;
  border-left-color: #165DFF;
}
.sidebar-footer {
  padding: 12px 16px;
  border-top: 1px solid #E5E6EB;
}
.sidebar-footer button {
  width: 100%;
  padding: 6px 0;
  background: none;
  border: 1px solid #E5E6EB;
  border-radius: 4px;
  color: #86909C;
  cursor: pointer;
  font-size: 13px;
}
.main {
  flex: 1;
  padding: 20px;
  background: #F7F7F9;
}
</style>
