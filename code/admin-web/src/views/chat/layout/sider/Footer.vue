<script setup lang='ts'>
import { defineAsyncComponent, ref } from 'vue'
import { HoverButton, SvgIcon, UserAvatar } from '@/components/common'
import Setting  from '@/components/common/Setting/index.vue'
const show = ref(false)
</script>

<template>
  <footer
    class="flex  relative glass m-2 rounded-lg bg-blue-200 dark:bg-gray-900 dark:text-white  items-center justify-between min-w-0 p-4 overflow-hidden border-t dark:border-neutral-800">
  
    <div class="w-16 h-16 bg-purple-600 dark:bg-purple-900 dark:text-white rounded-full absolute -bottom-9 -left-8"></div>
    
      <div class="flex-1 flex-shrink-0 overflow-hidden">
        <UserAvatar />
        
      </div>

    <HoverButton @click="show = true">
      <span class="text-xl text-[#4f555e] dark:text-white">
        <SvgIcon icon="ri:settings-4-line" />
      </span>
    </HoverButton>

    <Setting v-if="show" v-model:visible="show" />
</footer></template>
