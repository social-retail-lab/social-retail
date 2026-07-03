import { ref, onUnmounted } from 'vue'
import { useCartStore } from '@/store/cart'
import { useUserStore } from '@/store/user'
import { showToast, getValidImageUrl } from '@/utils/common'

export const useCart = () => {
  const cartStore = useCartStore()
  const userStore = useUserStore()
  const debounceTimers = ref({})
  const loading = ref(false)
  const addLoading = ref(false)
  const invalidLoading = ref(false)

  const checkLogin = () => {
    if (!userStore.isLogin) {
      showToast('请先登录')
      setTimeout(() => {
        uni.navigateTo({ url: '/pages/login/login' })
      }, 1000)
      return false
    }
    return true
  }

  const loadCartData = async () => {
    if (!checkLogin()) {
      cartStore.setCartData(null)
      cartStore.setInvalidList(null)
      return
    }

    loading.value = true

    try {
      const [cartRes, invalidRes] = await Promise.all([
        cartStore.fetchCartItems(),
        cartStore.fetchInvalidCartItems()
      ])

      if (cartRes) {
        cartStore.setCartData(cartRes)
      } else {
        cartStore.setCartData(null)
      }

      if (invalidRes) {
        cartStore.setInvalidList(invalidRes)
      } else {
        cartStore.setInvalidList(null)
      }
    } catch (error) {
      console.error('获取购物车数据失败:', error)
      cartStore.setCartData(null)
      cartStore.setInvalidList(null)

      const errorCodeMap = {
        40101: '登录已过期，请重新登录'
      }

      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('获取购物车数据失败')
      }
    } finally {
      loading.value = false
    }
  }

  const loadAddToCart = async (skuId, quantity = 1) => {
    if (!checkLogin()) {
      return false
    }

    if (!skuId) {
      showToast('商品信息异常')
      return false
    }

    addLoading.value = true

    try {
      const res = await cartStore.addCartItem({ skuId, quantity })
      if (res) {
        showToast('已加入购物车')
        loadCartData()
        return true
      } else {
        showToast('添加失败')
        return false
      }
    } catch (error) {
      console.error('添加购物车失败:', error)

      const errorCodeMap = {
        40911: '库存不足，无法加入',
        40101: '登录已过期，请重新登录'
      }

      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('添加失败')
      }

      return false
    } finally {
      addLoading.value = false
    }
  }

  const loadUpdateQuantity = async (cartItemId, quantity) => {
    if (!checkLogin()) {
      return
    }

    const item = cartStore.cartList.find(item => item.cartItemId === cartItemId)
    if (!item) return

    if (quantity <= 0) {
      loadDeleteItem(cartItemId)
      return
    }

    if (quantity > item.stock) {
      showToast('超出库存限制')
      return
    }

    if (debounceTimers.value[cartItemId]) {
      clearTimeout(debounceTimers.value[cartItemId])
    }

    debounceTimers.value[cartItemId] = setTimeout(async () => {
      try {
        const res = await cartStore.updateCartItem(cartItemId, { quantity })
        if (res) {
          loadCartData()
        }
      } catch (error) {
        console.error('修改购物车数量失败:', error)

        const errorCodeMap = {
          40411: '购物车商品不存在',
          40911: '商品库存不足'
        }

        if (errorCodeMap[error?.code]) {
          showToast(errorCodeMap[error.code])
        } else if (error?.message) {
          showToast(error.message)
        } else {
          showToast('修改数量失败')
        }

        loadCartData()
      } finally {
        delete debounceTimers.value[cartItemId]
      }
    }, 300)
  }

  const loadDeleteItem = async (cartItemId) => {
    if (!checkLogin()) {
      return
    }

    if (debounceTimers.value[cartItemId]) {
      clearTimeout(debounceTimers.value[cartItemId])
    }

    try {
      await cartStore.deleteCartItem(cartItemId)
      cartStore.removeItem(cartItemId)
      showToast('已删除')
      loadCartData()
    } catch (error) {
      console.error('删除购物车商品失败:', error)

      const errorCodeMap = {
        40411: '购物车商品不存在'
      }

      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('删除失败')
      }

      loadCartData()
    }
  }

  const loadDeleteSelectedItems = async () => {
    if (!checkLogin()) {
      return
    }

    const selected = cartStore.selectedItems
    if (selected.length === 0) {
      showToast('请先选择商品')
      return
    }

    uni.showModal({
      title: '确认删除',
      content: `确定要删除选中的${selected.length}件商品吗？`,
      success: async (res) => {
        if (res.confirm) {
          try {
            const cartItemIds = selected.map(item => item.cartItemId)
            await cartStore.deleteCartItems({ cartItemIds })
            cartStore.removeSelectedItems()
            showToast('删除成功')
            loadCartData()
          } catch (error) {
            console.error('批量删除购物车商品失败:', error)

            const errorCodeMap = {
              40001: '请选择要删除的商品'
            }

            if (errorCodeMap[error?.code]) {
              showToast(errorCodeMap[error.code])
            } else if (error?.message) {
              showToast(error.message)
            } else {
              showToast('删除失败')
            }

            loadCartData()
          }
        }
      }
    })
  }

  const loadDeleteInvalidItems = async () => {
    if (!checkLogin()) {
      return
    }

    const invalidItems = cartStore.invalidList
    if (invalidItems.length === 0) {
      showToast('没有失效商品')
      return
    }

    uni.showModal({
      title: '确认清空',
      content: `确定要清空${invalidItems.length}件失效商品吗？`,
      success: async (res) => {
        if (res.confirm) {
          try {
            const cartItemIds = invalidItems.map(item => item.cartItemId)
            await cartStore.deleteCartItems({ cartItemIds })
            cartStore.setInvalidList(null)
            showToast('已清空')
            loadCartData()
          } catch (error) {
            console.error('清空失效商品失败:', error)
            showToast('清空失败')
            loadCartData()
          }
        }
      }
    })
  }

  const loadCheckout = async () => {
    if (!checkLogin()) {
      return
    }

    const selected = cartStore.selectedItems
    if (selected.length === 0) {
      showToast('请选择商品')
      return
    }

    const cartItemIds = selected.map(item => item.cartItemId)

    try {
      const res = await cartStore.fetchCheckoutPreview({ cartItemIds })
      if (res) {
        uni.navigateTo({
          url: `/pagesSub/order/confirmOrder?source=cart&cartItemIds=${cartItemIds.join(',')}`
        })
      }
    } catch (error) {
      console.error('结算预览失败:', error)

      const errorCodeMap = {
        40101: '登录已过期，请重新登录',
        40911: '商品库存不足',
        40912: '部分商品已失效'
      }

      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('结算失败')
      }

      loadCartData()
    }
  }

  onUnmounted(() => {
    Object.values(debounceTimers.value).forEach(timer => {
      clearTimeout(timer)
    })
  })

  return {
    cartStore,
    loading,
    addLoading,
    invalidLoading,
    loadCartData,
    loadAddToCart,
    loadUpdateQuantity,
    loadDeleteItem,
    loadDeleteSelectedItems,
    loadDeleteInvalidItems,
    loadCheckout
  }
}
