<script setup lang='ts'>
import { computed, onUnmounted, ref, watch } from 'vue'
import { useMessage } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { useChatStore } from '@/store'
import { t } from '@/locales'
import { copyToClip } from '@/utils/copy'
import { put } from '@/utils/request'
const message = useMessage()
interface Props {
  item: Chat.MessageAI
}

interface Emit {
  (ev: 'regenerate'): void
  (ev: 'delete'): void
}

const chatStore = useChatStore()
const typeService = computed(() => chatStore.currentConversation.type);
const emit = defineEmits<Emit>()
const props = defineProps<Props>()

const item = computed(() => props.item);
const isLike = computed(() => props.item.isLike);

const asRawText = ref(false)
const messageRef = ref<HTMLElement>()

const isSpeaking = ref<boolean>(false)
const selectedIconLike = computed(() => {
  return isLike.value === true ? 'fluent:thumb-like-48-filled' : 'fluent:thumb-like-24-regular';
})

const selectedIconDisLike = computed(() => {
  return isLike.value === false ? 'fluent:thumb-dislike-24-filled' : 'fluent:thumb-dislike-24-regular';
})



async function handleLike(messageId: string, value: boolean | null) {
  if (isLike.value === value) {
    // Toggle like/dislike if the button is clicked again
    item.value.isLike = null;
  } else {
    item.value.isLike = value;
  }

  const data = {
    is_like: item.value.isLike,
    id:messageId
  }

  try {
    const result = await put<any>({
      url: `update-message-ai/${messageId}/`,
      data
    });

    console.log('PUT Success:', result);
  } catch (error: any) {
    console.error('PUT Error:', error.message);


  }
  console.log("is_likeRef.value", isLike.value)
}


const lang = computed(() => chatStore.currentConversation.lang);
const textTranInfo = computed(() => props.item.textTranInfo);
const isShowOrignalText = computed(() => props.item.isShowOrignalText);

const text = computed(() => {
  let result = props.item.text;
  if (isShowOrignalText.value && isShowOrignalText.value === true) {
    return result
  }

  if (textTranInfo.value) {
    console.log(textTranInfo.value)
    const langInfoCode = textTranInfo.value?.find(info => info.code_id === lang.value);
    const langInfo = textTranInfo.value?.find(info => info.code === lang.value);
    if (langInfo) {
      result = langInfo.text;
    } else if (langInfoCode) {
      result = langInfoCode.text;
    }

  }

  return result;
});



function handleShowTran() {
  item.value.isShowOrignalText = !isShowOrignalText.value
}


async function handleCopy() {
  try {
    await copyToClip(text.value || '')
    message.success(t('chat.copySuccess'),
    )
  }
  catch {
    message.error(t('chat.copyFailed'))
  }
}


let cancelSpeech = false;
let currentUtterance: SpeechSynthesisUtterance | null = null;

async function textToSpeech(text: string, lang: string = 'en'): Promise<void> {
  const voices = window.speechSynthesis.getVoices();

  // const arabicVoices = voices.filter((v) => v.lang.startsWith('ar'));
  // console.log(voices);

  if (isSpeaking.value) {
    cancelSpeech = true;
    window.speechSynthesis.cancel();
  }

  isSpeaking.value = true;

  if ('speechSynthesis' in window) {
    return new Promise<void>((resolve, reject) => {
      const utterance = new SpeechSynthesisUtterance(text);
      console.log("lang", lang)
      utterance.lang = lang;
      currentUtterance = utterance;
      utterance.onend = () => {
        isSpeaking.value = false;
        resolve();
      };
      utterance.onerror = (error) => {
        isSpeaking.value = false;
        reject(error);
      };
      if (!cancelSpeech) {
        window.speechSynthesis.speak(utterance);
      } else {
        cancelSpeech = false;
        window.speechSynthesis.cancel();
        isSpeaking.value = false;
        resolve();
      }
    });
  } else {
    console.error('SpeechSynthesis API is not supported in this browser');
    isSpeaking.value = false;
    return Promise.reject('SpeechSynthesis API is not supported in this browser');
  }
}


const isShowTranslate = computed(() => {
  let result = false
  if (typeService.value !== 'image' && text.value !== '' && textTranInfo && chatStore.currentConversation.lang != 'en') {
    if (textTranInfo.value) {
      const langInfo = textTranInfo.value.find(info => info.code === lang.value);

      if (langInfo) {
        result = true
      }
      const langInfoCode = textTranInfo.value?.find(info => info.code_id === lang.value);
      if (langInfoCode) {
        result = true
      }
    }
  }
  return result
})


onUnmounted(() => {
  if (isSpeaking.value) {
    cancelSpeech = true;
    window.speechSynthesis.cancel();
  }

});
</script>

<template>
  <div class="flex flex-row gap-2 justify-end items-center p-0 md:px-2 md:gap-1">




    <div class="inline-flex gap-2 px-1 border border-gray-200 rounded-full p-0.5 dark:border-gray-700">

      <button
        v-if="typeService !== 'image' && item.text !== '' && !item.loading"
        @click="textToSpeech(text, 'ar')"
        class="p-1 rounded-full flex justify-center"
        :class="[isSpeaking ? 'bg-primary text-white' : 'hover:bg-blue-200  ']"
      >
        <SvgIcon
          icon="lets-icons:sound-max-fill"
          class="bounce-in-fwd text-lg md:text-xl  rounded-full"
        />
      </button>

      <button
        v-if="typeService !== 'image' && item.text !== ''"
        @click="handleCopy()"
        class="p-1 rounded-full hover:bg-blue-200"
      >
        <SvgIcon
          icon="uil:copy"
          class=" text-lg md:text-xl"
        />
      </button>

      <!-- <template v-if="!item.inversion && !item.loading && !item.error && item.text !== ''">
        <button
          type="button"
          @click="handleLike(item.id!, false)"
          class="p-1 rounded-full"
          :class="[isLike === false ? 'text-blue-800 bg-blue-200 hover:bg-blue-100 hover:text-blue-800' : '']"
        >
          <SvgIcon
            :icon="selectedIconDisLike"
            class="text-lg md:text-xl"
          />
        </button>

        <button
          type="button"
          @click="handleLike(item.id!, true)"
          class="p-1 rounded-full"
          :class="[isLike === true ? 'text-blue-800 bg-blue-100 hover:bg-blue-100 hover:text-blue-800' : '']"
        >
          <SvgIcon
            :icon="selectedIconLike"
            class="text-lg md:text-xl"
          />
        </button>
      </template> -->

      <button
        v-if="isShowTranslate"
        @click="handleShowTran()"
        class="p-1 rounded-full"
        :class="isShowOrignalText ? 'bg-primary  text-white' : ''"
      >
        <SvgIcon
          icon="material-symbols:translate"
          class=" text-lg md:text-xl"
        />
      </button>
    </div>



  </div>
</template>
