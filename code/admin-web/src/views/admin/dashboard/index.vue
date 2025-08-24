<script setup lang="ts">
import { onMounted, ref, computed } from 'vue'
import { useDashboardStore } from '@/store'
import { SvgIcon } from '@/components/common'
import { t } from '@/locales'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { use } from "echarts/core"
import { CanvasRenderer } from "echarts/renderers"
import { LineChart, BarChart } from "echarts/charts"
import {
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
} from "echarts/components"
import VChart from "vue-echarts"

// Register ECharts components
use([
  CanvasRenderer,
  LineChart,
  BarChart,
  TitleComponent,
  TooltipComponent,
  LegendComponent,
  GridComponent
])

const dashboardStore = useDashboardStore()
const isLoading = ref(true)
const { isMobile } = useBasicLayout()




const cardItems = [
  { title: t('common.Clients'), count: () => dashboardStore.clientCount, icon: 'mdi:account-group' },
  { title: t('common.AgriExperts'), count: () => dashboardStore.expertCount, icon: 'mdi:account-tie' },
  { title: t('common.Admins'), count: () => dashboardStore.adminCount, icon: 'mdi:account-cog' },
  { title: t('common.AICompanies'), count: () => dashboardStore.aiCompanyCount, icon: 'mdi:domain' },
  { title: t('common.AIModels'), count: () => dashboardStore.aiModelCount, icon: 'mdi:robot' },
  { title: t('common.Questions'), count: () => dashboardStore.questionCount, icon: 'mdi:help-circle' },
  { title: t('common.convAI'), count: () => dashboardStore.convAICount, icon: 'hugeicons:ai-chat-02' },
  { title: t('common.convExperts'), count: () => dashboardStore.convExpertCount, icon: 'mdi:chat-processing' },
]

// Chart options
const userTrendOptions = computed(() => ({
  title: {
    text: t('common.UserGrowthTrend'),
    left: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  legend: {
    data: [t('common.Clients'), t('common.AgriExperts')],
    bottom: 0
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '60px',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    boundaryGap: false,
    data: dashboardStore.monthlyData?.map(d => d.month) || []
  },
  yAxis: {
    type: 'value'
  },
  series: [
    {
      name: t('common.Clients'),
      type: 'line',
      data: dashboardStore.monthlyData?.map(d => d.clientCount) || [],
      smooth: true
    },
    {
      name: t('common.AgriExperts'),
      type: 'line',
      data: dashboardStore.monthlyData?.map(d => d.expertCount) || [],
      smooth: true
    }
  ]
}))

const conversationTrendOptions = computed(() => ({
  title: {
    text: t('common.ConversationTrends'),
    left: 'center'
  },
  tooltip: {
    trigger: 'axis',
    axisPointer: {
      type: 'shadow'
    }
  },
  legend: {
    data: [t('common.convAI'), t('common.convExperts')],
    bottom: 0
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '60px',
    containLabel: true
  },
  xAxis: {
    type: 'category',
    data: dashboardStore.monthlyData?.map(d => d.month) || []
  },
  yAxis: {
    type: 'value'
  },
  series: [
    {
      name: t('common.convAI'),
      type: 'bar',
      data: dashboardStore.monthlyData?.map(d => d.aiConvCount) || [],
      itemStyle: {
        color: '#4080ff'
      }
    },
    {
      name: t('common.convExperts'),
      type: 'bar',
      data: dashboardStore.monthlyData?.map(d => d.expertConvCount) || [],
      itemStyle: {
        color: '#00b42a'
      }
    }
  ]
}))

onMounted(async () => {
  await dashboardStore.fetchDashboardData()
  isLoading.value = false
})
</script>

<template>
  <div class="p-4 mx-12">
    <h1 class="text-2xl font-bold mb-4 gtext">{{ t('common.Dashboard') }}</h1>
    

     <!-- Charts Section -->
     <NGrid :x-gap="12" :y-gap="12" :cols="isMobile ? 1 : 2" class="mt-6">
        <!-- User Growth Trend Chart -->
        <NGridItem>
          <NCard>
            <NSkeleton v-if="isLoading" text :repeat="3" />
            <v-chart
              v-else
              class="chart"
              :option="userTrendOptions"
              :autoresize="true"
            />
          </NCard>
        </NGridItem>
  
        <!-- Conversation Trend Chart -->
        <NGridItem>
          <NCard>
            <NSkeleton v-if="isLoading" text :repeat="3" />
            <v-chart
              v-else
              class="chart"
              :option="conversationTrendOptions"
              :autoresize="true"
            />
          </NCard>
        </NGridItem>
      </NGrid>
  
      
      <!-- Stat Cards -->
      <NGrid :x-gap="12" :y-gap="12" :cols="isMobile ? 1 : 2">
        <NGridItem v-for="item in cardItems" :key="item.title">
          <NCard>
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-2xl font-bold mb-2 gtext">{{ item.title }}</h3>
                <NSkeleton v-if="isLoading" text :repeat="1" :width="60" />
                <div v-else class="font-bold text-4xl gtext">{{ item.count() }}</div>
              </div>
              <NSkeleton v-if="isLoading" circle :width="48" :height="48" />
              <SvgIcon :icon="item.icon" :width="38" :height="38" class="color: blue;" />
            </div>
          </NCard>
        </NGridItem>
      </NGrid>
  
     
    </div>
  </template>
  
  <style scoped>
  .chart {
    height: 400px;
  }
  </style>