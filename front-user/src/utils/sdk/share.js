// 微信分享SDK封装
// 包含：分享到好友、分享到朋友圈、生成分享海报

// 分享到微信好友
export const shareToFriend = (options) => {
  const { title, desc, imageUrl, link } = options
  
  return new Promise((resolve, reject) => {
    uni.share({
      provider: 'weixin',
      scene: 'WXSceneSession',
      title,
      desc,
      imageUrl,
      link,
      success: (res) => {
        resolve(res)
      },
      fail: (err) => {
        reject(err)
      }
    })
  })
}

// 分享到朋友圈
export const shareToTimeline = (options) => {
  const { title, imageUrl, link } = options
  
  return new Promise((resolve, reject) => {
    uni.share({
      provider: 'weixin',
      scene: 'WXSenceTimeline',
      title,
      imageUrl,
      link,
      success: (res) => {
        resolve(res)
      },
      fail: (err) => {
        reject(err)
      }
    })
  })
}

// 生成分享海报
export const generateSharePoster = (options) => {
  // 调用海报生成接口
  // return new Promise((resolve, reject) => {
  //   // 生成海报
  // })
}

// 保存海报到相册
export const savePosterToAlbum = (imagePath) => {
  return new Promise((resolve, reject) => {
    uni.saveImageToPhotosAlbum({
      filePath: imagePath,
      success: (res) => {
        resolve(res)
        uni.showToast({ title: '保存成功', icon: 'success' })
      },
      fail: (err) => {
        reject(err)
        uni.showToast({ title: '保存失败', icon: 'none' })
      }
    })
  })
}

// 复制分享链接
export const copyShareLink = (link) => {
  return new Promise((resolve, reject) => {
    uni.setClipboardData({
      data: link,
      success: (res) => {
        resolve(res)
        uni.showToast({ title: '链接已复制', icon: 'success' })
      },
      fail: (err) => {
        reject(err)
        uni.showToast({ title: '复制失败', icon: 'none' })
      }
    })
  })
}

// 设置分享信息（页面onLoad时调用）
export const setShareInfo = (options) => {
  // 设置默认分享信息
  // uni.$emit('shareInfo', options)
}
