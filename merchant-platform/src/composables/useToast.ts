import { ref, type Ref } from 'vue'

let toastRef: Ref<any> = ref(null)

export function registerToast(ref: any) {
  toastRef = ref
}

export function useToast() {
  const success = (msg: string) => toastRef.value?.show(msg, 'success')
  const error = (msg: string) => toastRef.value?.show(msg, 'error')
  const info = (msg: string) => toastRef.value?.show(msg, 'info')
  return { success, error, info }
}
