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
            @click="$router.push(menu.path)"
          >
            <span class="nav-icon">{{ menu.icon }}</span>
            <span class="nav-label">{{ menu.label }}</span>
          </div>
          <div v-if="menu.children" class="sub-menu">
            <div 
              v-for="child in menu.children" 
              :key="child.path"
              :class="['sub-item', { active: currentPath === child.path }]"
              @click="$router.push(child.path)"
            >
              <span class="sub-label">{{ child.label }}</span>
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

const router = useRouter()
const route = useRoute()

const currentPath = computed(() => route.path)

const adminInfo = ref({
  username: localStorage.getItem('adminType') === 'SYSTEM' ? 'admin' : 'operator',
  type: localStorage.getItem('adminType') || 'SYSTEM'
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

const systemMenus = [
  { 
    path: '/users', 
    label: '系统管理', 
    icon: '⚙️',
    children: [
      { path: '/users', label: '用户管理' },
      { path: '/roles', label: '角色管理' }
    ]
  }
]

const operationMenus = [
  { path: '/dashboard', label: '运营看板', icon: '📊' },
  { 
    path: '/merchant-audit', 
    label: '审核管理', 
    icon: '✅',
    children: [
      { path: '/merchant-audit', label: '商家入驻审核' },
      { path: '/product-audit', label: '商品审核' },
      { path: '/info-change', label: '信息审核' }
    ]
  },
  { 
    path: '/orders', 
    label: '订单管理', 
    icon: '📋'
  },
  { 
    path: '/seckill', 
    label: '营销管理', 
    icon: '🎯',
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
  gap: 10px;
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

.nav-icon {
  font-size: 16px;
}

.nav-label {
  font-size: 14px;
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