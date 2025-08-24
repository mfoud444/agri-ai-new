<script setup lang='ts'>
import HeaderRand from './HeaderRand.vue'
import {  ref } from 'vue'
import { SvgIcon } from '@/components/common'
import { t } from '@/locales'
interface Props {
    item: Chat.MessageAI
}
const props = defineProps<Props>()
const emit = defineEmits<Emit>()
const messageRef = ref<HTMLElement>()
interface Emit {
    (ev: 'regenerate'): void
    (ev: 'retry'): void
    (ev: 'delete'): void
}
function handleRetry() {
    messageRef.value?.scrollIntoView()
    emit('retry')
}
</script>
<template>
    <div class="bg-red-50 dark:bg-red-900 dark:text-white rounded-lg">
        <HeaderRand :date="item.createdAt" />
        <div class="p-2 h-52 lg:h-56 flex items-center justify-center">
            <div  class="flex flex-col gap-4 item-center  rounded-lg">
            <div class="font-bold text-2xl text-center text-red-500 dark:text-white">{{ t('common.errorSomeThing') }}</div>
            <button
            @click="handleRetry()"
            class="flex bg-red-800 text-white  justify-center items-center gap-4 px-1 py-[0.2rem] border border-gray-200 rounded-lg  dark:border-gray-700">
                <div class="font-bold text-lg ">{{ t('common.tryAgain') }}</div>
                    <SvgIcon
                        class="bounce-in-fwd"
                        icon="pajamas:retry"
                    />
               
            </button>
        </div>

        </div>

    </div>

</template>