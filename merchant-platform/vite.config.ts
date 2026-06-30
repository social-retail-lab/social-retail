import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'
import { readFileSync } from 'fs'

// ==================== 后端地址：从 shared/api-config.json 全局配置 ====================
const configJson = JSON.parse(readFileSync(resolve(__dirname, '../shared/api-config.json'), 'utf-8'))
const BACKEND_URL = configJson.backendUrl || 'http://192.168.0.179:8080'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 5174,
    host: '0.0.0.0',
    proxy: {
      '/api': {
        target: BACKEND_URL,
        changeOrigin: true
      }
    }
  }
})
