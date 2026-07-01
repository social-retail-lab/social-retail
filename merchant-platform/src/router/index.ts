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
    path: '/',
    name: '商家首页',
    component: () => import('@/components/Layout.vue'),
    redirect: '/goods',
    children: [
      {
        path: '/store-info',
        name: '商家信息',
        component: () => import('@/merchant/store-info/index.vue')
      },
      {
        path: '/audit-requests',
        name: '审核请求',
        component: () => import('@/merchant/audit-requests/index.vue')
      },
      {
        path: '/goods',
        name: '商品管理',
        component: () => import('@/merchant/goods/list.vue')
      },
      {
        path: '/goods/edit/:id?',
        name: '商品编辑',
        component: () => import('@/merchant/goods/edit.vue')
      },
      {
        path: '/orders',
        name: '订单管理',
        component: () => import('@/merchant/order/list.vue')
      },
      {
        path: '/pickup/verify',
        name: '门店核销',
        component: () => import('@/merchant/pickup/verify.vue')
      },
      {
        path: '/pickup/manage',
        name: '自提点管理',
        component: () => import('@/merchant/pickup/manage.vue')
      },
      {
        path: '/after-sale',
        name: '售后管理',
        component: () => import('@/merchant/after-sale/list.vue')
      },
      {
        path: '/earnings',
        name: '我的收益',
        component: () => import('@/merchant/earnings/index.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('merchantToken')
  if (to.path === '/login' || to.path === '/register') {
    return next()
  }
  if (!token) {
    return next('/login')
  }
  next()
})

export default router