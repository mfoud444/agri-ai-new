<script setup lang='ts'>
import type { CSSProperties } from 'vue'
import { computed, ref, watch } from 'vue'
import { NButton, NLayoutSider } from 'naive-ui'
import MainList from './MainList.vue'
import Footer from './Footer.vue'
import { useAppStore, useChatStore } from '@/store'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { PromptStore } from '@/components/common'
import { SvgIcon } from '@/components/common'
import { LogoApp } from '@/components/common';
const appStore = useAppStore()
const chatStore = useChatStore()
const { isMobile } = useBasicLayout()
const show = ref(false)
const collapsed = computed(() => appStore.siderCollapsedChat)
const loadingMessage = computed(() =>  chatStore.loadingMessage);

function handleAdd() {
  chatStore.resetChatState()
  if (isMobile.value)
    appStore.setSiderCollapsedChat(true)
}

function handleUpdateCollapsedChat() {
  appStore.setSiderCollapsedChat(!collapsed.value)
}

const getMobileClass = computed<CSSProperties>(() => {
  if (isMobile.value) {
    return {
      position: 'fixed',
      zIndex: 50,
    }
  }
  return {}
})

const mobileSafeArea = computed(() => {
  if (isMobile.value) {
    return {
      paddingBottom: 'env(safe-area-inset-bottom)',
    }
  }
  return {}
})

watch(
  isMobile,
  (val) => {
    appStore.setSiderCollapsedChat(val)
  },
  {
    immediate: true,
    flush: 'post',
  },
)
</script>

<template>
  <NLayoutSider   

  :collapsed="collapsed"
    :collapsed-width="0"
    :width="260"
    :show-trigger="false"
    collapse-mode="transform"
    position="absolute"
    :top="30"
    bordered
    :style="getMobileClass"
    @update-collapsed="handleUpdateCollapsedChat">
    <div  class="flex flex-col h-full" :style="mobileSafeArea">
      <main class="flex flex-col  flex-1 min-h-0">

      <div class="flex flex-col px-4 py-2  justify-center items-center ">
          
           
              <LogoApp :size="35" />
              <!-- <div class=""> {{ $t('chat.newChatButton') }}</div> @click="handleAdd" :disabled="loadingMessage"-->
              <!-- <SvgIcon icon="ri:chat-new-fill" /> -->
        
          
        </div> 


        <div class="flex-1 min-h-0 pb-4 overflow-hidden">
          <MainList/>
          <!-- <List /> -->
        </div>

        <!-- <div class="p-4">
          <NButton block @click="show = true">
            {{ $t('store.siderButton') }}
          </NButton>
        </div> -->

      </main>
      <!-- <div class="">
        <Footer />
      </div> -->
    </div>
  </NLayoutSider>
  <template v-if="isMobile">
    <div v-show="!collapsed" class="fixed inset-0 z-40 w-full h-full bg-black/40" @click="handleUpdateCollapsedChat" />
  </template>
  <PromptStore v-model:visible="show" />
</template>
