# 社交新零售电商平台部署文档

## 1. 部署包结构

部署包建议包含以下内容：

```text
social-retail/
  backend/
    target/
      backend-0.0.1-SNAPSHOT.jar
  front-user/
    dist/
      build/
        h5/
  admin-platform/
    dist/
  merchant-platform/
    dist/
  sql/
    deploy/
      init.sql
      schema.sql
      data.sql
  DEPLOYMENT.md
```

说明：

- `backend-0.0.1-SNAPSHOT.jar`：后端可运行 jar 包。
- `front-user/dist/build/h5/`：用户端 H5 静态文件。
- `admin-platform/dist/`：管理后台静态文件。
- `merchant-platform/dist/`：商家端静态文件。
- `sql/deploy/`：数据库初始化脚本。

部署服务器只需要运行后端 jar、导入数据库、启动 Redis，并将三个前端静态目录交给 Nginx 托管。不需要在服务器上重新执行 `npm run dev`。

## 2. 环境要求

| 软件 | 要求 |
| --- | --- |
| JDK | 17 |
| MySQL | 8.x |
| Redis | 6.x/7.x |
| Nginx | 用于部署三个前端静态站点 |

如果需要在服务器上重新打包源码，还需要：

| 软件 | 要求 |
| --- | --- |
| Maven | 3.8+ |
| Node.js | 18+ 或 20+ |
| npm | 与 Node.js 配套版本 |

检查命令：

```bash
java -version
mysql --version
redis-server --version
nginx -v
```

注意：本项目后端基于 Spring Boot 3，运行 jar 必须使用 JDK 17，不能使用 JDK 8。

## 3. 部署辅助工具

如果部署到 Linux 服务器，建议准备以下工具：

| 类型 | 可选工具 | 用途 |
| --- | --- | --- |
| SSH 连接工具 | XShell、FinalShell、MobaXterm | 登录服务器执行部署命令 |
| 文件上传工具 | WinSCP、FileZilla、FinalShell 自带 SFTP | 上传 jar、前端静态文件和 SQL 脚本 |
| 数据库工具 | MySQL 命令行、Navicat、DBeaver | 导入 SQL、检查表数据 |

常见上传目录示例：

```text
/opt/social-retail/
  backend/
    backend-0.0.1-SNAPSHOT.jar
    logs/
    uploads/
  frontend/
    user/
    admin/
    merchant/
  sql/
    deploy/
      init.sql
      schema.sql
      data.sql
```

## 4. 端口规划

| 服务 | 端口 | 说明 |
| --- | --- | --- |
| 用户端后端 | `8081` | 用户端接口、支付回调 |
| 商家端/管理后台后端 | `8080` | 商家端、管理后台接口 |
| Redis | `6379` | 缓存服务 |
| MySQL | `3306` | 数据库服务 |
| Nginx HTTP | `80` | 前端访问入口 |
| Nginx HTTPS | `443` | 生产环境 HTTPS 入口 |

如果服务器开启防火墙或云服务器安全组，需要放行 `80`、`443`。后端端口 `8080`、`8081` 可以只允许本机访问，再由 Nginx 反向代理。

## 5. 数据库部署

进入数据库脚本目录：

```bash
cd sql/deploy
```

执行初始化脚本：

```bash
mysql -u root -p < init.sql
```

`init.sql` 会创建并使用 `social_retail_db` 数据库，然后依次执行：

```sql
SOURCE schema.sql;
SOURCE data.sql;
```

因此建议必须在 `sql/deploy` 目录下执行导入命令，避免相对路径找不到 `schema.sql` 和 `data.sql`。

注意：初始化脚本中包含 `DROP TABLE IF EXISTS`，会重建相关数据表。导入前请确认目标数据库中没有需要保留的数据。

## 6. Redis 部署

### 6.1 Linux 服务器

```bash
systemctl start redis
systemctl enable redis
```

### 6.2 Windows 演示环境

进入 Redis 目录后执行：

```powershell
redis-server.exe redis.windows.conf
```

后端默认连接配置：

```text
Redis 地址: 127.0.0.1
Redis 端口: 6379
Redis 数据库: 0
```

如果 Redis 设置了密码，需要在后端启动参数或配置文件中同步设置 `REDIS_PASSWORD`。

## 7. 后端部署

后端 jar 位置：

```text
backend/target/backend-0.0.1-SNAPSHOT.jar
```

本项目当前部署方式为同一个 jar 启动两个后端实例：

| 后端实例 | 端口 | 用途 | 启动配置 |
| --- | --- | --- | --- |
| 用户端后端 | `8081` | 用户端接口、支付回调、用户端文件上传 | `local` |
| 商家端/管理后台后端 | `8080` | 商家端接口、管理后台接口 | `local-merchant` |

### 7.1 前台启动用户端后端

```bash
cd backend
java -jar target/backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=local
```

启动成功后，用户端接口地址为：

```text
http://服务器IP:8081
```

### 7.2 前台启动商家端/管理后台后端

新开一个终端执行：

```bash
cd backend
java -jar target/backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=local-merchant
```

启动成功后，商家端和管理后台接口地址为：

```text
http://服务器IP:8080
```

### 7.3 Linux 后台启动方式

生产或服务器演示环境建议使用后台方式运行：

```bash
mkdir -p /opt/social-retail/backend/logs
cd /opt/social-retail/backend

nohup java -jar backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=local > logs/user-backend.log 2>&1 &
nohup java -jar backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=local-merchant > logs/manage-backend.log 2>&1 &
```

查看进程：

```bash
ps -ef | grep backend-0.0.1-SNAPSHOT.jar
```

查看日志：

```bash
tail -f logs/user-backend.log
tail -f logs/manage-backend.log
```

停止服务：

```bash
ps -ef | grep backend-0.0.1-SNAPSHOT.jar
kill -9 进程ID
```

### 7.4 关键配置项

正式部署时建议通过环境变量或外部配置文件设置以下参数：

| 配置项 | 说明 |
| --- | --- |
| `DB_URL` | MySQL 连接地址 |
| `DB_USERNAME` | MySQL 用户名 |
| `DB_PASSWORD` | MySQL 密码 |
| `REDIS_HOST` | Redis 地址 |
| `REDIS_PORT` | Redis 端口 |
| `REDIS_PASSWORD` | Redis 密码，没有密码可留空 |
| `JWT_SECRET` | JWT 签名密钥 |
| `UPLOAD_PATH` | 上传文件保存目录 |
| `UPLOAD_BASE_URL` | 上传文件访问地址 |
| `ALIPAY_APP_ID` | 支付宝沙箱应用 ID |
| `ALIPAY_PRIVATE_KEY` | 应用私钥 |
| `ALIPAY_PUBLIC_KEY` | 支付宝公钥 |
| `ALIPAY_NOTIFY_URL` | 支付宝异步回调地址 |
| `ALIPAY_RETURN_URL` | 支付完成后的前端返回地址 |
| `DEEPSEEK_API_KEY` | DeepSeek API Key |
| `DEEPSEEK_BASE_URL` | DeepSeek API 地址 |
| `DEEPSEEK_MODEL` | DeepSeek 模型名称 |

示例：

```bash
export DB_URL="jdbc:mysql://127.0.0.1:3306/social_retail_db?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai"
export DB_USERNAME="root"
export DB_PASSWORD="你的数据库密码"
export REDIS_HOST="127.0.0.1"
export REDIS_PORT="6379"
export JWT_SECRET="请替换为足够长的随机密钥"
export DEEPSEEK_API_KEY="你的 DeepSeek API Key"
```

Windows PowerShell 示例：

```powershell
$env:DB_URL="jdbc:mysql://127.0.0.1:3306/social_retail_db?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="你的数据库密码"
$env:REDIS_HOST="127.0.0.1"
$env:REDIS_PORT="6379"
$env:JWT_SECRET="请替换为足够长的随机密钥"
$env:DEEPSEEK_API_KEY="你的 DeepSeek API Key"
```

## 8. 支付宝沙箱与内网穿透

如果部署在本地电脑，支付宝沙箱异步回调需要公网可访问地址，因此需要启动内网穿透。

回调地址格式：

```text
https://你的公网穿透域名/api/pay/alipay/notify
```

并将该地址配置到：

```text
ALIPAY_NOTIFY_URL
```

如果部署在正式服务器，并且服务器已经有公网域名，则不需要内网穿透，直接使用正式域名即可。

示例：

```text
ALIPAY_NOTIFY_URL=https://api.example.com/api/pay/alipay/notify
ALIPAY_RETURN_URL=https://m.example.com/#/pagesSub/order/orderList
```

## 9. 前端静态文件部署

三个前端都已经打包为静态文件，部署时只需要将对应目录复制到 Nginx 网站目录。

| 前端 | 打包产物目录 | 建议部署目录 |
| --- | --- | --- |
| 用户端 H5 | `front-user/dist/build/h5/` | `/usr/share/nginx/html/user/` |
| 管理后台 | `admin-platform/dist/` | `/usr/share/nginx/html/admin/` |
| 商家端 | `merchant-platform/dist/` | `/usr/share/nginx/html/merchant/` |

Linux 示例：

```bash
cp -r front-user/dist/build/h5/* /usr/share/nginx/html/user/
cp -r admin-platform/dist/* /usr/share/nginx/html/admin/
cp -r merchant-platform/dist/* /usr/share/nginx/html/merchant/
```

Windows 部署时，也可以直接将三个静态目录复制到 Nginx 的 `html` 目录下，例如：

```text
nginx/html/user/
nginx/html/admin/
nginx/html/merchant/
```

### 9.1 前端接口地址注意事项

部署前需要确认前端静态文件中的接口地址与服务器地址一致：

- 管理后台和商家端默认使用 `/api` 请求后端，需要 Nginx 将 `/api` 代理到 `8080`。
- 用户端 H5 生产包中需要确认用户端接口地址指向 `8081` 或对应的公网代理地址。
- 如果更换服务器 IP、域名或 Nginx 路径，建议先调整前端接口地址后重新打包，再部署静态文件。

如果使用三个独立域名部署，推荐保持每个前端都使用 `/api`：

```text
用户端: https://m.example.com        /api -> http://127.0.0.1:8081
管理端: https://admin.example.com    /api -> http://127.0.0.1:8080
商家端: https://merchant.example.com /api -> http://127.0.0.1:8080
```

## 10. Nginx 配置示例

如果使用一个域名加不同路径部署，可以参考：

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location /user/ {
        alias /usr/share/nginx/html/user/;
        try_files $uri $uri/ /user/index.html;
    }

    location /admin/ {
        alias /usr/share/nginx/html/admin/;
        try_files $uri $uri/ /admin/index.html;
    }

    location /merchant/ {
        alias /usr/share/nginx/html/merchant/;
        try_files $uri $uri/ /merchant/index.html;
    }

    location /user-api/ {
        proxy_pass http://127.0.0.1:8081/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /manage-api/ {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

如果前端代码中仍然使用 `/api` 作为接口前缀，推荐使用不同域名部署前端，分别配置 `/api` 代理：

```text
用户端: https://m.example.com      /api -> http://127.0.0.1:8081
管理端: https://admin.example.com  /api -> http://127.0.0.1:8080
商家端: https://merchant.example.com /api -> http://127.0.0.1:8080
```

这种方式对前端代码改动最少。

### 10.1 Nginx 常用命令

检查配置文件是否正确：

```bash
nginx -t
```

启动 Nginx：

```bash
nginx
```

重新加载配置：

```bash
nginx -s reload
```

停止 Nginx：

```bash
nginx -s stop
```

Linux systemd 环境也可以使用：

```bash
systemctl start nginx
systemctl reload nginx
systemctl status nginx
```

## 11. 推荐部署顺序

1. 安装并启动 MySQL。
2. 导入 `sql/deploy/init.sql`。
3. 安装并启动 Redis。
4. 配置数据库、Redis、支付宝沙箱、DeepSeek 等后端参数。
5. 启动用户端后端实例 `8081`。
6. 启动商家端/管理后台后端实例 `8080`。
7. 如使用支付宝沙箱本地回调，启动内网穿透并配置 `ALIPAY_NOTIFY_URL`。
8. 将三个前端静态目录复制到 Nginx。
9. 配置并重启 Nginx。
10. 打开用户端、管理后台、商家端页面进行功能验证。

## 12. 部署后访问地址

本地演示地址：

```text
用户端 H5: http://localhost:5173 或 Nginx 中配置的 /user/
管理后台: http://localhost:5174 或 Nginx 中配置的 /admin/
商家端: http://localhost:5175 或 Nginx 中配置的 /merchant/
用户端后端: http://localhost:8081
商家端/管理后台后端: http://localhost:8080
```

正式部署地址按实际域名填写，例如：

```text
用户端 H5: https://m.example.com
管理后台: https://admin.example.com
商家端: https://merchant.example.com
用户端后端: https://api.example.com 或 Nginx 代理地址
商家端/管理后台后端: https://manage-api.example.com 或 Nginx 代理地址
```

## 13. 验收检查

部署完成后检查：

- MySQL 数据库 `social_retail_db` 已创建，表和初始化数据完整。
- Redis 服务已启动，后端连接正常。
- 用户端后端 `8081` 正常启动。
- 商家端/管理后台后端 `8080` 正常启动。
- 用户端可以登录、浏览商品、加入购物车、提交订单。
- 管理后台可以登录、审核商家、审核商品、查看统计数据。
- 商家端可以登录、管理商品、处理订单。
- 图片上传和静态资源访问正常。
- 支付宝沙箱支付可以发起，异步回调可以到达后端。
- DeepSeek 相关功能可以正常调用。

## 14. 常见问题

### 14.1 前端页面能打开，但接口请求失败

检查 Nginx 代理是否正确：

- 用户端接口应代理到 `8081`。
- 管理后台、商家端接口应代理到 `8080`。

### 14.2 后端启动失败，提示 Java 版本不兼容

检查 JDK 版本：

```bash
java -version
```

必须使用 JDK 17。

### 14.3 支付宝回调失败

检查：

- `ALIPAY_NOTIFY_URL` 是否公网可访问。
- 内网穿透是否启动。
- 回调地址是否代理到用户端后端 `8081`。
- 支付宝沙箱应用 ID、公钥、私钥是否正确。

### 14.4 数据库导入失败

请确认在 `sql/deploy` 目录下执行：

```bash
mysql -u root -p < init.sql
```

否则 `SOURCE schema.sql;` 和 `SOURCE data.sql;` 可能找不到文件。

## 15. 附录：从源码重新打包

如果部署包中没有打包产物，可以按以下命令重新打包。

### 15.1 后端

```bash
cd backend
mvn clean package -DskipTests
```

产物：

```text
backend/target/backend-0.0.1-SNAPSHOT.jar
```

### 15.2 用户端 H5

```bash
cd front-user
npm install
npm run build:h5
```

产物：

```text
front-user/dist/build/h5/
```

### 15.3 管理后台

```bash
cd admin-platform
npm install
npm run build
```

产物：

```text
admin-platform/dist/
```

### 15.4 商家端

```bash
cd merchant-platform
npm install
npm run build
```

产物：

```text
merchant-platform/dist/
```
