<template>
  <div class="reviews-page">
    <div class="page-header">
      <h1>用户评价</h1>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-value">{{ stats.rating.value }}</div>
        <div class="stat-label">综合评分</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.total }}</div>
        <div class="stat-label">总评价数</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.goodRate }}</div>
        <div class="stat-label">好评率</div>
      </div>
    </div>

    <div class="tabs">
      <button
        v-for="tab in tabs"
        :key="tab.value"
        :class="['tab-btn', { active: activeRating === tab.value }]"
        @click="activeRating = tab.value"
      >
        {{ tab.label }}
      </button>
    </div>

    <div class="review-list">
      <div v-for="review in reviewList" :key="review.id" class="review-card">
        <div class="review-row1">
          <span class="review-stars">
            <span v-for="i in 5" :key="i" :class="i <= review.rating ? 'star-filled' : 'star-empty'">★</span>
          </span>
          <span class="review-sn">订单: {{ review.orderSn }}</span>
          <span class="review-date">{{ review.createTime }}</span>
        </div>
        <div class="review-row2">
          <span class="review-content">{{ review.content }}</span>
        </div>
        <div class="review-row3">
          <span v-if="review.appealStatus === 1" class="badge badge-blue">申诉中</span>
          <span v-if="review.appealStatus === 2" class="badge badge-red">已屏蔽</span>
          <span v-if="review.appealStatus === 3" class="badge badge-gray">申诉驳回</span>
          <button
            v-if="review.appealStatus === 0"
            class="appeal-btn"
            @click="openAppeal(review)"
          >
            申请屏蔽
          </button>
        </div>
      </div>
    </div>

    <div v-if="reviewList.length === 0 && !loading" class="empty-state">
      <div class="empty-text">暂无评价</div>
    </div>

    <div class="pagination">
      <button :disabled="currentPage <= 1" @click="currentPage--; loadReviews()" class="page-btn">上一页</button>
      <span class="page-info">第{{ currentPage }}页 / 共{{ totalPages }}页</span>
      <button :disabled="currentPage >= totalPages" @click="currentPage++; loadReviews()" class="page-btn">下一页</button>
    </div>

    <!-- 申诉弹窗 -->
    <div v-if="showAppeal" class="modal-mask" @click.self="showAppeal = false">
      <div class="modal-box">
        <div class="modal-header">
          <h2>申请屏蔽评价</h2>
          <button class="close-btn" @click="showAppeal = false">×</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label class="form-label">申诉原因 <span class="required">*</span></label>
            <textarea v-model="appealForm.reason" class="form-textarea" rows="4" placeholder="请描述申诉原因"></textarea>
          </div>
          <div class="form-item">
            <label class="form-label">证明材料</label>
            <input v-model="appealForm.evidence" class="form-input" placeholder="请输入图片路径或链接" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="submit-btn" @click="submitAppeal">提交申诉</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import request from '@/utils/request'

interface Review {
  id: number
  orderSn: string
  rating: number
  content: string
  appealStatus: number
  createTime: string
}

interface Stats {
  rating: { value: string }
  total: number
  goodRate: string
}

const stats = reactive<Stats>({
  rating: { value: '0.0' },
  total: 0,
  goodRate: '0%'
})

const activeRating = ref('')
const tabs = [
  { label: '全部', value: '' },
  { label: '好评(5星)', value: 'good' },
  { label: '中评(3-4星)', value: 'middle' },
  { label: '差评(1-2星)', value: 'bad' }
]

const reviewList = ref<Review[]>([])
const loading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)

const showAppeal = ref(false)
const appealReview = ref<Review | null>(null)
const appealForm = reactive({
  reason: '',
  evidence: ''
})

const fetchStats = async () => {
  try {
    const res = await request.get('/merchant/reviews/stats')
    if (res.code === 0 && res.data) {
      const d = res.data
      stats.rating.value = d.bayesianRating != null ? Number(d.bayesianRating).toFixed(1) : '0.0'
      stats.total = d.totalReviews || 0
      const pct = d.totalReviews > 0 ? ((d.goodCount || 0) / d.totalReviews * 100).toFixed(1) : 0
      stats.goodRate = pct + '%'
    }
  } catch (e: any) {
    console.error('[评价统计] 请求异常:', e.message || e)
  }
}

const loadReviews = async () => {
  loading.value = true
  try {
    const params: any = {
      page: currentPage.value,
      pageSize: 10
    }
    if (activeRating.value) {
      params.rating = activeRating.value
    }
    const res = await request.get('/merchant/reviews/list', { params })
    if (res.code === 0 && res.data) {
      const list = res.data.list || res.data.records || (Array.isArray(res.data) ? res.data : [])
      reviewList.value = list
      const total = res.data.total || list.length
      totalPages.value = Math.max(1, Math.ceil(total / 10))
    }
  } catch (e: any) {
    console.error('[评价列表] 请求异常:', e.message || e)
  } finally {
    loading.value = false
  }
}

const openAppeal = (review: Review) => {
  appealReview.value = review
  appealForm.reason = ''
  appealForm.evidence = ''
  showAppeal.value = true
}

const submitAppeal = async () => {
  if (!appealForm.reason.trim()) {
    alert('请填写申诉原因')
    return
  }
  if (!appealReview.value) return
  try {
    const res = await request.post(`/merchant/reviews/${appealReview.value.id}/appeal`, {
      reason: appealForm.reason,
      evidence: appealForm.evidence
    })
    if (res.code === 0) {
      alert('申诉提交成功')
      showAppeal.value = false
      loadReviews()
    } else {
      alert('申诉失败: ' + (res.msg || '未知错误'))
    }
  } catch (e: any) {
    console.error('[申诉提交] 请求异常:', e.message || e)
  }
}

onMounted(() => {
  fetchStats()
  loadReviews()
})

watch(activeRating, () => {
  currentPage.value = 1
  loadReviews()
})
</script>

<style scoped>
.reviews-page {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 22px;
  color: #2D2D2D;
}

/* 统计卡片 */
.stats-row {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.stat-card {
  flex: 1;
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.stat-value {
  font-size: 28px;
  font-weight: 600;
  color: #409EFF;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #8C8C8C;
}

/* 筛选标签 */
.tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.tab-btn {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  background: white;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  color: #595959;
}

.tab-btn.active {
  background: #409EFF;
  color: white;
  border-color: #409EFF;
}

/* 评价列表 */
.review-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.review-card {
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  padding: 16px 20px;
}

.review-row1 {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 10px;
}

.review-stars {
  font-size: 16px;
  letter-spacing: 2px;
}

.star-filled {
  color: #F7BA2A;
}

.star-empty {
  color: #dcdcdc;
}

.review-sn {
  font-size: 13px;
  color: #595959;
  font-family: monospace;
}

.review-date {
  margin-left: auto;
  font-size: 13px;
  color: #8C8C8C;
}

.review-row2 {
  margin-bottom: 10px;
}

.review-content {
  font-size: 14px;
  color: #2D2D2D;
  line-height: 1.6;
}

.review-row3 {
  display: flex;
  align-items: center;
}

.badge {
  font-size: 12px;
  padding: 2px 10px;
  border-radius: 10px;
}

.badge-blue {
  background: #E6F7FF;
  color: #1890FF;
}

.badge-red {
  background: #FFF2F0;
  color: #FF4D4F;
}

.badge-gray {
  background: #F5F5F5;
  color: #999;
}

.appeal-btn {
  padding: 4px 14px;
  border: 1px solid #409EFF;
  background: white;
  color: #409EFF;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.appeal-btn:hover {
  background: #409EFF;
  color: white;
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
}

.empty-text {
  font-size: 14px;
  color: #8C8C8C;
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 30px;
}

.page-btn {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  background: white;
  border-radius: 4px;
  cursor: pointer;
}

.page-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.page-info {
  font-size: 14px;
  color: #595959;
}

/* 弹窗 */
.modal-mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-box {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  width: 480px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.modal-header h2 {
  font-size: 17px;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 22px;
  color: #999;
  cursor: pointer;
}

.modal-body {
  margin-bottom: 20px;
}

.form-item {
  margin-bottom: 14px;
}

.form-label {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 6px;
}

.required {
  color: #FF4D4F;
}

.form-textarea {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  font-family: inherit;
  resize: vertical;
  box-sizing: border-box;
}

.form-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  box-sizing: border-box;
}

.modal-footer {
  text-align: right;
}

.submit-btn {
  padding: 8px 24px;
  background: #409EFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.submit-btn:hover {
  background: #3A8EE6;
}
</style>
