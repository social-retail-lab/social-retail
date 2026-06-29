import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/admin/login.vue')
  },
  {
    path: '/',
    redirect: '/dashboard',
    children: [
      {
        path: '/dashboard',
        name: '工作台',
        component: () => import('@/admin/dashboard/index.vue')
      },
      {
        path: '/merchant-audit',
        name: '商家审核',
        component: () => import('@/admin/audit/goods.vue')
      },
      {
        path: '/product-audit',
        name: '商品审核',
        component: () => import('@/admin/audit/goods.vue')
      },
      // 仅系统管理员可访问页面
      {
        path: '/system',
        name: '系统管理',
        component: () => import('@/admin/system/user.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('adminToken')
  const adminType = localStorage.getItem('adminType')

  // 未登录强制跳登录页
  if (!token && to.path !== '/login') {
    return next('/login')
  }

  // 已登录禁止回到登录页
  if (token && to.path === '/login') {
    return next('/dashboard')
  }

  // 权限拦截：/system 仅系统管理员SYSTEM可进
  if (to.path.startsWith('/system') && adminType !== 'SYSTEM') {
    alert('无权限，仅系统管理员可访问系统模块')
    return next('/dashboard')
  }

  next()
})

export default router