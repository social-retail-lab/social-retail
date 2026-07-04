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
```

## 环境要求
JDK 17
Maven 3.8+
MySQL 8.0+
Redis 6.0+
## 数据库初始化
创建 MySQL 数据库：
CREATE DATABASE social_retail_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
执行基础建表脚本。
按日期顺序执行增量 SQL。
根据需要执行测试数据脚本。
SQL 文件目前位于 sql/、backend/src/main/resources/db/
和 backend/src/main/resources/db_new/。正式使用前应明确唯一的
基线脚本和增量脚本执行顺序。

## 环境变量
变量	说明	示例
DB_URL	MySQL 地址	jdbc:mysql://localhost:3306/social_retail_db
DB_USERNAME	数据库用户名	root
DB_PASSWORD	数据库密码	password
REDIS_HOST	Redis 地址	127.0.0.1
REDIS_PORT	Redis 端口	6379
JWT_SECRET	JWT 签名密钥	请使用高强度随机字符串
UPLOAD_PATH	文件上传目录	D:/uploads
UPLOAD_BASE_URL	文件访问地址	http://localhost:8081/uploads
ALIPAY_APP_ID	支付宝应用 ID	沙箱应用 ID
ALIPAY_PRIVATE_KEY	支付宝应用私钥	-
ALIPAY_PUBLIC_KEY	支付宝公钥	-

## 启动项目
cd backend
mvn clean spring-boot:run
默认服务地址：
http://localhost:8081
运行测试
cd backend
mvn test
API 文档
接口说明位于：
docs/api/3.2-order-preview-submit.md
docs/api/orders-submit.md
## 配置说明
默认 Profile：local
数据库不会自动执行 SQL
本地敏感配置不要提交到 Git
生产环境必须修改 JWT 密钥并关闭模拟短信
## 注意事项
- 请确保 MySQL 和 Redis 已启动。
- SQL 应严格按照约定顺序执行。
- 不要在仓库中提交数据库密码、JWT 密钥或支付私钥。
- 支付功能默认对接支付宝沙箱环境。
## License
本项目仅供学习、课程设计及内部研发使用。
