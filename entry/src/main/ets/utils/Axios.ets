import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { TOKEN_KEY } from '../consts/Global';

// 创建axios实例
export const instance = axios.create({
  baseURL: 'http://192.168.101.24:3000',
  timeout: 3000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 添加请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {

  const token = AppStorage.get<string>(TOKEN_KEY)
  console.log('请求数据:', JSON.stringify(config.params) || JSON.stringify(config.data));
  if (token) {
    config.headers['token'] = token
  }
  return config
})

// 添加响应拦截器（仅处理逻辑，不弹Toast）
instance.interceptors.response.use((response: AxiosResponse) => {
  console.log('响应数据:', JSON.stringify(response.data));
  if (response.data.code === 200) {
    return response
  }
  return Promise.reject(response.data.message ?? '请求失败')
}, (error: AxiosError) => {
  return Promise.reject(error.message ?? '网络错误')
})
