// 腾讯地图SDK封装
// 包含：地图初始化、定位、搜索、路径规划

// 初始化地图
export const initMap = (options) => {
  // 初始化腾讯地图SDK
  // const map = new TencentMap(options)
  // return map
}

// 获取定位
export const getLocation = () => {
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

// 地址搜索
export const searchAddress = (keyword, options = {}) => {
  // 调用腾讯地图搜索接口
  // return new Promise((resolve, reject) => {
  //   // 搜索地址
  // })
}

// 逆地理编码（经纬度转地址）
export const reverseGeocode = (latitude, longitude) => {
  // 调用腾讯地图逆地理编码接口
  // return new Promise((resolve, reject) => {
  //   // 逆地理编码
  // })
}

// 地理编码（地址转经纬度）
export const geocode = (address) => {
  // 调用腾讯地图地理编码接口
  // return new Promise((resolve, reject) => {
  //   // 地理编码
  // })
}

// 计算距离
export const calculateDistance = (from, to) => {
  // 调用腾讯地图距离计算接口
  // return new Promise((resolve, reject) => {
  //   // 计算距离
  // })
}

// 路径规划
export const getRoute = (from, to, mode = 'driving') => {
  // 调用腾讯地图路径规划接口
  // return new Promise((resolve, reject) => {
  //   // 路径规划
  // })
}

// 打开地图导航
export const openNavigation = (latitude, longitude, name) => {
  uni.openLocation({
    latitude,
    longitude,
    name
  })
}
