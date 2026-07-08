import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/merchant/login.vue')
  },
  {
    path: '/register',
    name: 'Register',
