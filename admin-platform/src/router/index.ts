import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/admin/dashboard/index.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/admin/login.vue')
  },
  {
    path: '/',
    component: DashboardLayout,
    redirect: '/dashboard',
    children: [
      {
        path: '/dashboard',
        name: '工作台',
        component: { template: '<div></div>' }
      },
      {
        path: '/merchant-audit',
        name: '商家审核',
        component: () => import('@/admin/audit/merchant.vue')
      },
      {
        path: '/product-audit',
        name: '商品审核',
        component: () => import('@/admin/audit/goods.vue')
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

  if (!token && to.path !== '/login') {
    return next('/login')
  }

  if (token && to.path === '/login') {
    return next('/dashboard')
  }

  next()
})

export default router
