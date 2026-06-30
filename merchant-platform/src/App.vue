<template>
  <router-view />
  <Toast ref="toastRef" />
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Toast from '@/components/Toast.vue'
import { setToast } from '@/utils/request'

const toastRef = ref(null)

onMounted(() => {
  // 将 Toast 的 show 方法注入 request 拦截器，统一错误通知
  if (toastRef.value) {
    setToast((msg, type) => toastRef.value?.show(msg, type))
  }
})
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  background: #F7F7F9;
  font-family: system-ui, -apple-system, sans-serif;
  color: #2D2D2D;
}
input, button, select, textarea {
  font-family: inherit;
}
</style>
