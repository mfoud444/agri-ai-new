<script lang="ts" setup>
import { t } from '@/locales';

import textGen from '@/assets/textGen.png'
import imageGen from '@/assets/imageGen.png'
import aiChat from '@/assets/aiChat.avif'
import noAds from '@/assets/noAds.webp'
import freeAndNoAds from '@/assets/freeAndNoAds.png'
</script>

<template>
  <div class=" font-bold text-6xl md:text-8xl underlined gtext text-center my-8"> Features </div>
  <div class="grid grid-col-2 gap-y-2">
    <!-- Text Generation div -->
    <div class="section bg-purple-100 dark:bg-purple-900 dark:text-white">
      <div class="header2 gtext">{{ t('features.textGeneration') }}</div>
      <img class="w-72 h-44 rounded-lg" :src="textGen" alt="text Generation">
      <div class="description">{{ t('features.textGenerationDescription') }}</div>
    </div>

    <!-- Image Generation div -->
    <div class="section bg-orange-100 dark:bg-orange-900 dark:text-white">
      <div class="header2 gtext">{{ t('features.imageGeneration') }}</div>
      <img class="w-72 h-44 rounded-lg" :src="imageGen" alt="image Generation">
      <div class="description">{{ t('features.imageGenerationDescription') }}</div>
    </div>

    <!-- AI Chat div -->
    <div class="section bg-emerald-100 dark:bg-emerald-900 dark:text-white">
      <div class="header2 gtext">{{ t('features.aiChat') }}</div>
      <img class="w-72 h-44 rounded-lg" :src="aiChat" alt="AI Chat">
      <div class="description">{{ t('features.aiChatDescription') }}</div>
    </div>

    <!-- Free and No Ads div -->
    <div class="section bg-red-100 dark:bg-red-900 dark:text-white">
      <div class="header2 gtext">{{ t('features.freeAndNoAds') }}</div>
      <img class="w-72 h-44 rounded-lg" :src="noAds" alt="Free and No Ads">
      <div class="description">{{ t('features.freeAndNoAdsDescription') }}</div>
    </div>
  </div>
</template>
<style scoped>
.section{
  @apply flex p-4 rounded-lg flex-col gap-4 items-center mx-4;
}
.header2{
  @apply font-bold  text-3xl py-2;
}
.description{
@apply text-xl text-gray-700 dark:text-yellow-300 text-center;
}
</style>