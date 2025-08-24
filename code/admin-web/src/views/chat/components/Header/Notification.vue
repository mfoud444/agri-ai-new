<script lang="ts" setup>
import { ref } from 'vue'
import { NPopover, NBadge, NEllipsis } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { LogoApp } from '@/components/common';
import { useBasicLayout } from '@/hooks/useBasicLayout';
const { isMobile } = useBasicLayout()
const value = ref(0)
// interface Props {
//     value: 'Empty' | 'Popselect'

// }
// const props = defineProps<Props>()
</script>

<template>
    <NPopover
        placement="bottom"
        trigger="click"
        style="width: 300px; margin-left: 60px;"
    >
        <template #trigger>
            <NBadge
                class="cursor-pointer"
                :value="value"
                :max="99"
            >
                <SvgIcon
                    class="text-xl text-black dark:text-white"
                    icon="ion:notifcations"
                />

            </NBadge>
        </template>

        <template #header>
            <div
                class="flex flex-col gap-2"
                dir="rtl"
            >
                <div class="flex gap-4 items-center   px-2 h-28 overflow-hidden bg-rose-50 rounded-lg">

                    <div class="flex flex-col">
                        <div class="flex gap-2 items-start">
                            <LogoApp :size="30" />
                            <div class="font-bold text-lg gtext">
                                تنبية
                            </div>
                        </div>
                        <div>
                            يمكنك إلغاء خيار عدم تلقى الإيموجي في الردود من قائمة الإعدادات
                        </div>
                        <!-- <NEllipsis
                            class=""
                            :tooltip="true"
                        >
                        
                    يمكنك إلغاء خيار عدم تلقى الإيموجي في الردود من قائمة الإعدادات
                        
                        
                        </NEllipsis> -->
                    </div>
                </div>
<!-- 
                <div class="flex gap-4 items-center p-1 bg-rose-50 rounded-lg">
                    <LogoApp :size="30" />
                    <div class="flex flex-col">
                        <div class="font-bold">title</div>
                        <div>Vue.js will automatically escape any HTML content and prevent it from being executed as code,
                            reducing the risk of XSS vulnerabilities. Always sanitize and validate user input to ensure a
                            secure app</div>
                    </div>
                </div> -->

            </div>
        </template>

    </NPopover></template>
  
 