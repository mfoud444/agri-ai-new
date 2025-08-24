<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { FormInst } from 'naive-ui';
import { t } from '@/locales';
import { BaseInput, BaseSwitch } from '@/components/common';
import { useAppStore } from '@/store';
import { generateValidationRules } from '@/utils/functions';

const appStore = useAppStore();
const span = appStore.getSpan();
const props = defineProps<{
  initialModel: API.Country;
  objStore: Object,
}>();
onMounted(() => {
  emit('formMounted', formRef.value);
});
const emit = defineEmits(['handleValidateButtonClick', 'formMounted']);
const model = toRef(props, 'initialModel');
const formRef = ref<FormInst | null>(null);
const requiredFields: (keyof API.Country)[] = ['name', 'alpha_2', 'alpha_3', 'country_code', 'region', 'sub_region', 'region_code', 'sub_region_code'];
const rules = generateValidationRules(props.initialModel, requiredFields);
</script>

<template>
  <NForm
    ref="formRef"
    :model="model"
    :rules="rules"
    size="large"
  >
    <div>
      <NGrid>
        <NFormItemGi
          :span="span"
          path="name"
          :label="t('common.name')"
        >
          <BaseInput
            v-model="model.name"
            :placeholder="t('common.name')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="alpha_2"
          :label="t('common.alpha_2')"
        >
          <BaseInput
            v-model="model.alpha_2"
            :placeholder="t('common.alpha_2')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="alpha_3"
          :label="t('common.alpha_3')"
        >
          <BaseInput
            v-model="model.alpha_3"
            :placeholder="t('common.alpha_3')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="country_code"
          :label="t('common.country_code')"
        >
          <BaseInput
            v-model="model.country_code"
            :placeholder="t('common.country_code')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="iso_3166_2"
          :label="t('common.iso_3166_2')"
        >
          <BaseInput
            v-model="model.iso_3166_2"
            :placeholder="t('common.iso_3166_2')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="region"
          :label="t('common.region')"
        >
          <BaseInput
            v-model="model.region"
            :placeholder="t('common.region')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="sub_region"
          :label="t('common.sub_region')"
        >
          <BaseInput
            v-model="model.sub_region"
            :placeholder="t('common.sub_region')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="region_code"
          :label="t('common.region_code')"
        >
          <BaseInput
            v-model="model.region_code"
            :placeholder="t('common.region_code')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="sub_region_code"
          :label="t('common.sub_region_code')"
        >
          <BaseInput
            v-model="model.sub_region_code"
            :placeholder="t('common.sub_region_code')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="intermediate_region_code"
          :label="t('common.intermediate_region_code')"
        >
          <BaseInput
            v-model="model.intermediate_region_code"
            :placeholder="t('common.intermediate_region_code')"
            @keyup.enter="$emit('handleValidateButtonClick', $event)"
          />
        </NFormItemGi>

        <NFormItemGi
          :span="span"
          path="isActivate"
          :label="t('common.isActivate')"
        >
          <BaseSwitch v-model:value="model.is_activate" />
        </NFormItemGi>
      </NGrid>
    </div>
  </NForm>
</template>
