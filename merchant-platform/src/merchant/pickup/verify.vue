<template>
  <div class="pickup-verify">
    <h2>门店核销</h2>
    <div class="verify-form">
      <input v-model="pickupCode" placeholder="请输入自提核销码" />
      <button @click="handleVerify">核销</button>
    </div>

    <div v-if="result" class="result-box">
      <h3>核销成功</h3>
      <p><span>订单编号：</span>{{ result.orderSn }}</p>
      <p><span>订单ID：</span>{{ result.orderId }}</p>
      <p><span>商品：</span>{{ result.productTitle }}</p>
      <p><span>规格：</span>{{ result.specs }}</p>
      <p><span>数量：</span>{{ result.quantity }}</p>
      <p><span>收货人：</span>{{ result.receiverName }}</p>
      <p><span>联系方式：</span>{{ result.receiverPhone }}</p>
      <p><span>核销时间：</span>{{ result.verifyTime }}</p>
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
}
h2 {
  margin-bottom: 20px;
  color: #1D2129;
}
.verify-form {
  display: flex;
  gap: 10px;
  margin-bottom: 24px;
}
.verify-form input {
  flex: 1;
  max-width: 400px;
  padding: 10px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
button {
  padding: 10px 24px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.result-box {
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: 6px;
  padding: 20px;
  max-width: 500px;
}
.result-box h3 {
  color: #166534;
  margin-bottom: 12px;
}
.result-box p {
  margin: 6px 0;
  color: #4E5969;
}
.result-box p span {
  color: #1D2129;
  font-weight: 500;
}
</style>
