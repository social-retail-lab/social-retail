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
      if (!res) {
        showToast('注册失败')
        return
      }

      // 注册接口仅返回 userId/phone/nickname/status，不含 token
      // 注册成功后自动调用登录接口获取 token，实现"注册即登录"
      try {
        const loginRes = await userStore.fetchUserLogin({ phone, code, loginType: 'CODE' })
        if (loginRes) {
          userStore.setUserInfo(loginRes)
          showToast('注册成功，已自动登录')
          setTimeout(() => {
            uni.reLaunch({ url: '/pages/index/index' })
          }, 1000)
        } else {
          // 登录接口未返回数据，跳转到登录页让用户手动登录
          showToast('注册成功，请登录')
          setTimeout(() => {
            uni.reLaunch({ url: '/pages/login/login' })
          }, 1000)
        }
      } catch (loginError) {
        console.error('自动登录失败:', loginError)
        showToast('注册成功，请登录')
        setTimeout(() => {
          uni.reLaunch({ url: '/pages/login/login' })
        }, 1000)
      }
    } catch (error) {
      console.error('注册失败:', error)
      showToast(error.message || '注册失败')
    }
  }

  const loadUserLogin = async (loginForm) => {
    const { phone, code, password } = loginForm

    try {
      // 显式判断登录方式，默认验证码登录
      const loginType = loginForm.loginType || (code ? 'CODE' : 'PASSWORD')
      const res = await userStore.fetchUserLogin({ phone, code, password, loginType })
      if (res) {
        userStore.setUserInfo(res)
        showToast('登录成功')
        setTimeout(() => {
          uni.reLaunch({ url: '/pages/index/index' })
        }, 1000)
      }
    } catch (error) {
      console.error('登录失败:', error)
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
    // 后端可能未实现 logout 接口(无状态 token),失败也无所谓
    // 仍然尝试调用以通知后端清理会话(若后端支持),失败静默处理
    try {
      await userStore.fetchUserLogout()
    } catch (error) {
      // 静默处理:404/网络错误都不影响前端退出流程
      console.warn("退出登录接口调用失败(不影响本地退出):", error?.status || error?.message || 'unknown')
    }
    // 清除本地登录状态（token、userInfo、memberInfo 等）
    userStore.logout()
    showToast("已退出登录")
    // 退出登录后跳转到登录页，而非主页
    // 避免未登录状态进入主页后，切换 Tab 触发登录跳转导致页面混乱
    setTimeout(() => {
      uni.reLaunch({ url: "/pages/login/login" })
    }, 500)
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