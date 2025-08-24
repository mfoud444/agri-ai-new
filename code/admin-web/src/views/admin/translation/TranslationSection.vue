<template>
    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
      <dt class="text-sm font-medium text-gray-500">{{ sectionKey }}</dt>
      <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
        <template v-if="typeof sectionValue === 'object'">
          <TranslationSection
            v-for="(value, key) in sectionValue"
            :key="key"
            :sectionKey="key"
            :sectionValue="value"
            :path="[...path, key]"
            @update:value="updateNestedValue"
          />
        </template>
        <template v-else>
          <NInput
            v-model:value="sectionValue"
            @update:value="updateValue"
            placeholder="Enter translation"
            class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
          />
        </template>
      </dd>
    </div>
  </template>
  
  <script setup>
  import { defineProps, defineEmits } from 'vue'
  import { NInput } from 'naive-ui'
  
  const props = defineProps({
    sectionKey: {
      type: String,
      required: true,
    },
    sectionValue: {
      type: [String, Object],
      required: true,
    },
    path: {
      type: Array,
      required: true,
    },
  })
  
  const emit = defineEmits(['update:value'])
  
  const updateValue = (value) => {
    emit('update:value', props.path, value)
  }
  
  const updateNestedValue = (path, value) => {
    emit('update:value', path, value)
  }
  </script>
  