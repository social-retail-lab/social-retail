<template>
  <div class="info-change-audit">
    <h2>商家信息审核</h2>
    <div class="search-bar">
      <input placeholder="店铺名称 / 请求类型" v-model="keyword" />
      <select v-model="auditStatusFilter">
        <option value="">全部状态</option>
        <option value="0">待审核</option>
        <option value="1">审核通过</option>
        <option value="2">审核驳回</option>
      </select>
      <button @click="getList">查询</button>
    </div>
    <table border="1">
      <thead>
        <tr>
          <th>请求ID</th>
          <th>商家名称</th>
          <th>请求类型</th>
          <th>申请时间</th>
          <th>审核状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in tableList" :key="item.id">
          <td>{{ item.id }}</td>
          <td>{{ item.merchantName }}</td>
          <td>{{ requestTypeText(item.requestType) }}</td>
          <td>{{ item.createTime }}</td>
          <td>{{ auditMap[item.auditStatus] || '待审核' }}</td>
          <td>
            <button
              v-if="item.auditStatus === 0"
              @click="openAudit(item)"
            >审核</button>
            <button
              v-else
              class="btn-done"
              disabled
            >已审核</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div class="page">
      <button :disabled="page === 1" @click="page--; getList()">上一页</button>
      <span>第{{ page }}页 / 共{{ total }}条</span>
      <button :disabled="page * pageSize >= total" @click="page++; getList()">下一页</button>
    </div>

    <!-- 审核弹窗 -->
    <div v-if="showMask" class="mask" @click.self="showMask = false">
      <div class="dialog">
        <h3>信息变更审核</h3>
        <div v-if="currentItem">
          <p><b>请求ID：</b>{{ currentItem.id }}</p>
          <p><b>商家：</b>{{ currentItem.merchantName }}</p>
          <p><b>请求类型：</b>{{ requestTypeText(currentItem.requestType) }}</p>
          <div class="compare">
            <div class="compare-col">
              <h4 class="old-label">原信息</h4>
              <div class="compare-item" v-for="(val, key) in parsedOld" :key="key">
                <label>{{ fieldLabel(String(key)) }}</label>
                <span>{{ val || '-' }}</span>
              </div>
            </div>
            <div class="compare-col">
              <h4 class="new-label">新信息</h4>
              <div class="compare-item" v-for="(val, key) in parsedNew" :key="key">
                <label>{{ fieldLabel(String(key)) }}</label>
                <span class="highlight">{{ val || '-' }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="form-item">
          <label>审核结果</label>
          <select v-model="curAuditStatus">
            <option value="1">审核通过</option>
            <option value="2">驳回申请</option>
          </select>
        </div>
        <div class="form-item">
          <label>审核备注</label>
          <input v-model="remark" placeholder="填写审核意见" />
        </div>
        <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:20px">
          <button @click="showMask = false">取消</button>
          <button style="background:#165DFF;color:#fff" @click="submitAudit">确认提交</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { getInfoChanges, auditInfoChange } from '@/api/admin'

const keyword = ref('')
const auditStatusFilter = ref('')
const page = ref(1)
const pageSize = 10
const total = ref(0)
const tableList = ref<any[]>([])
const auditMap: Record<string, string> = { '0': '待审核', '1': '通过', '2': '驳回' }

const showMask = ref(false)
const currentItem = ref<any>(null)
const curChangeId = ref(0)
const curAuditStatus = ref(1)
const remark = ref('')

const requestTypeText = (t: string) => {
  const map: Record<string, string> = {
    'INFO_CHANGE': '商家信息更改',
    'QUALIFICATION_UPGRADE': '企业资质升级'
  }
  return map[t] || t
}

const fieldLabel = (key: string) => {
  const map: Record<string, string> = {
    merchantName: '店铺名称', shopName: '店铺名称',
    contactName: '联系人', contactPhone: '联系电话',
    shopAddress: '店铺地址', businessHours: '营业时间',
    introduction: '店铺简介',
    companyName: '企业名称', licenseNumber: '营业执照号',
    licenseImage: '营业执照', foodPermitNumber: '食品许可证号',
    foodPermitImage: '食品许可证'
  }
  return map[key] || key
}

const parsedOld = computed(() => {
  if (!currentItem.value?.oldData) return {}
  return typeof currentItem.value.oldData === 'string'
    ? JSON.parse(currentItem.value.oldData)
    : currentItem.value.oldData
})

const parsedNew = computed(() => {
  if (!currentItem.value?.newData) return {}
  return typeof currentItem.value.newData === 'string'
    ? JSON.parse(currentItem.value.newData)
    : currentItem.value.newData
})

const getList = async () => {
  try {
    const data = await getInfoChanges({
      keyword: keyword.value || undefined,
      auditStatus: auditStatusFilter.value !== '' ? Number(auditStatusFilter.value) : undefined,
      pageNum: page.value,
      pageSize
    })
    tableList.value = data.list || []
    total.value = data.total || 0
  } catch (e: any) {
    alert(e.message)
  }
}

const openAudit = (row: any) => {
  currentItem.value = row
  curChangeId.value = row.id
  remark.value = ''
  curAuditStatus.value = 1
  showMask.value = true
}

const submitAudit = async () => {
  try {
    await auditInfoChange(curChangeId.value, {
      auditStatus: curAuditStatus.value,
      remark: remark.value
    })
    alert('审核完成')
    showMask.value = false
    getList()
  } catch (e: any) {
    alert(e.message)
  }
}

getList()
</script>

<style scoped>
.info-change-audit {
  width: 1000px;
  margin: 40px auto;
  padding: 30px;
  background: #FFFFFF;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}
h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #1D2129;
}
.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}
input, select, button {
  padding: 7px 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
button {
  background: #165DFF;
  color: #fff;
  border: none;
  cursor: pointer;
}
.btn-done {
  background: #C9CDD4 !important;
  color: #fff !important;
  cursor: not-allowed !important;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0;
}
table th, table td {
  padding: 8px;
  text-align: center;
  border: 1px solid #eee;
  color: #4E5969;
}
.page {
  display: flex;
  gap: 12px;
  align-items: center;
  color: #4E5969;
}
.mask {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.dialog {
  background: #fff;
  padding: 24px;
  border-radius: 8px;
  min-width: 650px;
  max-height: 80vh;
  overflow-y: auto;
}
.dialog p { margin: 4px 0; color: #4E5969; font-size: 14px; }
.compare { display: flex; gap: 16px; margin: 12px 0; }
.compare-col { flex: 1; }
.compare-col h4 { margin-bottom: 6px; font-size: 13px; }
.old-label { color: #86909C; }
.new-label { color: #165DFF; }
.compare-item { display: flex; padding: 3px 0; font-size: 13px; border-bottom: 1px solid #f0f0f0; }
.compare-item label { width: 100px; color: #86909C; flex-shrink: 0; }
.compare-item span { color: #1D2129; word-break: break-all; }
.compare-item .highlight { color: #165DFF; }
.form-item { margin-bottom: 14px; }
label { display: block; margin-bottom: 6px; color: #4E5969; }
input { width: 100%; box-sizing: border-box; padding: 9px; border: 1px solid #ddd; border-radius: 4px; }
select { width: 100%; box-sizing: border-box; padding: 9px; border: 1px solid #ddd; border-radius: 4px; }
</style>
