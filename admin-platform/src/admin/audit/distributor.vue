<template>
  <div class="distributor-audit-page">
    <h1>分销员审核</h1>
    <p class="subtitle">审核用户提交的分销员申请</p>

    <!-- 筛选栏 -->
    <div class="filter-bar">
      <select v-model="filterStatus" @change="loadData" class="status-select">
        <option :value="undefined">全部状态</option>
        <option :value="0">待审核</option>
        <option :value="1">已通过</option>
        <option :value="2">已拒绝</option>
      </select>
      <input v-model="keyword" placeholder="搜索姓名" class="search-input" @keyup.enter="loadData" />
      <button @click="loadData" class="search-btn">搜索</button>
    </div>

    <!-- 数据表格 -->
    <div class="table-wrap">
      <table class="data-table" v-if="list.length > 0">
        <thead>
          <tr>
            <th>申请ID</th>
            <th>用户ID</th>
            <th>真实姓名</th>
            <th>身份证号</th>
            <th>身份证正面</th>
            <th>身份证反面</th>
            <th>开户银行</th>
            <th>银行卡号</th>
            <th>开户人</th>
            <th>申请时间</th>
            <th>审核状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.id">
            <td>{{ item.id }}</td>
            <td>{{ item.userId }}</td>
            <td>{{ item.realName }}</td>
            <td>{{ item.idCardNo }}</td>
            <td>
              <img v-if="item.idCardFront" :src="item.idCardFront" class="id-img" @click="previewImage(item.idCardFront)" />
              <span v-else>-</span>
            </td>
            <td>
              <img v-if="item.idCardBack" :src="item.idCardBack" class="id-img" @click="previewImage(item.idCardBack)" />
              <span v-else>-</span>
            </td>
            <td>{{ item.bankName }}</td>
            <td>{{ item.bankCardNo }}</td>
            <td>{{ item.bankAccountName }}</td>
            <td>{{ item.applyTime || '-' }}</td>
            <td>
              <span :class="['status-tag', getAuditClass(item.auditStatus)]">
                {{ getAuditText(item.auditStatus) }}
              </span>
            </td>
            <td>
              <div v-if="item.auditStatus === 0" class="action-btns">
                <button class="btn-approve" @click="audit(item, 1)">通过</button>
                <button class="btn-reject" @click="openReject(item)">拒绝</button>
              </div>
              <span v-else-if="item.auditRemark" class="remark-text">{{ item.auditRemark }}</span>
              <span v-else>-</span>
            </td>
          </tr>
        </tbody>
      </table>
      <div v-else class="empty-state">
        <span class="empty-text">暂无分销员申请</span>
      </div>
    </div>

    <!-- 分页 -->
    <div class="pagination" v-if="totalPages > 1">
      <button :disabled="pageNum <= 1" @click="pageNum--; loadData()">上一页</button>
      <span>{{ pageNum }} / {{ totalPages }}</span>
      <button :disabled="pageNum >= totalPages" @click="pageNum++; loadData()">下一页</button>
    </div>

    <!-- 拒绝理由弹窗 -->
    <div v-if="showReject" class="modal-mask" @click.self="showReject = false">
      <div class="modal-box">
        <h2>拒绝申请</h2>
        <div class="form-row">
          <label>拒绝理由</label>
          <textarea v-model="rejectRemark" rows="3" placeholder="请输入拒绝理由"></textarea>
        </div>
        <div class="dialog-btns">
          <button class="btn-cancel" @click="showReject = false">取消</button>
          <button class="btn-submit" @click="doReject">确认拒绝</button>
        </div>
      </div>
    </div>

    <!-- 图片预览 -->
    <div v-if="previewVisible" class="modal-mask" @click.self="previewVisible = false">
      <div class="preview-box">
        <span class="close-preview" @click="previewVisible = false">×</span>
        <img :src="previewUrl" class="preview-img" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const list = ref<any[]>([])
const filterStatus = ref<number | undefined>(undefined)
const keyword = ref('')
const pageNum = ref(1)
const totalPages = ref(1)

const showReject = ref(false)
const rejectRemark = ref('')
const currentItem = ref<any>(null)

const previewVisible = ref(false)
const previewUrl = ref('')

const getAuditClass = (status: number) => {
  if (status === 0) return 'WAIT'
  if (status === 1) return 'PASSED'
  if (status === 2) return 'REJECTED'
  return 'UNKNOWN'
}

const getAuditText = (status: number) => {
  if (status === 0) return '待审核'
  if (status === 1) return '已通过'
  if (status === 2) return '已拒绝'
  return '未知'
}

const previewImage = (url: string) => {
  previewUrl.value = url
  previewVisible.value = true
}

const loadData = async () => {
  try {
    const params: any = { pageNum: pageNum.value, pageSize: 10 }
    if (filterStatus.value !== undefined) params.auditStatus = filterStatus.value
    if (keyword.value) params.keyword = keyword.value

    const res = await request.get('/admin/distributor/applies', { params })
    if (res.code === 0) {
      const data = res.data
      list.value = data.list || data.records || []
      const total = data.total || list.value.length
      totalPages.value = Math.max(1, Math.ceil(total / 10))
    }
  } catch (e: any) {
    console.error('[分销员审核] 加载失败:', e.message)
  }
}

const audit = async (item: any, auditStatus: number) => {
  try {
    const res = await request.post(`/admin/distributor/applies/${item.id}/audit`, {
      auditStatus,
      auditRemark: ''
    })
    if (res.code === 0) {
      alert(auditStatus === 1 ? '已通过审核' : '已拒绝')
      loadData()
    } else {
      alert(res.message || '操作失败')
    }
  } catch (e: any) {
    alert('操作失败: ' + (e.message || '网络错误'))
  }
}

const openReject = (item: any) => {
  currentItem.value = item
  rejectRemark.value = ''
  showReject.value = true
}

const doReject = async () => {
  if (!currentItem.value || !rejectRemark.value.trim()) {
    alert('请输入拒绝理由')
    return
  }
  await request.post(`/admin/distributor/applies/${currentItem.value.id}/audit`, {
    auditStatus: 2,
    auditRemark: rejectRemark.value
  })
  showReject.value = false
  loadData()
}

onMounted(loadData)
</script>

<style scoped>
.distributor-audit-page { padding: 24px; max-width: 100%; margin: 0 auto; }
h1 { font-size: 20px; color: #2D2D2D; margin-bottom: 4px; }
.subtitle { font-size: 13px; color: #999; margin-bottom: 16px; }

.filter-bar { display: flex; gap: 8px; margin-bottom: 16px; align-items: center; }
.status-select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; font-size: 13px; }
.search-input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 160px; font-size: 13px; }
.search-btn { padding: 8px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }

.table-wrap { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 6px; overflow: hidden; white-space: nowrap; min-width: 1400px; }
.data-table th, .data-table td { padding: 10px 12px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 13px; vertical-align: middle; }
.data-table th { background: #EDEDED; color: #555; font-weight: 600; font-size: 15px; }
.data-table td { color: #333; }

.id-img { width: 64px; height: 40px; object-fit: cover; border-radius: 4px; border: 1px solid #e8e8e8; cursor: pointer; }
.id-img:hover { border-color: #165DFF; }

.status-tag { padding: 2px 8px; border-radius: 4px; font-size: 12px; }
.status-tag.WAIT { background: #FFF7E6; color: #FA8C16; }
.status-tag.PASSED { background: #F6FFED; color: #52C41A; }
.status-tag.REJECTED { background: #FFF2F0; color: #FF4D4F; }
.status-tag.UNKNOWN { background: #f5f5f5; color: #999; }

.action-btns { display: flex; gap: 6px; justify-content: center; }
.btn-approve { padding: 4px 12px; background: #52C41A; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
.btn-approve:hover { background: #45a715; }
.btn-reject { padding: 4px 12px; background: #FF4D4F; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
.btn-reject:hover { background: #e04345; }

.remark-text { color: #999; font-size: 12px; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 40px; color: #999; }
.empty-icon { font-size: 36px; margin-bottom: 8px; }

.pagination { display: flex; justify-content: center; gap: 16px; margin-top: 20px; align-items: center; font-size: 13px; color: #666; }
.pagination button { padding: 6px 14px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: .4; cursor: default; }

.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,.55); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-box { background: #fff; border-radius: 8px; padding: 24px; width: 480px; }
.modal-box h2 { font-size: 17px; margin-bottom: 16px; }
.form-row { margin-bottom: 14px; }
.form-row label { display: block; font-size: 13px; color: #555; margin-bottom: 6px; }
.form-row textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: none; box-sizing: border-box; font-size: 13px; }
.dialog-btns { display: flex; gap: 10px; justify-content: flex-end; margin-top: 16px; }
.btn-cancel { padding: 8px 18px; background: #f5f5f5; color: #666; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; }
.btn-submit { padding: 8px 18px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; }

.preview-box { position: relative; }
.preview-img { max-width: 80vw; max-height: 80vh; border-radius: 6px; }
.close-preview { position: absolute; top: -28px; right: 0; font-size: 28px; color: #fff; cursor: pointer; }
</style>
