<template>
  <div class="merchant-layout">
    <aside class="sidebar">
      <div class="sidebar-header">
        <h1>商家管理后台</h1>
      </div>
      <nav class="sidebar-nav">
        <div v-for="menu in menus" :key="menu.path">
          <div 
            :class="['nav-item', { active: currentPath === menu.path }]"
            @click="$router.push(menu.path)"
          >
            <span class="nav-icon">{{ menu.icon }}</span>
            <span class="nav-label">{{ menu.label }}</span>
          </div>
        </div>
      </nav>
      <div class="sidebar-footer">
        <button @click="logout" class="logout-btn">退出登录</button>
      </div>
    </aside>
    <main class="main-content">
      <header class="top-bar">
        <div class="top-left">
          <span class="merchant-name">{{ merchantInfo.name }}</span>
        </div>
        <div class="top-right">
          <span class="current-time">{{ currentTime }}</span>
        </div>
      </header>
      <div class="content-area">
        <router-view />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const currentPath = computed(() => route.path)

const merchantInfo = ref({
  name: localStorage.getItem('merchantName') || '我的店铺'
})

const currentTime = ref('')

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN')
}

let timer: number

onMounted(() => {
  updateTime()
  timer = window.setInterval(updateTime, 1000)
})

onUnmounted(() => {
  clearInterval(timer)
})

const menus = [
  { path: '/goods', label: '商品管理', icon: '🛒' },
  { path: '/orders', label: '订单管理', icon: '📋' },
  { path: '/pickup/verify', label: '门店核销', icon: '✅' },
  { path: '/pickup/manage', label: '自提点管理', icon: '📍' },
  { path: '/after-sale', label: '售后管理', icon: '🔧' },
  { path: '/earnings', label: '我的收益', icon: '💰' }
]

const logout = () => {
  localStorage.removeItem('merchantToken')
  localStorage.removeItem('merchantName')
  router.push('/login')
}
</script>

<style scoped>
.merchant-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.sidebar {
  width: 200px;
  background: #2D3748;
  color: #fff;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #4A5568;
}

.sidebar-header h1 {
  font-size: 14px;
  font-weight: 600;
  margin: 0;
  color: #fff;
}

.sidebar-nav {
  flex: 1;
  padding: 10px 0;
  overflow-y: auto;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  cursor: pointer;
  transition: background 0.2s;
}

.nav-item:hover {
  background: rgba(255,255,255,0.1);
}

.nav-item.active {
  background: #3182CE;
}

.nav-icon {
  font-size: 18px;
}

.nav-label {
  font-size: 14px;
}

.sidebar-footer {
  padding: 15px;
  border-top: 1px solid #4A5568;
}

.logout-btn {
  width: 100%;
  padding: 10px;
  background: transparent;
  color: #fff;
  border: 1px solid rgba(255,255,255,0.2);
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.logout-btn:hover {
  background: rgba(255,255,255,0.1);
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: #fff;
  border-bottom: 1px solid #E2E8F0;
}

.top-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.merchant-name {
  font-size: 15px;
  font-weight: 600;
  color: #2D3748;
}

.current-time {
  font-size: 13px;
  color: #718096;
}

.content-area {
  flex: 1;
  overflow-y: auto;
  background: #F7F7F9;
}
</style>