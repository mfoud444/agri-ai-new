<script setup lang="ts">
import { ref, computed } from 'vue';
import { SelectOption, NSelect } from 'naive-ui';
import { useSettingStore, useChatStore } from '@/store';
import promptText from './promt.json';
import promptImage from './image.json'
const settingStore = useSettingStore();
const chatStore = useChatStore()
const options = computed(() => {
  if (chatStore.currentConversation.type === 'text') {
    return promptText.map((item) => ({
      label: item.act,
      value: item.prompt.toString(),
    }));
  }
  else {
    return promptImage.map((item) => ({
      label: item.name,
      value: item.prompt,
    }));
  }

});


function handleSelect(value: string) {
  settingStore.updateSetting({ systemMessage: value })
  // settingStore.systemMessage = value
}
</script>
<template>
    <NSelect
      placeholder="Please select"
      filterable
      tag
      :options="options"
      @update:value="handleSelect"
    />
</template>
