<script setup lang='ts'>
import { onBeforeMount, onUnmounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useChatStore } from '@/store'
import { useMessage } from 'naive-ui'
import Chat from "./Chat.vue";
const chatStore = useChatStore()
// const route = useRoute()
// let { uuid } = route.params as { uuid: string }
const message = useMessage()
import { t } from '@/locales'

async function getChat() {
  try {
    chatStore.loadingChat = true
    await chatStore.getListChatAction()
    chatStore.loadingChat = false
  } catch (error: any) {
    console.error(error.message)
    // message.error(t('chat.deleteFailed') + ' ' )
    await chatStore.resetChatState()
    chatStore.loadingChat = false
  }
}

// onBeforeMount(async () => {
//   console.error("uuid")
//   // chatStore.currentConversation.id =  ''
//   await getChat()
// })

watch(() => chatStore.currentConversation.id, async (newUuid) => {
  console.error("uuid")
  chatStore.handelSelectAction(newUuid)
  await getChat()
})


</script>
<template>
   <Chat />
</template>