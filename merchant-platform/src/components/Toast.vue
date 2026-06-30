<template>
  <Teleport to="body">
    <div class="toast-container">
      <transition-group name="toast-fade">
        <div
          v-for="t in toasts"
          :key="t.id"
          :class="['toast-item', 'toast-' + t.type]"
        >
          {{ t.message }}
        </div>
      </transition-group>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface ToastItem {
  id: number
  message: string
  type: 'success' | 'error' | 'info'
}

const toasts = ref<ToastItem[]>([])
let nextId = 1

const show = (message: string, type: 'success' | 'error' | 'info' = 'info') => {
  const id = nextId++
  toasts.value.push({ id, message, type })
  setTimeout(() => {
    const idx = toasts.value.findIndex(t => t.id === id)
    if (idx >= 0) toasts.value.splice(idx, 1)
  }, 2500)
}

defineExpose({ show })
</script>

<style scoped>
.toast-container {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 9999;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  pointer-events: none;
}
.toast-item {
  padding: 12px 28px;
  border-radius: 6px;
  font-size: 15px;
  color: #fff;
  white-space: nowrap;
  pointer-events: auto;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
}
.toast-success { background: #00B42A; }
.toast-error { background: #E34D59; }
.toast-info { background: #165DFF; }

.toast-fade-enter-active { transition: all 0.3s ease-out; }
.toast-fade-leave-active { transition: all 0.25s ease-in; }
.toast-fade-enter-from { opacity: 0; transform: translateY(-20px); }
.toast-fade-leave-to { opacity: 0; transform: translateY(10px); }
</style>
