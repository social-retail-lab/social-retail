<template>
  <div class="pickup-page">
    <!-- 门店核销（上半部分） -->
    <div class="verify-card">
      <h2>门店核销</h2>
      <p class="verify-desc">输入顾客提供的自提核销码，完成订单核销</p>

      <div class="code-input-wrapper">
        <input
          v-model="pickupCode"
          placeholder="请输入核销码"
          class="code-input"
          @keyup.enter="handleVerify"
        />
        <button class="verify-btn" @click="handleVerify">核销</button>
      </div>

      <div v-if="result" class="result-box">
        <h3>核销成功</h3>
        <div class="result-grid">
          <div class="result-item">
            <span class="r-label">订单编号</span>
            <span class="r-value">{{ result.orderSn }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">订单ID</span>
            <span class="r-value">{{ result.orderId }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">商品</span>
            <span class="r-value">{{ result.productTitle }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">规格</span>
            <span class="r-value">{{ result.specs }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">数量</span>
            <span class="r-value">{{ result.quantity }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">收货人</span>
            <span class="r-value">{{ result.receiverName }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">联系方式</span>
            <span class="r-value">{{ result.receiverPhone }}</span>
          </div>
          <div class="result-item">
            <span class="r-label">核销时间</span>
            <span class="r-value">{{ result.verifyTime }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 分隔线 -->
    <div class="divider">
      <span class="divider-text">自提点管理</span>
    </div>

    <!-- 自提点管理（下半部分） -->
    <div class="pickup-section">
      <div class="page-header">
        <h2>自提点管理</h2>
        <button class="btn-add" @click="openAddDialog">+ 新增自提点</button>
      </div>

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
          <tr v-for="item in pointList" :key="item.id || item.pointId">
            <td>{{ item.id || item.pointId }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.address }}</td>
            <td>{{ item.contactPhone }}</td>
            <td>
              <span :class="['status-tag', getStatusClass(item.status)]">
                {{ getStatusText(item.status) }}
              </span>
            </td>
            <td>
              <button class="btn-danger" @click="handleDelete(item.id || item.pointId)">删除</button>
            </td>
          </tr>
          <tr v-if="pointList.length === 0">
            <td colspan="6" class="empty-cell">暂无自提点</td>
          </tr>
        </tbody>
      </table>

      <!-- 新增弹窗 -->
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
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { pickupVerify, getPickupPoints, addPickupPoint, deletePickupPoint } from '@/api/order'
import request from '@/utils/request'

// ===== 门店核销 =====
const pickupCode = ref('')
const result = ref<any>(null)

const handleVerify = async () => {
  if (!pickupCode.value.trim()) {
    alert('请输入核销码')
    return
  }
  const res = await pickupVerify(pickupCode.value.trim())
  if (res.code === 0) {
    result.value = res.data
  } else {
    alert(res.message || '核销失败')
  }
}

// ===== 自提点管理 =====
const pointList = ref<any[]>([])
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
  if (file.size > 5 * 1024 * 1024) {
    alert('图片大小不能超过 5MB')
    return
  }
  const reader = new FileReader()
  reader.onload = (e) => { imagePreview.value = e.target?.result as string }
  reader.readAsDataURL(file)
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

const cancelAdd = () => { showAddDialog.value = false }

const getStatusClass = (status: number) => {
  if (status === 1) return 'ENABLED'
  if (status === 0) return 'DISABLED'
  return 'UNKNOWN'
}
const getStatusText = (status: number) => {
  if (status === 1) return '营业中'
  if (status === 0) return '已关闭'
  return '未知'
}

const fetchPointList = async () => {
  try {
    const res = await getPickupPoints()
    if (res.code === 0) pointList.value = res.data || []
  } catch (e: any) {
    console.error('[自提点管理] 异常:', e.message)
  }
}

const handleAdd = async () => {
  if (!form.value.name || !form.value.address) { alert('名称和地址不能为空'); return }
  if (!form.value.image) { alert('请上传自提点图片'); return }
  try {
    const res = await addPickupPoint(form.value)
    if (res.code === 0) { alert('新增成功'); showAddDialog.value = false; fetchPointList() }
    else { alert(res.message || '新增失败') }
  } catch (e: any) { console.log('[新增自提点] 异常:', e.message) }
}

const handleDelete = async (id: number) => {
  if (!confirm('确认删除该自提点？')) return
  try {
    const res = await deletePickupPoint(id)
    if (res.code === 0) { alert('删除成功'); fetchPointList() }
    else { alert(res.message || '删除失败') }
  } catch (e: any) { console.log('[删除自提点] 异常:', e.message) }
}

onMounted(() => { fetchPointList() })
</script>

<style scoped>
.pickup-page { padding: 20px; max-width: 1000px; margin: 0 auto; }

/* 门店核销 */
.verify-card {
  background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  padding: 40px 56px; text-align: center; margin-bottom: 32px;
}
.verify-card h2 { font-size: 24px; color: #1D2129; margin: 0 0 12px; }
.verify-desc { font-size: 14px; color: #86909C; margin: 0 0 32px; }
.code-input-wrapper { display: flex; gap: 12px; margin-bottom: 32px; }
.code-input {
  flex: 1; padding: 14px 16px; font-size: 18px; border: 2px solid #E5E6EB;
  border-radius: 8px; outline: none; letter-spacing: 2px; text-align: center; transition: border-color 0.2s;
}
.code-input:focus { border-color: #165DFF; }
.code-input::placeholder { font-size: 14px; letter-spacing: 0; color: #C9CDD4; }
.verify-btn {
  padding: 14px 40px; font-size: 18px; background: #165DFF; color: #fff;
  border: none; border-radius: 8px; cursor: pointer; white-space: nowrap; transition: background 0.2s;
}
.verify-btn:hover { background: #4080FF; }
.result-box { background: #F0FDF4; border: 1px solid #BBF7D0; border-radius: 10px; padding: 28px; }
.result-box h3 { font-size: 18px; color: #166534; margin: 0 0 20px; }
.result-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; text-align: left; }
.result-item { display: flex; flex-direction: column; gap: 4px; background: rgba(255,255,255,0.7); border-radius: 6px; padding: 10px 14px; }
.r-label { font-size: 12px; color: #86909C; }
.r-value { font-size: 14px; color: #1D2129; font-weight: 500; word-break: break-all; }

/* 分隔线 */
.divider { display: flex; align-items: center; margin-bottom: 24px; }
.divider::before,.divider::after { content: ''; flex: 1; height: 1px; background: #E5E6EB; }
.divider-text { padding: 0 20px; font-size: 18px; font-weight: 600; color: #1D2129; }

/* 自提点管理 */
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.page-header h2 { font-size: 20px; color: #1D2129; margin: 0; }
.btn-add { padding: 10px 24px; background: #165DFF; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; }
.btn-add:hover { background: #4080FF; }
.data-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
.data-table th, .data-table td { padding: 12px 14px; text-align: center; border-bottom: 1px solid #F2F3F5; font-size: 13px; color: #4E5969; }
.data-table th { background: #EDEEEF; font-weight: 600; color: #1D2129; font-size: 15px; }
.empty-cell { color: #C9CDD4 !important; padding: 32px !important; }
.status-tag { font-size: 12px; padding: 2px 10px; border-radius: 4px; }
.status-tag.ENABLED { background: #F6FFED; color: #52C41A; }
.status-tag.DISABLED { background: #FFF2F0; color: #FF4D4F; }
.status-tag.UNKNOWN { background: #F2F3F5; color: #86909C; }
.btn-danger { padding: 4px 14px; background: #E74C3C; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
.btn-danger:hover { background: #C0392B; }

/* 弹窗 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 10px; padding: 28px; width: 520px; max-height: 80vh; overflow-y: auto; }
.modal-box h3 { font-size: 17px; color: #1D2129; margin: 0 0 20px; }
.form-fields { margin-bottom: 20px; }
.field-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
.field-group.full-width { grid-column: 1 / -1; }
.field-group label { font-size: 13px; color: #4E5969; font-weight: 500; }
.required { color: #E74C3C; }
.field-group input { padding: 9px 12px; border: 1px solid #E5E6EB; border-radius: 4px; font-size: 13px; outline: none; transition: border-color 0.2s; }
.field-group input:focus { border-color: #165DFF; }
.upload-box { border: 2px dashed #D0D5DD; border-radius: 8px; padding: 32px; text-align: center; cursor: pointer; transition: border-color 0.2s, background 0.2s; display: flex; flex-direction: column; align-items: center; gap: 8px; }
.upload-box:hover { border-color: #165DFF; background: #F7F8FA; }
.upload-icon { font-size: 36px; }
.upload-text { font-size: 14px; color: #1D2129; }
.upload-hint { font-size: 12px; color: #C9CDD4; }
.upload-progress { padding: 20px; text-align: center; color: #165DFF; font-size: 14px; }
.preview-box { position: relative; display: inline-block; }
.preview-img { width: 160px; height: 160px; object-fit: cover; border-radius: 8px; border: 1px solid #E5E6EB; }
.btn-remove-img { position: absolute; top: -10px; right: -10px; width: 24px; height: 24px; border-radius: 50%; background: #E74C3C; color: #fff; border: none; cursor: pointer; font-size: 13px; display: flex; align-items: center; justify-content: center; }
.dialog-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 8px; }
.btn-cancel { padding: 9px 24px; background: #fff; color: #4E5969; border: 1px solid #E5E6EB; border-radius: 6px; cursor: pointer; font-size: 14px; }
.btn-cancel:hover { background: #F5F5F5; }
.btn-submit { padding: 9px 28px; background: #165DFF; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; }
.btn-submit:hover { background: #4080FF; }
</style>
