<template>
  <div class="admin-layout">
    <aside class="sidebar">
      <div class="sidebar-header">
        <h1>社交新零售管理后台</h1>
      </div>
      <nav class="sidebar-nav">
        <div v-for="menu in menus" :key="menu.path">
          <div 
            :class="['nav-item', { active: currentPath === menu.path }]"
            @click="menu.children && menu.children.length ? '' : $router.push(menu.path)"
          >
            <span class="nav-label">{{ menu.label }}</span>
            <span v-if="menu.badge && badge[menu.badge]" class="nav-badge">{{ badge[menu.badge] }}</span>
            <span v-if="menu.dot && hasDot(menu.dot)" class="nav-dot"></span>
          </div>
          <div v-if="menu.children" class="sub-menu">
            <div 
              v-for="child in menu.children" 
              :key="child.path"
              :class="['sub-item', { active: currentPath === child.path }]"
              @click="$router.push(child.path)"
            >
              <span class="sub-label">{{ child.label }}</span>
              <span v-if="child.badge && badge[child.badge]" class="sub-badge">{{ badge[child.badge] }}</span>
            </div>
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
          <span class="admin-name">{{ adminInfo.username }}</span>
          <span :class="['admin-type', adminInfo.type]">{{ adminInfo.type === 'SYSTEM' ? '系统管理员' : '运营管理员' }}</span>
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

const adminInfo = ref({
  username: localStorage.getItem('adminType') === 'SYSTEM' ? 'admin' : 'operator',
  type: localStorage.getItem('adminType') || 'SYSTEM'
})

const currentTime = ref('')
const badge = ref<Record<string, number>>({})
const dot = ref<Record<string, boolean>>({})

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN')
}

const fetchBadges = async () => {
  try {
    const res = await axios.get('/api/admin/notifications/badges')
    if (res.data?.code === 0) {
      const d = res.data.data
      const auditTotal = (d.pendingProductAudit || 0)
      if (auditTotal > 0) badge.value['audit'] = auditTotal
      else badge.value['audit'] = 0
      dot.value['audit'] = d.unreadNotifications > 0
    }
  } catch { /* silently fail */ }
}

const hasDot = (key: string) => dot.value[key] === true

const markRead = async () => {
  if (currentPath.value === '/merchant-audit' || currentPath.value === '/product-audit' ||
      currentPath.value === '/info-change' || currentPath.value === '/after-sale-appeal') {
    try {
      await axios.post('/api/admin/notifications/mark-read', {})
      dot.value['audit'] = false
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

const systemMenus = [
  { 
    path: '/users', 
    label: '系统管理',
    children: [
      { path: '/users', label: '用户管理' },
      { path: '/roles', label: '角色管理' }
    ]
  }
]

const operationMenus = [
  { path: '/dashboard', label: '运营看板' },
  { 
    path: '/merchant-audit', 
    label: '审核管理',
    dot: 'audit',
    children: [
      { path: '/merchant-audit', label: '商家入驻审核' },
      { path: '/product-audit', label: '商品审核', badge: 'audit' },
      { path: '/info-change', label: '信息审核' },
      { path: '/after-sale-appeal', label: '售后处理' },
      { path: '/distributor-audit', label: '分销员审核' }
    ]
  },
  { 
    path: '/orders', 
    label: '订单管理'
  },
  { 
    path: '/seckill', 
    label: '营销管理',
    children: [
      { path: '/seckill', label: '秒杀活动' },
      { path: '/coupon', label: '优惠券管理' },
      { path: '/distribution', label: '分销管理' }
    ]
  }
]

const menus = computed(() => {
  return adminInfo.value.type === 'SYSTEM' ? systemMenus : operationMenus
})

const logout = () => {
  localStorage.removeItem('adminToken')
  localStorage.removeItem('adminType')
  router.push('/login')
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
}

.sidebar {
  width: 220px;
  background: #1D2129;
  color: #fff;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #333;
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
  padding: 12px 20px;
  cursor: pointer;
  transition: background 0.2s;
}

.nav-item:hover {
  background: rgba(255,255,255,0.1);
}

.nav-item.active {
  background: #165DFF;
}

.nav-label {
  font-size: 14px;
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

.sub-menu {
  background: rgba(0,0,0,0.2);
}

.sub-item {
  padding: 10px 20px 10px 50px;
  cursor: pointer;
  transition: background 0.2s;
}

.sub-item:hover {
  background: rgba(255,255,255,0.08);
}

.sub-item.active {
  background: rgba(22,93,255,0.3);
  color: #69B1FF;
}

.sub-label {
  font-size: 13px;
  color: rgba(255,255,255,0.7);
}

.sub-item.active .sub-label {
  color: #69B1FF;
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

.sub-badge {
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

.sidebar-footer {
  padding: 15px;
  border-top: 1px solid #333;
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
  border-bottom: 1px solid #f0f0f0;
}

.top-left {
  display: flex;
  align-items: center;
  gap: 10px;
}

.admin-name {
  font-size: 14px;
  color: #1D2129;
}

.admin-type {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.admin-type.SYSTEM {
  background: #F6FFED;
  color: #52C41A;
}

.admin-type.OPERATION {
  background: #E6F7FF;
  color: #1890FF;
}

.current-time {
  font-size: 13px;
  color: #86909C;
}

.content-area {
  flex: 1;
  overflow-y: auto;
  background: #F2F3F5;
}
</style>