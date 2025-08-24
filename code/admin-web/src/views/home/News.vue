<script lang="ts" setup>
import { t } from '@/locales'
import { useRouter } from 'vue-router'
import { useLoadingBar, NButton, NInput } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import hero from '@/assets/hero.svg'
import { ref } from 'vue';
const router = useRouter()
async function goService() {
    handleStart()
    await router.push('/chat')
    handleFinish()
}

const { isMobile } = useBasicLayout()
const loadingBar = useLoadingBar()
const disabledRef = ref(true)
function handleStart() {
    loadingBar.start()
    disabledRef.value = false
}
function handleFinish() {
    loadingBar.finish()
    disabledRef.value = true
}
const model = ref({ email: null });

</script>
<template>
    <div class="rounded-lg bg-yellow-300 p-4 flex flex-col gap-4">
        <div class="gtext font-bold text-2xl">Join News List</div>
        <div class="flex gap-4 justify-center items-center">
        <div class="w-96">
            <NInput
                v-model:value="model.email"
                placeholder="example@gmail.com"
                @keydown.enter.prevent
            >
                <template #prefix>
                    <SvgIcon
                        icon="ic:baseline-email"
                        class="text-md text-primary"
                    />
                </template>
            </NInput>
        </div>
        <NButton
            type="primary"
            class="btn btn-primary text-2xl w-full md:w-96"
            @click="goService"
        >
            {{ t('app.start') }}
        </NButton>
    </div>
</div></template>