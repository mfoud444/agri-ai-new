
<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import { SelectOption, SelectGroupOption, NSelect } from 'naive-ui'
import { useChatStore } from '@/store'
const chatStore = useChatStore();
const currentModel = ref(chatStore.currentConversation.modelInfo.code)
const listModel =computed(() => {

  let filterBase = chatStore.currentConversation.type
  if (chatStore.currentConversation.type === 'research')
  filterBase = 'text'

 const  result =  chatStore.listModel.filter(model => model.typeService ===  filterBase)
  return result;

})

onMounted(async () => {
  chatStore.currentConversation.modelInfo = chatStore.getDefaultModel
  currentModel.value = chatStore.currentConversation.modelInfo.code
  await chatStore.fetchListModelsAIAction()
  const selectedModel = chatStore.listModel.find(model => model.code === currentModel.value);
  if (selectedModel) {
    chatStore.currentConversation.modelInfo = selectedModel;
  }
});

const options = computed(() => {
  return listModel.value.reduce((acc, model) => {
    const existingGroup = acc.find(group => group.modelLabel === model.companyAi.label);
    if (existingGroup) {
      existingGroup.modelChildren.push({
        disabled: false,
        modelLabel: model.label,
        modelValue: model.code
      });
    } else {
      acc.push({
        type: 'group',
        modelLabel: model.companyAi.label,
        key: model.companyAi.id,
        modelChildren: [
          {
            disabled: false,
            modelLabel: model.label,
            modelValue: model.code
          }
        ]
      });
    }
    return acc;
  }, []);
});
watch(() => chatStore.currentConversation.type, () => {
  chatStore.currentConversation.modelInfo = chatStore.getDefaultModel
  currentModel.value = chatStore.currentConversation.modelInfo.code
});
function handleUpdateValue(value: string, option: SelectOption) {
  const selectedModel = chatStore.listModel.find(model => model.code === value);
  if (selectedModel) {
    chatStore.currentConversation.modelInfo = selectedModel;
  }
  chatStore.recordState()
}
</script>


<template>
  <NSelect
    label-field="modelLabel"
    value-field="modelValue"
    children-field="modelChildren"
    :options="options"
    v-model:value="currentModel"
    @update:value="handleUpdateValue"
  />
</template> 