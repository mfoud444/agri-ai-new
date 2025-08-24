<script lang="ts" setup>
import { computed, onMounted, onUnmounted, onUpdated, ref } from 'vue'
import MarkdownIt from 'markdown-it'
import mdKatex from '@traptitech/markdown-it-katex'
import mila from 'markdown-it-link-attributes'
import hljs from 'highlight.js'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { t } from '@/locales'
import { copyToClip } from '@/utils/copy'
import { SvgIcon } from '@/components/common'
import { useChatStore } from '@/store'
// import * as markdownItLinkPreview from 'markdown-it-link-preview';

interface Props {
  inversion?: boolean
  error?: boolean
  text?: string
  loading?: boolean
  asRawText?: boolean
}

const props = defineProps<Props>()
const { isMobile } = useBasicLayout()
const textRef = ref<HTMLElement>()
const mdi = new MarkdownIt({
  html: false,
  linkify: true,
  highlight(code, language) {
    const validLang = !!(language && hljs.getLanguage(language))
    if (validLang) {
      const lang = language ?? ''
      return highlightBlock(hljs.highlight(code, { language: lang }).value, lang)
    }
    return highlightBlock(hljs.highlightAuto(code).value, '')
  },
})

mdi.use(mila, {
   attrs: { 
    target: '_blank', 
    rel: 'noopener' ,
    class: 'bg-red-200',
  } })

mdi.use(mdKatex, { blockClass: 'katexmath-block rounded-md p-[10px]', errorColor: ' #cc0000' })
// mdi.use(markdownItLinkPreview); 

const wrapClass = computed(() => {
  return [
    'text-wrap',
    'min-w-[30px]',
    'text-base',
    'md:text-[0.9rem]',
    isMobile.value ? 'p-2' : 'px-3 py-1',
  ]
})
const chatStore = useChatStore()
const isStream = computed(() => {
  const currentConversation = chatStore.currentConversation;

  if (currentConversation.modelInfo?.isStream) {
    const languages = currentConversation.modelInfo.languages;
    // console.log('languages', languages, currentConversation.lang)
    if (languages && currentConversation.lang && languages.includes(currentConversation.lang)) {
      return true;
    }
  }

  return false;
});

const text = computed(() => {
  const value = props.text ?? '';
  if (!props.asRawText) {
    return mdi.render(value);
  }
  return value;
});

function highlightBlock(str: string, lang?: string) {
  return `<pre class="code-block-wrapper" dir="ltr"><div class="code-block-header"><span class="code-block-header__lang">${lang}</span><span class="code-block-header__copy">${t('chat.copyCode')}</span></div><code class="hljs code-block-body ${lang}">${str}</code></pre>`
}



function addCopyEvents() {
  if (textRef.value) {
    const copyBtn = textRef.value.querySelectorAll('.code-block-header__copy')
    copyBtn.forEach((btn) => {
      btn.addEventListener('click', () => {
        const code = btn.parentElement?.nextElementSibling?.textContent
        if (code) {
          copyToClip(code).then(() => {
            btn.textContent = t('chat.copySuccess')
            setTimeout(() => {
              btn.textContent = t('chat.copyCode')
            }, 1000)
          })
        }
      })
    })
  }
}

function removeCopyEvents() {
  if (textRef.value) {
    const copyBtn = textRef.value.querySelectorAll('.code-block-header__copy')
    copyBtn.forEach((btn) => {
      btn.removeEventListener('click', () => {})
    })
  }
}




onMounted(() => {
  addCopyEvents()
})

onUpdated(() => {
  addCopyEvents()
})

onUnmounted(() => {
  removeCopyEvents()
})
const lang = computed(() => chatStore.currentConversation.lang)
const type = computed(() => chatStore.currentConversation.type);
</script>

<template>
    
  <div class="text-black dark:text-white" :class="wrapClass">
    <div ref="textRef" class="leading-relaxed  break-words">
      
      <div v-if="!inversion">
        <div v-if="!asRawText" class="markdown-body " style=" background-color: white;"   v-html="text" />
        <div v-else class="whitespace-pre-wrap" v-text="text" />
      </div>

      <div v-else class="whitespace-pre-wrap  md:text-[1.2rem]" v-html="text" />
      <template v-if="loading && !isStream && type === 'research'">
        <div class="h-52 lg:h-56 flex  items-center  gap-8">
          <div class="pulse"></div>
          <!-- <div class="spinner-non-stream"></div> -->
        <div class="flex flex-wrap items-center justify-center gap-2 text-blue-700">
        
          <div class="text-small md:text-lg  text-center font-bold">
            {{ lang === 'ar' ? 'ستحصل على إجابة القسم كاملة خلال لحظات' : 'You will get the full section answer in a few moments' }}
          </div>
       
           </div>
      </div>
      </template>

      <template v-if="loading && !isStream && type !== 'research'">
        <div class="h-52 lg:h-56 flex flex-col items-center justify-center gap-8">
          <div class="dots"></div>
          <!-- <div class="spinner-non-stream"></div> -->
        <div class="flex flex-wrap items-center justify-center gap-2 text-blue-700">
          <SvgIcon icon="material-symbols:info-outline"   class="h-5 w-5"/>
          <div class="text-small md:text-lg  text-center">
            {{ lang === 'ar' ? 'ستحصل على الإستجابة كاملة خلال لحظات' : 'You will get the full answer in a few moments' }}
          </div>
       
           </div>
      </div>
      </template>
      <template v-if="loading && isStream">
        <span class="dark:text-white w-[4px] h-[20px] block animate-blink" />
        <!-- <div class="pulser"></div> -->
      </template>

    </div>
  </div>

</template>

<style lang="less">
@import url(./style.less);


</style>
<style scoped>
.pulse {
   width: 9.6px;
   height: 9.6px;
   border-radius: 50%;
   background: #474bff;
   box-shadow: 0 0 0 0 rgba(71,75,255,0.5);
   animation: pulse-kefe91mn 1.5s infinite linear;
   position: relative;
}

.pulse:before,
.pulse:after {
   content: "";
   position: absolute;
   inset: 0;
   border-radius: inherit;
   box-shadow: 0 0 0 0 rgba(71,75,255,0.5);
   animation: inherit;
   animation-delay: -0.5s;
}

.pulse:after {
   animation-delay: -1s;
}

@keyframes pulse-kefe91mn {
   100% {
      box-shadow: 0 0 0 19.2px #0000;
   }
}
</style>
