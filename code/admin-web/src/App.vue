<script setup lang="ts">
import { NConfigProvider } from 'naive-ui'
import { NaiveProvider } from '@/components/common'
import { useTheme } from '@/hooks/useTheme'
import { useLanguage } from '@/hooks/useLanguage'
import { onMounted } from 'vue'

const { theme, themeOverrides } = useTheme()
const { language } = useLanguage()

onMounted(() => {
  const script = document.createElement('script')
  script.type = 'application/ld+json'
  script.text = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    'name': 'Agricultural Expert',
    'description': 'Engage in Agricultural Expert with AI-powered chatbots. Free and No Ads.',
    'url': 'https://example.com',
    'logo': 'https://.com',
    'potentialAction': {
      '@type': 'SearchAction',
      'target': {
        '@type': 'EntryPoint',
        'urlTemplate': 'https://query.example.com/search?q={search_term_string}'
      },
      'query-input': 'required name=search_term_string'
    }
  })
  document.head.appendChild(script)
})
</script>

<template>
  <NConfigProvider
    class="h-full"
    :theme="theme"
    :theme-overrides="themeOverrides"
    :locale="language"
  >
    <NaiveProvider>
      <RouterView />
    </NaiveProvider>
  </NConfigProvider>
</template>