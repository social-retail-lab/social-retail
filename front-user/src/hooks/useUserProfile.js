import { ref } from 'vue'
import { useUserStore } from '@/store/user'
import { showToast } from '@/utils/common'

export function useUserProfile() {
  const userStore = useUserStore()
  const loading = ref(false)
  const countdown = ref(0)
  let timer = null

  const startCountdown = (seconds = 60) => {
    if (timer) clearInterval(timer)
    countdown.value = seconds
    timer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(timer)
        timer = null
      }
    }, 1000)
  }

  const clearTimer = () => {
    if (timer) {
      clearInterval(timer)
      timer = null
      countdown.value = 0
    }
  }

  const loadUpdateUserInfo = async (data) => {
    loading.value = true
    try {
      const res = await userStore.fetchUpdateUserInfo(data)
      if (res) {
        userStore.updateUserInfo(res)
        showToast('修改成功')
        return true
      } else {
        showToast('修改失败')
        return false
      }
    } catch (error) {
      console.error('修改用户信息失败:', error)
      showToast('修改失败')
      return false
    } finally {
      loading.value = false
    }
  }

  const loadSendChangePhoneCode = async (phone) => {
    startCountdown(60)
    try {
      await userStore.fetchSendSmsCode({ phone, scene: 'CHANGE_PHONE' })
      showToast('验证码已发送')
    } catch (error) {
      if (error && error.code === 42901 && error.data?.retryAfterSeconds) {
        startCountdown(error.data.retryAfterSeconds)
      } else {
        clearTimer()
      }
    }
  }

  const loadUpdatePhone = async (data) => {
    loading.value = true
    try {
      const res = await userStore.fetchUpdatePhone(data)
      if (res) {
        if (res.phone) {
          userStore.updateUserInfo({ phone: res.phone })
        }
        showToast('手机号修改成功')
        setTimeout(() => {
          uni.navigateBack()
        }, 1500)
        return true
      } else {
        showToast('手机号修改失败')
        return false
      }
    } catch (error) {
      console.error('修改手机号失败:', error)
      showToast('手机号修改失败')
      return false
    } finally {
      loading.value = false
    }
  }

  const loadUpdatePassword = async (data) => {
    loading.value = true
    try {
      const success = await userStore.fetchUpdatePassword(data)
      if (success) {
        showToast('密码修改成功')
        setTimeout(() => {
          uni.navigateBack()
        }, 1500)
        return true
      } else {
        showToast('密码修改失败')
        return false
      }
    } catch (error) {
      console.error('修改密码失败:', error)
      showToast('密码修改失败')
      return false
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    countdown,
    loadUpdateUserInfo,
    loadSendChangePhoneCode,
    loadUpdatePhone,
    loadUpdatePassword,
    clearTimer,
    getUserInfo: () => userStore.userInfo,
    getMemberInfo: () => userStore.memberInfo
  }
}