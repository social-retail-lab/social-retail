<template>
  <div class="review-box">
    <h2>评价申诉审核</h2>

    <table border="1">
      <thead>
        <tr>
          <th>商家名称</th>
          <th>订单号</th>
          <th>评价内容</th>
          <th>评分</th>
          <th>申诉原因</th>
          <th>申诉时间</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.id">
          <td>{{ item.merchantName }}</td>
          <td>{{ item.orderSn }}</td>
          <td>
            <span class="content-cell" :title="item.content">{{ truncate(item.content, 30) }}</span>
          </td>
          <td>
            <span class="stars-num">{{ item.stars || 0 }}分</span>
          </td>
          <td>{{ item.appealReason }}</td>
          <td>{{ item.appealTime }}</td>
          <td>
            <template v-if="item.status === 1">
              <button class="btn-danger" @click="openAudit(item, 'block')">屏蔽评价</button>
              <button class="btn-default" @click="openAudit(item, 'reject')">驳回申诉</button>
            </template>
            <template v-else-if="item.status === 2">
              <span class="badge badge-red">已屏蔽</span>
              <span class="audit-time">{{ item.auditTime }}</span>
            </template>
            <template v-else-if="item.status === 3">
              <span class="badge badge-gray">已驳回</span>
              <span class="audit-time">{{ item.auditTime }}</span>
            </template>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="page">
      <button :disabled="page === 1" @click="page--">上一页</button>
      <span>第{{ page }}页 / 共{{ Math.ceil(total / 10) || 1 }}页</span>
      <button :disabled="page * 10 >= total" @click="page++">下一页</button>
    </div>

    <!-- 审核弹窗 -->
    <div v-if="showMask" class="mask" @click.self="showMask = false">
      <div class="dialog">
        <h3>{{ auditAction === 'block' ? '屏蔽评价' : '驳回申诉' }}</h3>
        <div class="review-detail">
          <div class="detail-row">
            <span class="detail-label">商家名称：</span>
            <span>{{ curItem.merchantName }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">订单号：</span>
            <span>{{ curItem.orderSn }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">评价内容：</span>
            <span>{{ curItem.content }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">评分：</span>
            <span class="stars-num">{{ curItem.stars || 0 }}分</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">申诉原因：</span>
            <span>{{ curItem.appealReason }}</span>
          </div>
          <div v-if="curItem.evidence" class="detail-row">
            <span class="detail-label">申诉证据：</span>
            <img :src="curItem.evidence" class="evidence-img" @click="previewImage(curItem.evidence)" />
          </div>
        </div>
        <div class="form-item">
          <label>审核备注</label>
          <textarea v-model="auditResult" placeholder="填写审核备注" rows="3"></textarea>
        </div>
        <div class="dialog-btns">
          <button @click="showMask = false">取消</button>
          <button class="btn-primary" @click="submitAudit">确认提交</button>
        </div>
      </div>
    </div>

    <!-- 图片预览 -->
    <div v-if="showPreview" class="mask preview-mask" @click.self="showPreview = false">
      <img :src="previewSrc" class="preview-img" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const tableList = ref<any[]>([])
const page = ref(1)
const total = ref(0)

const showMask = ref(false)
const curItem = ref<any>({})
const auditAction = ref('')
const auditResult = ref('')
const showPreview = ref(false)
const previewSrc = ref('')

const truncate = (str: string, len: number) => {
  if (!str) return ''
  return str.length > len ? str.slice(0, len) + '...' : str
}


const statusMap: Record<number, string> = {
  1: '申诉中',
  2: '已屏蔽',
  3: '已驳回'
}

const fetchList = async () => {
  try {
    const res: any = await request.get('/admin/reviews/appeals', { params: { page: page.value, pageSize: 10 } })
    if (res.code === 0) {
      tableList.value = res.data.list || []
      total.value = res.data.total || 0
    }
  } catch { /* */ }
}

const openAudit = (item: any, action: string) => {
  curItem.value = item
  auditAction.value = action
  auditResult.value = ''
  showMask.value = true
}

const submitAudit = async () => {
  try {
    const res: any = await request.post(`/admin/reviews/appeals/${curItem.value.id}/audit`, {
      action: auditAction.value,
      result: auditResult.value
    })
    if (res.code === 0) {
      showMask.value = false
      fetchList()
    }
  } catch { /* */ }
}

const previewImage = (src: string) => {
  previewSrc.value = src
  showPreview.value = true
}

const changePage = (p: number) => {
  page.value = p
  fetchList()
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped>
.review-box { padding: 20px; }
.review-box h2 { margin-bottom: 16px; font-size: 18px; }

table { width: 100%; border-collapse: collapse; background: #fff; }
th, td { padding: 10px 12px; text-align: left; border: 1px solid #e8e8e8; font-size: 14px; }
th { background: #fafafa; font-weight: 600; font-size: 15px; color: #333; }
.content-cell { cursor: default; max-width: 180px; display: inline-block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; vertical-align: middle; }
.stars-num { font-size: 16px; font-weight: 600; }

.badge { display: inline-block; padding: 2px 10px; border-radius: 4px; font-size: 12px; font-weight: 500; }
.badge-blue { background: #E6F7FF; color: #1890FF; }
.badge-red { background: #FFF1F0; color: #FF4D4F; }
.badge-gray { background: #F5F5F5; color: #999; }
.audit-time { display: block; font-size: 12px; color: #999; margin-top: 4px; }

button { padding: 6px 14px; border: 1px solid #dcdcdc; border-radius: 4px; background: #fff; font-size: 13px; cursor: pointer; }
button:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-danger { background: #FF4D4F; color: #fff; border-color: #FF4D4F; }
.btn-danger:hover { background: #FF7875; border-color: #FF7875; }
.btn-default { background: #fff; color: #666; border-color: #dcdcdc; margin-left: 8px; }
.btn-default:hover { border-color: #999; color: #333; }
.btn-primary { background: #165DFF; color: #fff; border-color: #165DFF; }

.page { display: flex; align-items: center; justify-content: center; gap: 16px; margin-top: 16px; font-size: 14px; color: #666; }

.mask { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.dialog { background: #fff; border-radius: 8px; padding: 24px; width: 520px; max-height: 80vh; overflow-y: auto; }
.dialog h3 { margin: 0 0 16px; font-size: 16px; }

.review-detail { margin-bottom: 20px; }
.detail-row { margin-bottom: 10px; font-size: 14px; color: #333; display: flex; }
.detail-label { color: #999; min-width: 90px; flex-shrink: 0; }
.evidence-img { max-width: 200px; max-height: 120px; border-radius: 4px; cursor: pointer; border: 1px solid #e8e8e8; }

.form-item { margin-bottom: 16px; }
.form-item label { display: block; margin-bottom: 6px; font-size: 14px; color: #333; }
.form-item textarea { width: 100%; padding: 8px 12px; border: 1px solid #dcdcdc; border-radius: 4px; font-size: 14px; resize: vertical; box-sizing: border-box; }
.form-item textarea:focus { outline: none; border-color: #165DFF; }

.dialog-btns { display: flex; gap: 10px; justify-content: flex-end; }

.preview-mask { z-index: 1100; }
.preview-img { max-width: 80vw; max-height: 80vh; border-radius: 8px; }
</style>
