// src/mock/adminMock.ts
export const mockAdminLogin = (data: {username:string,password:string,adminType:string}) => {
  const mockSysAdmin = {
    username:"superadmin",
    password:"123456",
    adminType:"SYSTEM",
    token:"mock-token-123456",
    adminInfo:{
      adminId:1,
      realName:"系统管理员",
      role:"超级管理员"
    }
  }
  const mockOpAdmin = {
    username:"operator01",
    password:"123456",
    adminType:"OPERATION",
    token:"mock-token-789",
    adminInfo:{
      adminId:2,
      realName:"运营管理员",
      role:"商品运营"
    }
  }
  if(data.adminType === "SYSTEM"){
    if(data.username === mockSysAdmin.username && data.password === mockSysAdmin.password){
      return {
        code:0,
        message:"success",
        data:mockSysAdmin
      }
    }
  }else{
    if(data.username === mockOpAdmin.username && data.password === mockOpAdmin.password){
      return {
        code:0,
        message:"success",
        data:mockOpAdmin
      }
    }
  }
  return {code:401,message:"账号密码错误"}
}