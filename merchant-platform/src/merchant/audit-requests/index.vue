<template>
  <div class="audit-requests-page">
    <div class="page-header">
      <h2>审核请求</h2>
    </div>

    <div class="table-card">
      <el-table :data="list" v-loading="loading" stripe style="width: 100%">
        <el-table-column prop="createTime" label="申请时间" min-width="160" />
        <el-table-column label="请求类型" min-width="140">
          <template #default="{ row }">
            {{ requestTypeMap[row.requestType] || row.requestType || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="审核状态" min-width="100">
          <template #default="{ row }">
            <el-tag :type="auditStatusTag(row.auditStatus)" size="small">
              {{ auditStatusMap[row.auditStatus] || '未知' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="审核备注" min-width="200">
          <template #default="{ row }">
            <span v-if="row.auditStatus !== 0 && row.auditRemark">{{ row.auditRemark }}</span>
            <span v-else class="text-muted">-</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="160" fixed="right">
          <template #default="{ row }">
            <el-button size="small" type="primary" link @click="openDetail(row)">详情</el-button>
            <el-button
              v-if="row.auditStatus === 0"
              size="small"
              type="danger"
              link
              :loading="row._withdrawing"
              @click="handleWithdraw(row)"
            >
              撤回
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div v-if="list.length === 0 && !loading" class="empty-state">
        <div class="empty-icon">📭</div>
        <div class="empty-text">暂无审核请求</div>
      </div>

      <div class="pagination-wrap" v-if="total > 0">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          @change="loadList"
        />
      </div>
    </div>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" title="审核请求详情" width="700px" destroy-on-close>
      <div v-if="detailLoading" class="detail-loading">加载中...</div>
      <div v-else-if="detail" class="detail-content">
        <div class="detail-meta">
          <div class="meta-item">
            <span class="meta-label">申请时间：</span>
            <span>{{ detail.createTime || '-' }}</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">请求类型：</span>
            <span>{{ requestTypeMap[detail.requestType] || '-' }}</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">审核状态：</span>
            <el-tag :type="auditStatusTag(detail.auditStatus)" size="small">
              {{ auditStatusMap[detail.auditStatus] || '未知' }}
            </el-tag>
          </div>
          <div v-if="detail.auditStatus !== 0 && detail.auditRemark" class="meta-item">
            <span class="meta-label">审核备注：</span>
            <span class="meta-remark">{{ detail.auditRemark }}</span>
          </div>
        </div>
        <div class="compare-section">
          <div class="compare-col">
            <h4>修改前</h4>
            <div class="compare-box">
              <pre>{{ formatJson(detail.oldData) }}</pre>
            </div>
          </div>
          <div class="compare-divider">→</div>
          <div class="compare-col">
            <h4>修改后</h4>
            <div class="compare-box">
              <pre>{{ formatJson(detail.newData) }}</pre>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getAuditRequests, getAuditRequestDetail, withdrawAuditRequest } from '@/api/order'

const requestTypeMap: Record<string, string> = {
  'GOODS_PUBLISH': '商品发布',
  'GOODS_EDIT': '商品编辑',
  'MERCHANT_INFO': '商家信息更改',
  'QUALIFICATION_UPGRADE': '企业资质升级'
}

const auditStatusMap: Record<number, string> = {
  0: '待审核',
  1: '通过',
  2: '驳回'
}

const auditStatusTag = (status: number): string => {
  if (status === 0) return 'primary'
  if (status === 1) return 'success'
  if (status === 2) return 'danger'
  return 'info'
}

const list = ref<any[]>([])
const loading = ref(false)
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

const detailDialogVisible = ref(false)
const detailLoading = ref(false)
const detail = ref<any>(null)

const loadList = async () => {
  loading.value = true
  try {
    const res = await getAuditRequests({ pageNum: pageNum.value, pageSize: pageSize.value })
    if (res.code === 0) {
      const data = res.data
      list.value = (data.list || data.records || []).map((item: any) => ({
        ...item,
        _withdrawing: false
      }))
      total.value = data.total || 0
    }
  } catch {
    // handled by interceptor
  } finally {
    loading.value = false
  }
}

const openDetail = async (row: any) => {
  detailDialogVisible.value = true
  detailLoading.value = true
  detail.value = null
  try {
    const res = await getAuditRequestDetail(row.id, row.requestType)
    if (res.code === 0) {
      detail.value = res.data
    }
  } catch {
    // handled by interceptor
  } finally {
    detailLoading.value = false
  }
}

const handleWithdraw = async (row: any) => {
  try {
    await ElMessageBox.confirm('确定要撤回该审核请求吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
  } catch {
    return
  }
  row._withdrawing = true
  try {
    const res = await withdrawAuditRequest(row.id, row.requestType)
    if (res.code === 0) {
      ElMessage.success('撤回成功')
      loadList()
    }
  } catch {
    // handled by interceptor
  } finally {
    row._withdrawing = false
  }
}

const formatJson = (data: any): string => {
  if (!data) return '-'
  if (typeof data === 'string') {
    try {
      const parsed = JSON.parse(data)
      return JSON.stringify(parsed, null, 2)
    } catch {
      return data
    }
  }
  return JSON.stringify(data, null, 2)
}

onMounted(() => {
  loadList()
})
</script>

<style scoped>
.audit-requests-page {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h2 {
  font-size: 20px;
  color: #1D2129;
  margin: 0;
}

.table-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
}

.text-muted {
  color: #C9CDD4;
}

.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  padding: 16px 0 0;
}

.empty-state {
  text-align: center;
  padding: 60px 0;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.empty-text {
  font-size: 14px;
  color: #86909C;
}

.detail-loading {
  text-align: center;
  padding: 40px;
  color: #86909C;
}

.detail-content {
  padding: 0;
}

.detail-meta {
  margin-bottom: 20px;
  padding: 16px;
  background: #F7F8FA;
  border-radius: 8px;
}

.meta-item {
  margin-bottom: 8px;
  font-size: 14px;
  color: #1D2129;
  line-height: 1.8;
}

.meta-item:last-child {
  margin-bottom: 0;
}

.meta-label {
  color: #86909C;
  margin-right: 4px;
}

.meta-remark {
  color: #FF4D4F;
}

.compare-section {
  display: flex;
  gap: 12px;
}

.compare-col {
  flex: 1;
}

.compare-col h4 {
  font-size: 14px;
  color: #1D2129;
  margin: 0 0 8px 0;
}

.compare-box {
  background: #F7F8FA;
  border-radius: 8px;
  padding: 12px;
  max-height: 400px;
  overflow-y: auto;
}

.compare-box pre {
  margin: 0;
  font-size: 12px;
  color: #4E5969;
  white-space: pre-wrap;
  word-break: break-all;
  font-family: 'Courier New', Courier, monospace;
}

.compare-divider {
  display: flex;
  align-items: center;
  font-size: 24px;
  color: #C9CDD4;
  flex-shrink: 0;
  padding-top: 30px;
}
</style>
