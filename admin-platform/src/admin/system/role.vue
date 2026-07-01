<template>
  <div class="role-page">
    <div class="page-header">
      <h2>角色管理</h2>
      <button class="add-btn" @click="showAddModal = true">+ 添加角色</button>
    </div>

    <div class="role-list">
      <div v-for="role in roleList" :key="role.id" class="role-card">
        <div class="role-header">
          <span class="role-name">{{ role.roleName || role.name }}</span>
          <span :class="['role-status', role.status === 1 ? 'active' : 'inactive']">
            {{ role.status === 1 ? '启用' : '禁用' }}
          </span>
        </div>
        <div class="role-info">
          <p class="role-code">角色编码: {{ role.roleCode || role.code }}</p>
          <p class="role-desc">{{ role.description || '暂无描述' }}</p>
        </div>
        <div class="role-permissions">
          <div class="perm-label">权限菜单:</div>
          <div class="perm-tags">
            <span v-for="perm in role.permissions || role.permissionList || []" :key="perm.label || perm" class="perm-tag">{{ perm.label || perm }}</span>
          </div>
        </div>
        <div class="role-actions">
          <button class="action-btn edit" @click="editRole(role)">编辑</button>
          <button class="action-btn delete" @click="deleteRole(role)">删除</button>
          <button v-if="role.status === 1" class="action-btn disable" @click="toggleStatus(role, 0)">禁用</button>
          <button v-else class="action-btn enable" @click="toggleStatus(role, 1)">启用</button>
        </div>
      </div>
    </div>

    <div v-if="showAddModal" class="modal-mask" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ editingRole ? '编辑角色' : '添加角色' }}</h3>
          <button class="close-btn" @click="closeModal">×</button>
        </div>
        <div class="modal-body">
          <div class="form-item">
            <label>角色名称</label>
            <input v-model="form.name" placeholder="请输入角色名称" />
          </div>
          <div class="form-item">
            <label>角色编码</label>
            <input v-model="form.code" placeholder="请输入角色编码（如 SYSTEM）" />
          </div>
          <div class="form-item">
            <label>角色描述</label>
            <textarea v-model="form.description" placeholder="请输入角色描述"></textarea>
          </div>
          <div class="form-item">
            <label>权限菜单</label>
            <div class="permission-tree">
              <div v-for="menu in permissionMenus" :key="menu.path">
                <label class="menu-label">
                  <input type="checkbox" :checked="form.permissionIds.includes(menu.id)" @change="togglePermission(menu.id)" />
                  {{ menu.icon }} {{ menu.label }}
                </label>
                <div v-if="menu.children" class="sub-menu">
                  <label v-for="child in menu.children" :key="child.path" class="sub-label">
                    <input type="checkbox" :checked="form.permissionIds.includes(child.id)" @change="togglePermission(child.id)" />
                    {{ child.label }}
                  </label>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="cancel-btn" @click="closeModal">取消</button>
          <button class="confirm-btn" @click="submitRole">{{ editingRole ? '保存修改' : '添加角色' }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getRoleList, createRole, updateRole, deleteRole as deleteRoleApi, getPermissionList } from '@/api/system'

const showAddModal = ref(false)
const editingRole = ref<any>(null)

const form = reactive({
  name: '',
  code: '',
  description: '',
  permissionIds: [] as number[]
})

const roleList = ref<any[]>([])

const permissionMenus = ref<any[]>([
  { path: '/dashboard', label: '运营看板', icon: '📊' },
  { 
    path: '/merchant-audit', 
    label: '审核管理', 
    icon: '✅',
    children: [
      { path: '/merchant-audit', label: '商家审核' },
      { path: '/product-audit', label: '商品审核' }
    ]
  },
  { 
    path: '/users', 
    label: '系统管理', 
    icon: '⚙️',
    children: [
      { path: '/users', label: '用户管理' },
      { path: '/orders', label: '订单管理' },
      { path: '/roles', label: '角色管理' }
    ]
  },
  { 
    path: '/seckill', 
    label: '营销管理', 
    icon: '🎯',
    children: [
      { path: '/seckill', label: '秒杀活动' },
      { path: '/coupon', label: '优惠券管理' },
      { path: '/distribution', label: '分销管理' }
    ]
  }
])

const loadRoles = async () => {
  const res = await getRoleList()
  if (res.code === 0) {
    roleList.value = res.data || []
  }
}

const loadPermissions = async () => {
  const res = await getPermissionList()
  if (res.code === 0) {
    permissionMenus.value = res.data || permissionMenus.value
  }
}

const editRole = (role: any) => {
  editingRole.value = role
  form.name = role.roleName || role.name
  form.code = role.roleCode || role.code
  form.description = role.description || ''
  form.permissionIds = role.permissionIds || []
  showAddModal.value = true
}

const deleteRole = async (role: any) => {
  if (confirm(`确定要删除角色「${role.roleName || role.name}」吗？`)) {
    const res = await deleteRoleApi(role.id)
    if (res.code === 0) {
      alert('角色删除成功')
      loadRoles()
    }
  }
}

const toggleStatus = (role: any, status: number) => {
  role.status = status
}

const togglePermission = (label: string) => {
  const index = form.permissionIds.indexOf(label)
  if (index > -1) {
    form.permissionIds.splice(index, 1)
  } else {
    form.permissionIds.push(label)
  }
}

const closeModal = () => {
  showAddModal.value = false
  editingRole.value = null
  form.name = ''
  form.code = ''
  form.description = ''
  form.permissionIds = []
}

const submitRole = async () => {
  if (!form.name || !form.code) {
    alert('角色名称和编码不能为空')
    return
  }
  if (editingRole.value) {
    const res = await updateRole(editingRole.value.id, {
      roleName: form.name,
      description: form.description,
      permissionIds: form.permissionIds
    })
    if (res.code === 0) {
      alert('角色修改成功')
      loadRoles()
    }
  } else {
    const res = await createRole({
      roleName: form.name,
      roleCode: form.code,
      description: form.description,
      permissionIds: form.permissionIds
    })
    if (res.code === 0) {
      alert('角色添加成功')
      loadRoles()
    }
  }
  closeModal()
}

onMounted(() => {
  loadRoles()
  loadPermissions()
})
</script>

<style scoped>
.role-page {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  font-size: 20px;
  color: #1D2129;
}

.add-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.role-list {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.role-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.role-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.role-name {
  font-size: 16px;
  font-weight: 600;
  color: #1D2129;
}

.role-status {
  font-size: 12px;
  padding: 2px 8px;
  border-radius: 4px;
}

.role-status.active {
  background: #F6FFED;
  color: #52C41A;
}

.role-status.inactive {
  background: #FFF2F0;
  color: #FF4D4F;
}

.role-info {
  margin-bottom: 12px;
}

.role-code {
  font-size: 13px;
  color: #86909C;
  margin-bottom: 4px;
}

.role-desc {
  font-size: 13px;
  color: #4E5969;
}

.role-permissions {
  margin-bottom: 16px;
}

.perm-label {
  font-size: 12px;
  color: #86909C;
  margin-bottom: 6px;
}

.perm-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.perm-tag {
  font-size: 12px;
  padding: 2px 8px;
  background: #F2F3F5;
  color: #4E5969;
  border-radius: 4px;
}

.role-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
}

.action-btn.edit {
  background: #E6F7FF;
  color: #1890FF;
}

.action-btn.delete {
  background: #FFF2F0;
  color: #FF4D4F;
}

.action-btn.disable {
  background: #FFF7E6;
  color: #FA8C16;
}

.action-btn.enable {
  background: #F6FFED;
  color: #52C41A;
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  width: 500px;
  background: white;
  border-radius: 8px;
  overflow: hidden;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid #f0f0f0;
}

.modal-header h3 {
  font-size: 16px;
  color: #1D2129;
  margin: 0;
}

.close-btn {
  font-size: 20px;
  background: none;
  border: none;
  cursor: pointer;
  color: #86909C;
}

.modal-body {
  padding: 20px;
}

.form-item {
  margin-bottom: 16px;
}

.form-item label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  color: #4E5969;
}

.form-item input, .form-item textarea {
  width: 100%;
  box-sizing: border-box;
  padding: 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
}

.form-item textarea {
  height: 80px;
  resize: vertical;
}

.permission-tree {
  max-height: 300px;
  overflow-y: auto;
}

.menu-label {
  display: block;
  padding: 8px 0;
  font-size: 14px;
  color: #1D2129;
}

.sub-menu {
  padding-left: 20px;
}

.sub-label {
  display: block;
  padding: 6px 0;
  font-size: 13px;
  color: #4E5969;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 20px;
  border-top: 1px solid #f0f0f0;
}

.cancel-btn {
  padding: 8px 16px;
  background: #F2F3F5;
  color: #4E5969;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.confirm-btn {
  padding: 8px 16px;
  background: #165DFF;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>