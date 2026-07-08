<template>
  <div class="ranking-page">
    <div class="page-header">
      <h2>商家星级评价排行</h2>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>商家ID</th>
            <th>商家名字</th>
            <th>联系人名字</th>
            <th>联系电话</th>
            <th>评价星级</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.merchantId">
            <td>{{ item.merchantId }}</td>
            <td>{{ item.merchantName }}</td>
            <td>{{ item.contactName || '-' }}</td>
            <td>{{ item.contactPhone || '-' }}</td>
            <td>
              <span class="stars">
                <span v-for="i in 5" :key="i" :class="i <= Math.round(item.avgRating) ? 'star-filled' : 'star-empty'">★</span>
              </span>
              <span class="rating-num">{{ item.avgRating != null ? Number(item.avgRating).toFixed(1) : '0.0' }}</span>
            </td>
          </tr>
          <tr v-if="list.length === 0 && !loading">
            <td colspan="5" class="empty-cell">暂无数据</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination" v-if="totalPages > 1">
      <button :disabled="currentPage <= 1" @click="changePage(currentPage - 1)" class="page-btn">&lt;</button>
      <button
        v-for="p in visiblePages"
        :key="p"
        :class="['page-num', { active: currentPage === p }]"
        @click="changePage(p)"
      >{{ p }}</button>
      <button :disabled="currentPage >= totalPages" @click="changePage(currentPage + 1)" class="page-btn">&gt;</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import request from '@/utils/request'

const list = ref<any[]>([])
const loading = ref(false)
const currentPage = ref(1)
const totalPages = ref(1)
const totalRecords = ref(0)
const pageSize = 15

const visiblePages = computed(() => {
  const pages: number[] = []
  const start = Math.max(1, currentPage.value - 2)
  const end = Math.min(totalPages.value, currentPage.value + 2)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})

const fetchData = async () => {
  loading.value = true
  try {
    const res = await request.get('/admin/dashboard/merchant-rating', {
      params: {
        sortOrder: 'asc',
        page: currentPage.value,
        pageSize
      }
    })
    if (res.code === 0) {
      list.value = res.data.merchants || []
      totalRecords.value = res.data.total || 0
      totalPages.value = Math.max(1, Math.ceil(totalRecords.value / pageSize))
    }
  } catch (e: any) {
    console.error('[星级评价排行] 请求异常:', e.message)
  } finally {
    loading.value = false
  }
}

const changePage = (p: number) => {
  currentPage.value = p
  fetchData()
}

onMounted(fetchData)
</script>

<style scoped>
.ranking-page {
  padding: 24px;
  max-width: 1100px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h2 {
  font-size: 20px;
  color: #1D2129;
  margin: 0;
}

.table-container {
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th,
.data-table td {
  padding: 14px 16px;
  text-align: center;
  border-bottom: 1px solid #F2F3F5;
  font-size: 13px;
  color: #4E5969;
}

.data-table th {
  background: #EDEEEF;
  font-weight: 600;
  color: #1D2129;
  font-size: 15px;
}

.data-table tbody tr:hover {
  background: #F7F8FA;
}

.empty-cell {
  color: #C9CDD4 !important;
  padding: 40px !important;
}

.stars {
  font-size: 16px;
  letter-spacing: 2px;
}

.star-filled {
  color: #F7BA2A;
}

.star-empty {
  color: #E5E6EB;
}

.rating-num {
  margin-left: 8px;
  font-weight: 600;
  color: #F7BA2A;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 6px;
  margin-top: 24px;
}

.page-btn,
.page-num {
  min-width: 36px;
  height: 36px;
  border: 1px solid #E5E6EB;
  background: #fff;
  border-radius: 6px;
  cursor: pointer;
  font-size: 14px;
  color: #4E5969;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.page-btn:hover:not(:disabled),
.page-num:hover {
  border-color: #165DFF;
  color: #165DFF;
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.page-num.active {
  background: #165DFF;
  color: #fff;
  border-color: #165DFF;
}
</style>
