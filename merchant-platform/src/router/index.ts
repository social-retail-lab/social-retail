import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '@/merchant/MainLayout.vue'

const routes = [
  {
    path: '/login',
    name: '商家登录',
    component: () => import('@/merchant/login.vue')
  },
  {
    path: '/register',
    name: '商家入驻',
    component: () => import('@/merchant/register.vue')
  },
  {
    path: '/',
    component: MainLayout,
    redirect: '/store-info',
    children: [
      {
        path: '/store-info',
        name: '商家信息',
        component: () => import('@/merchant/StoreInfo.vue')
      },
      {
        path: '/product-manage',
        name: '商品列表',
        component: () => import('@/merchant/product.vue')
      },
      {
        path: '/orders',
        name: '订单处理',
        component: () => import('@/merchant/Orders.vue')
      },
      {
        path: '/business-data',
        name: '经营数据',
        component: () => import('@/merchant/BusinessData.vue')
      },
      {
        path: '/audit-requests',
        name: '审核请求',
        component: () => import('@/merchant/AuditRequests.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 登录拦截
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('merchantToken')
  // 不需要登录页面直接放行
  if (to.path === '/login' || to.path === '/register') {
    return next()
  }
  // 其他页面需要登录
  if (!token) {
    return next('/login')
  }
  next()
})

export default router
