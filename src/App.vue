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
  
  if (token && userInfo) {
    userStore.token = token
    userStore.userInfo = JSON.parse(userInfo)
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

.uni-tabbar {
  display: none !important;
}

.uni-tabbar__item {
  display: none !important;
}
</style>
