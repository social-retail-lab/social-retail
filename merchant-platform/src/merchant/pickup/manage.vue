<template>
  <div class="pickup-manage">
    <div class="page-header">
      <h2>自提点管理</h2>
      <button class="btn-add" @click="openAddDialog">+ 新增自提点</button>
    </div>

    <!-- 自提点列表 -->
    <table class="data-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>名称</th>
          <th>地址</th>
          <th>联系电话</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in list" :key="item.id || item.pointId">
          <td>{{ item.id || item.pointId }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.address }}</td>
          <td>{{ item.contactPhone }}</td>
          <td>
            <span :class="['status-tag', getAuditClass(item.auditStatus)]">
              {{ getAuditText(item.auditStatus) }}
            </span>
          </td>
          <td>
            <button class="btn-danger" @click="handleDelete(item.id || item.pointId)">删除</button>
          </td>
        </tr>
        <tr v-if="list.length === 0">
          <td colspan="6" class="empty-cell">暂无自提点</td>
        </tr>
      </tbody>
    </table>

    <!-- 新增自提点弹窗 -->
    <div v-if="showAddDialog" class="modal-mask" @click.self="cancelAdd">
      <div class="modal-box">
        <h3>新增自提点</h3>
        <div class="form-fields">
          <div class="field-group">
            <label>自提点名称 <span class="required">*</span></label>
            <input v-model="form.name" placeholder="请输入自提点名称" />
          </div>
          <div class="field-group">
            <label>详细地址 <span class="required">*</span></label>
            <input v-model="form.address" placeholder="请输入详细地址" />
          </div>
          <div class="field-group">
            <label>联系电话</label>
            <input v-model="form.contactPhone" placeholder="请输入联系电话" />
          </div>
          <div class="field-group full-width">
            <label>自提点图片 <span class="required">*</span></label>
            <div class="upload-area">
              <div v-if="!uploading && !imagePreview" class="upload-box" @click="triggerUpload">
                <input
                  ref="fileInputRef"
                  type="file"
                  accept="image/*"
                  style="display:none"
                  @change="handleFileSelect"
                />
                <span class="upload-icon">📷</span>
                <span class="upload-text">点击上传图片</span>
                <span class="upload-hint">支持 JPG/PNG，不超过 5MB</span>
              </div>
              <div v-if="uploading" class="upload-progress">
                <span>上传中...</span>
              </div>
              <div v-if="imagePreview && !uploading" class="preview-box">
                <img :src="imagePreview" alt="预览" class="preview-img" />
                <button class="btn-remove-img" @click="removeImage">✕</button>
              </div>
            </div>
          </div>
        </div>
        <div class="dialog-footer">
          <button class="btn-cancel" @click="cancelAdd">取消</button>
          <button class="btn-submit" @click="handleAdd">确认新增</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getPickupPoints, addPickupPoint, deletePickupPoint } from '@/api/order'
import request from '@/utils/request'

const list = ref<any[]>([])
const fileInputRef = ref<HTMLInputElement | null>(null)
const uploading = ref(false)
const imagePreview = ref('')
const uploadedUrl = ref('')
const showAddDialog = ref(false)

const form = ref({
  name: '',
  address: '',
  contactPhone: '',
  image: ''
})

const triggerUpload = () => {
  fileInputRef.value?.click()
}

const handleFileSelect = async (event: Event) => {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  // 校验文件大小：5MB
  if (file.size > 5 * 1024 * 1024) {
    alert('图片大小不能超过 5MB')
    return
  }

  // 本地预览
  const reader = new FileReader()
  reader.onload = (e) => {
    imagePreview.value = e.target?.result as string
  }
  reader.readAsDataURL(file)

  // 上传到服务器
  uploading.value = true
  try {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('uploadType', 'MERCHANT_LOGO')
    const res = await request.post('/files/images', formData, {
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    if (res.code === 0 && res.data) {
      uploadedUrl.value = res.data.url || res.data.imageUrl || ''
      form.value.image = uploadedUrl.value
    } else {
      alert('图片上传失败，请重试')
      imagePreview.value = ''
    }
  } catch (e: any) {
    console.log('[上传图片] 异常:', e.message)
    alert('图片上传失败，请重试')
    imagePreview.value = ''
  } finally {
    uploading.value = false
    // 重置 input 以允许重复选择同一文件
    if (fileInputRef.value) fileInputRef.value.value = ''
  }
}

const removeImage = () => {
  imagePreview.value = ''
  uploadedUrl.value = ''
  form.value.image = ''
}

const openAddDialog = () => {
  form.value = { name: '', address: '', contactPhone: '', image: '' }
  imagePreview.value = ''
  uploadedUrl.value = ''
  showAddDialog.value = true
}

const cancelAdd = () => {
  showAddDialog.value = false
}

const getAuditClass = (status: number) => {
  if (status === 0) return 'WAIT'
  if (status === 1) return 'PASSED'
  if (status === 2) return 'REJECTED'
  return ''
}

const getAuditText = (status: number) => {
  if (status === 0) return '待审核'
  if (status === 1) return '已通过'
  if (status === 2) return '已驳回'
  return '未知'
}

const fetchList = async () => {
  try {
    const res = await getPickupPoints()
    if (res.code === 0) {
      list.value = res.data || []
    }
  } catch (e: any) {
    console.log('[自提点列表] 异常:', e.message)
  }
}

const handleAdd = async () => {
  if (!form.value.name || !form.value.address) {
    alert('名称和地址不能为空')
    return
  }
  if (!form.value.image) {
    alert('请上传自提点图片')
    return
  }
  try {
    const res = await addPickupPoint(form.value)
    if (res.code === 0) {
      alert('新增成功')
      showAddDialog.value = false
      fetchList()
    } else {
      alert(res.message || '新增失败')
    }
  } catch (e: any) {
    console.log('[新增自提点] 异常:', e.message)
  }
}

const handleDelete = async (id: number) => {
  if (!confirm('确认删除该自提点？')) return
  try {
    const res = await deletePickupPoint(id)
    if (res.code === 0) {
      alert('删除成功')
      fetchList()
    } else {
      alert(res.message || '删除失败')
    }
  } catch (e: any) {
    console.log('[删除自提点] 异常:', e.message)
  }
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped>
.pickup-manage {
  padding: 24px;
  max-width: 1000px;
  margin: 0 auto;
}

h2 {
  font-size: 20px;
  color: #1D2129;
  margin: 0;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.btn-add {
  padding: 10px 24px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-add:hover {
  background: #4080FF;
}

.form-fields {
  margin-bottom: 20px;
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-group.full-width {
  grid-column: 1 / -1;
}

.field-group label {
  font-size: 13px;
  color: #4E5969;
  font-weight: 500;
}

.required {
  color: #E74C3C;
}

.field-group input {
  padding: 9px 12px;
  border: 1px solid #E5E6EB;
  border-radius: 4px;
  font-size: 13px;
  outline: none;
  transition: border-color 0.2s;
}

.field-group input:focus {
  border-color: #165DFF;
}

/* 上传区域 */
.upload-box {
  border: 2px dashed #D0D5DD;
  border-radius: 8px;
  padding: 32px;
  text-align: center;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.upload-box:hover {
  border-color: #165DFF;
  background: #F7F8FA;
}

.upload-icon {
  font-size: 36px;
}

.upload-text {
  font-size: 14px;
  color: #1D2129;
}

.upload-hint {
  font-size: 12px;
  color: #C9CDD4;
}

.upload-progress {
  padding: 20px;
  text-align: center;
  color: #165DFF;
  font-size: 14px;
}

.preview-box {
  position: relative;
  display: inline-block;
}

.preview-img {
  width: 160px;
  height: 160px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #E5E6EB;
}

.btn-remove-img {
  position: absolute;
  top: -10px;
  right: -10px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: #E74C3C;
  color: #fff;
  border: none;
  cursor: pointer;
  font-size: 13px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 弹窗 */
.modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.45);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-box {
  background: #fff;
  border-radius: 10px;
  padding: 28px;
  width: 520px;
  max-height: 80vh;
  overflow-y: auto;
}

.modal-box h3 {
  font-size: 17px;
  color: #1D2129;
  margin: 0 0 20px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 8px;
}

.btn-cancel {
  padding: 9px 24px;
  background: #fff;
  color: #4E5969;
  border: 1px solid #E5E6EB;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-cancel:hover {
  background: #F5F5F5;
}

.btn-submit {
  padding: 9px 28px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
}

.btn-submit:hover {
  background: #4080FF;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.data-table th,
.data-table td {
  padding: 12px 14px;
  text-align: center;
  border-bottom: 1px solid #F2F3F5;
  font-size: 13px;
  color: #4E5969;
}

.data-table th {
  background: #FAFBFC;
  font-weight: 600;
  color: #1D2129;
}

.empty-cell {
  color: #C9CDD4 !important;
  padding: 32px !important;
}

.status-tag {
  font-size: 12px;
  padding: 2px 10px;
  border-radius: 4px;
}

.status-tag.WAIT {
  background: #FFF7E6;
  color: #E67E22;
}

.status-tag.PASSED {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.REJECTED {
  background: #FFF2F0;
  color: #FF4D4F;
}

.btn-danger {
  padding: 4px 14px;
  background: #E74C3C;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-danger:hover {
  background: #C0392B;
}
</style>
