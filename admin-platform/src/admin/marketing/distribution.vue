<template>
  <div class="distribution-page">
    <h1>分销管理</h1>
    <p class="subtitle">管理分销员、查看分销数据与推广模版</p>

    <!-- Tab 切换 -->
    <div class="tab-bar">
      <button :class="['tab-btn', { active: activeTab === 'distributor' }]" @click="activeTab = 'distributor'">
        分销员管理
      </button>
      <button :class="['tab-btn', { active: activeTab === 'template' }]" @click="activeTab = 'template'">
        推广模版管理
      </button>
    </div>

    <!-- ========== 分销员管理 ========== -->
    <div v-if="activeTab === 'distributor'">
      <!-- 统计卡片 -->
      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-number">{{ stats.totalDistributors || 0 }}</div>
          <div class="stat-label">分销员总数</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">¥{{ formatPrice(stats.totalCommission) }}</div>
          <div class="stat-label">分销总金额</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">{{ stats.totalOrders || 0 }}</div>
          <div class="stat-label">分销订单数</div>
        </div>
      </div>

      <!-- 数据表格 -->
      <div class="table-wrap">
        <table class="data-table" v-if="list.length > 0">
          <thead>
            <tr>
              <th>分销员ID</th>
              <th>姓名</th>
              <th>用户ID</th>
              <th>加入时间</th>
              <th>累计佣金</th>
              <th>可提佣金</th>
              <th>状态</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in list" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.realName || '--' }}</td>
              <td>{{ item.userId }}</td>
              <td>{{ item.applyTime || '-' }}</td>
              <td>¥{{ formatPrice(item.totalCommission) }}</td>
              <td>¥{{ formatPrice(item.availableCommission) }}</td>
              <td>
                <span :class="['status-tag', item.status === 1 ? 'ACTIVE' : 'DISABLED']">
                  {{ item.status === 1 ? '正常' : '已禁用' }}
                </span>
              </td>
              <td>
                <button class="btn-detail" @click="openDetail(item)">查看详情</button>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="empty-state">
          <span class="empty-icon">📋</span>
          <span class="empty-text">暂无分销员数据</span>
        </div>
      </div>

      <!-- 分页 -->
      <div class="pagination" v-if="totalPages > 1">
        <button :disabled="pageNum <= 1" @click="pageNum--; loadList()">上一页</button>
        <span>{{ pageNum }} / {{ totalPages }}</span>
        <button :disabled="pageNum >= totalPages" @click="pageNum++; loadList()">下一页</button>
      </div>
    </div>

    <!-- ========== 推广模版管理（占位） ========== -->
    <div v-if="activeTab === 'template'" class="placeholder-card">
      <span class="placeholder-icon">🔧</span>
      <span class="placeholder-text">推广物料模版与链接模版管理功能开发中，敬请期待</span>
    </div>

    <!-- ========== 详情弹窗 ========== -->
    <div v-if="showDetail" class="modal-mask" @click.self="showDetail = false">
      <div class="modal-box detail-modal">
        <div class="modal-header">
          <h2>分销员详情</h2>
          <button class="close-btn" @click="showDetail = false">×</button>
        </div>

        <!-- 基本信息 -->
        <div class="info-section">
          <h3>基本信息</h3>
          <div class="info-grid">
            <div class="info-item">
              <span class="info-key">分销员ID：</span>
              <span class="info-val">{{ detail.distributorId }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">姓名：</span>
              <span class="info-val">{{ detail.realName }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">用户ID：</span>
              <span class="info-val">{{ detail.userId }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">加入时间：</span>
              <span class="info-val">{{ detail.applyTime || '-' }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">累计佣金：</span>
              <span class="info-val">¥{{ formatPrice(detail.totalCommission) }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">可提佣金：</span>
              <span class="info-val">¥{{ formatPrice(detail.availableCommission) }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">冻结佣金：</span>
              <span class="info-val">¥{{ formatPrice(detail.frozenCommission) }}</span>
            </div>
            <div class="info-item">
              <span class="info-key">状态：</span>
              <span :class="['status-tag', detail.status === 1 ? 'ACTIVE' : 'DISABLED']">
                {{ detail.status === 1 ? '正常' : '已禁用' }}
              </span>
            </div>
          </div>
        </div>

        <!-- 推广商品 -->
        <div class="info-section">
          <h3>推广商品（{{ detail.products ? detail.products.length : 0 }}个）</h3>
          <table class="data-table" v-if="detail.products && detail.products.length > 0">
            <thead>
              <tr>
                <th>商品图片</th>
                <th>商品名称</th>
                <th>佣金比例</th>
                <th>推广码</th>
                <th>带来订单数</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="p in detail.products" :key="p.productId">
                <td>
                  <img v-if="p.productImage" :src="p.productImage" class="product-thumb" />
                  <span v-else>-</span>
                </td>
                <td>{{ p.productTitle }}</td>
                <td>{{ p.commissionRate }}%</td>
                <td>{{ p.promotionCode }}</td>
                <td>{{ p.orderCount || 0 }}</td>
              </tr>
            </tbody>
          </table>
          <div v-else class="empty-state small">
            <span class="empty-text">暂无推广商品</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const activeTab = ref('distributor')

// 统计
const stats = ref({ totalDistributors: 0, totalCommission: 0, totalOrders: 0 })

// 列表
const list = ref<any[]>([])
const pageNum = ref(1)
const totalPages = ref(1)

// 详情弹窗
const showDetail = ref(false)
const detail = ref<any>({})

const formatPrice = (val: any) => {
  if (val === null || val === undefined) return '0.00'
  return Number(val).toFixed(2)
}

// 加载统计数据
const loadStats = async () => {
  try {
    const res = await request.get('/admin/distributor/stats')
    if (res.code === 0) {
      stats.value = res.data
    }
  } catch (e: any) {
    console.error('[分销管理] 统计加载失败:', e.message)
  }
}

// 加载分销员列表
const loadList = async () => {
  try {
    const res = await request.get('/admin/distributor/list', { params: { pageNum: pageNum.value, pageSize: 10 } })
    if (res.code === 0) {
      const d = res.data
      list.value = d.list || d.records || []
      const total = d.total || list.value.length
      totalPages.value = Math.max(1, Math.ceil(total / 10))
    }
  } catch (e: any) {
    console.error('[分销管理] 列表加载失败:', e.message)
  }
}

// 打开详情
const openDetail = async (item: any) => {
  showDetail.value = true
  detail.value = {}
  try {
    const res = await request.get(`/admin/distributor/detail/${item.id}`)
    if (res.code === 0) {
      detail.value = res.data
    }
  } catch (e: any) {
    console.error('[分销管理] 详情加载失败:', e.message)
  }
}

onMounted(() => {
  loadStats()
  loadList()
})
</script>

<style scoped>
.distribution-page { padding: 24px; }
h1 { font-size: 20px; color: #2D2D2D; margin-bottom: 4px; }
.subtitle { font-size: 13px; color: #999; margin-bottom: 16px; }

/* Tab */
.tab-bar { display: flex; gap: 0; margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; }
.tab-btn { padding: 10px 24px; background: none; border: none; font-size: 14px; color: #666; cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all .2s; }
.tab-btn:hover { color: #165DFF; }
.tab-btn.active { color: #165DFF; border-bottom-color: #165DFF; font-weight: 600; }

/* 统计卡片 */
.stats-row { display: flex; gap: 16px; margin-bottom: 20px; }
.stat-card { flex: 1; background: #fff; border-radius: 8px; padding: 20px; text-align: center; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
.stat-number { font-size: 28px; font-weight: 700; color: #1D2129; margin-bottom: 6px; }
.stat-label { font-size: 13px; color: #86909C; }

/* 表格 */
.table-wrap { background: #fff; border-radius: 6px; overflow: hidden; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table th, .data-table td { padding: 10px 14px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
.data-table th { background: #fafafa; color: #555; font-weight: 600; }
.data-table td { color: #333; }

.status-tag { padding: 2px 8px; border-radius: 4px; font-size: 12px; }
.status-tag.ACTIVE { background: #F6FFED; color: #52C41A; }
.status-tag.DISABLED { background: #FFF2F0; color: #FF4D4F; }

.btn-detail { padding: 4px 14px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
.btn-detail:hover { background: #0e4ad0; }

.empty-state { display: flex; flex-direction: column; align-items: center; padding: 40px; color: #999; }
.empty-state.small { padding: 20px; }
.empty-icon { font-size: 36px; margin-bottom: 8px; }

.pagination { display: flex; justify-content: center; gap: 16px; margin-top: 20px; align-items: center; font-size: 13px; color: #666; }
.pagination button { padding: 6px 14px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: .4; cursor: default; }

/* 占位卡片 */
.placeholder-card { display: flex; flex-direction: column; align-items: center; padding: 80px 20px; background: #fff; border-radius: 8px; }
.placeholder-icon { font-size: 48px; margin-bottom: 16px; }
.placeholder-text { font-size: 14px; color: #999; }

/* 弹窗 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,.55); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.detail-modal { width: 780px; max-height: 80vh; overflow-y: auto; }
.modal-box { background: #fff; border-radius: 8px; padding: 24px; }
.modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
.modal-header h2 { font-size: 17px; margin: 0; }
.close-btn { background: none; border: none; font-size: 22px; color: #999; cursor: pointer; }
.close-btn:hover { color: #333; }

.info-section { margin-bottom: 20px; }
.info-section h3 { font-size: 14px; color: #333; margin-bottom: 10px; padding-bottom: 6px; border-bottom: 1px solid #f0f0f0; }
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 24px; }
.info-item { display: flex; font-size: 13px; }
.info-key { color: #86909C; min-width: 75px; }
.info-val { color: #1D2129; }

.product-thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 4px; border: 1px solid #e8e8e8; }
</style>
