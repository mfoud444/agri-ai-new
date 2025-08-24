<script lang="ts" setup>
import { useRouter } from 'vue-router'
import { computed } from 'vue'
import type { Language, Theme } from '@/store/modules/app/helper'
import { SvgIcon } from '@/components/common'
import { useAppStore } from '@/store'
import { t } from '@/locales'
const router = useRouter()
function goHome() {
  router.push('/')
}


const appStore = useAppStore()
const theme = computed(() => appStore.theme)


const language = computed({
  get() {
    return appStore.language
  },
  set(value: Language) {
    appStore.setLanguage(value)
  },
})

const themeOptions: { label: string; key: Theme; icon: string }[] = [
  {
    label: 'Light',
    key: 'light',
    icon: 'ri:sun-foggy-line',
  },
  {
    label: 'Dark',
    key: 'dark',
    icon: 'ri:moon-foggy-line',
  },
]

const languageOptions: { label: string; key: Language; value: Language }[] = [
  { label: 'العربية', key: 'ar-DZ', value: 'ar-DZ' },
  // { label: '简体中文', key: 'zh-CN', value: 'zh-CN' },
  // { label: '繁體中文', key: 'zh-TW', value: 'zh-TW' },
  { label: 'English', key: 'en-US', value: 'en-US' },
  // { label: '한국어', key: 'ko-KR', value: 'ko-KR' },
  // { label: 'Русский язык', key: 'ru-RU', value: 'ru-RU' },
]




</script>

<template>
  <div class="py-0 pt-2 mb-4 lg:pt-4">
    <div class="navbar glass py-1 md:py-3 rounded-lg dark:bg-violet-800">
      <div class="navbar-start">
        <button
          @click="goHome"
          class="btn btn-ghost normal-case text-xl gtext"
        >
          {{ t('common.nameApp') }}
        </button>
      </div>
      <div class="navbar-center">

      </div>

      <div class="navbar-end gap-4">

        <NPopselect
          :value="language"
          :options="languageOptions"
          @update-value="value => appStore.setLanguage(value)"
        >
          <SvgIcon
            icon="material-symbols:language"
            class="h-8 w-8 gtext cursor-pointer hover:border-none"
          />
        </NPopselect>


        <div class="flex flex-wrap items-center gap-4">
          <template
            v-for="item of themeOptions"
            :key="item.key"
          >
            <NButton
              size="small"
              :type="item.key === theme ? 'primary' : undefined"
              @click="appStore.setTheme(item.key)"
            >
              <template #icon>
                <SvgIcon :icon="item.icon" />
            </template>
          </NButton>
        </template>
      </div>



    </div>
  </div>
</div></template>