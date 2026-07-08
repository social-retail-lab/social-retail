import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getCartItemsApi, addCartItemApi, updateCartItemApi, deleteCartItemApi, deleteCartItemsApi, checkoutPreviewApi, getInvalidCartItemsApi } from '@/api/cart'

export const useCartStore = defineStore('cart', () => {
  const cartList = ref([])
  const invalidList = ref([])
  const totalQuantity = ref(0)
  const totalAmount = ref(0)
  const checkedAmount = ref(0)
  const isAllSelected = ref(false)
  const isManageMode = ref(false)
  const checkoutPreviewData = ref(null)

  const validCartList = computed(() => {
    return cartList.value.filter(item => item.valid)
  })

  const selectedItems = computed(() => {
    return validCartList.value.filter(item => item.checked)
  })

  const selectedCount = computed(() => {
    return selectedItems.value.reduce((sum, item) => sum + item.quantity, 0)
  })

  const selectedTotal = computed(() => {
    return selectedItems.value.reduce((sum, item) => sum + item.price * item.quantity, 0)
  })

  const hasSelectedItems = computed(() => {
    return selectedItems.value.length > 0
  })

  const groupedCartList = computed(() => {
    const groups = {}
    validCartList.value.forEach(item => {
      const merchantId = item.merchantId || 'unknown'
      if (!groups[merchantId]) {
        groups[merchantId] = {
          merchantId,
          merchantName: item.merchantName || '未知商家',
          items: [],
          isGroupSelected: false
        }
      }
      groups[merchantId].items.push(item)
    })
    
    const result = Object.values(groups)
    result.forEach(group => {
      group.isGroupSelected = group.items.every(item => item.checked)
    })
    
    return result
  })

  const updateAllSelectedStatus = () => {
    if (validCartList.value.length === 0) {
      isAllSelected.value = false
      return
    }
    isAllSelected.value = validCartList.value.every(item => item.checked)
  }

  const toggleSelect = (cartItemId) => {
    const item = cartList.value.find(item => item.cartItemId === cartItemId)
    if (item && item.valid) {
      item.checked = !item.checked
      updateAllSelectedStatus()
    }
  }

  const toggleAllSelect = () => {
    isAllSelected.value = !isAllSelected.value
    validCartList.value.forEach(item => {
      item.checked = isAllSelected.value
    })
  }

  const toggleManageMode = () => {
    isManageMode.value = !isManageMode.value
    if (!isManageMode.value) {
      cartList.value.forEach(item => {
        item.checked = false
      })
      updateAllSelectedStatus()
    }
  }

  const setCartData = (data) => {
    if (data) {
      cartList.value = data.items || []
      totalQuantity.value = data.totalQuantity || 0
      totalAmount.value = data.totalAmount || 0
      checkedAmount.value = data.checkedAmount || 0
    } else {
      cartList.value = []
      totalQuantity.value = 0
      totalAmount.value = 0
      checkedAmount.value = 0
    }
    updateAllSelectedStatus()
  }

  const setInvalidList = (data) => {
    invalidList.value = data?.list || []
  }

  const removeItem = (cartItemId) => {
    const index = cartList.value.findIndex(item => item.cartItemId === cartItemId)
    if (index > -1) {
      cartList.value.splice(index, 1)
      updateAllSelectedStatus()
    }
  }

  const removeSelectedItems = () => {
    cartList.value = cartList.value.filter(item => !item.checked)
    updateAllSelectedStatus()
  }

  const setCheckoutPreviewData = (data) => {
    checkoutPreviewData.value = data
  }

  const fetchCartItems = async () => {
    const res = await getCartItemsApi()
    if (res.code === 0 && res.data) {
      return res.data
    }
    return { items: [], totalQuantity: 0, totalAmount: 0, checkedAmount: 0 }
  }

  const addCartItem = async (data) => {
    const res = await addCartItemApi(data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const updateCartItem = async (cartItemId, data) => {
    const res = await updateCartItemApi(cartItemId, data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const deleteCartItem = async (cartItemId) => {
    const res = await deleteCartItemApi(cartItemId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const deleteCartItems = async (data) => {
    const res = await deleteCartItemsApi(data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const fetchCheckoutPreview = async (data) => {
    const res = await checkoutPreviewApi(data)
    if (res.code === 0 && res.data) {
      checkoutPreviewData.value = res.data
      return res.data
    }
    return null
  }

  const fetchInvalidCartItems = async () => {
    const res = await getInvalidCartItemsApi()
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  return {
    cartList,
    invalidList,
    totalQuantity,
    totalAmount,
    checkedAmount,
    isAllSelected,
    isManageMode,
    checkoutPreviewData,
    validCartList,
    groupedCartList,
    selectedItems,
    selectedCount,
    selectedTotal,
    hasSelectedItems,
    toggleSelect,
    toggleAllSelect,
    toggleManageMode,
    setCartData,
    setInvalidList,
    setCheckoutPreviewData,
    removeItem,
    removeSelectedItems,
    fetchCartItems,
    addCartItem,
    updateCartItem,
    deleteCartItem,
    deleteCartItems,
    fetchCheckoutPreview,
    fetchInvalidCartItems
  }
})
