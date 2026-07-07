<template>
  <div class="earnings-page">
    <div class="page-header">
      <h2>我的收益</h2>
    </div>

    <div class="balance-section">
      <div class="balance-card available">
        <div class="balance-info">
          <div class="balance-label">可提现金额</div>
          <div class="balance-amount">¥{{ totalAvailable.toFixed(2) }}</div>
        </div>
      </div>
      <div class="balance-card frozen">
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
        @click="handleWithdrawClick"
      >
        立即提现
      </button>
      <div class="commission-rule-link" @click="showCommissionModal = true">
        平台阶梯式佣金收费细则？
      </div>
    </div>

    <div class="tabs-section">
      <div class="tabs">
        <button :class="['tab', { active: activeTab === 'earnings' }]" @click="activeTab = 'earnings'">收益明细</button>
        <button :class="['tab', { active: activeTab === 'records' }]" @click="activeTab = 'records'">提现记录</button>
      </div>

      <div v-if="activeTab === 'earnings'" class="table-container">
        <table class="data-table">
          <thead>
            <tr><th>订单号</th><th>金额</th><th>状态</th><th>下单时间</th><th>预计到账时间</th></tr>
          </thead>
          <tbody>
            <tr v-for="item in earningsList" :key="item.earningsId">
              <td>{{ item.orderSn }}</td>
              <td>¥{{ (Number(item.amount) || 0).toFixed(2) }}</td>
              <td><span :class="['status-tag', getStatusClass(item.status)]">{{ item.statusText }}</span></td>
              <td>{{ item.orderTime }}</td>
              <td>{{ item.expectedTime || '-' }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="earningsList.length === 0" class="empty-state">
          <div class="empty-text">暂无收益记录</div>
        </div>
      </div>

      <div v-if="activeTab === 'records'" class="table-container">
        <table class="data-table">
          <thead>
            <tr><th>提现金额</th><th>银行卡号</th><th>开户姓名</th><th>开户银行</th><th>状态</th><th>申请时间</th><th>处理时间</th></tr>
          </thead>
          <tbody>
            <tr v-for="record in withdrawRecords" :key="record.withdrawalId">
              <td>¥{{ (Number(record.amount) || 0).toFixed(2) }}</td>
              <td>{{ record.bankCardNumber }}</td>
              <td>{{ record.accountName }}</td>
              <td>{{ record.bankName }}</td>
              <td><span :class="['status-tag', getRecordStatusClass(record.status)]">{{ record.statusText }}</span></td>
              <td>{{ record.applyTime }}</td>
              <td>{{ record.processTime || '-' }}</td>
            </tr>
          </tbody>
        </table>
        <div v-if="withdrawRecords.length === 0" class="empty-state">
          <div class="empty-text">暂无提现记录</div>
        </div>
      </div>
    </div>

    <!-- ========== 银行卡绑定弹窗 ========== -->
    <div v-if="showBankCardModal" class="modal-mask" @click.self="showBankCardModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ bankCardData.id ? '修改银行卡信息' : '绑定银行卡' }}</h3>
          <button class="close-btn" @click="showBankCardModal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label>开户银行</label>
            <input v-model="bankCardForm.bankName" placeholder="请输入开户银行（如：中国工商银行）" />
          </div>
          <div class="form-item">
            <label>银行卡号</label>
            <input v-model="bankCardForm.bankCardNumber" placeholder="请输入银行卡号" maxlength="19" />
          </div>
          <div class="form-item">
            <label>开户人姓名</label>
            <input v-model="bankCardForm.accountName" placeholder="请输入开户人姓名" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showBankCardModal = false">取消</button>
          <button class="confirm-btn" @click="saveBankCard">保存</button>
        </div>
      </div>
    </div>

    <!-- ========== 提现确认弹窗（已绑卡） ========== -->
    <div v-if="showWithdrawConfirm" class="modal-mask" @click.self="showWithdrawConfirm = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>申请提现</h3>
          <button class="close-btn" @click="showWithdrawConfirm = false">×</button>
        </div>
        <div class="modal-body">
          <div class="withdraw-amount">
            <span class="label">提现金额</span>
            <span class="max-hint">可提现 ¥{{ totalAvailable.toFixed(2) }}</span>
          </div>
          <div class="form-item">
            <input v-model.number="withdrawAmount" type="number" placeholder="请输入提现金额" class="amount-input" :max="totalAvailable" />
            <div class="quick-amounts">
              <button v-for="pct in [25, 50, 75, 100]" :key="pct" :class="['quick-btn', { active: withdrawAmount === (totalAvailable * pct / 100) }]" @click="withdrawAmount = totalAvailable * pct / 100">{{ pct }}%</button>
            </div>
          </div>
          <div class="card-info-box">
            <div class="card-info-label">汇款银行卡</div>
            <div class="card-info-detail">
              <div>{{ bankCardData.bankName }}</div>
              <div class="card-no">{{ bankCardData.maskedCardNumber }}</div>
              <div>{{ bankCardData.accountName }}</div>
            </div>
          </div>
          <div class="confirm-actions">
            <button class="btn-link-action" @click="openModifyCard">修改银行卡信息</button>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showWithdrawConfirm = false">取消</button>
          <button class="confirm-btn" :disabled="withdrawAmount <= 0 || withdrawAmount > totalAvailable" @click="openVerifyCode">确认汇款</button>
        </div>
      </div>
    </div>

    <!-- ========== 验证码弹窗 ========== -->
    <div v-if="showVerifyModal" class="modal-mask" @click.self="showVerifyModal = false">
      <div class="modal-content modal-sm">
        <div class="modal-header">
          <h3>短信验证</h3>
          <button class="close-btn" @click="showVerifyModal = false">×</button>
        </div>
        <div class="modal-body">
          <p class="verify-tip">验证码已发送到您的手机，请输入6位数字验证码（模拟：任意6位数字均可）</p>
          <div class="form-item">
            <input v-model="verifyCode" placeholder="请输入6位验证码" maxlength="6" class="code-input" @input="onVerifyCodeInput" />
          </div>
          <div class="code-actions">
            <span v-if="codeCountdown > 0" class="countdown">{{ codeCountdown }}秒后重新发送</span>
            <button v-else class="btn-link-action" @click="sendVerifyCode">重新发送</button>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showVerifyModal = false">取消</button>
          <button class="confirm-btn" :disabled="verifyCode.length !== 6" @click="confirmWithdraw">确认提现</button>
        </div>
      </div>
    </div>

    <!-- ========== 佣金收费细则弹窗 ========== -->
    <div v-if="showCommissionModal" class="modal-mask" @click.self="showCommissionModal = false">
      <div class="commission-modal-content">
        <div class="modal-header">
          <h3>平台阶梯式佣金收费细则（V1.0）</h3>
          <button class="close-btn" @click="showCommissionModal = false">×</button>
        </div>
        <div class="commission-modal-body">
          <div class="rule-section">
            <h4>一、收费构成说明</h4>
            <p>平台收费由 <b>基础技术服务费 + 类目差异化费率</b> 两部分构成。最终佣金 = 商品实付金额（不含运费）× 类目佣金率。单笔订单佣金设有封顶值，超出部分不再收取。</p>
          </div>
          <div class="rule-section">
            <h4>二、阶梯收费标准（按店铺月销售额）</h4>
            <table class="commission-table">
              <thead><tr><th>月销售额区间（元）</th><th>标准佣金率</th><th>单笔订单封顶（元）</th></tr></thead>
              <tbody>
                <tr><td>0 ~ 10,000（试运营期）</td><td>1.0%</td><td>20</td></tr>
                <tr><td>10,001 ~ 50,000（成长期）</td><td>2.5%</td><td>50</td></tr>
                <tr><td>50,001 ~ 200,000（成熟期）</td><td>4.0%</td><td>80</td></tr>
                <tr><td>200,001 以上（头部商家）</td><td>5.0%</td><td>100</td></tr>
              </tbody>
            </table>
          </div>
          <div class="rule-section">
            <h4>三、类目差异化调整系数</h4>
            <p>在阶梯费率基础上，乘以类目系数（四舍五入保留两位小数）：</p>
            <table class="commission-table">
              <thead><tr><th>类目</th><th>调整系数</th></tr></thead>
              <tbody>
                <tr><td>家居百货日用品、厨具餐具厨房配件</td><td>1.0</td></tr>
                <tr><td>食品饮料滋补</td><td>0.7</td></tr>
                <tr><td>个护美妆清洁、母婴孕童用品</td><td>1.2</td></tr>
                <tr><td>生鲜果蔬肉禽</td><td>0.4</td></tr>
              </tbody>
            </table>
            <p class="formula">计算公式：实际佣金率 = 阶梯基准费率 × 类目调整系数</p>
          </div>
          <div class="rule-section">
            <h4>四、特殊场景规则</h4>
            <p><b>支付通道费：</b>所有订单另收 0.6% 支付手续费（由第三方支付机构收取，平台代扣，不计入平台收入）。</p>
            <p><b>促销订单：</b>使用平台官方大促券（如"满200减30"）产生的订单，佣金按优惠后实付金额计算，且该部分订单的佣金率按原档位的8折执行；使用店铺券的订单，佣金按券后实付金额计算（即原价 - 店铺券面额），佣金率按原档位正常执行，不打折。</p>
            <p><b>支付优先级：</b>订单结算时先计算店铺优惠卷，再计算平台优惠卷。大促满减卷与固定金额卷可同时使用（先满减、后固定金额）。订单使用优惠卷后最低需支付0.01元。</p>
            <p><b>平台固定金额卷贴补：</b>用户使用平台固定金额卷支付时，卷成本由平台承担。商家佣金按优惠后实付金额计算，订单直接收入为优惠后实付金额，平台额外贴补该卷金额。若一张卷支付多个商家商品，则按各商家商品金额比例分配贴补。</p>
            <p><b>退款订单：</b>全额退款退还已收佣金；部分退款按剩余实付金额重新计算佣金，差额退回。</p>
            <p><b>月销售额达标回溯：</b>当月实际销售额达到更高阶梯时，当月所有订单按新阶梯统一补差结算（而非仅增量部分）。</p>
          </div>
          <div class="rule-section">
            <h4>五、违规与争议处理</h4>
            <p>商家若存在刷单、虚假交易等行为，当月佣金率直接按最高档（5%）封顶执行，且不予退还。</p>
            <p>佣金争议申诉期为账单生成后 7个工作日，超时视为认可。</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import request from '@/utils/request'
import { getEarningsInfo, getEarningsList, getWithdrawRecords } from '@/api/order'

const activeTab = ref('earnings')
const showCommissionModal = ref(false)

const totalAvailable = ref(0)
const totalFrozen = ref(0)

const earningsList = ref<any[]>([])
const withdrawRecords = ref<any[]>([])

// 银行卡
const showBankCardModal = ref(false)
const bankCardData = reactive<any>({ id: null, bankName: '', bankCardNumber: '', accountName: '', maskedCardNumber: '' })
const bankCardForm = reactive({ bankName: '', bankCardNumber: '', accountName: '' })

// 提现确认
const showWithdrawConfirm = ref(false)
const withdrawAmount = ref(0)

// 验证码
const showVerifyModal = ref(false)
const verifyCode = ref('')
const codeCountdown = ref(0)

const getStatusClass = (status: number) => {
  if (status === 0) return 'frozen'
  if (status === 1) return 'available'
  if (status === 2) return 'withdrawn'
  return ''
}

const getRecordStatusClass = (status: number) => {
  if (status === 0) return 'processing'
  if (status === 1 || status === 2) return 'success'
  return 'failed'
}

// ========== 银行卡 ==========
const loadBankCard = async () => {
  try {
    const res = await request.get('/merchant/bank-card')
    if (res.code === 0 && res.data) {
      Object.assign(bankCardData, res.data)
    } else {
      Object.assign(bankCardData, { id: null, bankName: '', bankCardNumber: '', accountName: '', maskedCardNumber: '' })
    }
  } catch { /* */ }
}

const saveBankCard = async () => {
  if (!bankCardForm.bankName || !bankCardForm.bankCardNumber || !bankCardForm.accountName) {
    alert('请填写完整的银行卡信息')
    return
  }
  if (!/^\d{16,19}$/.test(bankCardForm.bankCardNumber)) {
    alert('请输入正确的银行卡号')
    return
  }
  try {
    const res = await request.post('/merchant/bank-card', {
      bankName: bankCardForm.bankName,
      bankCardNumber: bankCardForm.bankCardNumber,
      accountName: bankCardForm.accountName
    })
    if (res.code === 0) {
      alert('银行卡保存成功')
      showBankCardModal.value = false
      loadBankCard()
    } else {
      alert(res.msg || '保存失败')
    }
  } catch { alert('保存失败') }
}

const openModifyCard = () => {
  showWithdrawConfirm.value = false
  bankCardForm.bankName = bankCardData.bankName || ''
  bankCardForm.bankCardNumber = bankCardData.bankCardNumber || ''
  bankCardForm.accountName = bankCardData.accountName || ''
  showBankCardModal.value = true
}

// ========== 提现流程 ==========
const handleWithdrawClick = async () => {
  if (totalAvailable.value <= 0) return
  await loadBankCard()
  if (!bankCardData.id) {
    // 未绑定银行卡 -> 弹出绑定弹窗
    bankCardForm.bankName = ''
    bankCardForm.bankCardNumber = ''
    bankCardForm.accountName = ''
    showBankCardModal.value = true
  } else {
    // 已绑定 -> 弹出确认弹窗
    withdrawAmount.value = 0
    showWithdrawConfirm.value = true
  }
}

const openVerifyCode = () => {
  showWithdrawConfirm.value = false
  verifyCode.value = ''
  showVerifyModal.value = true
  sendVerifyCode()
}

const sendVerifyCode = async () => {
  try {
    const res = await request.post('/merchant/sms/send-verify-code')
    if (res.code === 0) {
      codeCountdown.value = 60
      const timer = setInterval(() => {
        codeCountdown.value--
        if (codeCountdown.value <= 0) clearInterval(timer)
      }, 1000)
    }
  } catch { /* */ }
}

const onVerifyCodeInput = () => {
  verifyCode.value = verifyCode.value.replace(/\D/g, '')
}

const confirmWithdraw = async () => {
  if (verifyCode.value.length !== 6) {
    alert('请输入6位验证码')
    return
  }
  try {
    const amount = totalAvailable.value
    // 从后端最新获取银行卡信息
    await loadBankCard()
    const res = await request.post('/merchant/earnings/withdraw', {
      amount: withdrawAmount.value,
      bankCardNumber: bankCardData.bankCardNumber,
      accountName: bankCardData.accountName,
      bankName: bankCardData.bankName,
      verifyCode: verifyCode.value
    })
    if (res.code === 0) {
      alert('提现申请已提交，资金将在1-3个工作日内到账')
      showVerifyModal.value = false
      loadEarningsInfo()
      loadWithdrawRecords()
    } else {
      alert(res.msg || '提现失败')
    }
  } catch (e: any) {
    alert(e?.response?.data?.msg || '提现失败')
  }
}

// ========== 收益信息 & 列表 ==========
const loadEarningsInfo = async () => {
  try {
    const res = await getEarningsInfo()
    if (res.code === 0) {
      const data = res.data
      totalAvailable.value = Number(data.availableAmount) || 0
      totalFrozen.value = Number(data.pendingAmount) || 0
    }
  } catch { /* */ }
}

const loadEarningsList = async () => {
  try {
    const res = await getEarningsList({ page: 1, pageSize: 100 })
    if (res.code === 0) {
      const data = res.data
      earningsList.value = data.list || data || []
    }
  } catch { /* */ }
}

const loadWithdrawRecords = async () => {
  try {
    const res = await getWithdrawRecords({ page: 1, pageSize: 20 })
    if (res.code === 0) {
      withdrawRecords.value = res.data.list || res.data || []
    }
  } catch { /* */ }
}

onMounted(() => {
  loadEarningsInfo()
  loadEarningsList()
  loadWithdrawRecords()
  loadBankCard()
})
</script>

<style scoped>
.earnings-page { padding: 20px; }
.page-header { margin-bottom: 20px; }
.page-header h2 { font-size: 20px; color: #1D2129; }
.balance-section { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 20px; }
.balance-card { background: white; padding: 24px; border-radius: 12px; display: flex; align-items: center; gap: 16px; }
.balance-card.available { background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%); color: white; }
.balance-card.frozen { background: white; border: 1px solid #E2E8F0; }
.balance-icon { font-size: 36px; }
.balance-info { flex: 1; }
.balance-label { font-size: 13px; opacity: 0.8; margin-bottom: 4px; }
.balance-card.frozen .balance-label { color: #86909C; }
.balance-amount { font-size: 28px; font-weight: bold; }
.balance-card.frozen .balance-amount { color: #1D2129; }
.balance-tip { font-size: 11px; color: #86909C; margin-top: 4px; }
.action-section { margin-bottom: 24px; }
.withdraw-btn { width: 100%; padding: 16px; background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; }
.withdraw-btn:hover:not(.disabled) { opacity: 0.9; }
.withdraw-btn.disabled { background: #E2E8F0; cursor: not-allowed; color: #86909C; }
.commission-rule-link { text-align: center; margin-top: 12px; font-size: 13px; color: #165DFF; cursor: pointer; user-select: none; }
.commission-rule-link:hover { text-decoration: underline; }
.tabs-section { background: white; border-radius: 8px; overflow: hidden; }
.tabs { display: flex; border-bottom: 1px solid #E2E8F0; }
.tab { flex: 1; padding: 14px; background: none; border: none; font-size: 14px; color: #86909C; cursor: pointer; border-bottom: 2px solid transparent; }
.tab.active { color: #165DFF; border-bottom-color: #165DFF; }
.table-container { padding: 16px; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { padding: 12px; text-align: left; border-bottom: 1px solid #F2F3F5; font-size: 13px; }
.data-table th { background: #EAEBED; color: #4E5969; font-weight: 600; font-size: 15px; }
.data-table td { color: #1D2129; }
.status-tag { font-size: 11px; padding: 2px 8px; border-radius: 4px; }
.status-tag.frozen { background: #FFF7E6; color: #FA8C16; }
.status-tag.available { background: #F6FFED; color: #52C41A; }
.status-tag.withdrawn { background: #F2F3F5; color: #86909C; }
.status-tag.processing { background: #E6F7FF; color: #1890FF; }
.status-tag.success { background: #F6FFED; color: #52C41A; }
.status-tag.failed { background: #FFF2F0; color: #FF4D4F; }
.empty-state { text-align: center; padding: 40px; }
.empty-icon { font-size: 48px; margin-bottom: 12px; }
.empty-text { font-size: 14px; color: #86909C; }

/* Modal */
.modal-mask { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-content { width: 420px; background: white; border-radius: 8px; overflow: hidden; }
.modal-sm { width: 380px; }
.modal-header { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-bottom: 1px solid #f0f0f0; }
.modal-header h3 { font-size: 16px; color: #1D2129; margin: 0; }
.close-btn { font-size: 20px; background: none; border: none; cursor: pointer; color: #86909C; }
.modal-body { padding: 20px; }
.modal-footer { display: flex; justify-content: flex-end; gap: 10px; padding: 16px 20px; border-top: 1px solid #f0f0f0; }

.cancel-btn { padding: 8px 16px; background: #F2F3F5; color: #4E5969; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
.confirm-btn { padding: 8px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
.confirm-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.form-item { margin-bottom: 14px; }
.form-item label { display: block; margin-bottom: 6px; font-size: 13px; color: #4E5969; font-weight: 500; }
.form-item input { width: 100%; box-sizing: border-box; padding: 8px 10px; border: 1px solid #dcdcdc; border-radius: 4px; font-size: 13px; }

.withdraw-amount { display: flex; justify-content: space-between; align-items: center; padding: 16px; background: #F7F8FA; border-radius: 8px; margin-bottom: 16px; }
.withdraw-amount .label { font-size: 14px; color: #4E5969; }
.max-hint { font-size: 13px; color: #165DFF; font-weight: 500; }
.amount-input { width: 100%; box-sizing: border-box; padding: 10px 14px; border: 2px solid #165DFF; border-radius: 6px; font-size: 20px; text-align: center; color: #1D2129; outline: none; }
.amount-input:focus { border-color: #4080FF; }
.quick-amounts { display: flex; gap: 8px; margin-top: 10px; }
.quick-btn { flex: 1; padding: 6px 0; border: 1px solid #dcdcdc; border-radius: 4px; background: #fff; font-size: 12px; color: #4E5969; cursor: pointer; }
.quick-btn:hover { border-color: #165DFF; color: #165DFF; }
.quick-btn.active { background: #165DFF; color: #fff; border-color: #165DFF; }

.card-info-box { padding: 14px 16px; background: #F7F8FA; border-radius: 8px; margin-bottom: 12px; }
.card-info-label { font-size: 13px; color: #86909C; margin-bottom: 6px; }
.card-info-detail { font-size: 14px; color: #1D2129; }
.card-no { font-family: monospace; font-size: 16px; letter-spacing: 1px; margin: 4px 0; }

.confirm-actions { text-align: right; }
.btn-link-action { background: none; border: none; color: #165DFF; cursor: pointer; font-size: 13px; }
.btn-link-action:hover { text-decoration: underline; }

.verify-tip { font-size: 13px; color: #4E5969; margin-bottom: 16px; text-align: center; }
.code-input { font-size: 24px !important; text-align: center; letter-spacing: 8px !important; padding: 12px !important; }
.code-actions { text-align: center; margin-top: 10px; }
.countdown { font-size: 12px; color: #86909C; }

/* Commission modal */
.commission-modal-content { width: 640px; max-height: 80vh; background: white; border-radius: 8px; overflow: hidden; display: flex; flex-direction: column; }
.commission-modal-body { padding: 20px 24px; overflow-y: auto; font-size: 13px; color: #333; line-height: 1.8; }
.rule-section { margin-bottom: 16px; }
.rule-section h4 { font-size: 14px; color: #1D2129; margin: 0 0 8px 0; padding-bottom: 4px; border-bottom: 1px solid #f0f0f0; }
.rule-section p { margin: 4px 0; }
.rule-section .formula { margin-top: 8px; padding: 8px 12px; background: #F7F8FA; border-radius: 4px; font-weight: 600; color: #165DFF; }
.commission-table { width: 100%; border-collapse: collapse; margin: 8px 0; font-size: 12px; }
.commission-table th, .commission-table td { padding: 8px 10px; border: 1px solid #E2E8F0; text-align: left; }
.commission-table th { background: #EAEBED; font-weight: 600; color: #4E5969; font-size: 14px; }
.commission-table td { color: #1D2129; }
</style>
