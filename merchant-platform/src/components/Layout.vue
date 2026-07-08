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
            <span class="nav-label">{{ menu.label }}</span>
            <span v-if="badge[menu.badge]" class="nav-badge">{{ badge[menu.badge] }}</span>
            <span v-if="!badge[menu.badge] && menu.dot && hasDot(menu.dot)" class="nav-dot"></span>
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
import axios from 'axios'

const router = useRouter()
const route = useRoute()

const currentPath = computed(() => route.path)

const merchantInfo = ref({
  name: localStorage.getItem('merchantName') || '我的店铺'
})

const badge = ref<Record<string, number>>({})
const dot = ref<Record<string, boolean>>({})

const currentTime = ref('')
const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN')
}

const fetchBadges = async () => {
  try {
    const res = await axios.get('/api/merchant/notifications/badges')
    if (res.data?.code === 0) {
      const d = res.data.data
      if (d.pendingAccept > 0) badge.value['order'] = d.pendingAccept
      else badge.value['order'] = 0
      if (d.pendingAfterSale > 0) badge.value['afterSale'] = d.pendingAfterSale
      else badge.value['afterSale'] = 0
      dot.value['auditRequest'] = d.unreadNotifications > 0
    }
  } catch { /* silently fail */ }
}

const hasDot = (key: string) => dot.value[key] === true

// mark notifications as read when visiting audit-requests page
const markRead = async () => {
  if (currentPath.value === '/audit-requests') {
    try {
      await axios.post('/api/merchant/notifications/mark-read', { type: 'AUDIT_RESULT' })
      dot.value['auditRequest'] = false
    } catch { /* silently fail */ }
  }
}

let badgeTimer: number
let dotTimer: number
let timer: number

onMounted(() => {
  fetchBadges()
  updateTime()
  badgeTimer = window.setInterval(fetchBadges, 30000)
  dotTimer = window.setInterval(markRead, 2000)
  timer = window.setInterval(updateTime, 1000)
})

onUnmounted(() => {
  clearInterval(badgeTimer)
  clearInterval(dotTimer)
  clearInterval(timer)
})

const menus = [
  { path: '/dashboard', label: '店铺看板' },
  { path: '/store-info', label: '商家信息' },
  { path: '/audit-requests', label: '审核请求', dot: 'auditRequest' },
  { path: '/goods', label: '商品管理' },
  { path: '/orders', label: '订单管理', badge: 'order' },
  { path: '/pickup', label: '门店核销' },
  { path: '/after-sale', label: '售后管理', badge: 'afterSale' },
  { path: '/reviews', label: '用户评价' },
  { path: '/promotion', label: '店铺促销' },
  { path: '/earnings', label: '我的收益' }
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

.nav-label {
  font-size: 14px;
}

.nav-badge {
  margin-left: auto;
  background: #FF4D4F;
  color: #fff;
  font-size: 11px;
  min-width: 18px;
  height: 18px;
  line-height: 18px;
  text-align: center;
  border-radius: 9px;
  padding: 0 5px;
}

.nav-dot {
  margin-left: auto;
  width: 8px;
  height: 8px;
  background: #FF4D4F;
  border-radius: 50%;
}

/* 滚动条美化 */
.sidebar-nav::-webkit-scrollbar {
  width: 4px;
}
.sidebar-nav::-webkit-scrollbar-track {
  background: transparent;
}
.sidebar-nav::-webkit-scrollbar-thumb {
  background: transparent;
  border-radius: 2px;
  transition: background 0.3s;
}
.sidebar-nav:hover::-webkit-scrollbar-thumb {
  background: rgba(255,255,255,0.15);
}
.sidebar-nav::-webkit-scrollbar-thumb:hover {
  background: rgba(255,255,255,0.3);
}
.sidebar-nav {
  scrollbar-width: thin;
  scrollbar-color: transparent transparent;
}

.content-area::-webkit-scrollbar {
  width: 4px;
}
.content-area::-webkit-scrollbar-track {
  background: transparent;
}
.content-area::-webkit-scrollbar-thumb {
  background: transparent;
  border-radius: 2px;
  transition: background 0.3s;
}
.content-area:hover::-webkit-scrollbar-thumb {
  background: rgba(0,0,0,0.12);
}
.content-area::-webkit-scrollbar-thumb:hover {
  background: rgba(0,0,0,0.25);
}
.content-area {
  scrollbar-width: thin;
  scrollbar-color: transparent transparent;
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