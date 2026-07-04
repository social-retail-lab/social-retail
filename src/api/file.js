// 文件上传接口模块
// 包含：图片上传(1.4.1)、文件访问(1.4.2)、文件删除(1.4.3)、批量上传(1.4.4)

import request, { http } from './base'
import { FILE_ERROR_CODE, getFileErrorMsg } from '@/constants/file'

// ============ 基础配置 ============

const baseUrl = process.env.NODE_ENV === 'development' ? '' : 'http://172.20.10.11:8081'

// 获取token
const getToken = () => uni.getStorageSync('token') || ''

// ============ 数据规范化 ============

// 规范化单文件上传响应数据
const normalizeFileData = (data) => {
  if (!data) return null
  return {
    fileId: data.fileId || null,
    fileName: data.fileName || '',
    fileUrl: data.fileUrl || '',
    uploadType: data.uploadType || '',
    fileSize: Number(data.fileSize) || 0,
    contentType: data.contentType || '',
    createTime: data.createTime || ''
  }
}

// 规范化批量上传响应数据
const normalizeBatchFileData = (data) => {
  if (!data) return { list: [], successList: [], failList: [] }

  // 兼容两种响应格式: list(全部成功) / successList+failList(部分成功)
  if (data.list && Array.isArray(data.list)) {
    return {
      list: data.list.map(item => normalizeFileData(item)),
      successList: data.list.map(item => normalizeFileData(item)),
      failList: []
    }
  }

  return {
    list: (data.successList || []).map(item => normalizeFileData(item)),
    successList: (data.successList || []).map(item => normalizeFileData(item)),
    failList: (data.failList || []).map(item => ({
      fileName: item.fileName || '',
      reason: item.reason || '上传失败'
    }))
  }
}

// ============ 1.4.1 图片上传 ============
// POST /api/files/images
// Content-Type: multipart/form-data
// 参数: file(File,必填), uploadType(String,必填), businessId(Long,可选)
export const uploadImageApi = (filePath, uploadType, businessId = null) => {
  return new Promise((resolve, reject) => {
    if (!filePath) {
      reject({ message: '文件路径不能为空' })
      return
    }
    if (!uploadType) {
      reject({ message: '上传类型不能为空' })
      return
    }

    const formData = { uploadType }
    if (businessId) {
      formData.businessId = businessId
    }

    uni.uploadFile({
      url: `${baseUrl}/api/files/images`,
      filePath,
      name: 'file',
      formData,
      header: {
        'Authorization': getToken() ? `Bearer ${getToken()}` : ''
      },
      success: (res) => {
        // uploadFile 的响应需要手动解析
        try {
          const data = JSON.parse(res.data)
          if (data.code === 0) {
            resolve({ code: 0, message: data.message || '上传成功', data: normalizeFileData(data.data) })
          } else {
            // 业务错误
            const errorMsg = getFileErrorMsg(data.code) || data.message || '上传失败'
            uni.showToast({ title: errorMsg, icon: 'none' })
            reject(data)
          }
        } catch (e) {
          uni.showToast({ title: '上传失败，响应格式错误', icon: 'none' })
          reject({ message: '上传失败，响应格式错误' })
        }
      },
      fail: (err) => {
        uni.showToast({ title: '网络异常，上传失败', icon: 'none' })
        reject(err)
      }
    })
  })
}

// ============ 1.4.2 文件访问 ============
// GET /api/files/{fileId}
// 鉴权: 可选
export const getFileApi = (fileId) => {
  return http.get(`/api/files/${fileId}`)
}

// ============ 1.4.3 文件删除 ============
// DELETE /api/files/{fileId}
export const deleteFileApi = (fileId) => {
  return http.delete(`/api/files/${fileId}`)
}

// ============ 1.4.4 批量上传图片 ============
// POST /api/files/images/batch
// Content-Type: multipart/form-data
// 参数: files(File[],必填), uploadType(String,必填), businessId(Long,可选)
export const uploadImagesBatchApi = (filePaths, uploadType, businessId = null) => {
  return new Promise((resolve, reject) => {
    if (!filePaths || !Array.isArray(filePaths) || filePaths.length === 0) {
      reject({ message: '文件列表不能为空' })
      return
    }
    if (!uploadType) {
      reject({ message: '上传类型不能为空' })
      return
    }

    const formData = { uploadType }
    if (businessId) {
      formData.businessId = businessId
    }

    // uni.uploadFile 支持多文件通过 files 参数
    // 但 files 参数要求是 [{ name, uri }] 格式
    const files = filePaths.map((uri, index) => ({
      name: `files`,
      uri
    }))

    uni.uploadFile({
      url: `${baseUrl}/api/files/images/batch`,
      files,
      formData,
      header: {
        'Authorization': getToken() ? `Bearer ${getToken()}` : ''
      },
      success: (res) => {
        try {
          const data = JSON.parse(res.data)
          if (data.code === 0) {
            resolve({ code: 0, message: data.message || '批量上传成功', data: normalizeBatchFileData(data.data) })
          } else {
            const errorMsg = getFileErrorMsg(data.code) || data.message || '批量上传失败'
            uni.showToast({ title: errorMsg, icon: 'none' })
            reject(data)
          }
        } catch (e) {
          uni.showToast({ title: '上传失败，响应格式错误', icon: 'none' })
          reject({ message: '上传失败，响应格式错误' })
        }
      },
      fail: (err) => {
        uni.showToast({ title: '网络异常，上传失败', icon: 'none' })
        reject(err)
      }
    })
  })
}

export default {
  uploadImageApi,
  getFileApi,
  deleteFileApi,
  uploadImagesBatchApi
}
