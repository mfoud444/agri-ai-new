<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { 
  NCard, 
  NSpace, 
  NSelect, 
  NTree, 
  NButton, 
  NInput,
  NModal,
  NTabs,
  NTabPane,
  NList,
  NListItem
} from 'naive-ui'
import { type I18n } from 'vue-i18n'
import translationsData from '@/locales'

type Language = 'zh-CN' | 'ar-DZ' | 'zh-TW' | 'en-US' | 'ko-KR' | 'ru-RU'

interface TreeNode {
  key: string
  label: string
  children?: TreeNode[]
  isLeaf?: boolean
  value?: string
}

interface MissingTranslation {
  language: string
  key: string
  referenceValue: string
}

// Initialize translations
const messages = (translationsData as I18n).global.messages 
const translations = ref<any>(messages)
const referenceLanguage = 'en-US'

// UI State
const languages = Object.keys(messages) as Language[]
const selectedLanguage = ref<Language>('en-US')
const selectedKeys = ref<string[]>([])
const expandedKeys = ref<string[]>([])
const selectedNode = ref<TreeNode | null>(null)
const editValue = ref('')
const saving = ref(false)

// Missing translations state
const showMissing = ref(false)
const missingTranslations = ref<MissingTranslation[]>([])
const quickEditValues = ref<Record<string, string>>({})

const languageOptions = computed(() => {
  return languages.map(lang => ({
    label: getLanguageName(lang),
    value: lang
  }))
})

const treeData = computed(() => {
  try {
    const currentTranslations = translations.value[selectedLanguage.value]
    return currentTranslations ? convertToTreeData(currentTranslations) : []
  } catch (error) {
    console.error('Error generating tree data:', error)
    return []
  }
})

const missingByLanguage = computed(() => {
  const grouped: Record<string, MissingTranslation[]> = {}
  missingTranslations.value.forEach(item => {
    if (!grouped[item.language]) {
      grouped[item.language] = []
    }
    grouped[item.language].push(item)
  })
  return grouped
})

function convertToTreeData(obj: any, parentKey = ''): TreeNode[] {
  if (!obj || typeof obj !== 'object') return []
  
  return Object.entries(obj).map(([key, value]) => {
    const currentKey = parentKey ? `${parentKey}.${key}` : key
    if (value && typeof value === 'object') {
      return {
        key: currentKey,
        label: key,
        children: convertToTreeData(value, currentKey)
      }
    }
    return {
      key: currentKey,
      label: key,
      isLeaf: true,
      value: String(value)
    }
  })
}

function getLanguageName(langCode: Language): string {
  const names: Record<Language, string> = {
    'zh-CN': 'Chinese (Simplified)',
    'ar-DZ': 'Arabic (Algeria)',
    'zh-TW': 'Chinese (Traditional)',
    'en-US': 'English (US)',
    'ko-KR': 'Korean',
    'ru-RU': 'Russian'
  }
  return names[langCode]
}

function handleSelect(keys: string[]) {
  selectedKeys.value = keys
  if (keys.length > 0) {
    const key = keys[0]
    selectedNode.value = findNodeByKey(treeData.value, key)
    if (selectedNode.value?.value) {
      editValue.value = selectedNode.value.value
    }
  } else {
    selectedNode.value = null
    editValue.value = ''
  }
}

function findNodeByKey(nodes: TreeNode[], key: string): TreeNode | null {
  for (const node of nodes) {
    if (node.key === key) return node
    if (node.children) {
      const found = findNodeByKey(node.children, key)
      if (found) return found
    }
  }
  return null
}

function handleExpand(keys: string[]) {
  expandedKeys.value = keys
}

function handleTranslationUpdate(value: string) {
  if (!selectedNode.value) return
  updateTranslationValue(selectedLanguage.value, selectedNode.value.key, value)
  saveTranslations()
}

function updateTranslationValue(lang: string, key: string, value: string) {
  const path = key.split('.')
  let target = translations.value[lang]
  
  for (let i = 0; i < path.length - 1; i++) {
    if (!target[path[i]]) {
      target[path[i]] = {}
    }
    target = target[path[i]]
  }
  
  target[path[path.length - 1]] = value
}

function handleQuickTranslation(lang: string, key: string, value: string) {
  const editKey = `${lang}-${key}`
  quickEditValues.value[editKey] = value
  updateTranslationValue(lang, key, value)
}

function getQuickEditValue(lang: string, key: string): string {
  const editKey = `${lang}-${key}`
  return quickEditValues.value[editKey] || ''
}

function initializeLanguage(lang: Language) {
  if (!translations.value[lang]) {
    translations.value[lang] = { ...translations.value['en-US'] }
  }
}

async function saveTranslations() {
  saving.value = true
  try {
    await new Promise(resolve => setTimeout(resolve, 1000))
    console.log('Saving translations:', translations.value)
    // Here you would typically make an API call to save the translations
  } catch (error) {
    console.error('Error saving translations:', error)
  } finally {
    saving.value = false
  }
}

// Translation checker functions
function getAllKeys(obj: any, prefix = ''): string[] {
  let keys: string[] = []
  
  for (const key in obj) {
    if (Object.prototype.hasOwnProperty.call(obj, key)) {
      const newPrefix = prefix ? `${prefix}.${key}` : key
      
      if (typeof obj[key] === 'object' && obj[key] !== null) {
        keys = [...keys, ...getAllKeys(obj[key], newPrefix)]
      } else {
        keys.push(newPrefix)
      }
    }
  }
  
  return keys
}

function getNestedValue(obj: any, path: string): any {
  return path.split('.').reduce((curr, key) => curr?.[key], obj)
}

function checkTranslations() {
  const referenceKeys = getAllKeys(translations.value[referenceLanguage])
  const missing: MissingTranslation[] = []
  
  Object.keys(translations.value).forEach(lang => {
    if (lang === referenceLanguage) return
    
    referenceKeys.forEach(key => {
      const refValue = getNestedValue(translations.value[referenceLanguage], key)
      const targetValue = getNestedValue(translations.value[lang], key)
      
      if (
        targetValue === undefined || 
        targetValue === '' || 
        (typeof targetValue === 'string' && targetValue === refValue)
      ) {
        missing.push({
          language: lang,
          key: key,
          referenceValue: refValue
        })
      }
    })
  })
  
  missingTranslations.value = missing
  showMissing.value = true
}

// Watch for language changes and initialize if needed
watch(selectedLanguage, (newLang) => {
  if (!translations.value[newLang]) {
    initializeLanguage(newLang)
  }
})

// Initialize all languages
languages.forEach(initializeLanguage)
</script>

<template>
  <div class="container mx-auto p-4">
    <n-card>
      <template #header>
        <h1 class="text-2xl font-bold">Translation Manager</h1>
      </template>

      <n-space vertical>
        <div class="flex justify-between gap-4 items-center">
          <n-select
            v-model:value="selectedLanguage"
            :options="languageOptions"
            placeholder="Select Language"
            class="w-64"
          />
          <n-button
            type="warning"
            @click="checkTranslations"
          >
            Check Missing Translations
          </n-button>
        </div>

        <div class="flex gap-4">
          <div class="w-1/2">
            <n-tree
              :data="treeData"
              :selected-keys="selectedKeys"
              :expanded-keys="expandedKeys"
              @update:selected-keys="handleSelect"
              @update:expanded-keys="handleExpand"
                style="max-height: 400px; overflow-y: auto;"
            />
          </div>

          <div class="w-1/2">
            <n-card v-if="selectedNode" title="Edit Translation">
              <n-input
                v-model:value="editValue"
                type="textarea"
                :rows="3"
                placeholder="Enter translation"
                @update:value="handleTranslationUpdate"
              />
            </n-card>
          </div>
        </div>

        <!-- <n-button
          type="primary"
          @click="saveTranslations"
          :loading="saving"
        >
          Save Translations
        </n-button> -->
      </n-space>
    </n-card>

    <!-- Missing Translations Modal -->
    <n-modal v-model:show="showMissing">
      <n-card
        style="max-width: 900px"
        title="Missing Translations"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <n-tabs type="line">
          <n-tab-pane
            v-for="(translations, lang) in missingByLanguage"
            :key="lang"
            :name="lang"
            :tab="getLanguageName(lang)"
          >
            <n-list>
              <n-list-item v-for="item in translations" :key="item.key">
                <n-space vertical>
                  <div class="font-bold">{{ item.key }}</div>
                  <div class="text-gray-600">
                    Reference ({{ referenceLanguage }}): {{ item.referenceValue }}
                  </div>
                  <n-input
                    :value="getQuickEditValue(item.language, item.key)"
                    type="textarea"
                    :rows="2"
                    placeholder="Enter translation"
                    @update:value="(value) => handleQuickTranslation(item.language, item.key, value)"
                  />
                </n-space>
              </n-list-item>
            </n-list>
          </n-tab-pane>
        </n-tabs>

        <template #footer>
          <n-space justify="end">
            <n-button @click="showMissing = false">
              Close
            </n-button>
            <n-button
              type="primary"
              @click="saveTranslations"
              :loading="saving"
            >
              Save All Changes
            </n-button>
          </n-space>
        </template>
      </n-card>
    </n-modal>
  </div>
</template>