<script setup lang='ts'>
import { computed, onMounted, ref, watch } from 'vue'
import { useMessage,NSkeleton, NImage } from 'naive-ui'
import { LogoUser } from '@/components/common'
import TextComponent from './Text.vue'
import { SvgIcon } from '@/components/common'
import { t } from '@/locales'
import { copyToClip } from '@/utils/copy'
import ImageGrid from './ImageGrid.vue'
import { useChatStore, useUsersStore } from '@/store'
interface Props {
  item: Chat.MessageUser
}
const props = defineProps<Props>()
const message = useMessage()
const usersStore = useUsersStore()
const textRef = ref<HTMLElement>()
const asRawText = ref(props.item.inversion)
async function handleCopy() {
  try {
    await copyToClip(props.item.text || '')
    message.success(t('chat.copySuccess'),
    )
  }
  catch {
    message.error(t('chat.copyFailed'))
  }
}
const chatStore = useChatStore()
const lang = computed(() => chatStore.currentConversation.lang)
// const base64Image =  computed(() => 'data:image/png;base64,' + props.item.imagePath) 
import { supabaseUrlImage } from '@/utils/supabase';
const bucket: string = 'chat-text';
const imageUrl =  computed(() => `${supabaseUrlImage}/${bucket}/${props.item.imagePath}`)
const userId = computed(() =>  chatStore.currentConversation.userId)

const user = ref<User.UserData | null>(null);
const loading = ref<boolean>(false);
const error = ref<string | null>(null); 

// Fetch user data when the component is mounted
onMounted(async () => {
  if (!userId.value) return // If there's no userId, don't fetch

  loading.value = true
  error.value = null // Reset error state

  try {
    // Fetch user data using the store action
    user.value = await usersStore.fetchDataActionById(userId.value)
  } catch (err: any) {
    error.value = err.message // Store error message if fetch fails
    user.value = null // Reset user data on error
  } finally {
    loading.value = false // Always reset loading state
  }
})

// Computed property for user data
const userData = computed(() => user.value);


</script>

<template>

<div class="p-2">
  <div class="flex  items-center gap-1 justify-start  flex-shrink-0  overflow-hidden rounded-full basis-8">
    <LogoUser />
    <div class="">
      <div class="text-base font-bold">
        <NSkeleton v-if="loading" text :repeat="1" :width="80" :round="true" size="medium"/>
        <NSkeleton v-if="loading" text :repeat="1" :width="80" :round="true" size="medium"/>
      <div v-else>{{userData?.firstName}} {{userData?.lastName}}</div>
      
      </div>
      <p class="text-[0.6rem] md:text-[0.7rem]">
        {{ new Date(item.createdAt || '').toLocaleString() }}
      </p>
    </div>
  </div>


    <div class="relative">

      <button
      @click="handleCopy()"
      class="absolute bottom-2"
      :class="lang==='ar' ? 'left-4' : 'right-4'"
    >
      <SvgIcon
        icon="uil:copy"
        class=" text-lg md:text-xl"
      />
    </button>
 <div class="">
    <TextComponent
    ref="textRef"
    class="w-full"
    :inversion="true"
    :error="false"
    :text="item.text"
    :loading="false"
    :as-raw-text="asRawText"
  />
  <template v-if="item.questionMedia && item.questionMedia.length > 0">
  <div>
          <ImageGrid :mediaItems="item.questionMedia" :loading="false" />
        </div>
        </template>
</div>
</div>

  <!-- <div>
  
    <NImage
      v-if="item.imagePath !== undefined && item.imagePath !== ''"
      class="rounded-lg slide-in-fwd-center"
      width="200"
      height="200"
      lazy
      :src="imageUrl"
    >
      <template #placeholder>
        <div class="flex items-center justify-center">
          <div class="loader1"></div>
        </div>
      </template>
    </NImage>
  </div> -->
</div>

</template>
