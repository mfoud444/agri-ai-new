<script setup lang='ts'>
import { computed, ref } from 'vue'
import { NGi, NGrid, NCheckbox, NButton } from 'naive-ui'
import { useResearchStore } from '@/store'
import { t } from '@/locales';
import { useBasicLayout } from '@/hooks/useBasicLayout';
const loading = ref(false)
const researchStore = useResearchStore()

const { isMobile } = useBasicLayout()

// const doc_options = computed(() => researchStore.$state.current_re_state.doc_options)
const docOptionsList = [
    'introduction',
    'methodology',
    'discussion',
    'summary',
    'result',
    'future_work',
    'conclusion',
    'references'
];
</script>

<template>
    <div class="my-2 p-4 rounded-lg py-12 flex flex-col gap-4 items-center justify-center  bg-rose-50">
        <div class="font-bold gtext text-3xl"> what is include in Research </div>
        <div class="flex flex-col gap-2">
            <NGrid
                :y-gap="8"
                :x-gap="16"
                :cols="isMobile ? 1 : 2"
            >
                <NGi
                    v-for="option in docOptionsList"
                    :key="option"
                >
                    <NCheckbox
                        :value="option"
                        :label="t('re.' + option)"
                    />
                </NGi>
            </NGrid>
        </div>

        <div class="flex flex-row justify-between w-full mt-4">
            <NButton>{{ t('auth.previous') }}</NButton>
            <NButton
                type="primary"
                :loading="loading"
            >{{ t('auth.signUp') }}</NButton>
        </div>
    </div></template>

