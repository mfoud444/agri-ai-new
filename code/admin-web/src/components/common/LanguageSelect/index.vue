<script lang="ts" setup>
import { computed} from 'vue'
import { NSelect} from 'naive-ui'
import { t } from '@/locales'
import type { Language } from '@/store/modules/app/helper'
import { useAppStore, useChatStore, useUserStore } from '@/store'
const appStore = useAppStore()
const language = computed({
  get() {
    return appStore.language
  },
  set(value: Language) {
    appStore.setLanguage(value)
  },
})
const languageOptions: { label: string; key: Language; value: Language }[] = [
  {label: 'العربية', key: 'ar-DZ', value: 'ar-DZ' },
  // { label: '简体中文', key: 'zh-CN', value: 'zh-CN' },
  // { label: '繁體中文', key: 'zh-TW', value: 'zh-TW' },
  { label: 'English', key: 'en-US', value: 'en-US' },
  // { label: '한국어', key: 'ko-KR', value: 'ko-KR' },
  // { label: 'Русский язык', key: 'ru-RU', value: 'ru-RU' },
]


</script>

<template>


<div class="flex flex-col gap-2">

  <div class="w-36">
       
        <div>
          <NSelect
            :value="language"
            :options="languageOptions"
            @update-value="value => appStore.setLanguage(value)"
          />
        </div>
  </div>


</div>

</template>
