
<script setup lang="ts">
import { defineProps, ref, computed , watch} from 'vue';
import { SvgIcon } from '@/components/common';
import MessageUser from './MessageUser.vue';
import MessageAI from './MessageAI.vue';
import   expoortSelect  from '../SelectOptions/exportSelect.vue'
import MessageImage from './MessageImage.vue';
import MessageError from './MessageError.vue'
import MessageResearch from './MessageResearch.vue'
import { useChatStore } from '@/store';

const props = defineProps<{
  type: PublicApp.TypeService;
  index: number;
  item: Chat.Item;
}>();

const chatStore = useChatStore()
const lang = computed(() => chatStore.currentConversation.lang)
const currentIndex = ref(props.item.currentIndex || 0);
const loadingMessage = computed(() => chatStore.loadingMessage)
const currentMessageAI = computed(() => props.item.messageAi[currentIndex.value]);
const isPreviousDisabled = computed(() => currentIndex.value === 0);
const isNextDisabled = computed(() => currentIndex.value === props.item.messageAi.length - 1);

const itemsPerPage = ref(4);
const getCurrentImageSubset = computed(() => {
  const startIdx = currentIndex.value;
  const endIdx = Math.min(startIdx + itemsPerPage.value, props.item.messageAi.length);
  return props.item.messageAi.slice(startIdx, endIdx);
});
const showNextItem = () => {
 if (props.type === 'image') {
    // Handle image type
    const lastPageIndex = Math.ceil(props.item.messageAi.length / itemsPerPage.value) - 1;
    if (currentIndex.value < lastPageIndex * itemsPerPage.value + itemsPerPage.value - 1) {
      currentIndex.value += itemsPerPage.value;
    }
  } else {
    // Handle text type
    if (currentIndex.value < props.item.messageAi.length - 1) {
      currentIndex.value += 1;
    }
  }
};

const showPreviousItem = () => {
 if (props.type === 'image') {
    // Handle image type
    if (currentIndex.value >= itemsPerPage.value) {
      currentIndex.value -= itemsPerPage.value;
    }
  } else {
    // Handle text type
    if (currentIndex.value > 0) {
      currentIndex.value -= 1;
    }
  } 
};
watch(() => props.item.currentIndex, (newIndex) => {
  currentIndex.value = newIndex;
});

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
const totalItemCount = computed(() => props.item.messageAi.length);
const getCurrentPageIndex = computed(() => Math.floor(currentIndex.value / itemsPerPage.value) + 1);
const getTotalPageCount = computed(() => Math.ceil(props.item.messageAi.length / itemsPerPage.value));
const getTotalItemCount = computed(() => props.item.messageAi.length);
</script>


<template>
  <div class="rounded-xl" :dir="lang === 'ar' ? 'rtl' : 'ltr'">
    <MessageUser 
    v-if="type !== 'research'"
    :item="item.messageUser" />
    <div 
    :class="type !== 'research' ? 'bg-blue-100 dark:bg-gray-800 px-2 py-0' : ''">
   
      <MessageAI v-if="(type === 'text' || type === 'AI' || type === 'Agri-Expert' ) && !currentMessageAI.error" :item="currentMessageAI" />
      <MessageResearch
      :itemUser="item.messageUser"
       v-if="type === 'research' && !currentMessageAI.error" 
       :item="currentMessageAI" 
       :fullItem="item"
       @regenerate="handleRegenerate()"
       />
      <MessageImage v-if="type === 'image' && !currentMessageAI.error"    :item="getCurrentImageSubset"/>
      <MessageError   @retry="handleRetry()" v-if="currentMessageAI.error" :item="currentMessageAI" />
    </div>
    <div  
    v-if="type !== 'research'"
    class="flex flex-row gap-2 justify-between items-center mx-4  md:gap-1 py-2">
   
 <div class="flex justify-center items-center gap-1">
        <!-- <button
        v-if="!loadingMessage && !currentMessageAI.error && type !== 'image'"
        class="p-2 bg-blue-100 dark:bg-gray-900  dark:hover:bg-gray-600  rounded-full hover:bg-blue-300"
          @click="handleRegenerate()"
        >
          <SvgIcon
          class="text-base bounce-in-fwd"
          icon="pajamas:retry"
        />
      </button> -->
  
  
      <div  v-if="(props.type === 'image' && props.item.messageAi.length > itemsPerPage) || (props.type != 'image' && props.item.messageAi.length > 1) "     class="flex flex-row gap-1 justify-end items-center">
      <SvgIcon
        icon="icon-park-outline:left"
        :class="['text-lg', 'md:text-xl', 'bounce-in-fwd', 'cursor-pointer', { 'text-gray-400': isPreviousDisabled }]"
        @click="showPreviousItem"
      />
      <span class="text-sm text-gray-500 dark:text-gray-400">
        {{ props.type === 'AI' ? `${currentIndex + 1} / ${getTotalItemCount}` : `${getCurrentPageIndex} / ${getTotalPageCount}` }}

      </span>
      <SvgIcon
        icon="icon-park-outline:right"
        :class="['text-lg', 'md:text-xl', 'bounce-in-fwd', 'cursor-pointer', { 'text-gray-400': isNextDisabled }]"
        @click="showNextItem"
      />
   
    </div>
</div>
      <!-- Display current item index and total count -->
   

    <!-- <expoortSelect 
     v-if="type !== 'image' && !currentMessageAI.loading && !currentMessageAI.error && currentMessageAI.text !== ''" 
    :item="item" 
    :isResearch="true"
      type="chat" /> -->
    </div>
  </div>
</template>