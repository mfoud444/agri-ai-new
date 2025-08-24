<script setup lang='ts'>
import { NImageGroup, NImage, NSkeleton } from 'naive-ui';
import ErrorImage from '@/assets/errorImage.png';
interface Props {
  mediaItems: Chat.QuestionMedia[] | Chat.AnswerMedia[]
  loading: boolean;
}

const props = defineProps<Props>();

const getImageSrc = (imagePath: string | undefined) => {
  return imagePath ? imagePath : ErrorImage;
};

</script>
<template>
    <div class="bg-blue-50 dark:bg-gray-900 rounded-lg">
      <template v-if="loading">
        <div class="h-52 lg:h-56 flex items-center justify-center">
          <div class="loader-circle-38"></div>
        </div>
      </template>
      <template v-else>
        <div class="py-1 grid grid-cols-2 gap-1 place-content-around place-items-center">
          <NImageGroup>
            <template v-for="(image, index) in mediaItems" :key="index">
              <NImage
                class="rounded-lg slide-in-fwd-center"
                width="200"
                height="200"
                lazy
                :src="getImageSrc(image.mediaUrl)"
              >
                <template #placeholder>
                    <NSkeleton  :width="200" :height="200" :sharp="false"  />
                </template>
              </NImage>
            </template>
          </NImageGroup>
        </div>
      </template>
    </div>
  </template>
  