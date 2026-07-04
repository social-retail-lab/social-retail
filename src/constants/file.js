// 文件上传模块常量
// 包含：上传类型、错误码、错误消息、辅助函数

// ============ 上传类型 ============
export const UPLOAD_TYPE = {
  // 用户相关
  USER_AVATAR: 'USER_AVATAR',
  // 商家相关
  MERCHANT_AVATAR: 'MERCHANT_AVATAR',
  MERCHANT_LOGO: 'MERCHANT_LOGO',
  MERCHANT_IDCARD_FRONT: 'MERCHANT_IDCARD_FRONT',
  MERCHANT_IDCARD_BACK: 'MERCHANT_IDCARD_BACK',
  MERCHANT_LICENSE: 'MERCHANT_LICENSE',
  // 商品相关
  PRODUCT_MAIN: 'PRODUCT_MAIN',
  PRODUCT_DETAIL: 'PRODUCT_DETAIL',
  PRODUCT_SKU: 'PRODUCT_SKU',
  // 品牌相关
  BRAND_LOGO: 'BRAND_LOGO',
  // 评价相关
  COMMENT: 'COMMENT',
  // 售后相关
  AFTER_SALE: 'AFTER_SALE',
  // 营销活动相关
  PROMOTION_SECKILL: 'PROMOTION_SECKILL',
  PROMOTION_GROUP: 'PROMOTION_GROUP',
  PROMOTION_COUPON: 'PROMOTION_COUPON',
  // 系统相关
  SYSTEM_CONFIG: 'SYSTEM_CONFIG',
  SYSTEM_QRCODE: 'SYSTEM_BANNER',
  SYSTEM_BANNER: 'SYSTEM_BANNER',
  // 海报相关
  POSTER: 'POSTER',
  // 社交分享
  SOCIAL_SHARE: 'SOCIAL_SHARE'
}

// ============ 上传类型分组(便于UI层使用) ============
// 单文件上传类型
export const SINGLE_UPLOAD_TYPES = [
  UPLOAD_TYPE.USER_AVATAR,
  UPLOAD_TYPE.MERCHANT_AVATAR,
  UPLOAD_TYPE.MERCHANT_LOGO,
  UPLOAD_TYPE.PRODUCT_MAIN,
  UPLOAD_TYPE.BRAND_LOGO
]

// 批量上传类型
export const BATCH_UPLOAD_TYPES = [
  UPLOAD_TYPE.PRODUCT_DETAIL,
  UPLOAD_TYPE.PRODUCT_SKU,
  UPLOAD_TYPE.COMMENT,
  UPLOAD_TYPE.AFTER_SALE,
  UPLOAD_TYPE.POSTER,
  UPLOAD_TYPE.SYSTEM_BANNER,
  UPLOAD_TYPE.PROMOTION_SECKILL,
  UPLOAD_TYPE.PROMOTION_GROUP,
  UPLOAD_TYPE.PROMOTION_COUPON,
  UPLOAD_TYPE.MERCHANT_LICENSE,
  UPLOAD_TYPE.SOCIAL_SHARE
]

// ============ 文件限制 ============
export const FILE_LIMIT = {
  // 最大文件大小(MB)
  MAX_SIZE_MB: 5,
  // 支持的图片格式
  ALLOWED_TYPES: ['jpg', 'jpeg', 'png', 'webp'],
  // 批量上传最大数量
  MAX_BATCH_COUNT: 9
}

// ============ 错误码 ============
export const FILE_ERROR_CODE = {
  // 文件格式不支持
  FORMAT_NOT_SUPPORTED: 40006,
  // 文件大小超过限制
  SIZE_EXCEEDED: 40007,
  // 文件不存在
  NOT_FOUND: 40405,
  // 无权限删除
  NO_PERMISSION: 40303
}

// ============ 错误消息映射 ============
export const FILE_ERROR_MSG = {
  [FILE_ERROR_CODE.FORMAT_NOT_SUPPORTED]: '文件格式不支持，仅支持 jpg、jpeg、png、webp',
  [FILE_ERROR_CODE.SIZE_EXCEEDED]: '文件大小超过限制',
  [FILE_ERROR_CODE.NOT_FOUND]: '文件不存在',
  [FILE_ERROR_CODE.NO_PERMISSION]: '无权限删除该文件'
}

// ============ 辅助函数 ============

// 获取文件错误消息
export const getFileErrorMsg = (code) => {
  return FILE_ERROR_MSG[code] || '文件操作失败'
}

// 获取文件扩展名
export const getFileExtension = (fileName) => {
  if (!fileName || typeof fileName !== 'string') return ''
  const lastDotIndex = fileName.lastIndexOf('.')
  return lastDotIndex !== -1 ? fileName.substring(lastDotIndex + 1).toLowerCase() : ''
}

// 校验文件格式
export const isValidImageType = (fileName) => {
  if (!fileName || typeof fileName !== 'string') return false
  // H5 端 uni.chooseImage 返回 blob: 或 data: URL,无文件扩展名
  // 此时跳过扩展名校验(uni.chooseImage 已保证是图片)
  if (fileName.startsWith('blob:') || fileName.startsWith('data:')) {
    return true
  }
  const ext = getFileExtension(fileName)
  return FILE_LIMIT.ALLOWED_TYPES.includes(ext)
}

// 校验文件大小(单位:字节)
export const isValidFileSize = (fileSize) => {
  const maxBytes = FILE_LIMIT.MAX_SIZE_MB * 1024 * 1024
  return Number(fileSize) <= maxBytes
}

// 格式化文件大小
export const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const units = ['B', 'KB', 'MB', 'GB']
  let unitIndex = 0
  let size = Number(bytes)
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024
    unitIndex++
  }
  return `${size.toFixed(unitIndex === 0 ? 0 : 1)} ${units[unitIndex]}`
}
