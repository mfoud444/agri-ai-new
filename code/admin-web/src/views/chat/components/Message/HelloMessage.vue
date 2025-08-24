<script setup lang='ts'>
import { LogoApp } from '@/components/common';
import { computed } from 'vue'
import { useChatStore } from '@/store';
import { NEllipsis } from 'naive-ui';
import TextJson from './Json/text.json'
import ImageJson from './Json/image.json'
import ResearchJson from './Json/research.json'
const chatStore = useChatStore();
const lang = computed(() => chatStore.currentConversation.lang)
const typeService = computed(() => chatStore.currentConversation.type);
function setPrompt(prompt: string) {
  chatStore.currentPromptUser = prompt;
}

const codeItems = computed(() => {
  const baseCodeItems = TextJson

  if (typeService.value === 'image') {
    return ImageJson
  }

  if (typeService.value === 'research') {
    return ResearchJson
  }
  // Default to the baseCodeItems if typeService is not 'image'
  return baseCodeItems;
});

const cardColors = ['bg-orange-100 dark:bg-orange-950', 'bg-green-100 dark:bg-green-950', 'bg-yellow-100 dark:bg-yellow-950'];
const innerColors = ['bg-sky-100', 'bg-rose-100', 'bg-orange-100'];
let colorIndex = 0;


</script>

<template>
  <div :dir="lang === 'ar' ? 'rtl' : 'ltr'"  class="flex flex-col items-center md:items-start rounded-2xl h-[50vh]">
    <div class="flex flex-col mb-4 items-center md:items-start">
      <div>
        <LogoApp :size="48"/>
      </div>
      <div class="text-lg  gtext dark:g-dark-text lg:text-2xl font-bold">
        {{ lang === 'ar' ? 'مرحبًا، كيف يمكنني مساعدتك اليوم؟' : 'Hello, How can I help you today?' }}
      </div>
    </div>

    <div class="grid grid-cols-2 gap-1 lg:grid-cols-3 md:grid-cols-2">
      <!-- Code Section -->
      <template v-for="item in codeItems[lang]" :key="item.title">
        <div :class="[cardColors[colorIndex++ % cardColors.length], 'p-2 w-38  md:w-56 h-44 overflow-hidden rounded-lg mb-2']">
          <NEllipsis class="font-bold text-xl  gtext pb-1 mb-2">{{ item.title }}</NEllipsis>
          <div class="flex flex-col gap-2 justify-start">
            <template v-for="code in item.codes" :key="code">
              <div @click="setPrompt(code)" class="flex items-center bg-blue-500 dark:bg-gray-600 text-white p-1 px-3 rounded-lg cursor-pointer">
                <NEllipsis :line-clamp="1">
                  {{ code }}
                  <template #tooltip>
                    <div class="lg:max-w-60">{{ code }}</div>
                  </template>
                </NEllipsis>
              </div>
            </template>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>
