// 文件上传 Hook 层
// 封装业务逻辑: 选择图片、上传、删除、错误处理

import { ref } from 'vue'
import { useFileStore } from '@/store/file'
import {
  UPLOAD_TYPE,
  FILE_LIMIT,
  FILE_ERROR_CODE,
  getFileErrorMsg,
  isValidImageType,
  isValidFileSize,
  formatFileSize
} from '@/constants/file'

export const useFile = () => {
  const fileStore = useFileStore()

  // ============ 本地状态 ============
  const uploading = ref(false)
  const uploadProgress = ref(0)

  // ============ 业务方法 ============

  /**
   * 选择单张图片
   * @param {Number} count - 最多可选择数量,默认1
   * @returns {Promise<Array<String>>} 选中图片的临时路径数组
   */
  const chooseImage = (count = 1) => {
    return new Promise((resolve, reject) => {
      uni.chooseImage({
        count,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res) => {
          resolve(res.tempFilePaths || [])
        },
        fail: (err) => {
          if (err.errMsg && err.errMsg.includes('cancel')) {
            // 用户取消选择,不报错
            resolve([])
          } else {
            reject(err)
          }
        }
      })
    })
  }

  /**
   * 选择多张图片
   * @param {Number} maxCount - 最多可选择数量,默认9
   * @returns {Promise<Array<String>>} 选中图片的临时路径数组
   */
  const chooseImages = (maxCount = FILE_LIMIT.MAX_BATCH_COUNT) => {
    return chooseImage(maxCount)
  }

  /**
   * 1.4.1 上传单张图片
   * @param {String} filePath - 图片临时路径
   * @param {String} uploadType - 上传类型(UPLOAD_TYPE)
   * @param {Number} businessId - 关联业务ID(可选)
   * @returns {Promise<Object|null>} 上传成功的文件信息,失败返回null
   */
  const uploadImage = async (filePath, uploadType, businessId = null) => {
    if (!filePath) {
      uni.showToast({ title: '请先选择图片', icon: 'none' })
      return null
    }

    // 前端预校验:文件格式
    if (!isValidImageType(filePath)) {
      uni.showToast({ title: '文件格式不支持，仅支持 jpg、jpeg、png、webp', icon: 'none' })
      return null
    }

    uploading.value = true
    try {
      const res = await fileStore.uploadImage(filePath, uploadType, businessId)
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      // API层已处理toast提示,这里只做日志
      console.error('上传图片失败:', error)
      return null
    } finally {
      uploading.value = false
    }
  }

  /**
   * 1.4.4 批量上传图片
   * @param {Array<String>} filePaths - 图片临时路径数组
   * @param {String} uploadType - 上传类型(UPLOAD_TYPE)
   * @param {Number} businessId - 关联业务ID(可选)
   * @returns {Promise<Object|null>} { successList, failList } 上传结果,失败返回null
   */
  const uploadImagesBatch = async (filePaths, uploadType, businessId = null) => {
    if (!filePaths || filePaths.length === 0) {
      uni.showToast({ title: '请先选择图片', icon: 'none' })
      return null
    }

    // 前端预校验:文件格式
    const invalidFiles = filePaths.filter(path => !isValidImageType(path))
    if (invalidFiles.length > 0) {
      uni.showToast({ title: '存在不支持的文件格式', icon: 'none' })
      return null
    }

    // 前端预校验:文件数量
    if (filePaths.length > FILE_LIMIT.MAX_BATCH_COUNT) {
      uni.showToast({ title: `最多上传${FILE_LIMIT.MAX_BATCH_COUNT}张图片`, icon: 'none' })
      return null
    }

    uploading.value = true
    try {
      const res = await fileStore.uploadImagesBatch(filePaths, uploadType, businessId)
      if (res.code === 0 && res.data) {
        const { successList, failList } = res.data
        // 部分失败提示
        if (failList && failList.length > 0) {
          uni.showToast({
            title: `${successList.length}张成功,${failList.length}张失败`,
            icon: 'none'
          })
        }
        return { successList, failList }
      }
      return null
    } catch (error) {
      console.error('批量上传图片失败:', error)
      return null
    } finally {
      uploading.value = false
    }
  }

  /**
   * 1.4.2 获取文件信息
   * @param {Number} fileId - 文件ID
   * @returns {Promise<Object|null>} 文件信息
   */
  const getFile = async (fileId) => {
    if (!fileId) return null
    try {
      const res = await fileStore.fetchFile(fileId)
      if (res.code === 0) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('获取文件信息失败:', error)
      return null
    }
  }

  /**
   * 1.4.3 删除文件
   * @param {Number} fileId - 文件ID
   * @returns {Promise<Boolean>} 是否删除成功
   */
  const deleteFile = async (fileId) => {
    if (!fileId) {
      uni.showToast({ title: '文件ID不能为空', icon: 'none' })
      return false
    }

    return new Promise((resolve) => {
      uni.showModal({
        title: '提示',
        content: '确认删除该文件?',
        success: async (modalRes) => {
          if (modalRes.confirm) {
            try {
              const res = await fileStore.deleteFile(fileId)
              if (res.code === 0) {
                uni.showToast({ title: '删除成功', icon: 'success' })
                resolve(true)
              } else {
                resolve(false)
              }
            } catch (error) {
              // 错误码特殊处理
              if (error?.code === FILE_ERROR_CODE.NO_PERMISSION) {
                uni.showToast({ title: '无权限删除该文件', icon: 'none' })
              } else if (error?.code === FILE_ERROR_CODE.NOT_FOUND) {
                uni.showToast({ title: '文件不存在', icon: 'none' })
              }
              resolve(false)
            }
          } else {
            resolve(false)
          }
        }
      })
    })
  }

  /**
   * 选择并上传单张图片(一体化)
   * @param {String} uploadType - 上传类型
   * @param {Number} businessId - 业务ID
   * @returns {Promise<Object|null>} 上传成功的文件信息
   */
  const chooseAndUploadImage = async (uploadType, businessId = null) => {
    const filePaths = await chooseImage(1)
    if (filePaths.length === 0) return null
    return uploadImage(filePaths[0], uploadType, businessId)
  }

  /**
   * 选择并上传多张图片(一体化)
   * @param {String} uploadType - 上传类型
   * @param {Number} businessId - 业务ID
   * @param {Number} maxCount - 最大数量
   * @returns {Promise<Object|null>} { successList, failList }
   */
  const chooseAndUploadImages = async (uploadType, businessId = null, maxCount = FILE_LIMIT.MAX_BATCH_COUNT) => {
    const filePaths = await chooseImages(maxCount)
    if (filePaths.length === 0) return null
    return uploadImagesBatch(filePaths, uploadType, businessId)
  }

  /**
   * 重置数据
   */
  const resetFileData = () => {
    fileStore.resetFileData()
    uploading.value = false
    uploadProgress.value = 0
  }

  return {
    // store
    fileStore,
    // state
    uploading,
    uploadProgress,
    // 选择图片
    chooseImage,
    chooseImages,
    // 上传(1.4.1 / 1.4.4)
    uploadImage,
    uploadImagesBatch,
    chooseAndUploadImage,
    chooseAndUploadImages,
    // 查询(1.4.2)
    getFile,
    // 删除(1.4.3)
    deleteFile,
    // 重置
    resetFileData,
    // 常量导出(便于页面使用)
    UPLOAD_TYPE,
    FILE_LIMIT
  }
}
