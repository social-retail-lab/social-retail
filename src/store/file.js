// 文件上传 Store 层
// 只调 API,不处理提示(toast)

import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  uploadImageApi,
  getFileApi,
  deleteFileApi,
  uploadImagesBatchApi
} from '@/api/file'

export const useFileStore = defineStore('file', () => {
  // ============ State ============
  // 当前上传的文件信息
  const currentFile = ref(null)
  // 批量上传成功的文件列表
  const batchFiles = ref([])
  // 批量上传失败的文件列表
  const batchFailFiles = ref([])
  // 上传中状态
  const uploading = ref(false)

  // ============ Actions ============

  // 1.4.1 图片上传
  const uploadImage = async (filePath, uploadType, businessId = null) => {
    const res = await uploadImageApi(filePath, uploadType, businessId)
    if (res.code === 0) {
      currentFile.value = res.data
    }
    return res
  }

  // 1.4.2 文件访问
  const fetchFile = async (fileId) => {
    const res = await getFileApi(fileId)
    return res
  }

  // 1.4.3 文件删除
  const deleteFile = async (fileId) => {
    const res = await deleteFileApi(fileId)
    return res
  }

  // 1.4.4 批量上传图片
  const uploadImagesBatch = async (filePaths, uploadType, businessId = null) => {
    const res = await uploadImagesBatchApi(filePaths, uploadType, businessId)
    if (res.code === 0) {
      batchFiles.value = res.data.successList || []
      batchFailFiles.value = res.data.failList || []
    }
    return res
  }

  // 重置状态
  const resetFileData = () => {
    currentFile.value = null
    batchFiles.value = []
    batchFailFiles.value = []
    uploading.value = false
  }

  return {
    // state
    currentFile,
    batchFiles,
    batchFailFiles,
    uploading,
    // actions
    uploadImage,
    fetchFile,
    deleteFile,
    uploadImagesBatch,
    resetFileData
  }
})
