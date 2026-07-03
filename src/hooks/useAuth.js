import { ref } from "vue"
import { useUserStore } from "@/store/user"
import { showToast } from '@/utils/common'

export function useAuth() {
  const userStore = useUserStore()

  const countdown = ref(0)
  const bindCountdown = ref(0)
  const bindVisible = ref(false)
  const tempOpenid = ref("")
  const currentScene = ref("LOGIN")

  let loginTimer = null
  let bindTimer = null

  const startTimer = (type, seconds) => {
    if (type === 'login') {
      if (loginTimer) clearInterval(loginTimer)
      countdown.value = seconds
      loginTimer = setInterval(() => {
        countdown.value--
        if (countdown.value <= 0) {
          clearInterval(loginTimer)
          loginTimer = null
        }
      }, 1000)
    } else if (type === 'bind') {
      if (bindTimer) clearInterval(bindTimer)
      bindCountdown.value = seconds
      bindTimer = setInterval(() => {
        bindCountdown.value--
        if (bindCountdown.value <= 0) {
          clearInterval(bindTimer)
          bindTimer = null
        }
      }, 1000)
    }
  }

  const loadSendSmsCode = async (phone, scene = "LOGIN") => {
    startTimer('login', 60)

    try {
      await userStore.fetchSendSmsCode({ phone, scene })
      showToast("验证码已发送")
      currentScene.value = scene
    } catch (error) {
      if (error && error.code === 42901 && error.data?.retryAfterSeconds) {
        startTimer('login', error.data.retryAfterSeconds)
        showToast(error.message || '发送过于频繁')
      } else {
        clearInterval(loginTimer)
        loginTimer = null
        countdown.value = 0
        showToast(error.message || '发送失败')
      }
    }
  }

  const loadBindSmsCode = async (phone) => {
    startTimer('bind', 60)

    try {
      await userStore.fetchSendSmsCode({ phone, scene: "CHANGE_PHONE" })
      showToast("验证码已发送")
    } catch (error) {
      if (error && error.code === 42901 && error.data?.retryAfterSeconds) {
        startTimer('bind', error.data.retryAfterSeconds)
        showToast(error.message || '发送过于频繁')
      } else {
        clearInterval(bindTimer)
        bindTimer = null
        bindCountdown.value = 0
        showToast(error.message || '发送失败')
      }
    }
  }

  const loadUserRegister = async (registerForm) => {
    const { phone, code, password, nickname } = registerForm

    try {
      const res = await userStore.fetchUserRegister({ phone, code, password, nickname })
      if (res) {
        showToast("注册成功")
        setTimeout(() => {
          uni.reLaunch({ url: "/pages/index/index" })
        }, 1000)
      }
    } catch (error) {
      console.error("注册失败:", error)
      showToast(error.message || '注册失败')
    }
  }

  const loadUserLogin = async (loginForm) => {
    const { phone, code, password } = loginForm

    try {
      const loginType = code ? "CODE" : "PASSWORD"
      const res = await userStore.fetchUserLogin({ phone, code, password, loginType })
      if (res) {
        userStore.setUserInfo(res)
        showToast("登录成功")
        setTimeout(() => {
          uni.switchTab({ url: "/pages/index/index" })
        }, 1000)
      }
    } catch (error) {
      console.error("登录失败:", error)
      showToast(error.message || '登录失败')
    }
  }

  const loadWxAuth = async () => {
    try {
      uni.showLoading({ title: "登录中..." })
      const loginRes = await new Promise((resolve, reject) => {
        uni.login({ provider: "weixin", success: resolve, fail: reject })
      })

      if (!loginRes.code) {
        uni.hideLoading()
        return showToast("微信授权失败")
      }

      const authRes = await userStore.fetchWxAuth({ code: loginRes.code })
      if (authRes && authRes.openid) {
        tempOpenid.value = authRes.openid
        userStore.setOpenid(tempOpenid.value)

        const bindRes = await userStore.fetchCheckWxBind({ openid: tempOpenid.value })
        uni.hideLoading()

        if (bindRes && bindRes.isBind) {
          userStore.setUserInfo(bindRes)
          showToast("微信登录成功")
          setTimeout(() => {
            uni.reLaunch({ url: "/pages/index/index" })
          }, 1000)
        } else {
          bindVisible.value = true
        }
      } else {
        uni.hideLoading()
        showToast("微信授权失败")
      }
    } catch (error) {
      uni.hideLoading()
      console.error("微信授权失败:", error)
      showToast("微信授权失败，请重试")
    }
  }

  const loadWxBindPhone = async (bindForm) => {
    const { phone, code } = bindForm

    try {
      uni.showLoading({ title: "绑定中..." })
      const res = await userStore.fetchWxBindPhone({ openid: tempOpenid.value, phone, code })
      if (res) {
        userStore.setUserInfo(res)
        bindVisible.value = false
        uni.hideLoading()
        showToast(res.isNewUser ? "注册绑定成功" : "绑定登录成功")
        setTimeout(() => {
          uni.reLaunch({ url: "/pages/index/index" })
        }, 1000)
      } else {
        uni.hideLoading()
        showToast("绑定失败")
      }
    } catch (error) {
      uni.hideLoading()
      console.error("绑定失败:", error)
    }
  }

  const loadLogout = async () => {
    try {
      await userStore.fetchUserLogout()
    } catch (error) {
      console.error("退出登录失败:", error)
    }
    userStore.logout()
    uni.reLaunch({ url: "/pages/index/index" })
    showToast("已退出登录")
  }

  const clearTimers = () => {
    if (loginTimer) { clearInterval(loginTimer); loginTimer = null }
    if (bindTimer) { clearInterval(bindTimer); bindTimer = null }
  }

  return {
    countdown,
    bindCountdown,
    bindVisible,
    currentScene,
    loadSendSmsCode,
    loadUserRegister,
    loadUserLogin,
    loadWxAuth,
    loadBindSmsCode,
    loadWxBindPhone,
    loadLogout,
    clearTimers,
    getCode: loadSendSmsCode,
    phoneRegister: loadUserRegister,
    phoneLogin: loadUserLogin,
    wxAuthorize: loadWxAuth,
    getBindCode: loadBindSmsCode,
    bindSubmit: loadWxBindPhone,
    logout: loadLogout
  }
}