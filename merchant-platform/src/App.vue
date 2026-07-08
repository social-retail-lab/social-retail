<template>
  <!-- 路由出口，所有页面都会渲染在这里 -->
  <router-view />
</template>

<script setup>
// 空脚本，不需要额外逻辑
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  background: #F7F7F9;
  font-family: system-ui, -apple-system, sans-serif;
  color: #2D2D2D;
}
input, button, select, textarea {
  font-family: inherit;
}
</style>