<template>
  <div class="user-page">
    <div class="page-header">
      <h1>用户管理</h1>
      <div class="header-right">
        <input v-model="searchKeyword" placeholder="搜索手机号/昵称" class="search-input" />
        <select v-model="userType" class="filter-select">
          <option value="ALL">全部类型</option>
          <option value="NORMAL">普通用户</option>
          <option value="MEMBER">会员用户</option>
          <option value="DISTRIBUTOR">分销员</option>
        </select>
        <button @click="search" class="search-btn">搜索</button>
      </div>
    </div>

    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-value">{{ stats.totalUsers }}</div>
        <div class="stat-label">总用户数</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.memberCount }}</div>
        <div class="stat-label">会员用户</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.distributorCount }}</div>
        <div class="stat-label">分销员</div>
      </div>
      <div class="stat-card">
        <div class="stat-value">{{ stats.todayRegister }}</div>
        <div class="stat-label">今日注册</div>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>用户ID</th>
            <th>头像</th>
            <th>昵称</th>
            <th>手机号</th>
            <th>用户类型</th>
            <th>会员等级</th>
            <th>积分/成长值</th>
            <th>注册时间</th>
            <th>状态</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in userList" :key="user.userId">
            <td>{{ user.userId }}</td>
            <td><img :src="user.avatar" class="avatar-sm" /></td>
            <td>{{ user.nickname }}</td>
            <td>{{ user.phone }}</td>
            <td><span :class="['type-tag', user.userType]">{{ getUserTypeText(user.userType) }}</span></td>
            <td>{{ user.memberLevel || '-' }}</td>
            <td>{{ user.points }}分 / {{ user.growth }}成长值</td>
            <td>{{ user.registerTime }}</td>
            <td><span :class="['status-tag', user.status]">{{ user.status === 'NORMAL' ? '正常' : '禁用' }}</span></td>
            <td class="actions">
              <button class="action-btn view" @click="viewDetail(user)">查看</button>
              <button v-if="user.status === 'NORMAL'" class="action-btn warn" @click="disableUser(user)">禁用</button>
              <button v-else class="action-btn success" @click="enableUser(user)">启用</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="userList.length === 0" class="empty-state">
      <div class="empty-icon">👥</div>
      <div class="empty-text">暂无用户</div>
    </div>

    <div class="pagination">
      <button :disabled="currentPage <= 1" @click="currentPage--" class="page-btn">上一页</button>
      <span class="page-info">第{{ currentPage }}页 / 共{{ totalPages }}页</span>
      <button :disabled="currentPage >= totalPages" @click="currentPage++" class="page-btn">下一页</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getUserList, updateUserStatus, getUserDetail } from '@/api/system'

interface User {
  userId: number
  nickname: string
  phone: string
  avatar: string
  userType: string
  memberLevel: string
  points: number
  growth: number
  registerTime: string
  status: string
}

const searchKeyword = ref('')
const userType = ref('ALL')
const currentPage = ref(1)
const totalPages = ref(1)
const totalCount = ref(0)
const pageSize = ref(10)

const stats = ref({
  totalUsers: 0,
  memberCount: 0,
  distributorCount: 0,
  todayRegister: 0
})

const userList = ref<User[]>([])

const getUserTypeText = (type: string) => {
  const map: Record<string, string> = {
    NORMAL: '普通用户',
    MEMBER: '会员用户',
    DISTRIBUTOR: '分销员'
  }
  return map[type] || type
}

const loadData = async () => {
  const params: any = {
    page: currentPage.value,
    pageSize: pageSize.value
  }
  if (searchKeyword.value) {
    params.keyword = searchKeyword.value
  }
  if (userType.value !== 'ALL') {
    params.userType = userType.value
  }
  const res = await getUserList(params)
  if (res.code === 0) {
    userList.value = res.data.list || res.data || []
    totalCount.value = res.data.total || userList.value.length
    totalPages.value = Math.ceil(totalCount.value / pageSize.value)
  }
}

const search = () => {
  currentPage.value = 1
  loadData()
}

const viewDetail = async (user: User) => {
  const res = await getUserDetail(user.userId)
  if (res.code === 0) {
    const data = res.data
    alert(`用户详情：\n用户ID：${data.userId}\n昵称：${data.nickname}\n手机号：${data.phone}\n会员等级：${data.memberLevel || '无'}\n积分：${data.points}\n成长值：${data.growth}`)
  }
}

const disableUser = async (user: User) => {
  if (confirm(`确定禁用用户 ${user.nickname} 吗？`)) {
    const res = await updateUserStatus(user.userId, { status: 'DISABLED' })
    if (res.code === 0) {
      alert(`用户 ${user.nickname} 已被禁用`)
      loadData()
    }
  }
}

const enableUser = async (user: User) => {
  if (confirm(`确定启用用户 ${user.nickname} 吗？`)) {
    const res = await updateUserStatus(user.userId, { status: 'NORMAL' })
    if (res.code === 0) {
      alert(`用户 ${user.nickname} 已被启用`)
      loadData()
    }
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.user-page {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 22px;
  color: #1D2129;
}

.header-right {
  display: flex;
  gap: 10px;
  align-items: center;
}

.search-input {
  padding: 8px 16px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  width: 200px;
  font-size: 14px;
}

.filter-select {
  padding: 8px 12px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.search-btn {
  padding: 8px 20px;
  background: #165DFF;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.stats-row {
  display: flex;
  gap: 16px;
  margin-bottom: 20px;
}

.stat-card {
  flex: 1;
  background: white;
  padding: 16px;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.stat-value {
  font-size: 24px;
  font-weight: bold;
  color: #165DFF;
}

.stat-label {
  font-size: 12px;
  color: #86909C;
  margin-top: 4px;
}

.table-container {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th, .data-table td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #f0f0f0;
}

.data-table th {
  background: #F2F3F5;
  font-size: 14px;
  color: #4E5969;
  font-weight: 600;
}

.data-table td {
  font-size: 14px;
  color: #1D2129;
}

.avatar-sm {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.type-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.type-tag.NORMAL { background: #F5F5F5; color: #86909C; }
.type-tag.MEMBER { background: #FFF7E6; color: #E67E22; }
.type-tag.DISTRIBUTOR { background: #E6F7FF; color: #1890FF; }

.status-tag {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.status-tag.NORMAL { background: #F6FFED; color: #52C41A; }
.status-tag.DISABLED { background: #FFF2F0; color: #FF4D4F; }

.actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 4px 10px;
  border: none;
  border-radius: 4px;
  font-size: 12px;
  cursor: pointer;
}

.action-btn.view {
  background: #F2F3F5;
  color: #4E5969;
}

.action-btn.warn {
  background: #FFF2F0;
  color: #FF4D4F;
}

.action-btn.success {
  background: #F6FFED;
  color: #52C41A;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 0;
  background: white;
  border-radius: 8px;
  margin-top: 20px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 14px;
  color: #86909C;
}

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
  color: #4E5969;
}
</style>