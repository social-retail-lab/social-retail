// 分销员管理模块常量
// 对应接口：5.1 分销员管理（POST /api/distributor/apply 等）

// ============ 审核状态（auditStatus） ============
// 来自接口文档：0待审核、1审核通过、2审核拒绝
export const AUDIT_STATUS = {
  // 待审核
  PENDING: 0,
  // 审核通过
  APPROVED: 1,
  // 审核拒绝
  REJECTED: 2
}

// 审核状态映射（含文案、颜色、图标）
export const AUDIT_STATUS_MAP = {
  [AUDIT_STATUS.PENDING]: {
    label: '待审核',
    color: '#FAAD14',
    icon: '⏳',
    desc: '您的申请正在审核中，请耐心等待'
  },
  [AUDIT_STATUS.APPROVED]: {
    label: '审核通过',
    color: '#52C41A',
    icon: '✓',
    desc: '恭喜您已成为分销员'
  },
  [AUDIT_STATUS.REJECTED]: {
    label: '审核拒绝',
    color: '#FF4D4F',
    icon: '✕',
    desc: '您的申请未通过，可修改后重新提交'
  }
}

// ============ 业务错误码 ============
export const DISTRIBUTOR_ERROR_CODE = {
  // 重复申请
  DUPLICATE_APPLY: 40961,
  // 已是分销员
  ALREADY_DISTRIBUTOR: 40962,
  // 非分销员访问工作台
  NOT_DISTRIBUTOR: 40361
}

// ============ 工作台快捷菜单 ============
export const QUICK_MENUS = [
  {
    name: '推广商品',
    path: '/pagesSub/distribution/products',
    icon: '📦',
    color: '#FF6A00'
  },
  {
    name: '我的推广',
    path: '/pagesSub/distribution/myProducts',
    icon: '📋',
    color: '#1890FF'
  },
  {
    name: '推广订单',
    path: '/pagesSub/distribution/commission/orders',
    icon: '🧾',
    color: '#13C2C2'
  },
  {
    name: '佣金明细',
    path: '/pagesSub/distribution/commission/commissionRecord',
    icon: '💰',
    color: '#52C41A'
  },
  {
    name: '佣金提现',
    path: '/pagesSub/distribution/commission/withdrawApply',
    icon: '🏦',
    color: '#722ED1'
  },
  {
    name: '提现记录',
    path: '/pagesSub/distribution/commission/withdrawRecords',
    icon: '📊',
    color: '#EB2F96'
  }
]

// ============ 推广商品状态（5.2 推广管理） ============
// 0-停用、1-启用
export const PROMOTION_STATUS = {
  // 停用
  DISABLED: 0,
  // 启用（推广中）
  ENABLED: 1
}

// 推广状态筛选 Tab
export const PROMOTION_STATUS_TABS = [
  { label: '全部', value: '' },
  { label: '推广中', value: PROMOTION_STATUS.ENABLED },
  { label: '已停用', value: PROMOTION_STATUS.DISABLED }
]

// 推广状态映射
export const PROMOTION_STATUS_MAP = {
  [PROMOTION_STATUS.DISABLED]: {
    label: '已停用',
    color: '#999999',
    bgColor: 'rgba(153, 153, 153, 0.1)'
  },
  [PROMOTION_STATUS.ENABLED]: {
    label: '推广中',
    color: '#52C41A',
    bgColor: 'rgba(82, 196, 26, 0.1)'
  }
}

// ============ 佣金状态 ============
// 0-冻结中、1-已结算
export const COMMISSION_STATUS = {
  // 冻结中
  FROZEN: 0,
  // 已结算
  SETTLED: 1
}

export const COMMISSION_STATUS_MAP = {
  [COMMISSION_STATUS.FROZEN]: {
    label: '冻结中',
    color: '#FAAD14',
    bgColor: 'rgba(250, 173, 20, 0.1)'
  },
  [COMMISSION_STATUS.SETTLED]: {
    label: '已结算',
    color: '#52C41A',
    bgColor: 'rgba(82, 196, 26, 0.1)'
  }
}

// 佣金状态筛选 Tab
export const COMMISSION_STATUS_TABS = [
  { label: '全部', value: '' },
  { label: '冻结中', value: COMMISSION_STATUS.FROZEN },
  { label: '已结算', value: COMMISSION_STATUS.SETTLED }
]

// ============ 提现状态（5.3 佣金管理） ============
// 0-处理中、1-成功、2-失败
export const WITHDRAW_STATUS = {
  PROCESSING: 0,
  SUCCESS: 1,
  FAILED: 2
}

export const WITHDRAW_STATUS_MAP = {
  [WITHDRAW_STATUS.PROCESSING]: {
    label: '处理中',
    color: '#1890FF',
    bgColor: 'rgba(24, 144, 255, 0.1)'
  },
  [WITHDRAW_STATUS.SUCCESS]: {
    label: '提现成功',
    color: '#52C41A',
    bgColor: 'rgba(82, 196, 26, 0.1)'
  },
  [WITHDRAW_STATUS.FAILED]: {
    label: '提现失败',
    color: '#FF4D4F',
    bgColor: 'rgba(255, 77, 79, 0.1)'
  }
}

// 提现状态筛选 Tab
export const WITHDRAW_STATUS_TABS = [
  { label: '全部', value: '' },
  { label: '处理中', value: WITHDRAW_STATUS.PROCESSING },
  { label: '已到账', value: WITHDRAW_STATUS.SUCCESS },
  { label: '失败', value: WITHDRAW_STATUS.FAILED }
]

// ============ 推广业务错误码扩展 ============
export const PROMOTION_ERROR_CODE = {
  // 推广商品不存在
  NOT_FOUND: 40461,
  // 非分销员
  NOT_DISTRIBUTOR: 40361
}

// ============ 表单校验规则 ============
export const DISTRIBUTOR_RULES = {
  realName: {
    required: true,
    label: '真实姓名',
    pattern: /^[\u4e00-\u9fa5]{2,10}$/,
    message: '请输入2-10位中文姓名'
  },
  idCardNo: {
    required: true,
    label: '身份证号',
    pattern: /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/,
    message: '请输入有效的18位身份证号'
  },
  bankCardNo: {
    required: true,
    label: '银行卡号',
    pattern: /^\d{16,19}$/,
    message: '请输入16-19位银行卡号'
  },
  bankName: {
    required: true,
    label: '开户银行',
    message: '请选择开户银行'
  },
  bankAccountName: {
    required: true,
    label: '开户人姓名',
    pattern: /^[\u4e00-\u9fa5]{2,10}$/,
    message: '请输入2-10位中文姓名'
  }
}

// ============ 常见银行列表 ============
export const BANK_LIST = [
  '中国工商银行',
  '中国农业银行',
  '中国银行',
  '中国建设银行',
  '交通银行',
  '招商银行',
  '中国邮政储蓄银行',
  '中信银行',
  '中国光大银行',
  '华夏银行',
  '中国民生银行',
  '兴业银行',
  '广发银行',
  '平安银行',
  '浦发银行'
]
