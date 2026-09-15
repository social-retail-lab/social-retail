<template>
  <div class="goods-edit-redirect">Redirecting...</div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

onMounted(() => {
  router.replace('/goods')
})
</script>

<style scoped>
.goods-edit-redirect {
  padding: 24px;
  color: #666;
}
</style>
