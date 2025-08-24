
<script setup lang="ts">
import {  ref, watch } from 'vue'
import {  NSelect } from 'naive-ui'
import { useChatStore } from '@/store'
const chatStore = useChatStore();
const value = ref(chatStore.currentConversation.lang)
const options = [
    {
        label: 'English',
        value: 'en',
        disabled: false,
    },
    {
        label: 'Arabic',
        value: 'ar',
        disabled: false,
    },

]

watch(() => value.value ,(newIndex) => {
    chatStore.currentConversation.lang = newIndex;
});
</script>
<template>
        <NSelect
            v-model:value="value"
            :options="options"
        />
</template> 