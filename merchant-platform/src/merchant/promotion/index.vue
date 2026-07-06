<template>
  <div class="promotion-page">
    <!-- ==================== Tab 切换 ==================== -->
    <div class="tab-bar">
      <button :class="['tab', { active: activeTab === 'platform' }]" @click="activeTab = 'platform'">平台促销活动</button>
      <button :class="['tab', { active: activeTab === 'coupon' }]" @click="activeTab = 'coupon'">店铺优惠券</button>
    </div>

    <!-- ==================== 左 Tab：平台促销活动 ==================== -->
    <template v-if="activeTab === 'platform'">
      <!-- 跨店满减活动 -->
      <div class="section-card">
        <h2 class="section-title">跨店满减活动</h2>
        <div v-if="platformLoading" class="empty-state"><div class="empty-text">加载中...</div></div>
        <div v-else-if="platformActivities.length === 0" class="empty-state">
          <div class="empty-icon">📢</div><div class="empty-text">暂无跨店满减活动</div>
        </div>
        <div v-else class="activity-cards">
          <div v-for="item in platformActivities" :key="item.id" class="activity-card">
            <div class="activity-header" @click="toggleExpand(item.id)">
              <div class="activity-left">
                <h3 class="activity-name">{{ item.title }}</h3>
                <p class="activity-time">{{ formatDate(item.startTime) }} - {{ formatDate(item.endTime) }}</p>
              </div>
              <div class="activity-right">
                <span v-if="item.joined" class="tag-joined">已参与</span>
                <button v-else class="btn-join" @click.stop="confirmJoin(item)">参与</button>
                <span class="expand-icon">{{ expandedIds.includes(item.id) ? '▲' : '▼' }}</span>
              </div>
            </div>
            <div v-if="expandedIds.includes(item.id)" class="activity-detail">
              <div class="tiers-list">
                <div v-for="(tier, idx) in item.tiers" :key="idx" class="tier-item">
                  <span class="tier-label">满</span><span class="tier-amount">¥{{ formatAmount(tier.minAmount) }}</span>
                  <span class="tier-label">减</span><span class="tier-amount">¥{{ formatAmount(tier.discountAmount) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 秒杀活动 -->
      <div class="section-card">
        <h2 class="section-title">秒杀活动</h2>
        <div class="activity-selector">
          <label class="selector-label">选择活动：</label>
          <select v-model="selectedActivityId" class="selector-input" @change="onActivityChange">
            <option :value="null" disabled>请选择秒杀活动</option>
            <option v-for="item in seckillActivities" :key="item.id" :value="item.id">
              {{ item.title }}（{{ formatDate(item.startTime) }} ~ {{ formatDate(item.endTime) }}）
            </option>
          </select>
        </div>

        <div v-if="selectedActivityId" class="seckill-table-wrap">
          <div class="section-sub-header">
            <h3 class="sub-title">我的秒杀商品</h3>
            <button class="btn-primary" @click="openSeckillAddModal">添加商品</button>
          </div>
          <div class="table-container">
            <div v-if="seckillLoading" class="empty-state"><div class="empty-text">加载中...</div></div>
            <table v-else-if="seckillProducts.length > 0" class="data-table">
              <thead>
                <tr><th>商品ID</th><th>商品名称</th><th>SKU码</th><th>秒杀价</th><th>秒杀库存</th><th>已售</th><th>限购</th><th>操作</th></tr>
              </thead>
              <tbody>
                <tr v-for="p in seckillProducts" :key="p.productId">
                  <td>{{ p.productId }}</td>
                  <td>{{ p.productName || '-' }}</td>
                  <td>{{ p.skuId }}</td>
                  <td>¥{{ formatAmount(p.seckillPrice) }}</td>
                  <td>{{ p.seckillStock }}</td>
                  <td>{{ p.soldCount ?? 0 }}</td>
                  <td>{{ p.limitQuantity ?? 1 }}</td>
                  <td>
                    <button class="btn-link" @click="openSeckillEditModal(p)">编辑</button>
                    <button class="btn-link btn-danger" @click="handleSeckillRemove(p)">移除</button>
                  </td>
                </tr>
              </tbody>
            </table>
            <div v-else class="empty-state"><div class="empty-icon">⚡</div><div class="empty-text">暂无秒杀商品，点击"添加商品"参与</div></div>
          </div>
        </div>
      </div>
    </template>

    <!-- ==================== 右 Tab：店铺优惠券 ==================== -->
    <template v-if="activeTab === 'coupon'">
      <div class="section-card">
        <div class="section-header">
          <h2 class="section-title">店铺优惠券</h2>
          <button class="btn-primary" @click="openCouponModal()">新建优惠券</button>
        </div>
        <div class="table-container">
          <div v-if="couponLoading" class="empty-state"><div class="empty-text">加载中...</div></div>
          <table v-else-if="coupons.length > 0" class="data-table">
            <thead>
              <tr>
                <th>名称</th><th>类型</th><th>面值/梯度</th><th>最低消费</th><th>已领取/发行量</th><th>有效期</th><th>状态</th><th>操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="c in coupons" :key="c.id">
                <td>{{ c.title }}</td>
                <td><span :class="['type-tag', c.type === 'FIXED' ? 'type-fixed' : 'type-tier']">{{ c.type === 'FIXED' ? '固定' : '满减' }}</span></td>
                <td>
                  <template v-if="c.type === 'FIXED'">¥{{ formatAmount(c.discountAmount) }}</template>
                  <template v-else>
                    <span v-for="(t, i) in c.tiers" :key="i">满{{ formatAmount(t.minAmount) }}减{{ formatAmount(t.discountAmount) }}<template v-if="i < c.tiers.length - 1">, </template></span>
                  </template>
                </td>
                <td>{{ c.type === 'FIXED' ? '¥' + formatAmount(c.minConsume || '0.01') : '-' }}</td>
                <td>{{ c.receivedCount || 0 }} / {{ c.totalCount }}</td>
                <td>
                  <template v-if="c.validityType === 2">领取后{{ c.validityDays }}天过期</template>
                  <template v-else>{{ formatDate(c.validStart) }} ~ {{ formatDate(c.validEnd) }}</template>
                </td>
                <td><span :class="['status-tag', c.status === 'DISABLED' ? 'status-disabled' : 'status-active']">{{ c.status === 'DISABLED' ? '已禁用' : '启用中' }}</span></td>
                <td>
                  <button class="btn-link" @click="openCouponModal(c)">编辑</button>
                  <button v-if="c.status !== 'DISABLED'" class="btn-link btn-danger" @click="handleDisableCoupon(c)">禁用</button>
                  <button v-if="c.status === 'DISABLED'" class="btn-link btn-enable" @click="handleEnableCoupon(c)">启用（重置领取）</button>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-else class="empty-state"><div class="empty-icon">🎫</div><div class="empty-text">暂无优惠券，点击"新建优惠券"创建</div></div>
        </div>
      </div>
    </template>

    <!-- ==================== 参与确认弹窗 ==================== -->
    <div v-if="showJoinConfirm" class="modal-mask" @click.self="showJoinConfirm = false">
      <div class="modal-content modal-sm">
        <div class="modal-header"><h3>确认参与</h3><button class="close-btn" @click="showJoinConfirm = false">×</button></div>
        <div class="modal-body"><p>请确认是否参与，一经参与无法退出</p></div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showJoinConfirm = false">取消</button>
          <button class="confirm-btn" @click="doJoin">确认</button>
        </div>
      </div>
    </div>

    <!-- ==================== 优惠券弹窗 ==================== -->
    <div v-if="showCouponModal" class="modal-mask" @click.self="showCouponModal = false">
      <div class="modal-content">
        <div class="modal-header"><h3>{{ editingCoupon ? '编辑优惠券' : '新建优惠券' }}</h3><button class="close-btn" @click="showCouponModal = false">×</button></div>
        <div class="modal-body">
          <div class="form-item"><label>券名称</label><input v-model="couponForm.title" placeholder="请输入优惠券名称" /></div>
          <div class="form-item"><label>类型</label>
            <select v-model="couponForm.type">
              <option value="FIXED">固定金额券</option>
              <option value="FULL_REDUCTION">满减券</option>
            </select>
          </div>
          <template v-if="couponForm.type === 'FIXED'">
            <div class="form-item"><label>优惠金额</label><input v-model.number="couponForm.discountAmount" type="number" min="0" step="0.01" /></div>
            <div class="form-item"><label>最低消费门槛</label><input v-model.number="couponForm.minConsume" type="number" min="0.01" step="0.01" /></div>
          </template>
          <template v-if="couponForm.type === 'FULL_REDUCTION'">
            <div class="form-item"><label>梯度设置</label>
              <div class="tier-editor">
                <div v-for="(tier, idx) in couponForm.tiers" :key="idx" class="tier-row">
                  <span>满</span><input v-model.number="tier.minAmount" type="number" min="0" step="0.01" />
                  <span>减</span><input v-model.number="tier.discountAmount" type="number" min="0" step="0.01" />
                  <button class="btn-remove" @click="removeTier(idx)">删除</button>
                </div>
                <button class="btn-add-tier" @click="addTier">+ 添加梯度</button>
              </div>
            </div>
          </template>
          <div class="form-row">
            <div class="form-item form-half"><label>发行总量</label><input v-model.number="couponForm.totalCount" type="number" min="1" /></div>
            <div class="form-item form-half"><label>每人限领</label><input v-model.number="couponForm.perUserLimit" type="number" min="1" /></div>
          </div>
          <div class="form-row">
            <div class="form-item form-half"><label>有效期开始</label><input v-model="couponForm.validStart" type="date" /></div>
            <div class="form-item form-half"><label>有效期结束</label><input v-model="couponForm.validEnd" type="date" /></div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showCouponModal = false">取消</button>
          <button class="confirm-btn" @click="saveCoupon">保存</button>
        </div>
      </div>
    </div>

    <!-- ==================== 秒杀商品弹窗 ==================== -->
    <div v-if="showSeckillModal" class="modal-mask" @click.self="showSeckillModal = false">
      <div class="modal-content">
        <div class="modal-header"><h3>{{ editingSeckillProduct ? '编辑秒杀商品' : '添加秒杀商品' }}</h3><button class="close-btn" @click="showSeckillModal = false">×</button></div>
        <div class="modal-body">
          <div class="form-item"><label>商品ID</label><input v-model.number="seckillForm.productId" type="number" min="1" :disabled="!!editingSeckillProduct" /></div>
          <div class="form-item"><label>SKU码</label><input v-model="seckillForm.skuId" type="text" :disabled="!!editingSeckillProduct" /></div>
          <div class="form-item"><label>秒杀价</label><input v-model.number="seckillForm.seckillPrice" type="number" min="0" step="0.01" /></div>
          <div class="form-item"><label>秒杀库存</label><input v-model.number="seckillForm.seckillStock" type="number" min="1" /></div>
          <div class="form-item"><label>限购数量</label><input v-model.number="seckillForm.limitQuantity" type="number" min="1" /></div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="showSeckillModal = false">取消</button>
          <button class="confirm-btn" @click="saveSeckillProduct">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import {
  getPlatformPromotions, joinPromotion,
  getMerchantCoupons, createMerchantCoupon, updateMerchantCoupon, disableMerchantCoupon, enableMerchantCoupon,
  getSeckillActivities, getSeckillProducts, addSeckillProduct, updateSeckillProduct, deleteSeckillProduct
} from '@/api/order'

const activeTab = ref('platform')

// ========== 工具函数 ==========
const formatAmount = (val: any): string => { const n = Number(val); return isNaN(n) ? '0.00' : n.toFixed(2) }
const formatDate = (val: string): string => {
  if (!val) return ''
  try { const d = new Date(val); if (isNaN(d.getTime())) return val; return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}` } catch { return val }
}
const toDateInput = (val: string): string => {
  if (!val) return ''
  try { const d = new Date(val); if (isNaN(d.getTime())) return ''; return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}` } catch { return '' }
}

// ========== 跨店满减活动 ==========
interface PlatformTier { minAmount: number|string; discountAmount: number|string }
interface PlatformActivity { id: number; title: string; startTime: string; endTime: string; status: string; joined: boolean; tiers: PlatformTier[] }
const platformActivities = ref<PlatformActivity[]>([])
const platformLoading = ref(true)
const expandedIds = ref<number[]>([])
const toggleExpand = (id: number) => { const idx = expandedIds.value.indexOf(id); idx >= 0 ? expandedIds.value.splice(idx,1) : expandedIds.value.push(id) }
const showJoinConfirm = ref(false)
const pendingJoinItem = ref<PlatformActivity|null>(null)
const confirmJoin = (item: PlatformActivity) => { pendingJoinItem.value = item; showJoinConfirm.value = true }
const doJoin = async () => {
  if (!pendingJoinItem.value) return
  try { const res = await joinPromotion(pendingJoinItem.value.id); if (res.code === 0) pendingJoinItem.value.joined = true } catch (e: any) { alert(e?.response?.data?.msg || '参与失败') }
  showJoinConfirm.value = false; pendingJoinItem.value = null
}
const loadPlatformPromotions = async () => {
  platformLoading.value = true
  try { const res = await getPlatformPromotions(); platformActivities.value = res.code === 0 ? (res.data || []) : [] } catch { platformActivities.value = [] }
  platformLoading.value = false
}

// ========== 店铺优惠券 ==========
interface CouponTier { minAmount: number; discountAmount: number }
interface CouponItem { id: number; merchantId: number; title: string; type: string; discountAmount?: number|string; minConsume?: number|string; totalCount: number; receivedCount: number; perUserLimit: number; validStart: string; validEnd: string; validityType?: number; validityDays?: number; status: string; tiers: CouponTier[] }
const coupons = ref<CouponItem[]>([])
const couponLoading = ref(true)
const showCouponModal = ref(false)
const editingCoupon = ref<CouponItem|null>(null)
const couponForm = reactive({ title: '', type: 'FIXED' as string, discountAmount: 0, minConsume: 0.01, tiers: [] as CouponTier[], totalCount: 100, perUserLimit: 1, validStart: '', validEnd: '' })

const resetCouponForm = () => { couponForm.title = ''; couponForm.type = 'FIXED'; couponForm.discountAmount = 0; couponForm.minConsume = 0.01; couponForm.tiers = []; couponForm.totalCount = 100; couponForm.perUserLimit = 1; couponForm.validStart = ''; couponForm.validEnd = '' }
const openCouponModal = (coupon?: CouponItem) => {
  if (coupon) {
    editingCoupon.value = coupon; couponForm.title = coupon.title; couponForm.type = coupon.type; couponForm.discountAmount = Number(coupon.discountAmount) || 0; couponForm.minConsume = Number(coupon.minConsume) || 0.01
    couponForm.tiers = (coupon.tiers||[]).map(t => ({ minAmount: Number(t.minAmount)||0, discountAmount: Number(t.discountAmount)||0 }))
    couponForm.totalCount = coupon.totalCount; couponForm.perUserLimit = coupon.perUserLimit; couponForm.validStart = toDateInput(coupon.validStart); couponForm.validEnd = toDateInput(coupon.validEnd)
  } else { editingCoupon.value = null; resetCouponForm() }
  showCouponModal.value = true
}
const addTier = () => couponForm.tiers.push({ minAmount: 0, discountAmount: 0 })
const removeTier = (idx: number) => couponForm.tiers.splice(idx, 1)
const saveCoupon = async () => {
  if (!couponForm.title) { alert('请输入优惠券名称'); return }
  if (couponForm.type === 'FIXED' && (!couponForm.discountAmount || couponForm.discountAmount <= 0)) { alert('请输入有效的优惠金额'); return }
  if (couponForm.type === 'FULL_REDUCTION' && couponForm.tiers.length === 0) { alert('请至少添加一个梯度'); return }
  if (!couponForm.validStart || !couponForm.validEnd) { alert('请选择有效期'); return }
  const body: any = { title: couponForm.title, type: couponForm.type, totalCount: Number(couponForm.totalCount), perUserLimit: Number(couponForm.perUserLimit), validStart: couponForm.validStart, validEnd: couponForm.validEnd }
  if (couponForm.type === 'FIXED') { body.discountAmount = Number(couponForm.discountAmount); body.minConsume = Number(couponForm.minConsume) }
  else { body.tiers = couponForm.tiers.map(t => ({ minAmount: Number(t.minAmount)||0, discountAmount: Number(t.discountAmount)||0 })) }
  try { editingCoupon.value ? await updateMerchantCoupon(editingCoupon.value.id, body) : await createMerchantCoupon(body); showCouponModal.value = false; editingCoupon.value = null; loadCoupons() } catch (e: any) { alert(e?.response?.data?.msg || '保存失败') }
}
const handleDisableCoupon = async (coupon: CouponItem) => { if (!confirm(`确定禁用优惠券"${coupon.title}"吗？`)) return; try { await disableMerchantCoupon(coupon.id); loadCoupons() } catch (e: any) { alert(e?.response?.data?.msg || '禁用失败') } }
const handleEnableCoupon = async (coupon: CouponItem) => { if (!confirm(`启用后领取次数将清零，确定启用"${coupon.title}"吗？`)) return; try { await enableMerchantCoupon(coupon.id); loadCoupons() } catch (e: any) { alert(e?.response?.data?.msg || '启用失败') } }
const loadCoupons = async () => {
  couponLoading.value = true
  try {
    const res = await getMerchantCoupons()
    if (res.code === 0) { coupons.value = (res.data||[]).map((item:any)=>({...item, type: item.type===1||item.type==='FIXED'?'FIXED':'FULL_REDUCTION', status: item.status===0?'DISABLED':'ACTIVE', tiers:(item.tiers||[]).map((t:any)=>({minAmount:Number(t.minAmount)||0,discountAmount:Number(t.discountAmount)||0})) })) } else coupons.value = []
  } catch { coupons.value = [] }
  couponLoading.value = false
}

// ========== 秒杀活动 ==========
interface SeckillActivity { id: number; title: string; startTime: string; endTime: string; status: number }
interface SeckillProduct { id: number; productId: number; productName?: string; skuId: string; seckillPrice: number; seckillStock: number; soldCount: number; limitQuantity: number }
const seckillActivities = ref<SeckillActivity[]>([])
const selectedActivityId = ref<number|null>(null)
const seckillProducts = ref<SeckillProduct[]>([])
const seckillLoading = ref(false)
const showSeckillModal = ref(false)
const editingSeckillProduct = ref<SeckillProduct|null>(null)
const seckillForm = reactive({ productId: null as number|null, skuId: null as string|null, seckillPrice: null as number|null, seckillStock: null as number|null, limitQuantity: 1 })

const resetSeckillForm = () => { seckillForm.productId = null; seckillForm.skuId = null; seckillForm.seckillPrice = null; seckillForm.seckillStock = null; seckillForm.limitQuantity = 1 }

const loadSeckillActivities = async () => {
  try { const res = await getSeckillActivities(); seckillActivities.value = res.code===0 ? (res.data||[]).filter((a:SeckillActivity)=>a.status===1) : [] } catch { seckillActivities.value = [] }
}
const onActivityChange = () => loadSeckillProducts()
const loadSeckillProducts = async () => {
  if (!selectedActivityId.value) return
  seckillLoading.value = true
  try { const res = await getSeckillProducts(selectedActivityId.value); seckillProducts.value = res.code===0 ? (res.data||[]) : [] } catch { seckillProducts.value = [] }
  seckillLoading.value = false
}
const openSeckillAddModal = () => { editingSeckillProduct.value = null; resetSeckillForm(); showSeckillModal.value = true }
const openSeckillEditModal = (p: SeckillProduct) => {
  editingSeckillProduct.value = p; seckillForm.productId = p.productId; seckillForm.skuId = p.skuId; seckillForm.seckillPrice = p.seckillPrice; seckillForm.seckillStock = p.seckillStock; seckillForm.limitQuantity = p.limitQuantity ?? 1; showSeckillModal.value = true
}
const saveSeckillProduct = async () => {
  if (!seckillForm.productId) { alert('请输入商品ID'); return }
  if (!seckillForm.skuId) { alert('请输入SKU码'); return }
  if (seckillForm.seckillPrice === null || seckillForm.seckillPrice < 0) { alert('请输入有效的秒杀价'); return }
  if (!seckillForm.seckillStock || seckillForm.seckillStock < 1) { alert('请输入有效的秒杀库存'); return }
  try {
    if (editingSeckillProduct.value) {
      await updateSeckillProduct(editingSeckillProduct.value.id, { seckillPrice: seckillForm.seckillPrice!, seckillStock: seckillForm.seckillStock!, limitQuantity: seckillForm.limitQuantity })
    } else {
      await addSeckillProduct(selectedActivityId.value!, { productId: seckillForm.productId, skuId: seckillForm.skuId, seckillPrice: seckillForm.seckillPrice!, seckillStock: seckillForm.seckillStock!, limitQuantity: seckillForm.limitQuantity })
    }
    showSeckillModal.value = false; editingSeckillProduct.value = null; loadSeckillProducts()
  } catch (e: any) { alert(e?.response?.data?.msg || '保存失败') }
}
const handleSeckillRemove = async (p: SeckillProduct) => { if (!confirm(`确定移除商品 ${p.productId} 吗？`)) return; try { await deleteSeckillProduct(p.id); loadSeckillProducts() } catch (e: any) { alert(e?.response?.data?.msg || '移除失败') } }

onMounted(() => { loadPlatformPromotions(); loadCoupons(); loadSeckillActivities() })
</script>

<style scoped>
.promotion-page { padding: 20px; max-width: 1100px; margin: 0 auto; }
.tab-bar { display: flex; gap: 0; margin-bottom: 20px; background: white; border-radius: 8px; overflow: hidden; }
.tab { flex: 1; padding: 14px; background: none; border: none; font-size: 15px; color: #86909C; cursor: pointer; border-bottom: 3px solid transparent; font-weight: 500; }
.tab.active { color: #165DFF; border-bottom-color: #165DFF; background: #F0F5FF; }
.section-card { background: white; border-radius: 8px; padding: 20px 24px; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.04); }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.section-title { font-size: 18px; color: #1D2129; margin: 0 0 16px; font-weight: 600; }
.section-header .section-title { margin-bottom: 0; }
.section-sub-header { display: flex; justify-content: space-between; align-items: center; margin: 16px 0 12px; }
.sub-title { font-size: 15px; color: #1D2129; margin: 0; font-weight: 500; }
.seckill-table-wrap { margin-top: 4px; }
.activity-cards { display: flex; flex-direction: column; gap: 12px; }
.activity-card { border: 1px solid #E2E8F0; border-radius: 8px; overflow: hidden; }
.activity-header { display: flex; justify-content: space-between; align-items: center; padding: 14px 16px; cursor: pointer; transition: background .2s; }
.activity-header:hover { background: #F7F8FA; }
.activity-left { flex: 1; }
.activity-name { font-size: 15px; color: #1D2129; margin: 0 0 4px; font-weight: 600; }
.activity-time { font-size: 12px; color: #86909C; margin: 0; }
.activity-right { display: flex; align-items: center; gap: 10px; }
.expand-icon { font-size: 11px; color: #86909C; }
.tag-joined { font-size: 12px; padding: 3px 10px; background: #F6FFED; color: #52C41A; border-radius: 4px; font-weight: 500; }
.btn-join { padding: 6px 16px; background: #165DFF; color: white; border: none; border-radius: 4px; font-size: 13px; cursor: pointer; }
.btn-join:hover { background: #4080FF; }
.activity-detail { padding: 0 16px 16px; border-top: 1px solid #F2F3F5; }
.tiers-list { display: flex; flex-wrap: wrap; gap: 8px; padding: 12px 0; }
.tier-item { display: flex; align-items: center; gap: 4px; padding: 4px 10px; background: #F7F8FA; border-radius: 4px; font-size: 13px; }
.tier-label { color: #86909C; font-size: 12px; }
.tier-amount { color: #FF4D4F; font-weight: 600; }
.table-container { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { padding: 10px 12px; text-align: left; border-bottom: 1px solid #F2F3F5; font-size: 13px; }
.data-table th { background: #F7F8FA; color: #4E5969; font-weight: 600; }
.data-table td { color: #1D2129; }
.type-tag { font-size: 12px; padding: 2px 8px; border-radius: 4px; }
.type-fixed { background: #E6F7FF; color: #1890FF; }
.type-tier { background: #FFF7E6; color: #FA8C16; }
.status-tag { font-size: 12px; padding: 2px 8px; border-radius: 4px; }
.status-active { background: #F6FFED; color: #52C41A; }
.status-disabled { background: #F2F3F5; color: #86909C; }
.btn-link { background: none; border: none; color: #165DFF; cursor: pointer; font-size: 13px; padding: 0; margin-right: 10px; }
.btn-link:hover { text-decoration: underline; }
.btn-danger { color: #FF4D4F; }
.btn-enable { color: #52C41A; }
.btn-primary { padding: 8px 16px; background: #165DFF; color: white; border: none; border-radius: 4px; font-size: 13px; cursor: pointer; }
.btn-primary:hover { background: #4080FF; }
.empty-state { text-align: center; padding: 48px 20px; }
.empty-icon { font-size: 48px; margin-bottom: 12px; }
.empty-text { font-size: 14px; color: #86909C; }
.modal-mask { position: fixed; top:0;left:0;right:0;bottom:0; background:rgba(0,0,0,.5); display:flex; align-items:center; justify-content:center; z-index:1000; }
.modal-content { width:500px; max-height:80vh; background:white; border-radius:8px; overflow:hidden; display:flex; flex-direction:column; }
.modal-sm { width:380px; }
.modal-header { display:flex; justify-content:space-between; align-items:center; padding:16px 20px; border-bottom:1px solid #f0f0f0; }
.modal-header h3 { font-size:16px; color:#1D2129; margin:0; }
.close-btn { font-size:20px; background:none; border:none; cursor:pointer; color:#86909C; }
.modal-body { padding:20px; overflow-y:auto; flex:1; }
.modal-footer { display:flex; justify-content:flex-end; gap:10px; padding:14px 20px; border-top:1px solid #f0f0f0; }
.cancel-btn { padding:8px 16px; background:#F2F3F5; color:#4E5969; border:none; border-radius:4px; cursor:pointer; font-size:13px; }
.confirm-btn { padding:8px 16px; background:#165DFF; color:#fff; border:none; border-radius:4px; cursor:pointer; font-size:13px; }
.form-item { margin-bottom:14px; }
.form-item label { display:block; margin-bottom:6px; font-size:13px; color:#4E5969; font-weight:500; }
.form-item input,.form-item select { width:100%; box-sizing:border-box; padding:8px 10px; border:1px solid #dcdcdc; border-radius:4px; font-size:13px; }
.form-row { display:flex; gap:12px; }
.form-half { flex:1; }
.tier-editor { border:1px solid #E2E8F0; border-radius:4px; padding:10px; }
.tier-row { display:flex; align-items:center; gap:6px; margin-bottom:8px; }
.tier-row span { font-size:13px; color:#4E5969; white-space:nowrap; }
.tier-row input { width:100px; box-sizing:border-box; padding:6px 8px; border:1px solid #dcdcdc; border-radius:4px; font-size:13px; }
.btn-remove { background:none; border:none; color:#FF4D4F; cursor:pointer; font-size:12px; white-space:nowrap; }
.btn-remove:hover { text-decoration:underline; }
.btn-add-tier { background:none; border:1px dashed #165DFF; color:#165DFF; border-radius:4px; padding:6px 12px; font-size:12px; cursor:pointer; width:100%; }
.btn-add-tier:hover { background:#F0F5FF; }
.activity-selector { display:flex; align-items:center; gap:10px; }
.selector-label { font-size:14px; color:#4E5969; white-space:nowrap; }
.selector-input { flex:1; max-width:500px; padding:8px 10px; border:1px solid #dcdcdc; border-radius:4px; font-size:13px; color:#1D2129; }
</style>
