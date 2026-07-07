# 分销员身份证图片上传

分销员申请前，分别上传身份证正面和反面。图片属于敏感资料，返回的文件地址需要登录鉴权，不能作为公开静态资源访问。

## 上传接口

```http
POST /api/files/images
Authorization: Bearer {token}
Content-Type: multipart/form-data
```

表单字段：

| 字段 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| file | File | 是 | JPG、PNG、GIF 或 WEBP，最大 10MB |
| uploadType | String | 是 | 正面传 `DISTRIBUTOR_IDCARD_FRONT`，反面传 `DISTRIBUTOR_IDCARD_BACK` |

响应示例：

```json
{
  "code": 0,
  "message": "上传成功",
  "data": {
    "fileId": 1001,
    "fileName": "front.jpg",
    "fileUrl": "/api/files/images/1001/content",
    "fileSize": 102400
  }
}
```

本地存储位置：

```text
G:/social_retail_lab/social-retail/backend/src/main/resources/static/distributor/id/front
G:/social_retail_lab/social-retail/backend/src/main/resources/static/distributor/id/back
```

可通过 `DISTRIBUTOR_ID_CARD_STORAGE_PATH` 修改共同的 `id` 根目录。

## 提交申请

将两次上传返回的 `fileUrl` 分别传入申请接口：

```json
{
  "realName": "张三",
  "idCardNo": "500101199901011234",
  "idCardFront": "/api/files/images/1001/content",
  "idCardBack": "/api/files/images/1002/content",
  "bankName": "中国工商银行",
  "bankCardNo": "6222020202020202020",
  "bankAccountName": "张三"
}
```

系统会校验图片所有者及正反面类型。读取图片时调用 `GET {fileUrl}` 并携带登录 Token；仅图片所有者和管理员可以访问。
