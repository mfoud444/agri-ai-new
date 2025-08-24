<script setup lang='ts'>
import { ref, computed, watch } from 'vue'
import { useMessage } from 'naive-ui'
import TextComponent from './Text.vue'
import HeaderRand from './HeaderRand.vue'
import expoortSelect from '../SelectOptions/exportSelect.vue'
import FooterMessageAI from './FooterMessageAI.vue'
import { SvgIcon } from '@/components/common'
import { useChatStore } from '@/store'
const message = useMessage()
interface Props {
  itemUser: Chat.MessageUser
  item: Chat.MessageAI
  fullItem: Chat.Item
}


const props = defineProps<Props>()
const asRawText = ref(false)
const itemUser = computed(() => props.itemUser)
const chatStore = useChatStore()
const lang = computed(() => chatStore.currentConversation.lang)
const textTranInfo = computed(() => currentMessageAI.value.textTranInfo);
const isShowOrignalText = computed(() => currentMessageAI.value.isShowOrignalText);

const dir = computed(() => {
  let dir = ''
  if (isShowOrignalText.value && isShowOrignalText.value === true && chatStore.currentConversation.lang == 'ar') {
    dir = 'ltr'
  }
  return dir
})
const text = computed(() => {
  let result = props.item.text;
  if(isShowOrignalText.value && isShowOrignalText.value === true){
    return result
  }

  if (textTranInfo.value) {
    console.log(textTranInfo.value)
    const langInfoCode = textTranInfo.value?.find(info => info.code_id === lang.value);
    const langInfo = textTranInfo.value?.find(info => info.code === lang.value);
    if (langInfo) {
      result = langInfo.text;
    }else if(langInfoCode) {
      result = langInfoCode.text;
    }
   
  }

  return result;
});

const countChar = computed(() => {
  return text.value.length + itemUser.value.text.length
})

const loadingMessage = computed(() => chatStore.loadingMessage)

interface Emit {
  (ev: 'regenerate'): void
  (ev: 'retry'): void
  (ev: 'delete'): void
}



const emit = defineEmits<Emit>()
const messageRef = ref<HTMLElement>()

function handleRegenerate() {
  messageRef.value?.scrollIntoView()
  emit('regenerate')
}

function handleRetry() {
  messageRef.value?.scrollIntoView()
  emit('retry')
}


const currentIndex = ref(props.fullItem.currentIndex || 0);

const currentMessageAI = computed(() => props.fullItem.messageAi[currentIndex.value]);
const isPreviousDisabled = computed(() => currentIndex.value === 0);
const isNextDisabled = computed(() => currentIndex.value === props.fullItem.messageAi.length - 1);


const showNextItem = () => {

  // Handle text type
  if (currentIndex.value < props.fullItem.messageAi.length - 1) {
    currentIndex.value += 1;
  }

};

const showPreviousItem = () => {

  // Handle text type
  if (currentIndex.value > 0) {
    currentIndex.value -= 1;
  }

};
watch(() => props.fullItem.currentIndex, (newIndex) => {
  currentIndex.value = newIndex;
});


const getTotalItemCount = computed(() => props.fullItem.messageAi.length);
const colors:string[] = [ 'red', 'yellow', 'green', 'blue', 'indigo', 'purple', 'pink'];
const getRandomColor = computed(() => {
      const randomIndex = Math.floor(Math.random() * colors.length);
      // console.log(randomIndex)
      return 'bg-'+ colors[randomIndex]+ '-50';
 });
</script>

<template>
  <div 
  class="flex justify-center static"
 >

    <div
      class="mt-4 mb-1  mx-1 md:mx-4 w-full   border-[1px] border-gray-500 overflow-y-scroll bg-white  dark:bg-gray-900 py-8 px-2 md:px-8 shadow-lg"
      :dir="dir"
    >
      <h1 class="text-blue-500 text-center font-bold text-xl md:text-3xl py-2 pb-10">{{ itemUser.text }}</h1>
      <hr/>

      <TextComponent
        ref="textRef"
        class="w-full pt-4"
        :inversion="false"
        :error="currentMessageAI.error"
        :text="text"
        :loading="currentMessageAI.loading"
        :as-raw-text="asRawText"
      />
    </div>

  </div>

  <div
  v-if="countChar > 0"
  class="flex  mx-1 md:mx-4 justify-evenly flex-wrap drop-shadow-2xl gap-1 items-center bg-blue-50  dark:bg-gray-900 border-[1px] border-blue-800 rounded-lg py-2">
    <FooterMessageAI :item="currentMessageAI" />
    <expoortSelect
      v-if="!currentMessageAI.loading && !currentMessageAI.error && currentMessageAI.text !== ''"
      :item="fullItem"
      :isResearch="true"
      type="chat"
    />
 

<div class="flex justify-center items-center gap-1">
  <div class="px-2 py-1 rounded-md  bg-yellow-300 text-blue-900 font-bold self-end">{{ countChar }}</div>
    <button
      v-if="!loadingMessage && !currentMessageAI.error"
      class="p-2 bg-blue-100  dark:bg-gray-900  dark:hover:bg-gray-600 rounded-full hover:bg-blue-300"
      @click="handleRegenerate()"
    >
      <SvgIcon
        class="text-base bounce-in-fwd"
        icon="pajamas:retry"
      />
    </button>


    <div
      v-if="props.fullItem.messageAi.length > 1"
      class="flex flex-row gap-1 justify-end items-center"
    >
      <SvgIcon
        icon="icon-park-outline:left"
        :class="['text-lg', 'md:text-xl', 'bounce-in-fwd', 'cursor-pointer', { 'text-gray-400': isPreviousDisabled }]"
        @click="showPreviousItem"
      />
      <span class="text-sm text-gray-500 dark:text-gray-400">
        {{ `${currentIndex + 1} / ${getTotalItemCount}` }}

      </span>
      <SvgIcon
        icon="icon-park-outline:right"
        
        :class="['text-lg', 'md:text-xl', 'bounce-in-fwd', 'cursor-pointer', { 'text-gray-400': isNextDisabled }]"
        @click="showNextItem"
      />

    </div>
  </div>
  </div>
</template>
