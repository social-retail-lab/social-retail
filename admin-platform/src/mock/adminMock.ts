export const mockAdminLogin = (data: { username: string; password: string; adminType: string }) => {
  const mockAdmins: Record<string, { username: string; password: string; token: string }> = {
    SYSTEM: {
      username: 'admin',
      password: '123456',
      token: 'admin-system-token-001'
    },
    OPERATION: {
      username: 'operator',
      password: '123456',
      token: 'admin-operation-token-001'
    }
  }

  const admin = mockAdmins[data.adminType]
  if (admin && data.username === admin.username && data.password === admin.password) {
    return {
      code: 0,
      message: '登录成功',
      data: {
        token: admin.token,
        adminType: data.adminType,
        username: admin.username
      }
    }
  }
  return {
    code: 401,
    message: '账号或密码错误'
  }
}