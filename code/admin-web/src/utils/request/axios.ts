import axios, { type AxiosResponse } from 'axios'
import { useAuthStore } from '@/store'
import applyCaseMiddleware from 'axios-case-converter';
// export const baseURL = "import.meta.env.VITE_GLOB_API_URL"; 
// export const baseURL = "http://127.0.0.1:8000/api/"
export const baseURL = ""

const service = applyCaseMiddleware(axios.create({
  baseURL:baseURL,
}))

service.interceptors.request.use(
  (config) => {
    const token = useAuthStore().token
    if (token)
      config.headers.Authorization = `Bearer ${token}`
    return config
  },
  (error) => {
    return Promise.reject(error.response)
  },
)

service.interceptors.response.use(
  (response: AxiosResponse): AxiosResponse => {
    if (response.status === 200)
      return response

    throw new Error(response.status.toString())
  },
  (error) => {
    return Promise.reject(error)
  },
)

export default service
