<template>
  <div class="appeal-page">
    <h1>售后申诉处理</h1>
    <p class="subtitle">被商家拒绝后用户申诉的售后请求，由平台介入裁决</p>

    <div class="search-bar">
      <input v-model="keyword" placeholder="搜索订单号" class="search-input" />
      <button @click="search" class="search-btn">搜索</button>
    </div>

    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th style="width: 60px;">售后ID</th>
            <th style="width: 170px;">订单号</th>
            <th style="width: 160px;">商品</th>
            <th style="width: 70px;">类型</th>
            <th style="width: 80px;">退款金额</th>
            <th style="min-width: 150px;">申诉原因</th>
            <th style="min-width: 140px;">商家拒绝理由</th>
            <th style="width: 120px;">申诉图片</th>
            <th style="width: 140px;">申诉时间</th>
            <th style="width: 140px;">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.afterSaleId">
            <td>{{ item.afterSaleId }}</td>
            <td class="text-left">{{ item.orderSn }}</td>
            <td class="text-left">{{ item.productName }}</td>
            <td>{{ item.typeText }}</td>
            <td>¥{{ item.refundAmount?.toFixed(2) }}</td>
            <td class="text-left reason-cell">{{ item.appealReason || '-' }}</td>
            <td class="text-left reason-cell">{{ item.merchantAuditRemark || '-' }}</td>
            <td>
              <div v-if="parsedImages(item).length > 0" class="img-thumbs">
                <img
                  v-for="(url, idx) in parsedImages(item)"
                  :key="idx"
                  :src="url"
                  class="thumb"
                  @click="previewImage(url)"
                  alt="举证图片"
                />
              </div>
              <span v-else style="color: #ccc;">-</span>
            </td>
            <td>{{ item.appealTime }}</td>
            <td>
              <div class="action-btns">
                <button class="btn-approve" @click="openIntervene(item, 1)">支持退款</button>
                <button class="btn-reject" @click="openIntervene(item, 2)">维持拒绝</button>
              </div>
            </td>
          </tr>
          <tr v-if="list.length === 0">
            <td colspan="10" class="empty">暂无申诉记录</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination">
      <button :disabled="pageNum <= 1" @click="pageNum--; loadData()">上一页</button>
      <span>第{{ pageNum }}页 / 共{{ totalPages }}页 (共{{ total }}条)</span>
      <button :disabled="pageNum >= totalPages" @click="pageNum++; loadData()">下一页</button>
    </div>

    <!-- 图片预览 -->
    <div v-if="previewVisible" class="modal-mask" @click="previewVisible = false">
      <div class="preview-box">
        <img :src="previewUrl" class="preview-img" @click.stop />
        <span class="close-btn" @click="previewVisible = false">&times;</span>
      </div>
    </div>

    <!-- 介入处理对话框 -->
    <div v-if="showDialog" class="modal-mask" @click.self="showDialog = false">
      <div class="modal-box">
        <h2>{{ dialogTitle }}</h2>
        <div class="detail-info">
          <p>订单号：{{ currentItem?.orderSn }}</p>
          <p>商品：{{ currentItem?.productName }}</p>
          <p>退款金额：¥{{ currentItem?.refundAmount?.toFixed(2) }}</p>
          <p>申诉原因：{{ currentItem?.appealReason }}</p>
          <div v-if="parsedImages(currentItem).length > 0" class="dialog-images">
            <p>申诉图片：</p>
            <div class="dialog-thumbs">
              <img
                v-for="(url, idx) in parsedImages(currentItem)"
                :key="idx"
                :src="url"
                class="thumb"
                @click="previewImage(url)"
                alt="举证图片"
              />
            </div>
          </div>
        </div>
        <div class="form-row">
          <label>处理备注：</label>
          <textarea v-model="remark" rows="3" placeholder="请输入处理备注（选填）"></textarea>
        </div>
        <div class="dialog-btns">
          <button class="btn-cancel" @click="showDialog = false">取消</button>
          <button class="btn-submit" @click="handleIntervene">{{ dialogTitle }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { getAppealedAfterSales, interveneAfterSale } from '@/api/audit'

const keyword = ref('')
const pageNum = ref(1)
const totalPages = ref(1)
const total = ref(0)
const list = ref<any[]>([])

const showDialog = ref(false)
const dialogTitle = ref('')
const currentItem = ref<any>(null)
const currentAction = ref(0)
const remark = ref('')

const previewVisible = ref(false)
const previewUrl = ref('')

const parsedImages = (item: any) => {
  if (!item?.evidenceImages) return []
  const raw = item.evidenceImages
  if (typeof raw === 'string') {
    try {
      const arr = JSON.parse(raw)
      return Array.isArray(arr) ? arr : []
    } catch {
      return raw.split(',').map((u: string) => u.trim()).filter(Boolean)
    }
  }
  if (Array.isArray(raw)) return raw
  return []
}

const previewImage = (url: string) => {
  previewUrl.value = url
  previewVisible.value = true
}

const search = () => { pageNum.value = 1; loadData() }

const loadData = async () => {
  const params: any = { pageNum: pageNum.value, pageSize: 10 }
  if (keyword.value) params.keyword = keyword.value
  console.log('[售后申诉] 开始加载...')
  const res = await getAppealedAfterSales(params)
  console.log('[售后申诉] 结果:', res.code, res.data)
  if (res.code === 0) {
    list.value = res.data.list || res.data.records || []
    total.value = res.data.total || list.value.length
    totalPages.value = Math.max(1, Math.ceil(total.value / 10))
  }
}

const openIntervene = (item: any, action: number) => {
  currentItem.value = item
  currentAction.value = action
  remark.value = ''
  dialogTitle.value = action === 1 ? '确认支持退款？' : '确认维持拒绝？'
  showDialog.value = true
}

const handleIntervene = async () => {
  const res = await interveneAfterSale(currentItem.value.afterSaleId, {
    action: currentAction.value,
    remark: remark.value
  })
  if (res.code === 0) {
    alert(res.data.message || '处理成功')
    showDialog.value = false
    loadData()
  } else {
    alert(res.message || '处理失败')
  }
}

loadData()
</script>

<style scoped>
.appeal-page { padding: 24px; max-width: 100%; margin: 0 auto; }
.appeal-page h1 { font-size: 20px; color: #2D2D2D; margin-bottom: 4px; }
.subtitle { font-size: 13px; color: #999; margin-bottom: 16px; }
.search-bar { display: flex; gap: 8px; margin-bottom: 16px; }
.search-input { padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 240px; }
.search-btn { padding: 8px 16px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; }

.table-wrap { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 6px; overflow: hidden; table-layout: auto; white-space: nowrap; }
.data-table th, .data-table td { padding: 10px 12px; text-align: center; border-bottom: 1px solid #f0f0f0; font-size: 13px; vertical-align: middle; }
.data-table th { background: #fafafa; color: #555; font-weight: 600; }
.data-table td { color: #333; }
.text-left { text-align: left !important; }
.reason-cell { white-space: normal; max-width: 200px; line-height: 1.5; }
.empty { color: #999; padding: 30px !important; }

/* 图片缩略图 */
.img-thumbs { display: flex; gap: 4px; justify-content: center; flex-wrap: wrap; }
.thumb { width: 48px; height: 48px; object-fit: cover; border-radius: 4px; border: 1px solid #e8e8e8; cursor: pointer; transition: border-color .2s; }
.thumb:hover { border-color: #165DFF; }

/* 操作按钮 */
.action-btns { display: flex; flex-direction: column; gap: 6px; align-items: center; }
.btn-approve { padding: 5px 14px; background: #52C41A; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; white-space: nowrap; }
.btn-approve:hover { background: #45a715; }
.btn-reject { padding: 5px 14px; background: #FF4D4F; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; white-space: nowrap; }
.btn-reject:hover { background: #e04345; }

.pagination { display: flex; justify-content: center; gap: 16px; margin-top: 20px; align-items: center; font-size: 13px; color: #666; }
.pagination button { padding: 6px 14px; border: 1px solid #ddd; background: #fff; border-radius: 4px; cursor: pointer; }
.pagination button:disabled { opacity: .4; cursor: default; }

/* 图片预览 */
.modal-mask { position: fixed; inset: 0; background: rgba(0,0,0,.55); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.preview-box { position: relative; max-width: 80vw; max-height: 80vh; }
.preview-img { max-width: 80vw; max-height: 80vh; border-radius: 6px; }
.close-btn { position: absolute; top: -32px; right: -4px; font-size: 28px; color: #fff; cursor: pointer; width: 28px; height: 28px; line-height: 26px; text-align: center; }

/* 对话框 */
.modal-box { background: #fff; border-radius: 8px; padding: 24px; width: 520px; max-height: 80vh; overflow-y: auto; }
.modal-box h2 { font-size: 17px; margin-bottom: 16px; }
.detail-info p { margin: 4px 0; font-size: 13px; color: #555; }
.dialog-images { margin-top: 8px; }
.dialog-images p { margin: 4px 0; font-size: 13px; color: #555; }
.dialog-thumbs { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 4px; }
.form-row { margin: 14px 0; }
.form-row label { display: block; font-size: 13px; color: #555; margin-bottom: 6px; }
.form-row textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: none; box-sizing: border-box; }
.dialog-btns { display: flex; gap: 10px; justify-content: flex-end; margin-top: 16px; }
.btn-cancel { padding: 8px 18px; background: #f5f5f5; color: #666; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; }
.btn-submit { padding: 8px 18px; background: #165DFF; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
</style>
