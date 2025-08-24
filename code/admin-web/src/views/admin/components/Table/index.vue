<script setup lang='ts'>
import { ref, h, onMounted, computed,reactive } from 'vue'
import {
  NSpace, NButton, NDataTable, DataTableBaseColumn,
  useDialog, NEmpty,NResult,
  DataTableRowKey, NModal,
  useMessage, DataTableFilterState, DataTableColumns,
} from 'naive-ui'
import { useUsersStore } from '@/store'
import { t } from '@/locales';
import { useIconRender } from '@/hooks/useIconRender'
import { useBasicLayout } from '@/hooks/useBasicLayout';

interface Props {
 date : Chat.CompanyAI[]
}

const props = defineProps<Props>()
const { iconRender } = useIconRender()
const loadingActionDelete = ref(false)
const loadingActionEdit = ref(false)
const loading = ref(true)
const error_get = ref<boolean>(false)
const checkedRowKeysRef = ref<Array<string | number>>([])
const { isMobile } = useBasicLayout()
const dialog = useDialog()
const message = useMessage();
const pageSize:number = 3
const pages = computed(() => 10)

const pagination = reactive({
  page: pages!,
  pageSize:pageSize,
  showSizePicker: true,
  // pageSizes: [3, 5, 7],
  onChange: (page: number) => {
    pagination.page = page
  },
  onUpdatePageSize: (pageSize: number) => {
    pagination.pageSize = pageSize
    pagination.page = 1
  }
})






const columns = reactive<DataTableColumns<Chat.CompanyAI>>([
  {
    type: 'selection',
    options: [
      'all',
      'none',
    ],
    disabled(row: Chat.CompanyAI) {
      return row.type_added === 'default'
    }
  },
  {
    title: t('research.actions'),
    key: 'actions',
    align: 'center',
    width: 100,
    render(row: Chat.CompanyAI) {
      return h(
        'div',
        {
          class: 'flex gap-1'
        },
        [
          h(
            NButton,
            {
              strong: true,
              tertiary: true,
              size: 'small',
              loading: loadingActionEdit.value,
              style:"border-radius:100%",
              onClick: async () => {
                try {
                //   await handleUpdateUniversity(row);
                } catch (error: any) {

                  console.error(t('common.updateFailed'), error.message);
                }
              }
            },
            { default: () => h(iconRender({ icon: 'fluent:edit-32-regular', color: 'blue' })) }
          ),

          h(
            NButton,
            {
              strong: true,
              tertiary: true,
              size: 'small',
              loading: loadingActionDelete.value,
            //   onClick: () => handleDeleteAction(row)
            },
            { default: () => h(iconRender({ icon: 'fluent:delete-32-regular', color: 'red' })) }
          ),

        ]
      );
    }
  },

]);




const dataTableInstRef = ref(null)
const dataTableInst = dataTableInstRef


</script>
<template>
  <div class="container_dashboard">

    <div class="header_dashboard">
        {{ t('university.universitys') }}
      </div>


    <div class="">
      <NSpace
        vertical
        :size="12"
      >
        <template v-if="error_get">
          <div class=" border-red-400 bg-red-100 p-4 rounded-lg ">


      
        </div>
        </template>
        <template v-if="!error_get">
            <NDataTable
          remote
            :size="isMobile ? 'small' : 'small'"
            striped
            :loading="loading"
            ref="dataTableInst"
            :columns="columns"
            :data="data"
            :pagination="pagination"
            :max-height="isMobile ? 400 : 370"
            :min-height="isMobile ? 380 : 370"
            :paginate-single-page=false
        
          />
          <!-- <NDataTable
          remote
            :size="isMobile ? 'small' : 'small'"
            striped
            :loading="loading"
            ref="dataTableInst"
            :columns="columns"
            :data="data"
            :pagination="pagination"
            :max-height="isMobile ? 400 : 370"
            :min-height="isMobile ? 380 : 370"
            :paginate-single-page=false
            v-model:checked-row-keys="checkedRowKeysRef"
            @update:filters="handleUpdateFilter"
            @update:sorter="handleSorterChange"
            :row-key="rowKey"
            @update:checked-row-keys="handleCheck"
          /> -->
        </template>
      </NSpace>
    </div>
  </div>


</template>

<style scoped>
:deep(th) {
  font-weight: bold;
font-size: 1rem;

}

</style>
