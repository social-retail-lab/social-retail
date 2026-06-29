// 商家登录模拟账号
export const mockMerchantLogin = (data: {phone:string,password:string}) => {
  const mockMerchant = {
    phone: "13800138000",
    password: "123456",
    token: "merchant-token-001",
    merchantId: 20001,
    merchantName: "张三生鲜超市"
  }
  if (data.phone === mockMerchant.phone && data.password === mockMerchant) {
    return {
      code: 0,
      message: "登录成功",
      data: mockMerchant
    }
  }
  return {
    code: 401,
    message: "手机号或密码错误"
  }
}