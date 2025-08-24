<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue';
import { NForm, NButton, FormRules, NCard, NTabs, NTabPane, NFormItem } from 'naive-ui';
import { useSettingStore } from '@/store';
import { t } from '@/locales';
import { MdEditor } from 'md-editor-v3';
import type { ExposeParam, FocusOption } from 'md-editor-v3';
import 'md-editor-v3/lib/style.css';
const editorRef = ref<ExposeParam>();

const settingStore = useSettingStore();
const formRefEn = ref(null);
const formRefAr = ref(null);
const loadingEn = ref(false);
const loadingAr = ref(false);

const formEn = ref({
    privacyPolicyEn: ''
});
const formAr = ref({
    privacyPolicyAr: ''
});

const rulesEn: FormRules = {
    privacyPolicyEn: [{ required: true, message: 'Privacy policy (English) is required', trigger: 'blur' }]
};
const rulesAr: FormRules = {
    privacyPolicyAr: [{ required: true, message: 'Privacy policy (Arabic) is required', trigger: 'blur' }]
};

async function updatePrivacyPolicyEn() {
    try {
        loadingEn.value = true;
        await settingStore.updatePrivacyPolicyEn(formEn.value.privacyPolicyEn);
        
    } catch (error) {
        console.error('Failed to update English privacy policy', error);
    } finally {
        loadingEn.value = false;
    }
}

async function updatePrivacyPolicyAr() {
    try {
        loadingAr.value = true;
        await settingStore.updatePrivacyPolicyAr(formAr.value.privacyPolicyAr);
        
    } catch (error) {
        console.error('Failed to update Arabic privacy policy', error);
    } finally {
        loadingAr.value = false;
    }
}

const isButtonDisabledEn = computed(() => {
    return loadingEn.value || !formEn.value.privacyPolicyEn;
});
const isButtonDisabledAr = computed(() => {
    return loadingAr.value || !formAr.value.privacyPolicyAr;
});

async function fetchData(): Promise<void> {
    try {
        // await settingStore.fetchDataAction();
        editorRef.value?.on('catalog', console.log);
        editorRef.value?.toggleCatalog(true);
        formEn.value.privacyPolicyEn = settingStore.$state.privacyPolicyEn || '';
        formAr.value.privacyPolicyAr = settingStore.$state.privacyPolicyAr || '';
    } catch (error: any) {
        console.error(t('setting.dataFetchError'), error.message);
    }
}
const option: FocusOption | undefined = 'start';

// Cursor position when focusing on textarea, default: position when it last lost focus
editorRef.value?.focus(option);
editorRef.value?.rerender();
onMounted(() => {
    fetchData()
  editorRef.value?.on('catalog', console.log);
  editorRef.value?.toggleCatalog(true);
  editorRef.value?.rerender();
  editorRef.value?.togglePreview(true);
  editorRef.value?.toggleHtmlPreview(true);
});

</script>


<template>
    <div class="p-8 m-8 shadow-lg mx-20 border-none flex flex-col gap-2 rounded-lg">
        <div class="post-heading mb-1">
            <div class="gtext text-2xl font-bold underlined mb-8">
                {{ t('common.editPrivacyPolicy') }}
            </div>
        </div>
       
        <NCard
            title="Edit Privacy Policy"
            style="margin-bottom: 16px"
        >
            <NTabs
                type="line"
                animated
            >
                <NTabPane
                    name="english"
                    tab="English"
                >
                    <NForm
                        :model="formEn"
                        :rules="rulesEn"
                        ref="formRefEn"
                    >
                        <NFormItem
                            path="privacyPolicyEn"
                            :label="t('common.privacyPolicyEn')"
                        >
                        <MdEditor  ref="editorRef" 
                          />
                        </NFormItem>
                        <div class="mt-4">
                            <NButton
                                type="primary"
                                style="width: 100%;"
                                size="large"
                                :loading="loadingEn"
                                :disabled="isButtonDisabledEn"
                                @click="updatePrivacyPolicyEn"
                            >
                                {{ t('common.save') }}
                            </NButton>
                        </div>
                    </NForm>
                </NTabPane>
                <NTabPane
                    name="arabic"
                    tab="Arabic"
                >
                    <NForm
                        :model="formAr"
                        :rules="rulesAr"
                        ref="formRefAr"
                    >
                        <NFormItem
                            path="privacyPolicyAr"
                            :label="t('common.privacyPolicyAr')"
                        >
                            <!-- <MdEditor
                                dir="rtl"
                                v-model="formAr.privacyPolicyAr"
                                style="min-height: 300px;"
                            /> -->
                        </NFormItem>
                        <div class="mt-4">
                            <NButton
                                type="primary"
                                style="width: 100%;"
                                size="large"
                                :loading="loadingAr"
                                :disabled="isButtonDisabledAr"
                                @click="updatePrivacyPolicyAr"
                            >
                                {{ t('common.save') }}
                            </NButton>
                        </div>
                    </NForm>
                </NTabPane>
            </NTabs>
        </NCard>
    </div>
</template>

