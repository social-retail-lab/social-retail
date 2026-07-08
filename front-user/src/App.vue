<script setup>
import { onLaunch, onShow, onHide } from '@dcloudio/uni-app'
import { useUserStore } from '@/store/user'
import { useCartStore } from '@/store/cart'

onLaunch(() => {
  initUserLogin()
})

onShow(() => {
  checkLoginStatus()
})

onHide(() => {
  saveUserStatus()
  saveCartData()
})

const initUserLogin = () => {
  const userStore = useUserStore()
  const token = uni.getStorageSync('token')
  const userInfo = uni.getStorageSync('userInfo')
  const memberInfo = uni.getStorageSync('memberInfo')
  
  if (token && userInfo) {
    userStore.token = token
    userStore.userInfo = JSON.parse(userInfo)
    if (memberInfo) {
      userStore.memberInfo = JSON.parse(memberInfo)
    }
    userStore.isLogin = true
  }
}

const initCart = () => {
  const cartStore = useCartStore()
  const cartData = uni.getStorageSync('cart')
  
  if (cartData) {
    cartStore.setCartList(JSON.parse(cartData))
  }
}

const checkLoginStatus = () => {
  const userStore = useUserStore()
  if (!userStore.isLogin) {
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    let currentRoute = currentPage?.route || ''
    
    if (currentRoute.startsWith('/')) {
      currentRoute = currentRoute.slice(1)
    }
    
    const publicPagePrefixes = [
      'pages/login/',
      'pages/index/',
      'pagesSub/goods/'
    ]
    
    const isPublic = publicPagePrefixes.some(prefix => currentRoute.startsWith(prefix))
    
    if (!isPublic) {
      uni.reLaunch({ url: '/pages/login/login' })
    }
  }
}

const saveUserStatus = () => {
  const userStore = useUserStore()
  
  if (userStore.isLogin) {
    uni.setStorageSync('token', userStore.token)
    uni.setStorageSync('userInfo', JSON.stringify(userStore.userInfo))
  }
}

const saveCartData = () => {
  const cartStore = useCartStore()
  uni.setStorageSync('cart', JSON.stringify(cartStore.cartList))
}
</script>

<style lang="scss">
page {
  background-color: $bg-grey;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', 'Helvetica Neue', Helvetica, Arial, sans-serif;
  // iOS 平滑滚动 + 抗锯齿
  -webkit-overflow-scrolling: touch;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

view, text, image {
  box-sizing: border-box;
}

button {
  margin: 0;
  padding: 0;
  background: none;
  border: none;
}

button::after {
  display: none;
}

// 隐藏系统 TabBar(使用自定义 TabBar)
.uni-tabbar {
  display: none !important;
}

.uni-tabbar__item {
  display: none !important;
}

// ============ 全局优化:GPU 加速 +  transition 默认值 ============
// 所有带 transform/opacity 的元素自动启用 GPU 加速,避免动画卡顿
view, text, image, button, input, textarea, scroll-view {
  // 默认 transition,让所有交互反馈更顺滑
  // 注:仅设置 transition-property 不会强制生效,需要元素本身有 :active 等才会触发
}

// ============ 自定义路由跳转过渡动画 ============
// App 端通过 pages.json 的 animationType 控制
// H5/小程序端通过页面根元素动画实现
.page-enter-active {
  animation: pageEnter $duration-base $ease-out-quart both;
  @include gpu-accelerate;
}

@keyframes pageEnter {
  from {
    opacity: 0;
    transform: translateX(40rpx);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

// ============ 优化长列表滚动性能 ============
// 移除图片默认下边距(避免图片下方留白)
image {
  display: block;
  // 防止图片加载导致页面重排
  &::after {
    content: '';
    display: block;
    height: 0;
    clear: both;
  }
}

// 修复 iOS 橡皮筋效果导致页面卡顿
scroll-view {
  -webkit-overflow-scrolling: touch;
}
</style>
