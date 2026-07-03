import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/admin/login.vue')
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('@/components/Layout.vue'),
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
        path: '/users',
        name: '用户管理',
        component: () => import('@/admin/system/user.vue')
      },
      {
        path: '/orders',
        name: '订单管理',
        component: () => import('@/admin/system/order.vue')
      },
      {
        path: '/roles',
        name: '角色管理',
        component: () => import('@/admin/system/role.vue')
      },
      {
        path: '/seckill',
        name: '秒杀活动',
        component: () => import('@/admin/marketing/seckill.vue')
      },
      {
        path: '/coupon',
        name: '优惠券管理',
        component: () => import('@/admin/marketing/coupon.vue')
      },
      {
        path: '/distribution',
        name: '分销管理',
        component: () => import('@/admin/marketing/distribution.vue')
      },
      {
        path: '/after-sale-appeal',
        name: '售后处理',
        component: () => import('@/admin/audit/after-sale.vue')
      },
      {
        path: '/distributor-audit',
        name: '分销员审核',
        component: () => import('@/admin/audit/distributor.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('adminToken')
  const adminType = localStorage.getItem('adminType')

  if (!token && to.path !== '/login') {
    return next('/login')
  }

  if (token && to.path === '/login') {
    return next(adminType === 'SYSTEM' ? '/users' : '/dashboard')
  }

  if ((to.path.startsWith('/users') || to.path.startsWith('/roles')) && adminType !== 'SYSTEM') {
    alert('无权限，仅系统管理员可访问')
    return next('/dashboard')
  }

  if ((to.path.startsWith('/dashboard') || to.path.startsWith('/merchant-audit') || to.path.startsWith('/product-audit') || to.path.startsWith('/info-change') || to.path.startsWith('/orders') || to.path.startsWith('/seckill') || to.path.startsWith('/coupon') || to.path.startsWith('/distribution') || to.path.startsWith('/after-sale-appeal') || to.path.startsWith('/distributor-audit')) && adminType === 'SYSTEM') {
    alert('无权限，系统管理员不可访问业务运营功能')
    return next('/users')
  }

  next()
})

export default router