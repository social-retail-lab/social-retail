/**
 * 首页Mock数据
 * 用于开发调试，模拟接口返回数据
 */

// 轮播图数据
export const mockBanners = {
  code: 200,
  msg: 'success',
  data: {
    list: [
      {
        id: 1,
        image: 'https://img.yzcdn.cn/vant/cat.jpeg',
        type: 'goods',
        target_id: '1',
        sort: 1,
        status: 1
      },
      {
        id: 2,
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        type: 'activity',
        target_id: '1',
        sort: 2,
        status: 1
      },
      {
        id: 3,
        image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
        type: 'coupon',
        target_id: '1',
        sort: 3,
        status: 1
      }
    ]
  }
}

// 分类数据
export const mockCategories = {
  code: 200,
  msg: 'success',
  data: {
    list: [
      { id: 1, name: '美食', icon: 'https://img.yzcdn.cn/vant/cat.jpeg', sort: 1, type: 'category' },
      { id: 2, name: '水果', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg', sort: 2, type: 'category' },
      { id: 3, name: '服饰', icon: 'https://img.yzcdn.cn/vant/cat.jpeg', sort: 3, type: 'category' },
      { id: 4, name: '美妆', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg', sort: 4, type: 'category' },
      { id: 5, name: '家居', icon: 'https://img.yzcdn.cn/vant/cat.jpeg', sort: 5, type: 'category' },
      { id: 6, name: '数码', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg', sort: 6, type: 'category' },
      { id: 7, name: '母婴', icon: 'https://img.yzcdn.cn/vant/cat.jpeg', sort: 7, type: 'category' },
      { id: 8, name: '图书', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg', sort: 8, type: 'category' },
      { id: 9, name: '运动', icon: 'https://img.yzcdn.cn/vant/cat.jpeg', sort: 9, type: 'category' },
      { id: 10, name: '医药', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg', sort: 10, type: 'category' }
    ]
  }
}

// 分类页面详细数据（一级分类+Banner+二级分类+商品模块）
export const mockCategoryDetail = {
  code: 200,
  msg: 'success',
  data: [
    {
      id: 1,
      name: '美食',
      banners: [
        { id: 1, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '美食特惠' },
        { id: 2, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '限时抢购' }
      ],
      second_categories: [
        { id: 101, name: '零食', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 102, name: '生鲜', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 103, name: '熟食', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 104, name: '饮料', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 105, name: '酒水', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 106, name: '速食', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' }
      ],
      modules: [
        {
          id: 1001,
          title: '热门零食',
          goods: [
            { id: 100101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '坚果混合礼盒', price: 69.9, original_price: 128, sales: 2000 },
            { id: 100102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '薯片大礼包', price: 39.9, original_price: 69.9, sales: 3500 },
            { id: 100103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '巧克力礼盒', price: 89.9, original_price: 158, sales: 1200 },
            { id: 100104, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '饼干零食', price: 29.9, original_price: 49.9, sales: 5000 },
            { id: 100105, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '糖果礼包', price: 45.9, original_price: 79.9, sales: 800 },
            { id: 100106, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '肉干零食', price: 59.9, original_price: 99.9, sales: 1800 }
          ]
        },
        {
          id: 1002,
          title: '新鲜生鲜',
          goods: [
            { id: 100201, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '新鲜猪肉', price: 49.9, original_price: 79.9, sales: 800 },
            { id: 100202, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '鲜牛肉', price: 89.9, original_price: 138, sales: 600 },
            { id: 100203, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '海鲜水产', price: 128, original_price: 198, sales: 400 },
            { id: 100204, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '鸡蛋', price: 19.9, original_price: 29.9, sales: 6000 }
          ]
        }
      ]
    },
    {
      id: 2,
      name: '水果',
      banners: [
        { id: 3, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '新鲜水果' },
        { id: 4, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '产地直发' }
      ],
      second_categories: [
        { id: 201, name: '苹果', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 202, name: '橙子', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 203, name: '香蕉', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 204, name: '葡萄', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 205, name: '西瓜', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 206, name: '草莓', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' }
      ],
      modules: [
        {
          id: 2001,
          title: '当季水果',
          goods: [
            { id: 200101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '红富士苹果 5斤', price: 29.9, original_price: 59.9, sales: 3000 },
            { id: 200102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '赣南脐橙 10斤', price: 49.9, original_price: 89.9, sales: 2500 },
            { id: 200103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '进口车厘子 2斤', price: 89.9, original_price: 169.9, sales: 1000 },
            { id: 200104, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '云南蓝莓', price: 39.9, original_price: 69.9, sales: 1500 }
          ]
        }
      ]
    },
    {
      id: 3,
      name: '服饰',
      banners: [
        { id: 5, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '时尚穿搭' },
        { id: 6, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '新品上市' }
      ],
      second_categories: [
        { id: 301, name: '男装', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 302, name: '女装', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 303, name: '童装', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 304, name: '鞋靴', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 305, name: '箱包', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 306, name: '配饰', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' }
      ],
      modules: [
        {
          id: 3001,
          title: '精选男装',
          goods: [
            { id: 300101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '纯棉T恤', price: 49.9, original_price: 99.9, sales: 2000 },
            { id: 300102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '休闲裤', price: 89.9, original_price: 159, sales: 1200 },
            { id: 300103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '外套', price: 199, original_price: 399, sales: 800 }
          ]
        },
        {
          id: 3002,
          title: '潮流女装',
          goods: [
            { id: 300201, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '连衣裙', price: 129, original_price: 259, sales: 1500 },
            { id: 300202, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '卫衣', price: 89.9, original_price: 169, sales: 2200 },
            { id: 300203, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '牛仔裤', price: 79.9, original_price: 139, sales: 1800 }
          ]
        }
      ]
    },
    {
      id: 4,
      name: '美妆',
      banners: [
        { id: 7, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '美妆护肤' },
        { id: 8, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '限时特惠' }
      ],
      second_categories: [
        { id: 401, name: '护肤', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 402, name: '彩妆', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 403, name: '香水', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 404, name: '面膜', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 405, name: '口红', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 406, name: '洗护', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' }
      ],
      modules: [
        {
          id: 4001,
          title: '护肤精选',
          goods: [
            { id: 400101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '补水精华', price: 199, original_price: 399, sales: 1000 },
            { id: 400102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '保湿面霜', price: 259, original_price: 499, sales: 800 },
            { id: 400103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '美白面膜', price: 69.9, original_price: 128, sales: 3000 }
          ]
        },
        {
          id: 4002,
          title: '彩妆专区',
          goods: [
            { id: 400201, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '口红套装', price: 168, original_price: 298, sales: 1200 },
            { id: 400202, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '粉底液', price: 189, original_price: 359, sales: 900 },
            { id: 400203, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '眼影盘', price: 129, original_price: 239, sales: 700 }
          ]
        }
      ]
    },
    {
      id: 5,
      name: '家居',
      banners: [
        { id: 9, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '家居生活' },
        { id: 10, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '品质家居' }
      ],
      second_categories: [
        { id: 501, name: '家具', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 502, name: '家纺', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 503, name: '厨具', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 504, name: '收纳', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 505, name: '装饰', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 506, name: '清洁', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' }
      ],
      modules: [
        {
          id: 5001,
          title: '厨房用品',
          goods: [
            { id: 500101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '不粘锅', price: 129, original_price: 259, sales: 1500 },
            { id: 500102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '餐具套装', price: 89.9, original_price: 168, sales: 800 },
            { id: 500103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '电饭煲', price: 299, original_price: 499, sales: 600 }
          ]
        },
        {
          id: 5002,
          title: '家纺床品',
          goods: [
            { id: 500201, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '四件套', price: 199, original_price: 399, sales: 1000 },
            { id: 500202, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '枕头', price: 69.9, original_price: 129, sales: 2000 }
          ]
        }
      ]
    },
    {
      id: 6,
      name: '数码',
      banners: [
        { id: 11, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '数码精选' },
        { id: 12, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '科技新品' }
      ],
      second_categories: [
        { id: 601, name: '手机', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 602, name: '电脑', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 603, name: '耳机', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 604, name: '相机', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 605, name: '手表', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 606, name: '配件', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' }
      ],
      modules: [
        {
          id: 6001,
          title: '智能穿戴',
          goods: [
            { id: 600101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '智能手表', price: 499, original_price: 899, sales: 500 },
            { id: 600102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '蓝牙耳机', price: 199, original_price: 399, sales: 2000 },
            { id: 600103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '手环', price: 149, original_price: 299, sales: 1500 }
          ]
        },
        {
          id: 6002,
          title: '数码配件',
          goods: [
            { id: 600201, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '手机壳', price: 29.9, original_price: 59.9, sales: 3000 },
            { id: 600202, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '充电宝', price: 89.9, original_price: 159, sales: 1800 }
          ]
        }
      ]
    },
    {
      id: 7,
      name: '母婴',
      banners: [
        { id: 13, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '母婴精选' }
      ],
      second_categories: [
        { id: 701, name: '奶粉', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 702, name: '纸尿裤', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 703, name: '玩具', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 704, name: '童装', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 705, name: '辅食', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 706, name: '用品', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' }
      ],
      modules: [
        {
          id: 7001,
          title: '婴幼儿奶粉',
          goods: [
            { id: 700101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '婴儿奶粉3段', price: 268, original_price: 368, sales: 800 },
            { id: 700102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '有机奶粉', price: 398, original_price: 598, sales: 500 }
          ]
        },
        {
          id: 7002,
          title: '宝宝用品',
          goods: [
            { id: 700201, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '纸尿裤', price: 69.9, original_price: 119, sales: 3000 },
            { id: 700202, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '婴儿湿巾', price: 29.9, original_price: 49.9, sales: 2000 }
          ]
        }
      ]
    },
    {
      id: 8,
      name: '运动',
      banners: [
        { id: 14, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '运动装备' }
      ],
      second_categories: [
        { id: 801, name: '跑步', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 802, name: '健身', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 803, name: '户外', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 804, name: '球类', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 805, name: '装备', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 806, name: '服饰', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' }
      ],
      modules: [
        {
          id: 8001,
          title: '健身器材',
          goods: [
            { id: 800101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '瑜伽垫', price: 49.9, original_price: 89.9, sales: 1500 },
            { id: 800102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '哑铃', price: 99, original_price: 169, sales: 600 },
            { id: 800103, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '跳绳', price: 29.9, original_price: 49.9, sales: 2000 }
          ]
        }
      ]
    },
    {
      id: 9,
      name: '图书',
      banners: [
        { id: 15, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '图书精选' }
      ],
      second_categories: [
        { id: 901, name: '小说', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 902, name: '教育', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 903, name: '儿童', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 904, name: '科技', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 905, name: '生活', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 906, name: '经管', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' }
      ],
      modules: [
        {
          id: 9001,
          title: '畅销书籍',
          goods: [
            { id: 900101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '文学小说', price: 39.9, original_price: 59.9, sales: 2000 },
            { id: 900102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '励志书籍', price: 29.9, original_price: 49.9, sales: 1500 }
          ]
        }
      ]
    },
    {
      id: 10,
      name: '医药',
      banners: [
        { id: 16, image: 'https://img.yzcdn.cn/vant/cat.jpeg', title: '健康医药' }
      ],
      second_categories: [
        { id: 1001, name: '药品', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 1002, name: '保健', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 1003, name: '器械', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' },
        { id: 1004, name: '母婴', icon: 'https://img.yzcdn.cn/vant/apple-1.jpg' },
        { id: 1005, name: '护肤', icon: 'https://img.yzcdn.cn/vant/apple-2.jpg' },
        { id: 1006, name: '口腔', icon: 'https://img.yzcdn.cn/vant/cat.jpeg' }
      ],
      modules: [
        {
          id: 10001,
          title: '保健品',
          goods: [
            { id: 1000101, image: 'https://img.yzcdn.cn/vant/apple-1.jpg', title: '维生素', price: 69.9, original_price: 128, sales: 1000 },
            { id: 1000102, image: 'https://img.yzcdn.cn/vant/apple-2.jpg', title: '蛋白粉', price: 199, original_price: 359, sales: 500 }
          ]
        }
      ]
    }
  ]
}

// 秒杀活动数据
export const mockSeckillActivity = {
  code: 200,
  msg: 'success',
  data: {
    id: 1,
    title: '限时秒杀',
    start_time: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
    end_time: new Date(Date.now() + 10 * 60 * 60 * 1000).toISOString(),
    status: 1,
    goods_list: [
      {
        id: 1,
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        title: '新鲜红富士苹果 5斤装',
        price: 29.9,
        original_price: 59.9,
        stock: 50
      },
      {
        id: 2,
        image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
        title: '有机大米 10斤装',
        price: 39.9,
        original_price: 79.9,
        stock: 30
      },
      {
        id: 3,
        image: 'https://img.yzcdn.cn/vant/cat.jpeg',
        title: '进口车厘子 2斤装',
        price: 89.9,
        original_price: 169.9,
        stock: 20
      },
      {
        id: 4,
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        title: '纯棉T恤 男款',
        price: 49.9,
        original_price: 99.9,
        stock: 100
      }
    ]
  }
}

// 推荐商品数据
export const mockRecommendGoods = {
  code: 200,
  msg: 'success',
  data: {
    list: [
      {
        id: 1,
        title: '新鲜红富士苹果 5斤装 产地直发 皮薄多汁',
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        price: 29.9,
        original_price: 59.9,
        commission: 2.99,
        sales: 1000,
        tag: '热卖',
        stock: 999
      },
      {
        id: 2,
        title: '有机大米 10斤装 东北特产 优质稻花香',
        image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
        price: 39.9,
        original_price: 79.9,
        commission: 3.99,
        sales: 800,
        tag: '推荐',
        stock: 999
      },
      {
        id: 3,
        title: '进口车厘子 2斤装 智利进口 新鲜直达',
        image: 'https://img.yzcdn.cn/vant/cat.jpeg',
        price: 89.9,
        original_price: 169.9,
        commission: 8.99,
        sales: 500,
        stock: 999
      },
      {
        id: 4,
        title: '纯棉T恤 男款 夏季透气 休闲百搭',
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        price: 49.9,
        original_price: 99.9,
        commission: 4.99,
        sales: 2000,
        tag: '热卖',
        stock: 999
      },
      {
        id: 5,
        title: '女士连衣裙 2024新款 时尚潮流 气质优雅',
        image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
        price: 129.9,
        original_price: 259.9,
        commission: 12.99,
        sales: 300,
        stock: 999
      },
      {
        id: 6,
        title: '智能手环 运动计步 心率监测 防水设计',
        image: 'https://img.yzcdn.cn/vant/cat.jpeg',
        price: 199.9,
        original_price: 399.9,
        commission: 19.99,
        sales: 1500,
        tag: '新品',
        stock: 999
      },
      {
        id: 7,
        title: '婴儿奶粉 3段 900g 荷兰原装进口',
        image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
        price: 268.0,
        original_price: 368.0,
        commission: 26.8,
        sales: 600,
        stock: 999
      },
      {
        id: 8,
        title: '护肤套装 保湿补水 美白淡斑 女士专用',
        image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
        price: 299.0,
        original_price: 599.0,
        commission: 29.9,
        sales: 400,
        tag: '推荐',
        stock: 999
      }
    ],
    total: 100,
    page: 1,
    page_size: 10
  }
}

// 购物车数据
export const mockCartData = {
  code: 200,
  msg: 'success',
  data: [
    {
      id: 1,
      goodsId: 1,
      skuId: 101,
      name: '2026新款极简纯棉短袖T恤 男士夏季透气上衣',
      image: 'https://img.yzcdn.cn/vant/apple-1.jpg',
      price: 89,
      original_price: 129,
      count: 1,
      selected: true,
      sku: '白色; XL',
      store_id: 1,
      store_name: '极简服饰官方旗舰店',
      store_icon: 'https://img.yzcdn.cn/vant/cat.jpeg'
    },
    {
      id: 2,
      goodsId: 2,
      skuId: 201,
      name: '高腰显瘦阔腿牛仔裤 复古蓝',
      image: 'https://img.yzcdn.cn/vant/apple-2.jpg',
      price: 129,
      original_price: 199,
      count: 1,
      selected: true,
      sku: '复古蓝; 29码',
      store_id: 1,
      store_name: '极简服饰官方旗舰店',
      store_icon: 'https://img.yzcdn.cn/vant/cat.jpeg'
    },
    {
      id: 3,
      goodsId: 3,
      skuId: 301,
      name: '保湿补水面膜 10片/盒',
      image: 'https://img.yzcdn.cn/vant/cat.jpeg',
      price: 59,
      original_price: 99,
      count: 1,
      selected: false,
      sku: '经典版',
      store_id: 2,
      store_name: '遇见美妆生活馆',
      store_icon: 'https://img.yzcdn.cn/vant/apple-1.jpg'
    }
  ],
  promotion: {
    discount: 20,
    type: 'full_reduction',
    desc: '满200减20'
  }
}

// 模拟延迟函数
export const mockDelay = (data, delay = 500) => {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(data)
    }, delay)
  })
}
