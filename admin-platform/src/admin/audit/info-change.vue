<template>
  <div class="info-change-page">
    <div class="page-header">
      <h2>商家信息审核</h2>
    </div>

    <div class="search-bar">
      <el-input
        v-model="keyword"
        placeholder="搜索商家名称"
        clearable
        style="width: 240px"
        @keyup.enter="getList"
      />
      <el-select v-model="auditStatus" placeholder="审核状态" clearable style="width: 160px" @change="getList">
        <el-option label="全部" :value="undefined" />
        <el-option label="待审核" :value="0" />
        <el-option label="审核通过" :value="1" />
        <el-option label="已驳回" :value="2" />
      </el-select>
      <el-button type="primary" @click="getList">查询</el-button>
    </div>

    <el-table :data="list" border stripe v-loading="loading" style="width: 100%">
      <el-table-column prop="id" label="ID" width="80" align="center" />
      <el-table-column prop="merchantName" label="商家名称" min-width="160" />
      <el-table-column prop="changeType" label="请求类型" width="180" align="center">
        <template #default="{ row }">
          <el-tag :type="row.changeType === 'QUALIFICATION_UPGRADE' ? 'warning' : 'info'" size="small">
            {{ changeTypeMap[row.changeType] || row.changeType }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="auditStatus" label="审核状态" width="120" align="center">
        <template #default="{ row }">
          <el-tag :type="statusTagType[row.auditStatus]" size="small">
            {{ auditMap[row.auditStatus] }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="auditRemark" label="审核备注" min-width="160">
        <template #default="{ row }">
          <span v-if="row.auditRemark" style="color: #86909C">{{ row.auditRemark }}</span>
          <span v-else style="color: #C9CDD4">-</span>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="提交时间" width="180" align="center" />
      <el-table-column label="操作" width="140" align="center" fixed="right">
        <template #default="{ row }">
          <el-button
            v-if="row.auditStatus === 0"
            type="primary"
            size="small"
            @click="openAudit(row)"
          >
            审核
          </el-button>
          <el-button
            v-else
            type="info"
            size="small"
            disabled
          >
            已审核
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <div class="pagination-wrap">
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @current-change="getList"
        @size-change="getList"
      />
    </div>

    <el-dialog v-model="dialogVisible" title="审核详情" width="800px" top="5vh" :close-on-click-modal="false">
      <div class="compare-container">
        <div class="compare-left">
          <h4>旧版信息</h4>
          <div class="info-block" v-if="currentRow.oldData">
            <div class="info-item" v-for="(value, key) in parseData(currentRow.oldData)" :key="key">
              <span class="info-label">{{ key }}：</span>
              <span class="info-value">{{ value }}</span>
            </div>
          </div>
          <div v-else class="no-data">暂无旧版数据</div>
        </div>
        <div class="compare-right">
          <h4>新版信息</h4>
          <div class="info-block" v-if="currentRow.newData">
            <div class="info-item" v-for="(value, key) in parseData(currentRow.newData)" :key="key">
              <span class="info-label">{{ key }}：</span>
              <span :class="['info-value', { changed: isChanged(key) }]">{{ value }}</span>
            </div>
          </div>
          <div v-else class="no-data">暂无新版数据</div>
        </div>
      </div>

      <template #footer>
        <div class="dialog-footer" v-if="currentRow.auditStatus === 0">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="danger" @click="submitAudit(2)">驳回</el-button>
          <el-button type="success" @click="submitAudit(1)">审核通过</el-button>
        </div>
        <div class="dialog-footer" v-else>
          <el-button @click="dialogVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoChanges, auditInfoChange } from '@/api/audit'

const keyword = ref('')
const auditStatus = ref<number | undefined>(undefined)
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)
const list = ref<any[]>([])
const loading = ref(false)

const dialogVisible = ref(false)
const currentRow = ref<any>({})

const auditMap: Record<number, string> = { 0: '待审核', 1: '审核通过', 2: '已驳回' }
const statusTagType: Record<number, string> = { 0: 'warning', 1: 'success', 2: 'danger' }
const changeTypeMap: Record<string, string> = {
  INFO_CHANGE: '商家信息更改',
  QUALIFICATION_UPGRADE: '企业资质升级'
}

const parseData = (data: any): Record<string, any> => {
  if (!data) return {}
  if (typeof data === 'string') {
    try {
      return JSON.parse(data)
    } catch {
      return { data }
    }
  }
  return data
}

const isChanged = (key: string): boolean => {
  const oldData = parseData(currentRow.value.oldData)
  const newData = parseData(currentRow.value.newData)
  return JSON.stringify(oldData[key]) !== JSON.stringify(newData[key])
}

const getList = async () => {
  loading.value = true
  try {
    const params: any = {
      pageNum: pageNum.value,
      pageSize: pageSize.value
    }
    if (keyword.value) params.keyword = keyword.value
    if (auditStatus.value !== undefined && auditStatus.value !== '') params.auditStatus = auditStatus.value

    const res = await getInfoChanges(params)
    if (res.code === 0) {
      const data = res.data
      list.value = data.list || data.records || []
      total.value = data.total || 0
    } else {
      ElMessage.error(res.msg || '获取列表失败')
    }
  } catch {
    ElMessage.error('网络错误')
  } finally {
    loading.value = false
  }
}

const openAudit = (row: any) => {
  currentRow.value = row
  dialogVisible.value = true
}

const submitAudit = async (auditStatus: number) => {
  try {
    const res = await auditInfoChange(currentRow.value.id, {
      auditStatus,
      auditRemark: ''
    })
    if (res.code === 0) {
      ElMessage.success('审核完成')
      dialogVisible.value = false
      getList()
    } else {
      ElMessage.error(res.msg || '审核失败')
    }
  } catch {
    ElMessage.error('网络错误')
  }
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.info-change-page {
  padding: 24px;
  background: #fff;
  margin: 20px;
  border-radius: 8px;
  min-height: calc(100vh - 120px);
}

.page-header h2 {
  font-size: 18px;
  color: #1D2129;
  margin: 0 0 20px 0;
}

.search-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  align-items: center;
}

.pagination-wrap {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.compare-container {
  display: flex;
  gap: 20px;
}

.compare-left,
.compare-right {
  flex: 1;
  border: 1px solid #E5E6EB;
  border-radius: 8px;
  padding: 16px;
  background: #FAFAFA;
}

.compare-left h4,
.compare-right h4 {
  font-size: 15px;
  color: #1D2129;
  margin: 0 0 12px 0;
  padding-bottom: 8px;
  border-bottom: 1px solid #E5E6EB;
}

.info-block {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.info-item {
  display: flex;
  font-size: 13px;
  line-height: 1.8;
}

.info-label {
  color: #86909C;
  min-width: 100px;
  flex-shrink: 0;
}

.info-value {
  color: #1D2129;
  word-break: break-all;
}

.info-value.changed {
  color: #F53F3F;
  font-weight: 600;
}

.no-data {
  color: #C9CDD4;
  font-size: 13px;
  text-align: center;
  padding: 30px 0;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}
</style>
