
<script setup lang="ts">
import {  ref } from 'vue'
import {  NSelect, SelectOption } from 'naive-ui'
import { useChatStore } from '@/store'
import { t } from '@/locales'
const chatStore = useChatStore();
const value = ref(chatStore.currentConversation.type)

const options = [
    {
        label: t('chat.chatTypeText'),
        value: 'text',
        disabled: false,
    },
    {
        label: t('chat.chatTypeImage'),
        value: 'image',
        disabled: false,
    },
    {
        label: t('chat.chatTypeResearch'),
        value: 'research',
        disabled: false,
    },

]
function handleUpdateValue(value: PublicApp.TypeService, option: SelectOption) {
  chatStore.currentConversation.type = value
  chatStore.recordState()
}
</script>
<template>
        <NSelect
            v-model:value="value"
            :options="options"
            @update:value="handleUpdateValue"
        />
</template> 