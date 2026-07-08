// 支付宝支付SDK封装
// 包含：支付宝沙箱支付、支付结果处理

// 发起支付宝支付
export const payWithAlipay = (orderInfo) => {
  return new Promise((resolve, reject) => {
    // #ifdef APP-PLUS
    uni.requestPayment({
      provider: 'alipay',
      orderInfo: orderInfo,
      success: (res) => {
        resolve(res)
      },
      fail: (err) => {
        reject(err)
      }
    })
    // #endif
    
    // #ifdef H5
    // H5环境下的支付宝支付处理
    // window.location.href = orderInfo
    // #endif
    
    // #ifdef MP-WEIXIN
    // 小程序不支持支付宝支付
    reject(new Error('小程序不支持支付宝支付'))
    // #endif
  })
}

// 沙箱支付（测试环境）
export const sandboxPay = (orderInfo) => {
  return payWithAlipay(orderInfo)
}

// 查询支付状态
export const queryPayStatus = (orderId) => {
  // 调用支付状态查询接口
  // return new Promise((resolve, reject) => {
  //   // 查询支付结果
  // })
}

// 支付结果处理
export const handlePayResult = (result) => {
  // 根据支付结果进行处理
  // if (result.status === 'success') {
  //   // 支付成功
  // } else {
  //   // 支付失败
  // }
}
