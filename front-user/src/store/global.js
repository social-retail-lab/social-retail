// 全局loading、弹窗状态管理
// 包含：全局Loading、登录弹窗、消息提示

import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useGlobalStore = defineStore('global', () => {
  // 全局Loading状态
  const loading = ref(false)
  
  // 登录弹窗状态
  const showLoginPopup = ref(false)
  
  // 消息提示
  const toast = ref({
    show: false,
    message: '',
    type: 'success' // success/warning/error/info
  })
  
  // 显示Loading
  const showLoading = () => {
    loading.value = true
  }
  
  // 隐藏Loading
  const hideLoading = () => {
    loading.value = false
  }
  
  // 显示登录弹窗
  const openLoginPopup = () => {
    showLoginPopup.value = true
  }
  
  // 隐藏登录弹窗
  const closeLoginPopup = () => {
    showLoginPopup.value = false
  }
  
  // 显示消息提示
  const showToast = (message, type = 'success') => {
    toast.value = {
      show: true,
      message,
      type
    }
    setTimeout(() => {
      toast.value.show = false
    }, 2000)
  }
  
  // 显示成功提示
  const showSuccessToast = (message) => {
    showToast(message, 'success')
  }
  
  // 显示错误提示
  const showErrorToast = (message) => {
    showToast(message, 'error')
  }
  
  // 显示警告提示
  const showWarningToast = (message) => {
    showToast(message, 'warning')
  }
  
  return {
    loading,
    showLoginPopup,
    toast,
    showLoading,
    hideLoading,
    openLoginPopup,
    closeLoginPopup,
    showToast,
    showSuccessToast,
    showErrorToast,
    showWarningToast
  }
})
