<script lang="ts" setup>
import { computed, nextTick, ref } from 'vue'
import { HoverButton, SvgIcon } from '@/components/common'
import { useAppStore, useChatStore } from '@/store'
import { t } from '@/locales'
import {NBadge} from 'naive-ui'
import  SelectModel  from '../ParamsSelect/SelectModel.vue'
import Notification from './Notification.vue'
import {SelectService} from  '@/views/chat/components/index'
import { useBasicLayout } from '@/hooks/useBasicLayout'
interface Props {
  usingContext: boolean

}

interface Emit {
  (ev: 'export'): void
  (ev: 'handleClear'): void
}

defineProps<Props>()

const emit = defineEmits<Emit>()
const isOptionSelectEnable = computed(() => chatStore.currentConversation.isOptionSelectEnable)
const appStore = useAppStore()
const chatStore = useChatStore()
const { isMobile } = useBasicLayout()
const collapsed = computed(() => appStore.siderCollapsed)
const currentChatHistory = computed(() => chatStore.currentConversation)
const loadingMessage = computed(() =>  chatStore.loadingMessage);
function handleUpdateCollapsed() {
  appStore.setSiderCollapsed(!collapsed.value)
}

function onScrollToTop() {
  const scrollRef = document.querySelector('#scrollRef')
  if (scrollRef)
    nextTick(() => scrollRef.scrollTop = 0)
}

function handleExport() {
  emit('export')
}

function handleClear() {
  emit('handleClear')
}

function handleAdd() {
  chatStore.resetChatState()
  if (isMobile.value)
    appStore.setSiderCollapsed(true)
}
const value = ref(1)

const textTpe = computed(() =>{ 
  if(currentChatHistory.value.type === 'text'){
  return  t('chat.chatTypeText')
  } else  if(currentChatHistory.value.type === 'image'){
  return  t('chat.chatTypeImage')
  } else  if(currentChatHistory.value.type === 'research'){
  return  t('chat.chatTypeResearch')
  }
  
  
})

const showNotification = ref(false)
</script>

<template>
  <header
    class="sticky top-0 left-0 mx-3 right-0 z-30 border rounded-lg mt-2 md:mt-0 md:mx-0 md:rounded-none md:py-1 dark:bg-violet-950 dark:text-white   backdrop-blur"
  >

    <div class="relative flex items-center justify-between px-4 md:px-8  min-w-0 overflow-hidden h-[54px]">
      <div class="flex items-center">
        <button
          class="flex items-center justify-center w-11 h-11"
          @click="handleUpdateCollapsed"
        >
          <SvgIcon v-if="collapsed" class="text-2xl" icon="ri:align-justify" />
          <SvgIcon v-else class="text-2xl" icon="ri:align-right" />
        </button>
      </div>
      <!-- <h1
        class="flex-1 px-4 pr-6 overflow-hidden cursor-pointer select-none text-ellipsis whitespace-nowrap"
        @dblclick="onScrollToTop"
      >
        {{ currentChatHistory?.title ?? '' }} 
      </h1> -->
      <div class="flex flex-col justify-center items-center">
        <div class="text-xl gtext font-bold">{{ t('common.nameApp') }}</div>
        <div class="text-sm dark:text-white">{{ textTpe }}</div>
      </div>
   <!-- <SelectModel/>
   <SelectService/> -->
   <div class="flex items-center gap-4">
 
  <!-- <NBadge class="cursor-pointer"  :value="value" :max="99">
    <SvgIcon class="text-2xl text-primary" icon="ion:notifcations" />

</NBadge>  -->

<!-- <Notification/> -->
      <!-- <button @click="handleAdd" :disabled="loadingMessage"        
       :class="{ 'pointer-events-none': loadingMessage, 'opacity-50': loadingMessage }">
          <span class="text-[1.5rem]  dark:text-white">
            <SvgIcon icon="material-symbols:chat-add-on" class="text-2xl md:text-3xl" />
          </span>
        </button> -->

     
     

      
        <!-- <HoverButton @click="handleExport">
          <span class="text-[1.5rem] text-[#4f555e] dark:text-white">
            <SvgIcon icon="uil:comment-share" />
          </span>
        </HoverButton> -->
        
        <!-- <HoverButton @click="handleClear">
          <span class="text-xl text-[#4f555e] dark:text-white">
            <SvgIcon icon="ri:delete-bin-line" />
          </span>
        </HoverButton> -->
      </div>
    </div>

    <!-- <div v-if="isOptionSelectEnable" class="relative flex items-center border-t-2 justify-between px-4 md:px-8  min-w-0 overflow-hidden h-14">
      <div class="flex items-center">
        <SelectService/>
      </div>

      <div class="flex items-center">
        <SelectModel/>
      </div>
      </div> -->
  </header>
</template>
