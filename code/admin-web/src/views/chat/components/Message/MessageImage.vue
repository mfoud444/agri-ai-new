<script setup lang='ts'>
import { NImageGroup, NImage} from 'naive-ui'
import HeaderRand from './HeaderRand.vue'
import { useChatStore } from '@/store';
import ErrorImage from '@/assets/errorImage.png'
import { supabaseUrlImage } from '@/utils/supabase';
interface Props {
  item: Chat.MessageAI[]
}
const chatStore = useChatStore()
// const url = ''
// const url = 'http://127.0.0.1:8000/api/get-image/?path='
// const url = 'https://randai09078-randdaj.hf.space/api/get-image/?path='
const props = defineProps<Props>()
  const getImageSrc = (imagePath: string | undefined) => {
  return imagePath !== undefined && imagePath !== '' ? `${supabaseUrlImage}/${imagePath}`: ErrorImage
}
// const getImageSrc = (imagePath: string | undefined) => {
//   return imagePath !== undefined && imagePath !== '' ? imagePath: ErrorImage
// }

</script>
<template>
  <div class="bg-blue-50  dark:bg-gray-900 rounded-lg">
    <HeaderRand :date="item[0].createdAt" />

    <template v-if="item[0].loading">
      <div class="h-52 lg:h-56 flex items-center justify-center">
        <div class="loader-circle-38"></div>
      </div>
    </template>

    <template v-else>
      <div class="py-1 grid grid-cols-2 gap-1 place-content-around place-items-center">
        <NImageGroup>
        <template
          v-for="(image, index) in props.item"
          :key="index"
        >
          <NImage
            class="rounded-lg slide-in-fwd-center"
            width="150"
            height="150"
            lazy
            :src="getImageSrc(image.imagePath)"
          >
            <template #placeholder>
              <div class="flex items-center justify-center">
                <div class="loader1"></div>
              </div>
            </template>
          </NImage>

        </template>
      </NImageGroup>
      </div>
    </template>

  </div>
</template>