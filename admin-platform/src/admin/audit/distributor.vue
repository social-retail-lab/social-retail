<template>
  <div class="distributor-page">
    <div class="page-header">
      <h1>分销员审核</h1>
      <p class="subtitle">审核申请成为分销员的用户</p>
    </div>

    <div class="search-bar">
      <input v-model="keyword" placeholder="搜索申请人" class="search-input" />
      <button @click="search" class="search-btn">搜索</button>
    </div>

    <table class="data-table">
      <thead>
        <tr>
          <th>申请ID</th>
          <th>申请人</th>
          <th>手机号</th>
          <th>申请时间</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in list" :key="item.id">
          <td>{{ item.id }}</td>
          <td>{{ item.realName || item.nickname || '-' }}</td>
          <td>{{ item.phone || '-' }}</td>
          <td>{{ item.applyTime || '-' }}</td>
          <td><span :class="['status-tag', getStatusClass(item.status)]">{{ getStatusText(item.status) }}</span></td>
          <td>
            <button class="btn-view" @click="openDetail(item)">查看详情</button>
            <button v-if="item.status === 0" class="btn-approve" @click="handleAudit(item, 1)">通过</button>
            <button v-if="item.status === 0" class="btn-reject" @click="handleAudit(item, 2)">拒绝</button>
          </td>
        </tr>
        <tr v-if="list.length === 0">
          <td colspan="6" class="empty">暂无申请记录</td>
        </tr>
      </tbody>
    </table>

    <div class="pagination" v-if="totalPages > 1">
      <button :disabled="pageNum <= 1" @click="pageNum--; loadData()">上一页</button>
      <span>第{{ pageNum }}页 / 共{{ totalPages }}页</span>
      <button :disabled="pageNum >= totalPages" @click="pageNum++; loadData()">下一页</button>
    </div>

    <!-- 详情对话框 -->
    <div v-if="showDetail" class="modal-mask" @click.self="showDetail = false">
      <div class="modal-box">
        <h2>申请详情</h2>
        <div class="detail-section">
          <div class="detail-row"><span class="d-label">申请ID：</span>{{ currentItem?.id }}</div>
          <div class="detail-row"><span class="d-label">申请人：</span>{{ currentItem?.realName || currentItem?.nickname || '-' }}</div>
          <div class="detail-row"><span class="d-label">手机号：</span>{{ currentItem?.phone || '-' }}</div>
          <div class="detail-row"><span class="d-label">申请时间：</span>{{ currentItem?.applyTime || '-' }}</div>
          <div class="detail-row"><span class="d-label">状态：</span>{{ getStatusText(currentItem?.status || 0) }}</div>
        </div>
        <div class="dialog-footer">
          <button class="btn-close" @click="showDetail = false">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const keyword = ref('')
const pageNum = ref(1)
const totalPages = ref(1)
const list = ref<any[]>([])

const showDetail = ref(false)
const currentItem = ref<any>(null)

const getStatusClass = (status: number) => {
  if (status === 0) return 'WAIT'
  if (status === 1) return 'APPROVED'
  if (status === 2) return 'REJECTED'
  return ''
}

const getStatusText = (status: number) => {
  if (status === 0) return '待审核'
  if (status === 1) return '已通过'
  if (status === 2) return '已拒绝'
  return '未知'
}

const search = () => { pageNum.value = 1; loadData() }

const loadData = async () => {
  // 不连接后端API，返回空列表
  list.value = []
  totalPages.value = 1
}

const openDetail = (item: any) => {
  currentItem.value = item
  showDetail.value = true
}

const handleAudit = async (item: any, action: number) => {
  if (action === 2) {
    const reason = prompt('请输入拒绝理由：')
    if (!reason) return
  }
  const msg = action === 1 ? '确认通过该分销员申请？' : '确认拒绝该分销员申请？'
  if (!confirm(msg)) return
  // 暂不连接后端
  alert(action === 1 ? '已通过申请' : '已拒绝申请')
  loadData()
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.distributor-page { padding: 24px; max-width: 1000px; margin: 0 auto; }
.page-header { margin-bottom: 20px; }
.page-header h1 { font-size: 20px; color: #1D2129; margin: 0; }
.subtitle { font-size: 13px; color: #86909C; margin: 4px 0 0; }

.search-bar { display: flex; gap: 8px; margin-bottom: 16px; }
.search-input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 200px; font-size: 13px; }
.search-btn { padding: 8px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }

.data-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 6px; overflow: hidden; }
.data-table th, .data-table td { padding: 10px 14px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
.data-table th { background: #fafafa; color: #555; font-weight: 600; }
.data-table td { color: #333; }
.empty { color: #86909C; padding: 30px !important; }

.status-tag { font-size: 11px; padding: 2px 8px; border-radius: 4px; }
.status-tag.WAIT { background: #FFF7E6; color: #E67E22; }
.status-tag.APPROVED { background: #F6FFED; color: #52C41A; }
.status-tag.REJECTED { background: #FFF2F0; color: #FF4D4F; }

.btn-view { padding: 4px 12px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; margin-right: 6px; }
.btn-approve { padding: 4px 12px; background: #52C41A; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; margin-right: 6px; }
.btn-reject { padding: 4px 12px; background: #FF4D4F; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }

.pagination { display: flex; justify-content: center; gap: 16px; margin-top: 20px; align-items: center; font-size: 13px; color: #666; }
.pagination button { padding: 6px 14px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: 0.4; cursor: default; }

.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 8px; padding: 24px; width: 480px; }
.modal-box h2 { font-size: 17px; margin: 0 0 16px; color: #1D2129; }
.detail-section { margin-bottom: 16px; }
.detail-row { display: flex; margin-bottom: 8px; font-size: 13px; }
.d-label { color: #86909C; min-width: 80px; flex-shrink: 0; }

.dialog-footer { margin-top: 16px; text-align: center; }
.btn-close { padding: 8px 24px; background: #f5f5f5; color: #666; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; font-size: 14px; }
</style>
