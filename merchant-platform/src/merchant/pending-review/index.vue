<template>
  <div class="pending-wrap">
    <div class="pending-card">
      <div class="icon-circle">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 5h2v6h-2V7zm0 8h2v2h-2v-2z" fill="#FAAD14"/>
        </svg>
      </div>
      <h2>入驻申请审核中</h2>
      <p class="status-text">您的入驻申请已提交，平台正在审核中</p>
      <p class="sub-text">审核通过后即可使用商家后台全部功能，请耐心等待</p>

      <div class="detail-box" v-if="application">
        <div class="detail-row">
          <span class="label">店铺名称</span>
          <span class="value">{{ application.shopName || '-' }}</span>
        </div>
        <div class="detail-row">
          <span class="label">联系人</span>
          <span class="value">{{ application.contactName || '-' }}</span>
        </div>
        <div class="detail-row">
          <span class="label">联系电话</span>
          <span class="value">{{ application.contactPhone || '-' }}</span>
        </div>
        <div class="detail-row">
          <span class="label">提交时间</span>
          <span class="value">{{ application.applyTime || '-' }}</span>
        </div>
        <div class="detail-row">
          <span class="label">审核状态</span>
          <span class="value status-pending">待审核</span>
        </div>
      </div>

      <div class="refresh-btn-row">
        <button class="refresh-btn" :disabled="refreshing" @click="checkStatus">
          {{ refreshing ? '检查中...' : '刷新审核状态' }}
        </button>
      </div>

      <div class="tip">
        <span @click="handleLogout">退出登录</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getApplicationStatus } from '@/api/order'

const router = useRouter()
const application = ref<any>(null)
const refreshing = ref(false)

const loadStatus = async () => {
  try {
    const res = await getApplicationStatus()
    if (res.code === 0 && res.data) {
      if (res.data.auditStatus === 2) {
        router.replace('/onboarding')
        return
      }
      if (res.data.auditStatus === 1) {
        localStorage.setItem('merchantStatus', '2')
        router.replace('/dashboard')
        return
      }
      application.value = res.data
    }
  } catch {
    // ignore
  }
}

const checkStatus = async () => {
  refreshing.value = true
  await loadStatus()
  refreshing.value = false
}

const handleLogout = () => {
  localStorage.removeItem('merchantToken')
  localStorage.removeItem('merchantStatus')
  localStorage.removeItem('merchantInfo')
  router.replace('/login')
}

onMounted(() => {
  loadStatus()
})
</script>

<style scoped>
.pending-wrap {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #F7F7F9;
}
.pending-card {
  width: 420px;
  padding: 40px 36px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  text-align: center;
}
.icon-circle {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  background: #FFFBE6;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
h2 {
  font-size: 20px;
  color: #1D2129;
  margin: 0 0 8px 0;
}
.status-text {
  font-size: 15px;
  color: #4E5969;
  margin: 0 0 4px 0;
}
.sub-text {
  font-size: 13px;
  color: #86909C;
  margin: 0 0 24px 0;
}
.detail-box {
  background: #F7F8FA;
  border-radius: 8px;
  padding: 16px;
  text-align: left;
}
.detail-row {
  display: flex;
  justify-content: space-between;
  padding: 6px 0;
  font-size: 14px;
}
.detail-row .label {
  color: #86909C;
}
.detail-row .value {
  color: #1D2129;
}
.status-pending {
  color: #FAAD14;
  font-weight: 500;
}
.refresh-btn-row {
  margin-top: 20px;
}
.refresh-btn {
  width: 100%;
  padding: 10px;
  background: #0E7490;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}
.refresh-btn:hover {
  opacity: 0.9;
}
.refresh-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
.tip {
  margin-top: 16px;
  text-align: center;
  font-size: 14px;
}
.tip span {
  color: #8C8C8C;
  cursor: pointer;
}
.tip span:hover {
  color: #E66100;
}
</style>
