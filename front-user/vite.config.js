import { defineConfig } from 'vite'
import uni from '@dcloudio/vite-plugin-uni'
import { resolve } from 'path'

export default defineConfig({
  plugins: [uni()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    host: '0.0.0.0',
    port: 5173,
    allowedHosts: ['j8b3daa4.natappfree.cc'],
    proxy: {
      '/api': {
        target: 'http://172.20.10.11:8081',
        changeOrigin: true,
        secure: false
      }
    }
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `@use "@/assets/scss/variable.scss" as *;
@use "@/assets/scss/mixin.scss" as *;
@use "uview-plus/theme.scss" as *;`
      }
    }
  },
  build: {
    transpileDependencies: ['uview-plus']
  }
})