<script setup lang='ts'>
import { NSkeleton, NSpace } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { t } from '@/locales'
</script>

<template>
<div>
    <SvgIcon
      icon="ri:bubble-chart-fill"
      class=" gtext text-3xl mb-2"
    />
    <span class="gtext font-bold text-2xl">{{ t('common.nameApp') }}</span>
    <NSpace vertical>
      <NSkeleton
        height="20px"
        circle
      />
      <NSkeleton
        height="20px"
        width="50%"
        round
      />
      <NSkeleton
        height="20px"
        width="70%"
        round
      />
      <NSkeleton
        height="20px"
        round
      />
    </NSpace>
    <NSpace
      vertical
    class="mt-4"
  >
    <NSkeleton
      height="20px"
      circle
    />
    <NSkeleton
      height="20px"
      width="70%"
      round
    />
    <NSkeleton
      height="20px"
      width="90%"
      round
    />
    <NSkeleton
      height="20px"
      width="80%"
      round
    />
  </NSpace>
  <NSpace
    vertical
    class="mt-4"
  >
    <NSkeleton
      height="20px"
      circle
    />
    <NSkeleton
      height="20px"
      width="50%"
      round
    />
    <NSkeleton
      height="20px"
      width="70%"
      round
    />
    <NSkeleton
      height="20px"
      round
    />
  </NSpace>
</div>
</template>
