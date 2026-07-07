// 分销员管理业务逻辑 Hook
// 封装：表单校验、申请提交、状态查询、跳转、异常拦截
// 异常处理：
//   40961 重复申请 → 提示并跳转结果页
//   40962 已是分销员 → 提示并跳转工作台
//   40361 非分销员 → 自动跳转申请页

import { ref } from 'vue'
import { useDistributorStore } from '@/store/distributor'
import { useUserStore } from '@/store/user'
import { useFile } from '@/hooks/useFile'
import {
  AUDIT_STATUS,
  DISTRIBUTOR_ERROR_CODE,
  DISTRIBUTOR_RULES,
  BANK_LIST,
  QUICK_MENUS,
  PROMOTION_ERROR_CODE,
  PROMOTION_STATUS,
  PROMOTION_STATUS_TABS,
  PROMOTION_STATUS_MAP,
  COMMISSION_STATUS,
  COMMISSION_STATUS_MAP,
  COMMISSION_STATUS_TABS,
  WITHDRAW_STATUS,
  WITHDRAW_STATUS_MAP,
  WITHDRAW_STATUS_TABS
} from '@/constants/distributor'
import { UPLOAD_TYPE } from '@/constants/file'

export const useDistributor = () => {
  const distributorStore = useDistributorStore()
  const userStore = useUserStore()
  const { chooseImage, uploadImage } = useFile()

  // ============ 申请表单状态 ============
  const formData = ref({
    realName: '',
    idCardNo: '',
    idCardFront: '',
    idCardBack: '',
    bankName: '',
    bankCardNo: '',
    bankAccountName: ''
  })

  // 身份证图片预览（本地临时路径）
  const idCardFrontPreview = ref('')
  const idCardBackPreview = ref('')

  // 银行选择器
  const bankPickerVisible = ref(false)
  const bankList = ref(BANK_LIST)

  // ============ 表单校验 ============
  const validateField = (field, value) => {
    const rule = DISTRIBUTOR_RULES[field]
    if (!rule) return { valid: true }

    if (rule.required && !value) {
      return { valid: false, message: `请输入${rule.label}` }
    }

    if (rule.pattern && value && !rule.pattern.test(value)) {
      return { valid: false, message: rule.message }
    }

    return { valid: true }
  }

  const validateForm = () => {
    const fields = Object.keys(DISTRIBUTOR_RULES)

    for (const field of fields) {
      const result = validateField(field, formData.value[field])
      if (!result.valid) {
        uni.showToast({ title: result.message, icon: 'none' })
        return false
      }
    }

    // 身份证图片必填
    if (!formData.value.idCardFront) {
      uni.showToast({ title: '请上传身份证正面', icon: 'none' })
      return false
    }
    if (!formData.value.idCardBack) {
      uni.showToast({ title: '请上传身份证反面', icon: 'none' })
      return false
    }

    return true
  }

  // ============ 图片上传 ============
  const uploadIdCardFront = async () => {
    const filePaths = await chooseImage()
    if (filePaths.length === 0) return
    const filePath = filePaths[0]
    idCardFrontPreview.value = filePath

    uni.showLoading({ title: '上传中...' })
    const res = await uploadImage(filePath, UPLOAD_TYPE.DISTRIBUTOR_IDCARD_FRONT)
    uni.hideLoading()

    if (res && res.fileUrl) {
      formData.value.idCardFront = res.fileUrl
    } else {
      uni.showToast({ title: '上传失败，请重试', icon: 'none' })
      idCardFrontPreview.value = ''
    }
  }

  const uploadIdCardBack = async () => {
    const filePaths = await chooseImage()
    if (filePaths.length === 0) return
    const filePath = filePaths[0]
    idCardBackPreview.value = filePath

    uni.showLoading({ title: '上传中...' })
    const res = await uploadImage(filePath, UPLOAD_TYPE.DISTRIBUTOR_IDCARD_BACK)
    uni.hideLoading()

    if (res && res.fileUrl) {
      formData.value.idCardBack = res.fileUrl
    } else {
      uni.showToast({ title: '上传失败，请重试', icon: 'none' })
      idCardBackPreview.value = ''
    }
  }

  // ============ 银行选择 ============
  const showBankPicker = () => {
    bankPickerVisible.value = true
  }

  const hideBankPicker = () => {
    bankPickerVisible.value = false
  }

  const selectBank = (bank) => {
    formData.value.bankName = bank
    hideBankPicker()
  }

  // ============ 提交申请 ============
  const submitDistributorApply = async () => {
    // 1. 登录校验
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      setTimeout(() => {
        uni.navigateTo({ url: '/pages/login/login' })
      }, 1000)
      return false
    }

    // 2. 表单校验
    if (!validateForm()) return false

    // 3. 提交申请
    try {
      await distributorStore.submitApply({ ...formData.value })
      uni.showToast({ title: '申请提交成功', icon: 'success' })
      // 跳转结果页
      setTimeout(() => {
        uni.redirectTo({ url: '/pagesSub/distribution/applyResult' })
      }, 1500)
      return true
    } catch (error) {
      handleApplyError(error)
      return false
    }
  }

  // 申请异常处理
  const handleApplyError = (error) => {
    const code = error?.code
    switch (code) {
      case DISTRIBUTOR_ERROR_CODE.DUPLICATE_APPLY:
        // 重复申请 → 跳转结果页
        uni.showToast({ title: error.message || '您已提交申请', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/applyResult' })
        }, 1500)
        break
      case DISTRIBUTOR_ERROR_CODE.ALREADY_DISTRIBUTOR:
        // 已是分销员 → 跳转工作台
        uni.showToast({ title: error.message || '您已是分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/distHome' })
        }, 1500)
        break
      default:
        // 其他错误 base.js 已统一 toast
        console.error('申请失败:', error)
    }
  }

  // ============ 状态查询 ============
  const loadDistributorStatus = async () => {
    if (!userStore.isLogin) return null
    try {
      const res = await distributorStore.fetchStatus()
      return res?.data || null
    } catch (error) {
      console.error('查询状态失败:', error)
      return null
    }
  }

  // ============ 工作台数据 ============
  const loadDashboard = async () => {
    if (!userStore.isLogin) return null
    try {
      const res = await distributorStore.fetchDashboard()
      return res?.data || null
    } catch (error) {
      // 40361 非分销员访问 → 跳转申请页
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
        return null
      }
      console.error('查询工作台失败:', error)
      return null
    }
  }

  // ============ 智能跳转（个人中心入口） ============
  // 根据当前状态自动跳转到对应页面：
  //   未申请 → 申请页
  //   待审核/已拒绝 → 结果页
  //   审核通过 → 工作台
  const smartGoDistributor = async () => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return
    }

    uni.showLoading({ title: '加载中...' })
    await loadDistributorStatus()
    uni.hideLoading()

    const status = distributorStore.auditStatus
    const isDistributor = distributorStore.isDistributor

    if (isDistributor || status === AUDIT_STATUS.APPROVED) {
      // 已是分销员 → 工作台
      uni.navigateTo({ url: '/pagesSub/distribution/distHome' })
    } else if (status === AUDIT_STATUS.PENDING) {
      // 待审核 → 结果页
      uni.navigateTo({ url: '/pagesSub/distribution/applyResult' })
    } else if (status === AUDIT_STATUS.REJECTED) {
      // 已拒绝 → 结果页（可重新申请）
      uni.navigateTo({ url: '/pagesSub/distribution/applyResult' })
    } else {
      // 未申请 → 申请页
      uni.navigateTo({ url: '/pagesSub/distribution/apply' })
    }
  }

  // ============ 重置表单 ============
  const resetForm = () => {
    formData.value = {
      realName: '',
      idCardNo: '',
      idCardFront: '',
      idCardBack: '',
      bankName: '',
      bankCardNo: '',
      bankAccountName: ''
    }
    idCardFrontPreview.value = ''
    idCardBackPreview.value = ''
  }

  // ============================================================
  // 5.2 推广商品管理
  // ============================================================

  // 5.2.1 加载可推广商品列表
  const loadPromotionProducts = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await distributorStore.fetchPromotionProducts({}, isLoadMore)
    } catch (error) {
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
      }
      return null
    }
  }

  // 搜索可推广商品
  const searchPromotionProducts = (keyword) => {
    distributorStore.promotionKeyword = keyword || ''
    return loadPromotionProducts(false)
  }

  // 商家筛选
  const filterPromotionByMerchant = (merchantId) => {
    distributorStore.promotionMerchantFilter = merchantId || null
    return loadPromotionProducts(false)
  }

  // 5.2.2 申请推广商品
  const promoteProduct = async (product) => {
    if (!product?.distributionProductId) return false
    try {
      await distributorStore.promoteProduct(product.distributionProductId)
      uni.showToast({ title: '申请推广成功', icon: 'success' })
      return true
    } catch (error) {
      console.error('申请推广失败:', error)
      return false
    }
  }

  // 5.2.3 生成推广链接（用于分享弹窗）
  const generateShareLink = async (distributorProductId) => {
    if (!distributorProductId) return null
    try {
      const res = await distributorStore.generateShareLink(distributorProductId)
      return res?.data || null
    } catch (error) {
      console.error('生成推广链接失败:', error)
      return null
    }
  }

  // 5.2.4 加载我的推广商品列表
  const loadMyPromotionProducts = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await distributorStore.fetchMyPromotionProducts({}, isLoadMore)
    } catch (error) {
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
      }
      return null
    }
  }

  // 搜索我的推广商品
  const searchMyPromotionProducts = (keyword) => {
    distributorStore.myPromotionKeyword = keyword || ''
    return loadMyPromotionProducts(false)
  }

  // 切换状态筛选
  const switchMyPromotionStatus = (status) => {
    distributorStore.myPromotionStatusFilter = status
    return loadMyPromotionProducts(false)
  }

  // 5.2.5 加载推广商品详情
  const loadPromotionProductDetail = async (distributorProductId) => {
    if (!distributorProductId) return null
    try {
      const res = await distributorStore.fetchPromotionProductDetail(distributorProductId)
      return res?.data || null
    } catch (error) {
      if (error?.code === PROMOTION_ERROR_CODE.NOT_FOUND) {
        uni.showToast({ title: '推广商品不存在', icon: 'none' })
        setTimeout(() => {
          uni.navigateBack()
        }, 1500)
      }
      return null
    }
  }

  // 5.2.6 取消推广（弹窗二次确认）
  const disablePromotionProduct = (product) => {
    if (!product?.distributorProductId) return Promise.resolve(false)
    return new Promise((resolve) => {
      uni.showModal({
        title: '取消推广',
        content: `确定取消推广「${product.productName}」吗？取消后推广链接将失效，历史佣金不受影响。`,
        confirmText: '取消推广',
        confirmColor: '#FF4D4F',
        success: async (res) => {
          if (!res.confirm) {
            resolve(false)
            return
          }
          try {
            await distributorStore.disablePromotionProduct(product.distributorProductId)
            uni.showToast({ title: '已取消推广', icon: 'success' })
            resolve(true)
          } catch (error) {
            console.error('取消推广失败:', error)
            resolve(false)
          }
        }
      })
    })
  }

  // 5.2.7 恢复推广
  // 恢复后推广链接和二维码被置空，需重新生成
  const enablePromotionProduct = async (product) => {
    if (!product?.distributorProductId) return false
    try {
      await distributorStore.enablePromotionProduct(product.distributorProductId)
      uni.showToast({ title: '已恢复推广，请重新生成推广链接', icon: 'none', duration: 2500 })
      return true
    } catch (error) {
      console.error('恢复推广失败:', error)
      const code = error?.code
      if (code === PROMOTION_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '当前用户不是分销员', icon: 'none' })
      } else if (code === PROMOTION_ERROR_CODE.NOT_FOUND) {
        uni.showToast({ title: '推广商品不存在', icon: 'none' })
      } else {
        uni.showToast({ title: error?.message || '恢复推广失败', icon: 'none' })
      }
      return false
    }
  }

  // 复制推广链接到剪贴板
  const copyPromotionUrl = (url) => {
    if (!url) {
      uni.showToast({ title: '链接生成中', icon: 'none' })
      return
    }
    uni.setClipboardData({
      data: url,
      success: () => {
        uni.showToast({ title: '链接已复制', icon: 'success' })
      }
    })
  }

  // 复制推广码
  const copyPromotionCode = (code) => {
    if (!code) {
      uni.showToast({ title: '推广码不存在', icon: 'none' })
      return
    }
    uni.setClipboardData({
      data: code,
      success: () => {
        uni.showToast({ title: '推广码已复制', icon: 'success' })
      }
    })
  }

  // 保存二维码到相册
  const saveQrCode = (qrCodeUrl) => {
    if (!qrCodeUrl) {
      uni.showToast({ title: '二维码不存在', icon: 'none' })
      return
    }
    uni.showLoading({ title: '保存中...' })
    uni.downloadFile({
      url: qrCodeUrl,
      success: (res) => {
        if (res.statusCode === 200) {
          uni.saveImageToPhotosAlbum({
            filePath: res.tempFilePath,
            success: () => {
              uni.showToast({ title: '已保存到相册', icon: 'success' })
            },
            fail: (err) => {
              if (err.errMsg.includes('auth deny')) {
                uni.showModal({
                  title: '提示',
                  content: '需要相册权限才能保存图片，请在设置中开启',
                  confirmText: '去设置',
                  success: (modalRes) => {
                    if (modalRes.confirm) {
                      uni.openSetting()
                    }
                  }
                })
              } else {
                uni.showToast({ title: '保存失败', icon: 'none' })
              }
            }
          })
        }
      },
      fail: () => {
        uni.showToast({ title: '下载失败', icon: 'none' })
      },
      complete: () => {
        uni.hideLoading()
      }
    })
  }

  // 跳转到推广商品详情页
  const goPromotionDetail = (distributorProductId) => {
    uni.navigateTo({
      url: `/pagesSub/distribution/productDetail?distributorProductId=${distributorProductId}`
    })
  }

  // ============================================================
  // 5.3 佣金管理
  // ============================================================

  // 5.3.1 加载推广订单列表
  const loadDistributorOrders = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await distributorStore.fetchDistributorOrders({}, isLoadMore)
    } catch (error) {
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
      }
      return null
    }
  }

  // 搜索推广订单
  const searchDistributorOrders = (keyword) => {
    distributorStore.distributorOrderKeyword = keyword || ''
    return loadDistributorOrders(false)
  }

  // 切换推广订单状态筛选
  const switchDistributorOrderStatus = (status) => {
    distributorStore.distributorOrderStatusFilter = status
    return loadDistributorOrders(false)
  }

  // 5.3.2 加载佣金明细
  const loadCommissionDetail = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await distributorStore.fetchCommissionDetail({}, isLoadMore)
    } catch (error) {
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
      }
      return null
    }
  }

  // 切换佣金明细状态筛选
  const switchCommissionRecordStatus = (status) => {
    distributorStore.commissionRecordStatusFilter = status
    return loadCommissionDetail(false)
  }

  // 5.3.3 提现申请
  const submitWithdraw = async (data) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return false
    }
    // 前端校验
    const amount = Number(data?.amount || 0)
    if (!amount || amount <= 0) {
      uni.showToast({ title: '请输入提现金额', icon: 'none' })
      return false
    }
    if (amount < 10) {
      uni.showToast({ title: '最低提现金额 10 元', icon: 'none' })
      return false
    }
    if (!data?.bankName) {
      uni.showToast({ title: '请选择开户银行', icon: 'none' })
      return false
    }
    if (!data?.bankCardNo || !/^\d{16,19}$/.test(data.bankCardNo)) {
      uni.showToast({ title: '请输入有效的银行卡号', icon: 'none' })
      return false
    }
    if (!data?.accountName) {
      uni.showToast({ title: '请输入开户人姓名', icon: 'none' })
      return false
    }
    // 可提现佣金校验
    const available = Number(distributorStore.dashboardData?.availableCommission || 0)
    if (amount > available) {
      uni.showToast({ title: '提现金额超过可提现佣金', icon: 'none' })
      return false
    }

    return new Promise((resolve) => {
      uni.showModal({
        title: '确认提现',
        content: `确认提现 ¥${amount.toFixed(2)} 到 ${data.bankName}（尾号 ${data.bankCardNo.slice(-4)}）？`,
        confirmText: '确认提现',
        confirmColor: '#FF6A00',
        success: async (res) => {
          if (!res.confirm) {
            resolve(false)
            return
          }
          try {
            await distributorStore.submitWithdrawApply(data)
            uni.showToast({ title: '提现申请已提交', icon: 'success' })
            resolve(true)
          } catch (error) {
            console.error('提现申请失败:', error)
            resolve(false)
          }
        }
      })
    })
  }

  // 5.3.4 加载提现记录
  const loadWithdrawRecords = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await distributorStore.fetchWithdrawRecords({}, isLoadMore)
    } catch (error) {
      if (error?.code === DISTRIBUTOR_ERROR_CODE.NOT_DISTRIBUTOR) {
        uni.showToast({ title: '请先成为分销员', icon: 'none' })
        setTimeout(() => {
          uni.redirectTo({ url: '/pagesSub/distribution/apply' })
        }, 1500)
      }
      return null
    }
  }

  // 切换提现记录状态筛选
  const switchWithdrawRecordStatus = (status) => {
    distributorStore.withdrawRecordStatusFilter = status
    return loadWithdrawRecords(false)
  }

  // 跳转到佣金相关页面
  const goCommissionPage = (page) => {
    const pathMap = {
      orders: '/pagesSub/distribution/commission/orders',
      commissionRecord: '/pagesSub/distribution/commission/commissionRecord',
      withdrawApply: '/pagesSub/distribution/commission/withdrawApply',
      withdrawRecords: '/pagesSub/distribution/commission/withdrawRecords'
    }
    const path = pathMap[page]
    if (path) {
      uni.navigateTo({ url: path })
    }
  }

  // 金额格式化（保留两位小数）
  const formatMoney = (value) => {
    return (Number(value) || 0).toFixed(2)
  }

  // 银行卡尾号格式化（显示 **** **** **** 1234）
  const formatBankCard = (cardNo) => {
    if (!cardNo) return ''
    const str = String(cardNo)
    if (str.length < 4) return str
    return `**** **** **** ${str.slice(-4)}`
  }

  return {
    // store
    distributorStore,
    // 表单
    formData,
    idCardFrontPreview,
    idCardBackPreview,
    bankPickerVisible,
    bankList,
    quickMenus: QUICK_MENUS,
    // 校验
    validateField,
    validateForm,
    // 图片上传
    uploadIdCardFront,
    uploadIdCardBack,
    // 银行选择
    showBankPicker,
    hideBankPicker,
    selectBank,
    // 业务方法
    submitDistributorApply,
    loadDistributorStatus,
    loadDashboard,
    smartGoDistributor,
    resetForm,
    // 5.2 推广商品方法
    loadPromotionProducts,
    searchPromotionProducts,
    filterPromotionByMerchant,
    promoteProduct,
    generateShareLink,
    loadMyPromotionProducts,
    searchMyPromotionProducts,
    switchMyPromotionStatus,
    loadPromotionProductDetail,
    disablePromotionProduct,
    enablePromotionProduct,
    copyPromotionUrl,
    copyPromotionCode,
    saveQrCode,
    goPromotionDetail,
    // 5.3 佣金管理方法
    loadDistributorOrders,
    searchDistributorOrders,
    switchDistributorOrderStatus,
    loadCommissionDetail,
    switchCommissionRecordStatus,
    submitWithdraw,
    loadWithdrawRecords,
    switchWithdrawRecordStatus,
    goCommissionPage,
    formatMoney,
    formatBankCard,
    // 常量
    AUDIT_STATUS,
    PROMOTION_STATUS,
    PROMOTION_STATUS_TABS,
    PROMOTION_STATUS_MAP,
    COMMISSION_STATUS,
    COMMISSION_STATUS_MAP,
    COMMISSION_STATUS_TABS,
    WITHDRAW_STATUS,
    WITHDRAW_STATUS_MAP,
    WITHDRAW_STATUS_TABS
  }
}
