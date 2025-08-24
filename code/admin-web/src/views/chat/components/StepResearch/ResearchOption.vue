<script setup lang='ts'>
import { computed, } from 'vue'
import { NGi,  NGrid, NCheckbox } from 'naive-ui'
import { useResearchStore } from '@/store'
import { t } from '@/locales';
import { useBasicLayout } from '@/hooks/useBasicLayout';

const researchStore = useResearchStore()

const { isMobile } = useBasicLayout()


const doc_options = computed(() => researchStore.$state.current_re_state.doc_options)
</script>

<template>
    <div class="flex flex-col gap-2">
        <NGrid
            :y-gap="8"
            :cols="isMobile ? 1 : 2"
        >
            <NGi>
                <NCheckbox
                    v-model:checked="doc_options.is_border"
                    :label="t('re.border')"
                  
                />
            </NGi>
            <NGi>
        <NCheckbox
          v-model:checked="doc_options.is_cover"
          :label="t('re.isCover')"
        
        />
      </NGi>
      <NGi>
        <NCheckbox
          v-model:checked="doc_options.is_page_number"
          :label="t('re.isPageNumber')"
        
        />
      </NGi>
      <NGi>
        <NCheckbox
          v-model:checked="doc_options.is_index"
          :label="t('re.isIndex')"
        
        />
      </NGi>
        </NGrid>

</div></template>
  

