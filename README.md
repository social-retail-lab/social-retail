# Social Retail 社交零售系统

基于 Spring Boot 的社交零售后端系统，包含用户、商品、订单、支付、优惠券、秒杀、会员、分销、商家和售后等业务模块。

## 技术栈

- Java 17
- Spring Boot 3.0.3
- MyBatis-Plus 3.5.5
- MySQL 8
- Redis
- Maven
- JWT
- 支付宝沙箱

## 项目结构

```text
social-retail/
├── backend/                    # Spring Boot 后端
│   ├── src/main/java/          # Java 源码
│   ├── src/main/resources/
│   │   ├── mapper/             # MyBatis XML
│   │   ├── db/                 # 数据库脚本
│   │   └── application.properties
│   └── pom.xml
├── sql/                        # 初始化及测试 SQL
└── docs/api/                   # API 文档
