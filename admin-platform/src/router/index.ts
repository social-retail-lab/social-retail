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
      },
      {
        path: '/info-change',
        name: '信息审核',
        component: () => import('@/admin/audit/info-change.vue')
      },
      {
        path: '/merchant-list',
        name: '商家列表',
        component: () => import('@/admin/merchant/list.vue')
      },
      {
        path: '/product-list',
        name: '商品列表',
        component: () => import('@/admin/product/list.vue')
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
