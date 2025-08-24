<script setup lang="ts">
import { ref, defineProps } from 'vue'
import { StepsProps, NButton, NButtonGroup, NRadioGroup, NRadioButton , NSpace, NSteps, NStep, NIcon } from 'naive-ui'
import { SvgIcon } from '@/components/common'

const props = defineProps(['initialStep', 'initialStatus'])

const current = ref<number | null>(1)
const currentStatus = ref<StepsProps['status']>(props.initialStatus)

function next() {
  if (current.value === null) current.value = 1
  else if (current.value >= 5) current.value = null
  else current.value++
}

function prev() {
  if (current.value === 0) current.value = null
  else if (current.value === null) current.value = 5
  else current.value--
}
</script>

<template>
  <NSpace vertical>
    <NSteps vertical v-model:current="current"  :current="current" :status="currentStatus">
      <NStep
        title="I Me Mine"
        description="All through the day, I me mine I me mine, I me mine"
      />
      <NStep
        title="Let It Be"
        description="When I find myself in times of trouble Mother Mary comes to me"
      />
      <NStep title="Break" />
      <NStep
        title="Come Together"
        description="Here come old flat top He come grooving up slowly"
      />
      <NStep
        title="Something"
        description="Something in the way she moves Attracts me like no other lover"
      />
    </NSteps>
    <NSpace>
      <NButtonGroup>
        <NButton @click="prev">
          <template #icon>
            <SvgIcon
        icon="icon-park-outline:left"
      />
          </template>
        </NButton>
        <NButton @click="next">
          <template #icon>
            <SvgIcon
          
            icon="icon-park-outline:right"
                class="h-5 w-5 md:w-7 md:h-7"
              />
          </template>
        </NButton>
      </NButtonGroup>

    </NSpace>
  </NSpace>
</template>
