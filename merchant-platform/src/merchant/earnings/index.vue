<template>
  <div class="earnings-page">
    <div class="page-header">
      <h2>我的收益</h2>
    </div>

    <div class="balance-section">
      <div class="balance-card available">
        <div class="balance-icon">💰</div>
        <div class="balance-info">
          <div class="balance-label">可提现金额</div>
          <div class="balance-amount">¥{{ totalAvailable.toFixed(2) }}</div>
        </div>
      </div>
      <div class="balance-card frozen">
        <div class="balance-icon">⏳</div>
        <div class="balance-info">
          <div class="balance-label">待确认收货</div>
          <div class="balance-amount">¥{{ totalFrozen.toFixed(2) }}</div>
          <div class="balance-tip">用户已支付，待确认收货后可提现</div>
        </div>
      </div>
    </div>

    <div class="action-section">
      <button 
        :disabled="totalAvailable <= 0" 
        :class="['withdraw-btn', { disabled: totalAvailable <= 0 }]"
        @click="showWithdrawModal = true"
      >
        💸 立即提现
      </button>
    </div>

    <div class="tabs-section">
      <div class="tabs">
        <button 
          :class="['tab', { active: activeTab === 'earnings' }]" 
          @click="activeTab = 'earnings'"
        >
          收益明细
        </button>
        <button 
          :class="['tab', { active: activeTab === 'records' }]" 
          @click="activeTab = 'records'"
        >
          提现记录
        </button>
      </div>

      <div v-if="activeTab === 'earnings'" class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>订单号</th>
              <th>金额</th>
              <th>状态</th>
              <th>下单时间</th>
              <th>预计到账时间</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in earningsList" :key="item.earningsId">
              <td>{{ item.orderSn }}</td>
              <td>¥{{ item.amount.toFixed(2) }}</td>
              <td>
                <span :class="['status-tag', getStatusClass(item.status)]">
                  {{ item.statusText }}
                </span>
              </td>
              <td>{{ item.orderTime }}</td>
              <td>{{ item.expectedTime || '-' }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="earningsList.length === 0" class="empty-state">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无收益记录</div>
        </div>
      </div>

      <div v-if="activeTab === 'records'" class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>提现金额</th>
              <th>银行卡号</th>
              <th>开户姓名</th>
              <th>开户银行</th>
              <th>状态</th>
              <th>申请时间</th>
              <th>处理时间</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="record in withdrawRecords" :key="record.withdrawalId">
              <td>¥{{ record.amount.toFixed(2) }}</td>
              <td>{{ record.bankCardNumber }}</td>
              <td>{{ record.accountName }}</td>
              <td>{{ record.bankName }}</td>
              <td>
                <span :class="['status-tag', getRecordStatusClass(record.status)]">
                  {{ record.statusText }}
                </span>
              </td>
              <td>{{ record.applyTime }}</td>
              <td>{{ record.processTime || '-' }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="withdrawRecords.length === 0" class="empty-state">
          <div class="empty-icon">📭</div>
          <div class="empty-text">暂无提现记录</div>
        </div>
      </div>
    </div>

    <div v-if="showWithdrawModal" class="modal-mask" @click.self="showWithdrawModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>申请提现</h3>
          <button class="close-btn" @click="showWithdrawModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="withdraw-amount">
            <span class="label">提现金额</span>
            <span class="amount">¥{{ totalAvailable.toFixed(2) }}</span>
          </div>
          <div class="form-item">
            <label>开户银行</label>
            <input v-model="withdrawForm.bankName" placeholder="请输入开户银行" />
          </div>
          <div class="form-item">
            <label>银行卡号</label>
            <input v-model="withdrawForm.bankCardNumber" placeholder="请输入银行卡号" />
          </div>
          <div class="form-item">
            <label>开户姓名</label>
            <input v-model="withdrawForm.accountName" placeholder="请输入开户姓名" />
          </div>
          <div class="withdraw-tip">
            ⚠️ 提现申请提交后，资金将在1-3个工作日内到账
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showWithdrawModal = false">取消</button>
          <button class="confirm-btn" @click="submitWithdraw">确认提现</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getEarningsInfo, getEarningsList, applyWithdraw, getWithdrawRecords } from '@/api/order'

const activeTab = ref('earnings')
const showWithdrawModal = ref(false)

const totalAvailable = ref(0)
const totalFrozen = ref(0)

const earningsList = ref<any[]>([])
const withdrawRecords = ref<any[]>([])

const withdrawForm = reactive({
  bankName: '',
  bankCardNumber: '',
  accountName: ''
})

const getStatusClass = (status: number) => {
  if (status === 0) return 'frozen'
  if (status === 1) return 'available'
  if (status === 2) return 'withdrawn'
  return ''
}

const getRecordStatusClass = (status: number) => {
  if (status === 0) return 'processing'
  if (status === 1) return 'success'
  if (status === 2) return 'success'
  if (status === 3) return 'failed'
  return ''
}

const loadEarningsInfo = async () => {
  const res = await getEarningsInfo()
  if (res.code === 0) {
    const data = res.data
    totalAvailable.value = data.availableAmount || 0
    totalFrozen.value = data.pendingAmount || 0
  }
}

const loadEarningsList = async () => {
  const res = await getEarningsList({ page: 1, pageSize: 20 })
  if (res.code === 0) {
    earningsList.value = res.data.list || res.data || []
  }
}

const loadWithdrawRecords = async () => {
  const res = await getWithdrawRecords({ page: 1, pageSize: 20 })
  if (res.code === 0) {
    withdrawRecords.value = res.data.list || res.data || []
  }
}

const submitWithdraw = async () => {
  if (!withdrawForm.bankName || !withdrawForm.bankCardNumber || !withdrawForm.accountName) {
    alert('请填写完整的银行卡信息')
    return
  }
  if (!/^\d{16,19}$/.test(withdrawForm.bankCardNumber)) {
    alert('请输入正确的银行卡号')
    return
  }
  const res = await applyWithdraw({
    amount: totalAvailable.value,
    bankName: withdrawForm.bankName,
    bankCardNumber: withdrawForm.bankCardNumber,
    accountName: withdrawForm.accountName
  })
  if (res.code === 0) {
    alert('提现申请已提交，资金将在1-3个工作日内到账')
    loadEarningsInfo()
    loadWithdrawRecords()
    showWithdrawModal.value = false
    withdrawForm.bankName = ''
    withdrawForm.bankCardNumber = ''
    withdrawForm.accountName = ''
  }
}

onMounted(() => {
  loadEarningsInfo()
  loadEarningsList()
  loadWithdrawRecords()
})
</script>

<style scoped>
.earnings-page {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h2 {
  font-size: 20px;
  color: #1D2129;
}

.balance-section {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.balance-card {
  background: white;
  padding: 24px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.balance-card.available {
  background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
  color: white;
}

.balance-card.frozen {
  background: white;
  border: 1px solid #E2E8F0;
}

.balance-icon {
  font-size: 36px;
}

.balance-info {
  flex: 1;
}

.balance-label {
  font-size: 13px;
  opacity: 0.8;
  margin-bottom: 4px;
}

.balance-card.frozen .balance-label {
  color: #86909C;
}

.balance-amount {
  font-size: 28px;
  font-weight: bold;
}

.balance-card.frozen .balance-amount {
  color: #1D2129;
}

.balance-tip {
  font-size: 11px;
  color: #86909C;
  margin-top: 4px;
}

.action-section {
  margin-bottom: 24px;
}

.withdraw-btn {
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.withdraw-btn:hover:not(.disabled) {
  opacity: 0.9;
}

.withdraw-btn.disabled {
  background: #E2E8F0;
  cursor: not-allowed;
  color: #86909C;
}

.tabs-section {
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.tabs {
  display: flex;
  border-bottom: 1px solid #E2E8F0;
}

.tab {
  flex: 1;
  padding: 14px;
  background: none;
  border: none;
  font-size: 14px;
  color: #86909C;
  cursor: pointer;
  border-bottom: 2px solid transparent;
}

.tab.active {
  color: #165DFF;
  border-bottom-color: #165DFF;
}

.table-container {
  padding: 16px;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th, .data-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #F2F3F5;
  font-size: 13px;
}

.data-table th {
  background: #F7F8FA;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  color: #1D2129;
}

.status-tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.frozen {
  background: #FFF7E6;
  color: #FA8C16;
}

.status-tag.available {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.withdrawn {
  background: #F2F3F5;
  color: #86909C;
}

.status-tag.processing {
  background: #E6F7FF;
  color: #1890FF;
}

.status-tag.success {
  background: #F6FFED;
  color: #52C41A;
}

.status-tag.failed {
  background: #FFF2F0;
  color: #FF4D4F;
}

.empty-state {
  text-align: center;
  padding: 40px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-text {
  font-size: 14px;
  color: #86909C;
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  width: 420px;
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
}

.modal-header h3 {
  font-size: 16px;
  color: #1D2129;
  margin: 0;
}

.close-btn {
  font-size: 20px;
  background: none;
  border: none;
  cursor: pointer;
  color: #86909C;
}

.modal-body {
  padding: 20px;
}

.withdraw-amount {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: #F7F8FA;
  border-radius: 8px;
  margin-bottom: 20px;
}

.withdraw-amount .label {
  font-size: 14px;
  color: #4E5969;
}

.withdraw-amount .amount {
  font-size: 24px;
  font-weight: bold;
  color: #FF4D4F;
}

.form-item {
  margin-bottom: 16px;
}

.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #4E5969;
}

.form-item input {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.withdraw-tip {
  font-size: 12px;
  color: #FA8C16;
  padding: 10px;
  background: #FFF7E6;
  border-radius: 4px;
  margin-top: 8px;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 20px;
  border-top: 1px solid #f0f0f0;
}

.cancel-btn {
  padding: 8px 16px;
  background: #F2F3F5;
  color: #4E5969;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.confirm-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>