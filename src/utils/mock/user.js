// Mock用户数据
// 用于开发演示，后期切换真实接口只需修改 USE_MOCK 开关

/**
 * ① 普通用户（不是会员，不是分销员）
 */
export const normalUser = {
  userId: '10001',
  nickname: '普通用户',
  avatar: '', // 默认头像
  phone: '138****0001',
  status: 'NORMAL',
  isMember: false,
  memberLevel: '普通用户',
  isDistributor: false,
  couponCount: 0,
  points: 320,
  growth: 320,
  unreadMessageCount: 5,
  orderCount: {
    pendingPayment: 1,   // 待支付
    pendingShipment: 2,  // 待发货
    pendingReceipt: 0,   // 待自提
    pendingReview: 3,    // 待评价
    afterSale: 0         // 售后
  },
  commission: null
}

/**
 * ② 分销员 + 黄金会员
 */
export const memberUser = {
  userId: '10002',
  nickname: '小美爱购物',
  avatar: '', // 默认头像
  phone: '138****0002',
  status: 'NORMAL',
  isMember: true,
  memberLevel: '黄金会员',
  isDistributor: true,
  couponCount: 3,
  points: 1250,
  growth: 1250,
  unreadMessageCount: 12,
  orderCount: {
    pendingPayment: 2,   // 待支付
    pendingShipment: 3,  // 待发货
    pendingReceipt: 1,   // 待自提
    pendingReview: 4,    // 待评价
    afterSale: 1         // 售后
  },
  commission: {
    yesterdayCommission: 128.60,  // 昨日佣金
    totalCommission: 3256.80,      // 累计佣金
    totalWithdrawn: 2860.00,       // 累计提现
    pendingCommission: 568.30      // 待结算
  }
}