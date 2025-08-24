<script setup lang='ts'>

import {
    NButton, DataTableFilterState, DataTableBaseColumn, DataTableColumns,
    NCheckboxGroup, NGrid, NCheckbox, NGi, NSelect, SelectOption, 
} from 'naive-ui'
import { ref, computed } from 'vue'
import { t } from '@/locales';
interface Props {
    mainColumn: DataTableBaseColumn<Research.University>
    columns: DataTableColumns<Research.University>
}
import countryList, { Country } from 'country-list';
import { SvgIcon } from '@/components/common';
const allCountries: Country[] = countryList.getData();
const countriesOptions = allCountries.map(country => ({
    label: country.name,
    value: country.code,
    disabled: false,
}));
const cities = ref<(string | number)[] | null>(null)
const props = defineProps<Props>()
const mainColumn = computed(() => props.mainColumn)
const columns = computed(() => props.columns)
const sortOrder = ref<'ascend' | 'descend'>('ascend');
const sortOrderDate = ref<'ascend' | 'descend'>('ascend');
const toggleSortOrder = () => {
    sortOrder.value = sortOrder.value === 'ascend' ? 'descend' : 'ascend';
    sortName(sortOrder.value);
};
const toggleSortOrderDate = () => {
    sortOrderDate.value = sortOrder.value === 'ascend' ? 'descend' : 'ascend';
    sortDate(sortOrderDate.value);
};

const sortLabel = computed(() => {
    return sortOrder.value === 'ascend'
        ? t('Sort By Name')
        : t('Sort By Name');
});
const sortIcon = computed(() => {
    return sortOrder.value === 'ascend' ? 'bi:sort-up' : 'bi:sort-down';
});
const sortIconDate = computed(() => {
    return sortOrderDate.value === 'ascend' ? 'bi:sort-up' : 'bi:sort-down';
});
function filterAddress() {
    mainColumn.value.filterOptionValue = 'YE'
}

function unfilterAddress() {
    mainColumn.value.filterOptionValue = null
}

const columnsRef = ref(columns)
function sortName(order: any) {

    mainColumn.value.sorter = {
        compare: (a, b) => a.name.length - b.name.length,
        multiple: 2
    }
    mainColumn.value.sortOrder = order
}
function sortDate(order: any) {
    mainColumn.value.sorter = {
        compare: (a, b) => {
            const dateA = new Date(a.updated_at);
            const dateB = new Date(b.updated_at);

            // Compare the dates
            if (dateA < dateB) {
                return order === 'ascend' ? -1 : 1;
            } else if (dateA > dateB) {
                return order === 'ascend' ? 1 : -1;
            } else {
                return 0;
            }
        },
        multiple: 3,
    };

    mainColumn.value.sortOrder = order;
}

function clearSorter() {
    mainColumn.value.sortOrder = false

}

import { Filter } from 'naive-ui/es/data-table/src/interface';
const customFilter: Filter<Research.University> = (value, row) => {

return ~row.country.indexOf(value)
};
function handleSelectValueCountry(value: string, option: SelectOption) {


    mainColumn.value.filterOptionValue = value
    mainColumn.value.filter = customFilter
}
function handleUpdateValue(value: (string | number)[]) {
    citiesRef.value = value
    message.info(JSON.stringify(value))
}
</script>


<template>
    <div class=" flex flex-col gap-2 p-4">
        <div>
            <div class="flex gap-2 items-center">
                <SvgIcon icon="solar:filter-bold-duotone" />
                <div class="font-bold">Filter</div>
            </div>
            <div class="ml-4">
                <div class=" flex flex-col gap-2 p-2">
                    <NSelect
                        filterable
                        multiple
                        trigger="hover"
                        @update:value="handleSelectValueCountry"
                        :options="countriesOptions"
                        :consistent-menu-width="false"
                        :max-tag-count="2"
                    >
                        <NButton>{{ t('university.country') }}</NButton>
                    </NSelect>
                    <!-- <NButton @click="filterAddress">

                        Filter Address(Use Value 'London')
                    </NButton> -->



                    <NCheckboxGroup
                        v-model:value="cities"
                        @update:value="handleUpdateValue"
                    >
                        <NGrid
                            :y-gap="8"
                            :cols="2"
                        >
                            <NGi>
                                <NCheckbox
                                    value="Beijing"
                                    label="Beijing"
                                />
                            </NGi>
                            <NGi>
                                <NCheckbox
                                    value="Shanghai"
                                    label="Shanghai"
                                />
                            </NGi>
                            <NGi>
                                <NCheckbox
                                    value="Guangzhou"
                                    label="Guangzhou"
                                />
                            </NGi>
                            <NGi>
                                <NCheckbox
                                    value="Shenzen"
                                    label="Shenzhen"
                                />
                            </NGi>
                        </NGrid>
                    </NCheckboxGroup>

                </div>
            </div>
        </div>

        <div>
            <div class="flex gap-2 items-center">
                <SvgIcon
                    icon="ic:twotone-sort"
                    class=" text-base"
                />
                <div class="font-bold">Sort</div>
            </div>

            <div class="ml-4">
                <div class="flex justify-around">
                    <div
                        @click="toggleSortOrder"
                        class="flex gap-2 items-center cursor-pointer"
                    >
                        <SvgIcon
                            :icon="sortIcon"
                            class="text-base"
                        />
                        <div>{{ sortLabel }}</div>
                    </div>

                    <div
                        @click="toggleSortOrderDate"
                        class="flex gap-2 items-center cursor-pointer"
                    >
                        <SvgIcon
                            :icon="sortIconDate"
                            class="text-base"
                        />
                        <div>Sort By Date</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex  gap-2 justify-between">
            <NButton
                strong
                secondary
                type="error"
                @click="unfilterAddress"
            >
                <div class="flex gap-2 items-center">
                    <SvgIcon
                        icon="flat-color-icons:clear-filters"
                        class=" text-base"
                    />
                    <div>Clear Filters</div>
                </div>

            </NButton>

            <NButton
                strong
                secondary
                type="error"
                @click="clearSorter"
            >
                <div class="flex gap-2 items-center">
                    <SvgIcon
                        icon="carbon:sort-remove"
                        class="text-base"
                    />
                    <div>Clear Sorter</div>
                </div>

            </NButton>

        </div>
    </div>
</template>