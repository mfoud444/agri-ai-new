<script setup lang="ts">
import { ref } from 'vue';
import { NForm, NInput, NButton, FormRules } from 'naive-ui';
import { useRouter } from 'vue-router';
import { useSettingStore } from '@/store';
import { t } from '@/locales'
const router = useRouter();
const settingStore = useSettingStore();
const formRef = ref(null);

const form = ref({
  termsOfUse: ''
});

const rules: FormRules = {
  termsOfUse: [{ required: true, message: 'Terms of use is required', trigger: 'blur' }]
};

async function updateTermsOfUse() {
  try {
    await settingStore.updateTermsOfUse(form.value.termsOfUse);
    router.push({ name: 'settingsapp' });
  } catch (error) {
    console.error('Failed to update terms of use', error);
  }
}
</script>



<template>
    <div>
      <h1>{{ t('common.editTermsOfUse') }}</h1>
      <NForm :model="form" :rules="rules" ref="formRef">
        <NFormItem path="termsOfUse" :label="t('common.termsOfUse')">
          <NInput v-model:value="form.termsOfUse" type="textarea" />
        </NFormItem>
        <NButton @click="updateTermsOfUse">{{ t('common.save') }}</NButton>
      </NForm>
    </div>
  </template>
  
