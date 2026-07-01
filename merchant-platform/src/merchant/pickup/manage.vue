<template>
  <div class="pickup-manage">
    <h2>自提点管理</h2>

    <!-- 新增自提点 -->
    <div class="add-form">
      <h3>新增自提点</h3>
      <div class="form-row">
        <input v-model="form.name" placeholder="自提点名称" />
        <input v-model="form.address" placeholder="详细地址" />
        <input v-model="form.contactPhone" placeholder="联系电话" />
        <input v-model="form.image" placeholder="图片URL（选填）" />
        <button @click="handleAdd">新增</button>
      </div>
    </div>

    <!-- 自提点列表 -->
    <table border="1">
      <thead>
        <tr>
          <th>ID</th>
          <th>名称</th>
          <th>地址</th>
          <th>联系电话</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="item in list" :key="item.id || item.pointId">
          <td>{{ item.id || item.pointId }}</td>
          <td>{{ item.name }}</td>
          <td>{{ item.address }}</td>
          <td>{{ item.contactPhone }}</td>
          <td>{{ item.auditStatus === 0 ? '待审核' : item.auditStatus === 1 ? '已通过' : '已驳回' }}</td>
          <td>
            <button class="btn-danger" @click="handleDelete(item.id || item.pointId)">删除</button>
          </td>
        </tr>
        <tr v-if="list.length === 0">
          <td colspan="6" style="color:#999">暂无自提点</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getPickupPoints, addPickupPoint, deletePickupPoint } from '@/api/order'

const list = ref<any[]>([])
const form = ref({
  name: '',
  address: '',
  contactPhone: '',
  image: ''
})

const fetchList = async () => {
  const res = await getPickupPoints()
  if (res.code === 0) {
    list.value = res.data || []
  }
}

const handleAdd = async () => {
  if (!form.value.name || !form.value.address) {
    alert('名称和地址不能为空')
    return
  }
  const res = await addPickupPoint(form.value)
  if (res.code === 0) {
    alert('新增成功')
    form.value = { name: '', address: '', contactPhone: '', image: '' }
    fetchList()
  } else {
    alert(res.message || '新增失败')
  }
}

const handleDelete = async (id: number) => {
  if (!confirm('确认删除该自提点？')) return
  const res = await deletePickupPoint(id)
  if (res.code === 0) {
    alert('删除成功')
    fetchList()
  } else {
    alert(res.message || '删除失败')
  }
}

onMounted(() => {
  fetchList()
})
</script>

<style scoped>
.pickup-manage {
  padding: 24px;
}
h2 {
  margin-bottom: 20px;
  color: #1D2129;
}
h3 {
  margin-bottom: 12px;
  font-size: 15px;
  color: #4E5969;
}
.add-form {
  background: #f7f7f9;
  padding: 16px;
  border-radius: 6px;
  margin-bottom: 20px;
}
.form-row {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.form-row input {
  flex: 1;
  min-width: 150px;
  padding: 8px 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
}
button {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.btn-danger {
  background: #e74c3c;
}
table {
  width: 100%;
  border-collapse: collapse;
}
table th, table td {
  padding: 10px;
  text-align: center;
  border: 1px solid #eee;
  color: #4E5969;
}
</style>
