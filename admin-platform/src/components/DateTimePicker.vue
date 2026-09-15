<template>
  <div class="datetime-picker">
    <select v-model.number="year" class="dt-select" @change="onFieldChange">
      <option :value="null" disabled>年</option>
      <option v-for="y in yearOptions" :key="y" :value="y">{{ y }}年</option>
    </select>

    <select v-model.number="month" class="dt-select" @change="onMonthOrYearChange">
      <option :value="null" disabled>月</option>
      <option v-for="m in 12" :key="m" :value="m">{{ pad(m) }}月</option>
    </select>

    <select v-model.number="day" class="dt-select" @change="onFieldChange">
      <option :value="null" disabled>日</option>
      <option v-for="d in daysInMonth" :key="d" :value="d">{{ pad(d) }}日</option>
    </select>

    <span class="dt-sep">-</span>

    <select v-model.number="hour" class="dt-select" @change="onFieldChange">
      <option :value="null" disabled>时</option>
      <option v-for="h in 24" :key="h - 1" :value="h - 1">{{ pad(h - 1) }}时</option>
    </select>

    <select v-model.number="minute" class="dt-select" @change="onFieldChange">
      <option :value="null" disabled>分</option>
      <option v-for="mi in 60" :key="mi - 1" :value="mi - 1">{{ pad(mi - 1) }}分</option>
    </select>

    <select v-model.number="second" class="dt-select" @change="onFieldChange">
      <option :value="null" disabled>秒</option>
      <option v-for="s in 60" :key="s - 1" :value="s - 1">{{ pad(s - 1) }}秒</option>
    </select>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

const year = ref<number | null>(null)
const month = ref<number | null>(null)
const day = ref<number | null>(null)
const hour = ref<number | null>(null)
const minute = ref<number | null>(null)
const second = ref<number | null>(null)

const currentYear = new Date().getFullYear()
const yearOptions = computed(() => {
  const arr: number[] = []
  for (let y = currentYear - 1; y <= currentYear + 6; y++) arr.push(y)
  return arr
})

const pad = (n: number): string => String(n).padStart(2, '0')

const daysInMonth = computed(() => {
  if (!year.value || !month.value) return 31
  return new Date(year.value, month.value, 0).getDate()
})

const onMonthOrYearChange = () => {
  if (day.value && daysInMonth.value && day.value > daysInMonth.value) {
    day.value = daysInMonth.value
  }
  onFieldChange()
}

const onFieldChange = () => {
  if (year.value && month.value && day.value && hour.value !== null && minute.value !== null && second.value !== null) {
    const v = `${year.value}-${pad(month.value)}-${pad(day.value)} ${pad(hour.value!)}:${pad(minute.value!)}:${pad(second.value!)}`
    emit('update:modelValue', v)
  } else {
    emit('update:modelValue', '')
  }
}

const parseFromModel = (val: string) => {
  if (!val) {
    year.value = null
    month.value = null
    day.value = null
    hour.value = null
    minute.value = null
    second.value = null
    return
  }
  const m = val.match(/^(\d{4})-(\d{1,2})-(\d{1,2})[ T](\d{1,2}):(\d{1,2}):(\d{1,2})/)
  if (m) {
    year.value = Number(m[1])
    month.value = Number(m[2])
    day.value = Number(m[3])
    hour.value = Number(m[4])
    minute.value = Number(m[5])
    second.value = Number(m[6])
  } else {
    const d = new Date(val)
    if (!isNaN(d.getTime())) {
      year.value = d.getFullYear()
      month.value = d.getMonth() + 1
      day.value = d.getDate()
      hour.value = d.getHours()
      minute.value = d.getMinutes()
      second.value = d.getSeconds()
    }
  }
}

const buildCurrentString = (): string => {
  if (year.value && month.value && day.value && hour.value !== null && minute.value !== null && second.value !== null) {
    return `${year.value}-${pad(month.value)}-${pad(day.value)} ${pad(hour.value!)}:${pad(minute.value!)}:${pad(second.value!)}`
  }
  return ''
}

watch(() => props.modelValue, (val) => {
  const current = buildCurrentString()
  if (val !== current) {
    parseFromModel(val)
    const normalized = buildCurrentString()
    if (normalized && normalized !== val) {
      emit('update:modelValue', normalized)
    }
  }
}, { immediate: true })
</script>

<style scoped>
.datetime-picker {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
}

.dt-select {
  padding: 8px 10px;
  border: 1px solid #dcdcdc;
  border-radius: 4px;
  font-size: 14px;
  color: #1D2129;
  background: #fff;
  cursor: pointer;
  min-width: 78px;
  box-sizing: border-box;
}

.dt-select:focus {
  outline: none;
  border-color: #165DFF;
}

.dt-sep {
  color: #86909C;
  font-size: 14px;
  padding: 0 2px;
}
</style>
