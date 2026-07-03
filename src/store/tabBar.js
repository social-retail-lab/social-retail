// TabBar全局状态管理
import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useTabBarStore = defineStore('tabBar', () => {
  // 当前选中的Tab索引
  const currentIndex = ref(0)

  // Tab配置数据
  const tabs = [
    { path: '/pages/index/index', text: '首页', icon: '🏠' },
    { path: '/pagesSub/goods/category/categoryHome', text: '分类', icon: '☰' },
    { path: '/pages/cart/cart', text: '购物车', icon: '🛒' },
    { path: '/pages/mine/mine', text: '我的', icon: '👤' }
  ]

  // 获取当前页面路径对应的索引
  const getCurrentIndex = () => {
    try {
      const pages = getCurrentPages()
      if (pages.length === 0) return 0
      
      const currentPage = pages[pages.length - 1]
      const route = '/' + currentPage.route
      
      const index = tabs.findIndex(tab => tab.path === route)
      return index >= 0 ? index : 0
    } catch (error) {
      console.error('获取当前页面索引失败:', error)
      return 0
    }
  }

  // 切换Tab
  const switchTab = (index) => {
    if (currentIndex.value === index) return
    
    currentIndex.value = index
    
    uni.switchTab({
      url: tabs[index].path,
      fail: (error) => {
        console.error('Tab跳转失败:', error)
        currentIndex.value = getCurrentIndex()
      }
    })
  }

  // 更新当前索引（用于路由变化后同步）
  const updateCurrentIndex = () => {
    currentIndex.value = getCurrentIndex()
  }

  return {
    currentIndex,
    tabs,
    getCurrentIndex,
    switchTab,
    updateCurrentIndex
  }
})
