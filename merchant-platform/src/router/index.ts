import { createRouter, createWebHistory } from 'vue-router'

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
    path: '/product-manage',
    name: '商品管理',
    component: () => import('@/merchant/product.vue')
  },
  {
    path: '/',
    redirect: '/login'
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
  // 商品管理需要登录
  if (!token) {
    return next('/login')
  }
  next()
})

export default router