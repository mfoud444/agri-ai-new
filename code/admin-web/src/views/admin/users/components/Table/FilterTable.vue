<script setup lang='ts'>

import {
    NSpace, NButton, useMessage, DataTableBaseColumn, DataTableColumns, NDropdown
} from 'naive-ui'
import { h, computed } from 'vue';
import OptionFilter from './OptionFilter.vue'
interface Props {
    mainColumn: DataTableBaseColumn<Research.University>
    columns: DataTableColumns<Research.University>
}
import { SvgIcon } from '@/components/common';

const props = defineProps<Props>()
const mainColumn = computed(() => props.mainColumn)
const columns = computed(() => props.columns)
const message = useMessage();
const options = [
    {
        key: 'header',
        type: 'render',
        render: () => {
            return h(
                OptionFilter,
                {
                    mainColumn: mainColumn.value,
                    columns: columns.value
                },
            )
        }

    },

]
function handleSelect(key: string | number) {
    message.info(String(key))
}

</script>


<template>
    <div class=" flex justify-end p-2">
        <NSpace>
            <NDropdown
                 trigger="click"
                :options="options"
                @select="handleSelect"
            >
                <div class=" flex rounded-full p-2 justify-center items-start bg-blue-200">
                    <SvgIcon
                        icon="solar:filter-bold-duotone"
                        class="text-xl"
                    />
                </div>
            </NDropdown>
        </NSpace>
</div></template>