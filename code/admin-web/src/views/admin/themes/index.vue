<script setup>
import { ref, computed } from 'vue'
import { 
  NConfigProvider, 
  NLayout, 
  NLayoutHeader, 
  NLayoutContent, 
  NLayoutFooter,
  NCard, 
  NTabs, 
  NTabPane, 
  NH1,
  NButton,
  NSelect,
  useMessage
} from 'naive-ui'
import ThemeSection from './ThemeSection.vue'
import { useAppStore } from '@/store'

const message = useMessage()
const appStore = useAppStore()

// Get the initial theme variables based on the current theme
let themeVars = appStore.theme === 'dark' ? appStore.darkThemeVars : appStore.normalThemeVars;

const generalVariables = computed(() => ({
  baseColor: themeVars.baseColor,
  bodyColor: themeVars.bodyColor,
  popoverColor: themeVars.popoverColor,
  cardColor: themeVars.cardColor,
  modalColor: themeVars.modalColor,
  tableColor: themeVars.tableColor,
}))

const colorVariables = computed(() => ({
  primaryColor: themeVars.primaryColor,
  infoColor: themeVars.infoColor,
  successColor: themeVars.successColor,
  warningColor: themeVars.warningColor,
  errorColor: themeVars.errorColor,
  textColorBase: themeVars.textColorBase,
  textColor1: themeVars.textColor1,
  textColor2: themeVars.textColor2,
  textColor3: themeVars.textColor3,
}))

const typographyVariables = computed(() => ({
  fontFamily: themeVars.fontFamily,
  fontFamilyMono: themeVars.fontFamilyMono,
  fontSize: themeVars.fontSize,
  fontWeight: themeVars.fontWeight,
  lineHeight: themeVars.lineHeight,
}))

const sizeVariables = computed(() => ({
  borderRadius: themeVars.borderRadius,
  heightTiny: themeVars.heightTiny,
  heightSmall: themeVars.heightSmall,
  heightMedium: themeVars.heightMedium,
  heightLarge: themeVars.heightLarge,
}))

const effectVariables = computed(() => ({
  boxShadow1: themeVars.boxShadow1,
  boxShadow2: themeVars.boxShadow2,
  boxShadow3: themeVars.boxShadow3,
}))

const saveTheme = () => {

  if (appStore.theme === 'dark') {
    appStore.setDarkThemeVars(themeVars)
  } else {
    appStore.setlightThemeVars(themeVars)
  }
}

const themeOptions = ref([
  { label: 'Light', value: 'light' },
  { label: 'Dark', value: 'dark' }
])

const selectedTheme = ref(appStore.theme)

const switchTheme = (value) => {
  selectedTheme.value = value
  appStore.setTheme(value)
  
  // Update theme variables based on the selected theme
  themeVars = value === 'dark' ? appStore.darkThemeVars : appStore.normalThemeVars
}

const updateThemeVariable = (key, value) => {
  themeVars[key] = value
  saveTheme() // Save changes immediately when a variable is updated
}
</script>
<template>
  <div class="mx-8 my-4">


  <n-config-provider :theme-overrides="themeOverrides">
    <n-layout>
      <n-layout-header>
        <n-h1>Theme Control</n-h1>
        <n-select 
          v-model:value="selectedTheme" 
          :options="themeOptions" 
          @update:value="switchTheme" 
          placeholder="Select Theme"
        />
      </n-layout-header>
      <n-layout-content>
        <n-card>
          <n-tabs type="line" animated>
            <n-tab-pane name="general" tab="General">
              <ThemeSection :variables="generalVariables" @update:variable="updateThemeVariable" />
            </n-tab-pane>
            <n-tab-pane name="colors" tab="Colors">
              <ThemeSection :variables="colorVariables" @update:variable="updateThemeVariable" />
            </n-tab-pane>
            <n-tab-pane name="typography" tab="Typography">
              <ThemeSection :variables="typographyVariables" @update:variable="updateThemeVariable" />
            </n-tab-pane>
            <n-tab-pane name="sizes" tab="Sizes">
              <ThemeSection :variables="sizeVariables" @update:variable="updateThemeVariable" />
            </n-tab-pane>
            <n-tab-pane name="effects" tab="Effects">
              <ThemeSection :variables="effectVariables" @update:variable="updateThemeVariable" />
            </n-tab-pane>
          </n-tabs>
        </n-card>
      </n-layout-content>
      <n-layout-footer>
        <!-- Removed save button since the theme saves automatically -->
      </n-layout-footer>
    </n-layout>
  </n-config-provider>
</div>
</template>
