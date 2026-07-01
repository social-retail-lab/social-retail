<template>
  <div class="store-info-page">
    <div class="info-card">
      <h2>商家信息</h2>
      <div class="info-grid">
        <div class="info-logo">
          <img v-if="merchantInfo.logo" :src="merchantInfo.logo" alt="商家Logo" />
          <div v-else class="logo-placeholder">🏪</div>
        </div>
        <div class="info-fields">
          <div class="info-row">
            <span class="info-label">店铺名称</span>
            <span class="info-value">{{ merchantInfo.merchantName || merchantInfo.name || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">联系人</span>
            <span class="info-value">{{ merchantInfo.contactName || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">联系电话</span>
            <span class="info-value">{{ merchantInfo.contactPhone || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">店铺地址</span>
            <span class="info-value">{{ merchantInfo.shopAddress || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">营业时间</span>
            <span class="info-value">{{ merchantInfo.businessHours || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">店铺介绍</span>
            <span class="info-value">{{ merchantInfo.introduction || '-' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">经营状态</span>
            <span class="info-value">
              <el-tag :type="statusType" size="small">{{ statusLabel }}</el-tag>
            </span>
          </div>
        </div>
      </div>
    </div>

    <div class="action-bar">
      <el-button type="primary" @click="openEditDialog">修改信息</el-button>
      <el-button
        v-if="merchantInfo.applyType === 1"
        type="warning"
        @click="openUpgradeDialog"
      >
        升级企业资质
      </el-button>
      <el-button
        v-if="toggleVisible"
        :type="merchantInfo.status === 1 ? 'danger' : 'success'"
        @click="handleTogglePause"
        :loading="toggleLoading"
      >
        {{ merchantInfo.status === 1 ? '暂时歇业' : '重新营业' }}
      </el-button>
    </div>

    <!-- 修改信息对话框 -->
    <el-dialog v-model="editDialogVisible" title="修改商家信息" width="520px" destroy-on-close>
      <el-form ref="editFormRef" :model="editForm" :rules="editRules" label-width="90px">
        <el-form-item label="店铺名称" prop="merchantName">
          <el-input v-model="editForm.merchantName" placeholder="请输入店铺名称" maxlength="50" />
        </el-form-item>
        <el-form-item label="联系人" prop="contactName">
          <el-input v-model="editForm.contactName" placeholder="请输入联系人姓名" maxlength="20" />
        </el-form-item>
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input v-model="editForm.contactPhone" placeholder="请输入联系电话" maxlength="11" />
        </el-form-item>
        <el-form-item label="店铺地址" prop="shopAddress">
          <el-input v-model="editForm.shopAddress" placeholder="请输入店铺地址" maxlength="100" />
        </el-form-item>
        <el-form-item label="营业时间" prop="businessHours">
          <el-input v-model="editForm.businessHours" placeholder="如：09:00-22:00" maxlength="30" />
        </el-form-item>
        <el-form-item label="店铺介绍" prop="introduction">
          <el-input
            v-model="editForm.introduction"
            type="textarea"
            :rows="4"
            placeholder="请输入店铺介绍"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="editLoading" @click="handleEditSubmit">提交</el-button>
      </template>
    </el-dialog>

    <!-- 升级企业资质对话框 -->
    <el-dialog v-model="upgradeDialogVisible" title="升级企业资质" width="520px" destroy-on-close>
      <el-form ref="upgradeFormRef" :model="upgradeForm" :rules="upgradeRules" label-width="110px">
        <el-form-item label="营业执照" prop="businessLicense">
          <el-upload
            class="upload-wrap"
            :auto-upload="false"
            :limit="1"
            :on-change="handleLicenseChange"
            :on-remove="handleLicenseRemove"
            accept="image/*,.pdf"
            list-type="picture"
          >
            <el-button type="primary" size="small">选择文件</el-button>
            <template #tip>
              <div class="upload-tip">支持 jpg/png/pdf 格式，大小不超过 5MB</div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item label="法人身份证正面" prop="idCardFront">
          <el-upload
            class="upload-wrap"
            :auto-upload="false"
            :limit="1"
            :on-change="handleIdCardFrontChange"
            :on-remove="handleIdCardFrontRemove"
            accept="image/*"
            list-type="picture"
          >
            <el-button type="primary" size="small">选择文件</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item label="法人身份证反面" prop="idCardBack">
          <el-upload
            class="upload-wrap"
            :auto-upload="false"
            :limit="1"
            :on-change="handleIdCardBackChange"
            :on-remove="handleIdCardBackRemove"
            accept="image/*"
            list-type="picture"
          >
            <el-button type="primary" size="small">选择文件</el-button>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="upgradeDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="upgradeLoading" @click="handleUpgradeSubmit">提交</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules, UploadFile } from 'element-plus'
import {
  getMerchantInfo,
  requestInfoChange,
  requestQualificationUpgrade,
  togglePause
} from '@/api/order'

const merchantInfo = ref<any>({})
const editDialogVisible = ref(false)
const upgradeDialogVisible = ref(false)
const editLoading = ref(false)
const upgradeLoading = ref(false)
const toggleLoading = ref(false)
const editFormRef = ref<FormInstance>()
const upgradeFormRef = ref<FormInstance>()

const editForm = reactive({
  merchantName: '',
  contactName: '',
  contactPhone: '',
  shopAddress: '',
  businessHours: '',
  introduction: ''
})

const editRules: FormRules = {
  merchantName: [{ required: true, message: '请输入店铺名称', trigger: 'blur' }],
  contactName: [{ required: true, message: '请输入联系人姓名', trigger: 'blur' }],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  shopAddress: [{ required: true, message: '请输入店铺地址', trigger: 'blur' }],
  businessHours: [{ required: true, message: '请输入营业时间', trigger: 'blur' }]
}

const upgradeForm = reactive({
  businessLicense: null as File | null,
  idCardFront: null as File | null,
  idCardBack: null as File | null
})

const upgradeRules: FormRules = {
  businessLicense: [{ required: true, message: '请上传营业执照', trigger: 'change' }],
  idCardFront: [{ required: true, message: '请上传法人身份证正面', trigger: 'change' }],
  idCardBack: [{ required: true, message: '请上传法人身份证反面', trigger: 'change' }]
}

const statusMap: Record<number, { label: string; type: string }> = {
  1: { label: '营业中', type: 'success' },
  2: { label: '休息中', type: 'warning' },
  3: { label: '暂时歇业', type: 'warning' },
  4: { label: '已关店', type: 'danger' },
  5: { label: '已封禁', type: 'info' }
}

const statusLabel = computed(() => {
  return statusMap[merchantInfo.value.status]?.label || '未知'
})

const statusType = computed(() => {
  return (statusMap[merchantInfo.value.status]?.type || 'info') as any
})

const toggleVisible = computed(() => {
  const s = merchantInfo.value.status
  return s === 1 || s === 5
})

const loadMerchantInfo = async () => {
  try {
    const res = await getMerchantInfo()
    if (res.code === 0) {
      merchantInfo.value = res.data || {}
    }
  } catch {
    // handled by interceptor
  }
}

const openEditDialog = () => {
  editForm.merchantName = merchantInfo.value.merchantName || merchantInfo.value.name || ''
  editForm.contactName = merchantInfo.value.contactName || ''
  editForm.contactPhone = merchantInfo.value.contactPhone || ''
  editForm.shopAddress = merchantInfo.value.shopAddress || ''
  editForm.businessHours = merchantInfo.value.businessHours || ''
  editForm.introduction = merchantInfo.value.introduction || ''
  editDialogVisible.value = true
}

const handleEditSubmit = async () => {
  if (!editFormRef.value) return
  try {
    await editFormRef.value.validate()
  } catch {
    return
  }
  editLoading.value = true
  try {
    const res = await requestInfoChange({ ...editForm })
    if (res.code === 0) {
      ElMessage.success('信息修改申请已提交，请等待审核')
      editDialogVisible.value = false
      loadMerchantInfo()
    }
  } catch {
    // handled by interceptor
  } finally {
    editLoading.value = false
  }
}

const openUpgradeDialog = () => {
  upgradeForm.businessLicense = null
  upgradeForm.idCardFront = null
  upgradeForm.idCardBack = null
  upgradeDialogVisible.value = true
}

const handleLicenseChange = (file: UploadFile) => {
  upgradeForm.businessLicense = file.raw || null
}

const handleLicenseRemove = () => {
  upgradeForm.businessLicense = null
}

const handleIdCardFrontChange = (file: UploadFile) => {
  upgradeForm.idCardFront = file.raw || null
}

const handleIdCardFrontRemove = () => {
  upgradeForm.idCardFront = null
}

const handleIdCardBackChange = (file: UploadFile) => {
  upgradeForm.idCardBack = file.raw || null
}

const handleIdCardBackRemove = () => {
  upgradeForm.idCardBack = null
}

const handleUpgradeSubmit = async () => {
  if (!upgradeFormRef.value) return
  try {
    await upgradeFormRef.value.validate()
  } catch {
    return
  }
  if (!upgradeForm.businessLicense || !upgradeForm.idCardFront || !upgradeForm.idCardBack) {
    ElMessage.warning('请上传完整的资质文件')
    return
  }
  upgradeLoading.value = true
  try {
    const formData = new FormData()
    formData.append('businessLicense', upgradeForm.businessLicense)
    formData.append('idCardFront', upgradeForm.idCardFront)
    formData.append('idCardBack', upgradeForm.idCardBack)
    const res = await requestQualificationUpgrade(formData)
    if (res.code === 0) {
      ElMessage.success('资质升级申请已提交，请等待审核')
      upgradeDialogVisible.value = false
      loadMerchantInfo()
    }
  } catch {
    // handled by interceptor
  } finally {
    upgradeLoading.value = false
  }
}

const handleTogglePause = async () => {
  toggleLoading.value = true
  try {
    const res = await togglePause()
    if (res.code === 0) {
      ElMessage.success(
        merchantInfo.value.status === 1 ? '已申请暂时歇业' : '已申请重新营业'
      )
      loadMerchantInfo()
    }
  } catch {
    // handled by interceptor
  } finally {
    toggleLoading.value = false
  }
}

onMounted(() => {
  loadMerchantInfo()
})
</script>

<style scoped>
.store-info-page {
  padding: 20px;
}

.info-card {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 20px;
}

.info-card h2 {
  font-size: 20px;
  color: #1D2129;
  margin: 0 0 20px 0;
}

.info-grid {
  display: flex;
  gap: 24px;
}

.info-logo {
  flex-shrink: 0;
}

.info-logo img {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  object-fit: cover;
  border: 1px solid #E2E8F0;
}

.logo-placeholder {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  background: #F7F8FA;
  border: 1px solid #E2E8F0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
}

.info-fields {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-row {
  display: flex;
  align-items: flex-start;
  line-height: 1.6;
}

.info-label {
  width: 80px;
  flex-shrink: 0;
  font-size: 14px;
  color: #86909C;
}

.info-value {
  font-size: 14px;
  color: #1D2129;
  word-break: break-all;
}

.action-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.upload-wrap {
  width: 100%;
}

.upload-tip {
  font-size: 12px;
  color: #86909C;
  margin-top: 4px;
}
</style>
