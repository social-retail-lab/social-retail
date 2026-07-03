# 社交新零售电商平台 - 用户端APP

## 项目简介

基于 UniApp + Vue3 的跨平台电商用户端应用，支持 H5、微信小程序、Android/iOS APP。

## 技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| UniApp | 3.0+ | 跨平台前端框架 |
| Vue.js | 3.4+ | 前端框架 |
| Pinia | 2.1+ | 状态管理 |
| Axios | 1.6+ | HTTP请求库 |
| TypeScript | 5.4+ | 类型语言 |
| Sass | 1.71+ | CSS预处理器 |
| Vite | 5.2+ | 构建工具 |

## 项目结构

```
frontend-user/
├── package.json              # 项目依赖、脚本配置
├── README.md                 # 项目说明
├── src/
│   ├── pages/                # 主包页面（Tab页、核心高频页面）
│   ├── pagesSub/             # 分包页面（按需加载）
│   ├── components/           # 全局可复用组件
│   ├── api/                  # 接口请求统一管理
│   ├── store/                # Pinia全局状态
│   ├── hooks/                # 业务逻辑抽离钩子
│   ├── utils/                # 通用工具函数
│   ├── assets/               # 全局样式文件
│   ├── static/               # 静态资源
│   ├── constants/            # 全局枚举常量
│   ├── middleware/           # 路由拦截守卫
│   ├── App.vue               # 应用根组件
│   ├── main.js               # 项目入口
│   ├── pages.json            # 路由、分包、tabBar配置
│   └── manifest.json         # APP打包配置
```

## 环境要求

- Node.js >= 18.0.0
- npm >= 9.0.0
- HBuilderX >= 4.0.0

## 开发命令

```bash
# 安装依赖
npm install

# H5开发
npm run dev:h5

# H5构建
npm run build:h5

# 微信小程序开发
npm run dev:mp-weixin

# 微信小程序构建
npm run build:mp-weixin

# APP开发
npm run dev:app

# APP构建
npm run build:app
```

## 分包策略

| 分包 | 路径 | 说明 |
|------|------|------|
| goods | pagesSub/goods | 商品模块（分类、搜索、详情、秒杀） |
| order | pagesSub/order | 订单模块（订单列表、详情、支付、售后） |
| promotion | pagesSub/promotion | 营销模块（优惠券、秒杀结算） |
| distribution | pagesSub/distribution | 分销模块（分销中心、佣金、分享） |
| member | pagesSub/member | 会员模块（会员中心、积分、成长值） |

## SDK配置

### 支付宝支付
在 manifest.json 中配置支付宝相关参数。

### 腾讯地图
在 manifest.json 中配置腾讯地图SDK密钥。

### 微信分享
在 manifest.json 微信小程序配置中设置 AppID。

## 权限说明

- android.permission.CAMERA - 拍照上传
- android.permission.LOCATION - 定位服务
- android.permission.INTERNET - 网络访问
- android.permission.WRITE_EXTERNAL_STORAGE - 文件存储
