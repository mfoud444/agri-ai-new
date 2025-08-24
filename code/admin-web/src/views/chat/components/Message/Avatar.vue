<script lang="ts" setup>
import { computed, ref } from 'vue'
import { NAvatar } from 'naive-ui'
import { useUserStore } from '@/store'
import { isString } from '@/utils/is'
import defaultAvatar from '@/assets/avatar.jpg'
import defaultLogo from '@/assets/logo.png'
interface Props {
  image?: boolean
}
defineProps<Props>()
const userStore = useUserStore()
const userInfo = computed(() => userStore.userInfo)
const email = userInfo.value.user?.email ?? '';
const atIndex = email.indexOf('@');
const name = ref(atIndex !== -1 ? email.slice(0, atIndex) : email);
// const avatar = computed(() => userStore.userInfo.avatar)
</script>

<template>
  <template v-if="image">
    <div class="avatar placeholder">
      <div class="bg-neutral text-neutral-content rounded-full w-8">
        <span class="text-2xl"> {{ name.charAt(0).toUpperCase() }}</span>
      </div>
    </div>
  </template>
  <span
    v-else
    class="text-[28px] dark:text-white"
  >
    <NAvatar
      round
    :src="defaultLogo"
  />
</span></template>
