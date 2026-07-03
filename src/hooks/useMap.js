// 地图定位、轨迹封装钩子
// 包含：定位获取、地址解析、距离计算、轨迹展示

export const useMap = () => {
  // 获取当前位置
  const getCurrentLocation = () => {
    return new Promise((resolve, reject) => {
      uni.getLocation({
        type: 'gcj02',
        success: (res) => {
          resolve({
            latitude: res.latitude,
            longitude: res.longitude
          })
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  }
  
  // 地址解析（经纬度转地址）
  const getAddressByLocation = (latitude, longitude) => {
    // 调用地图SDK地址解析接口
    // return new Promise((resolve, reject) => {
    //   // 地图SDK逆地理编码
    // })
  }
  
  // 地址搜索（地址转经纬度）
  const searchAddress = (keyword) => {
    // 调用地图SDK搜索接口
    // return new Promise((resolve, reject) => {
    //   // 地图SDK搜索
    // })
  }
  
  // 计算两点距离
  const calculateDistance = (lat1, lng1, lat2, lng2) => {
    const R = 6371 // 地球半径（公里）
    const dLat = (lat2 - lat1) * Math.PI / 180
    const dLng = (lng2 - lng1) * Math.PI / 180
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
      Math.sin(dLng / 2) * Math.sin(dLng / 2)
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    return R * c
  }
  
  // 获取配送轨迹
  const getDeliveryTrack = (orderId) => {
    // 调用获取配送轨迹接口
    // return new Promise((resolve, reject) => {
    //   // 获取轨迹数据
    // })
  }
  
  // 打开地图导航
  const openMapNavigation = (latitude, longitude, name) => {
    uni.openLocation({
      latitude,
      longitude,
      name,
      success: () => {}
    })
  }
  
  // 选择位置
  const chooseLocation = () => {
    return new Promise((resolve, reject) => {
      uni.chooseLocation({
        success: (res) => {
          resolve({
            latitude: res.latitude,
            longitude: res.longitude,
            name: res.name,
            address: res.address
          })
        },
        fail: (err) => {
          reject(err)
        }
      })
    })
  }
  
  return {
    getCurrentLocation,
    getAddressByLocation,
    searchAddress,
    calculateDistance,
    getDeliveryTrack,
    openMapNavigation,
    chooseLocation
  }
}
