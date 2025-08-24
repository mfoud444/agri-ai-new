<script setup lang='ts'>
import { ref, computed } from 'vue'
import { useMessage } from 'naive-ui'
import TextComponent from './Text.vue'
import HeaderRand from './HeaderRand.vue'
import FooterMessageAI from './FooterMessageAI.vue'
import ImageGrid from './ImageGrid.vue'
import { useChatStore } from '@/store'
const message = useMessage()
interface Props {
  item: Chat.MessageAI
}

interface Emit {
  (ev: 'regenerate'): void
  (ev: 'delete'): void
}
const emit = defineEmits<Emit>()
const props = defineProps<Props>()
const asRawText = ref(false)
const chatStore = useChatStore()
const lang = computed(() => chatStore.currentConversation.lang)
const textTranInfo = computed(() => props.item.textTranInfo);
const isShowOrignalText = computed(() => props.item.isShowOrignalText);

const dir = computed(() => {
  let dir = ''
  if(isShowOrignalText.value && isShowOrignalText.value === true && chatStore.currentConversation.lang == 'ar'){
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

</script>

<template>
   <div class="bg-white dark:bg-gray-900 rounded-lg p-1">
    <HeaderRand :date="item.createdAt"/>
  <div class="overflow-hidden">
    <div  :dir="dir">

      <TextComponent
        ref="textRef"
        class="w-full"
        :inversion="false"
        :error="item.error"
        :text="text"
        :loading="item.loading"
        :as-raw-text="asRawText"
      />


      <template v-if="item.answerMedia && item.answerMedia.length > 0">
          <ImageGrid :mediaItems="item.answerMedia" :loading="item.loading" />
        </template>
  
  </div>
  <div class="my-1">
  <FooterMessageAI :item="item"/>
</div>
</div>
</div></template>
