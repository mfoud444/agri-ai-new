<template>
    <n-grid :x-gap="12" :y-gap="8" :cols="24">
      <n-grid-item v-for="(value, key) in variables" :key="key" :span="12">
        <n-form-item :label="formatLabel(key)">
          <n-color-picker v-if="isColor(value)" :value="value" @update:value="updateColor(key, $event)" />
          <n-input v-else :value="value" @update:value="updateValue(key, $event)" />
        </n-form-item>
      </n-grid-item>
    </n-grid>
  </template>
  
  <script setup>
  import { NGrid, NGridItem, NFormItem, NInput, NColorPicker } from 'naive-ui'
  
  const props = defineProps({
    variables: {
      type: Object,
      required: true
    }
  })
  
  const emit = defineEmits(['update:variable'])
  
  const formatLabel = (key) => {
    return key.replace(/([A-Z])/g, ' $1').replace(/^./, (str) => str.toUpperCase())
  }
  
  const isColor = (value) => {
    return /^(#|rgb|hsl)/.test(value)
  }
  
  const updateColor = (key, value) => {
    emit('update:variable', key, value)
  }
  
  const updateValue = (key, value) => {
    emit('update:variable', key, value)
  }
  </script>