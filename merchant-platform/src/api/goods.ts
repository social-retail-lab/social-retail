import request from '@/utils/request'

// ========== 商家登录 ==========
export const merchantLogin = (data: { phone: string; password: string; smsCode: string }) => {
  return request.post('/merchant/auth/login', data) as Promise<{
    token: string
    expireTime: number
    merchantStatus: number
    merchantInfo?: {
      merchantId: number
      merchantName: string
      logo: string
      contactName: string
      contactPhone: string
      shopAddress: string
      status: number
      statusText: string
      createTime: string
    }
  }>
}

// ========== 入驻申请 ==========
export const submitApplication = (data: {
  applyType?: number
  companyName: string
  idCardFront: string
  idCardBack: string
  licenseNumber?: string
  licenseImage?: string
  foodPermitNumber?: string
  foodPermitImage?: string
  contactName: string
  contactPhone: string
  shopAddress: string
  shopName: string
}) => {
  return request.post('/merchant/applications', data) as Promise<{
    applyId: number
    applyType: number
    applyTypeText: string
    auditStatus: number
    auditStatusText: string
    applyTime: string
  }>
}

export const getApplicationStatus = () => {
  return request.get('/merchant/applications/status') as Promise<{
    applyId: number
    applyType: number
    applyTypeText: string
    auditStatus: number
    auditStatusText: string
    auditRemark: string
    applyTime: string
    auditTime: string
    merchantId: number
  }>
}

// ========== 商家信息 ==========
export const getCurrentMerchant = () => {
  return request.get('/merchant/info') as Promise<{
    merchantId: number
    merchantName: string
    logo: string
    contactName: string
    contactPhone: string
    shopAddress: string
    status: number
    statusText: string
    createTime: string
  }>
}

export const updateMerchantInfo = (data: {
  merchantName?: string
  logo?: string
  contactName?: string
  contactPhone?: string
  shopAddress?: string
  businessHours?: string
  introduction?: string
}) => {
  return request.put('/merchant/info', data)
}

export const getStoreInfo = () => {
  return request.get('/merchant/store')
}

export const updateStore = (data: {
  shopAddress?: string
  contactPhone?: string
  businessHours?: string
  introduction?: string
}) => {
  return request.put('/merchant/store', data)
}

// ========== 资质管理 ==========
export const uploadQualification = (data: {
  businessCategory?: string
  licenseNumber?: string
  licenseImage?: string
  foodPermitNumber?: string
  foodPermitImage?: string
}) => {
  return request.post('/merchant/qualifications', data) as Promise<{
    qualificationId: number
    businessCategory: string
    licenseNumber: string
    licenseImage: string
    foodPermitNumber: string
    foodPermitImage: string
  }>
}

export const getQualification = () => {
  return request.get('/merchant/qualifications') as Promise<{
    qualificationId: number
    businessCategory: string
    licenseNumber: string
    licenseImage: string
    foodPermitNumber: string
    foodPermitImage: string
  }>
}

// ========== 商品管理 ==========
export const getProductList = (params: {
  keyword?: string
  categoryId?: number
  status?: number
  auditStatus?: number
  pageNum?: number
  pageSize?: number
}) => {
  return request.get('/merchant/products', { params }) as Promise<{
    list: any[]
    total: number
    pageNum: number
    pageSize: number
  }>
}

export const createProduct = (data: {
  brandId: number
  categoryIds: number[]
  title: string
  subTitle?: string
  mainImage: string
  detailImages?: string
  detailDesc?: string
  saleType: number
  skuList: { specs: string; price: number; stock: number; skuCode?: string }[]
}) => {
  return request.post('/merchant/products', data) as Promise<{
    productId: number
    auditStatus: number
    auditStatusText: string
  }>
}

export const updateProduct = (productId: number, data: {
  brandId: number
  categoryIds: number[]
  title: string
  subTitle?: string
  mainImage: string
  detailImages?: string
  detailDesc?: string
  saleType: number
  skuList: { specs: string; price: number; stock: number; skuCode?: string }[]
}) => {
  return request.put(`/merchant/products/${productId}`, data) as Promise<{
    productId: number
    auditStatus: number
    auditStatusText: string
  }>
}

export const getProductDetail = (productId: number) => {
  return request.get(`/merchant/products/${productId}`) as Promise<{
    productId: number
    title: string
    subTitle: string
    brandId: number
    brandName: string
    categoryIds: number[]
    categoryNames: string[]
    mainImage: string
    detailImages: string
    detailDesc: string
    saleType: number
    saleTypeText: string
    auditStatus: number
    auditRemark: string
    status: number
    skuList: { skuId: number; specs: string; specsText: string; price: number; stock: number; skuCode: string }[]
    createTime: string
    updateTime: string
  }>
}

export const updateShelfStatus = (productId: number, status: number) => {
  return request.patch(`/merchant/products/${productId}/status`, { status })
}

export const updateStock = (skuId: number, data: { stock: number; remark?: string }) => {
  return request.patch(`/merchant/skus/${skuId}/stock`, data) as Promise<{
    skuId: number
    productName: string
    oldStock: number
    newStock: number
  }>
}

export const updatePrice = (skuId: number, data: { price: number }) => {
  return request.patch(`/merchant/skus/${skuId}/price`, data) as Promise<{
    skuId: number
    oldPrice: number
    newPrice: number
  }>
}

export const getProductAuditStatus = (productId: number) => {
  return request.get(`/merchant/products/${productId}/audit-status`) as Promise<{
    productId: number
    title: string
    auditStatus: number
    auditStatusText: string
    auditRemark: string
    auditTime: string
    submitTime: string
  }>
}
