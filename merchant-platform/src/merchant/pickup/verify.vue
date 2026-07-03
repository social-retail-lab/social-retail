<template>
  <div class="pickup-verify">
    <div class="verify-card">
      <div class="verify-icon">📱</div>
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
        <div class="result-icon">✅</div>
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
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { pickupVerify } from '@/api/order'

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
</script>

<style scoped>
.pickup-verify {
  padding: 24px;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  min-height: 100%;
  padding-top: 80px;
}

.verify-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
  padding: 48px 56px;
  text-align: center;
  max-width: 560px;
  width: 100%;
}

.verify-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

h2 {
  font-size: 24px;
  color: #1D2129;
  margin: 0 0 12px;
}

.verify-desc {
  font-size: 14px;
  color: #86909C;
  margin: 0 0 32px;
}

.code-input-wrapper {
  display: flex;
  gap: 12px;
  margin-bottom: 32px;
}

.code-input {
  flex: 1;
  padding: 14px 16px;
  font-size: 18px;
  border: 2px solid #E5E6EB;
  border-radius: 8px;
  outline: none;
  letter-spacing: 2px;
  text-align: center;
  transition: border-color 0.2s;
}

.code-input:focus {
  border-color: #165DFF;
}

.code-input::placeholder {
  font-size: 14px;
  letter-spacing: 0;
  color: #C9CDD4;
}

.verify-btn {
  padding: 14px 40px;
  font-size: 18px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  white-space: nowrap;
  transition: background 0.2s;
}

.verify-btn:hover {
  background: #4080FF;
}

.result-box {
  background: #F0FDF4;
  border: 1px solid #BBF7D0;
  border-radius: 10px;
  padding: 28px;
}

.result-icon {
  font-size: 40px;
  margin-bottom: 8px;
}

.result-box h3 {
  font-size: 18px;
  color: #166534;
  margin: 0 0 20px;
}

.result-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  text-align: left;
}

.result-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  background: rgba(255, 255, 255, 0.7);
  border-radius: 6px;
  padding: 10px 14px;
}

.r-label {
  font-size: 12px;
  color: #86909C;
}

.r-value {
  font-size: 14px;
  color: #1D2129;
  font-weight: 500;
  word-break: break-all;
}
</style>
