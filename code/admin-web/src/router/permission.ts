import type {Router } from 'vue-router'
import { useAuthStoreWithout } from '@/store/modules/auth'
export function setupPageGuard(router: Router) {
  router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStoreWithout()
    const isAuthenticated = authStore.isAuthenticated()
    if (to.meta.requiresAuth && !isAuthenticated) {
      next({ name: 'auth' })
    } else if (isAuthenticated && ['auth','signup', 'login', 'otp'].includes(to.name as string)) {
      next({ name: 'dashboard' })
    } else {
      next()
    }
  })
}
