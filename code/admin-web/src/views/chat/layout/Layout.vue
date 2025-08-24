<script setup lang='ts'>
import { computed} from 'vue'
import { NLayout, NLayoutContent } from 'naive-ui'
import Sider from './sider/index.vue'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { useAppStore, } from '@/store'
import IndexChat from "../index.vue";
import { ChatLayout } from '@/views/chat/layout'
const appStore = useAppStore()
const { isMobile } = useBasicLayout()
const collapsed = computed(() => appStore.siderCollapsed)
const getMobileClass = computed(() => {
  if (isMobile.value)
    return ['rounded-none', 'shadow-none']
  return ['border', 'rounded-md', 'shadow-md', 'dark:border-neutral-800']
})

const getContainerClass = computed(() => {
  return [
    'h-full',
    { 'pl-[260px]': !isMobile.value && !collapsed.value },
  ]
})


</script>

<template>
  <div class="h-[800px] mt-6 mx-8 border-blue-500 border-2 rounded-md dark:bg-[#24272e] transition-all">
    <div class="h-full overflow-hidden" :class="getMobileClass">
      <NLayout class="z-40 transition" :class="getContainerClass" has-sider>
        <Sider />
        <NLayoutContent class="h-full">
          <IndexChat/>
     
        </NLayoutContent>
      </NLayout>
    </div>
  </div>
</template>


