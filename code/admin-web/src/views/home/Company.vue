<script lang="ts" setup>
import MetaLogo from '@/assets/Meta.png'
import GoogleLogo from '@/assets/Google.png'
import OpenAILogo from '@/assets/OpenAI.png'
import Microsoft from '@/assets/Microsoft.png'
</script>
<template>
    <div class="grid grid-cols-2 bg-blue-200 dark:bg-rose-400 rounded-lg h-[350px] gap-y-8 py-8 place-content-center justify-items-center place-items-center w-full">
      <img class="w-36 h-22" :src="MetaLogo" alt="Meta Logo">
      <img class="w-36 h-18" :src="GoogleLogo" alt="Google Logo">
      <img class="w-36 h-18" :src="OpenAILogo" alt="OpenAI Logo">
      <img class="w-36 h-18" :src="Microsoft" alt="OpenAI Logo">
    </div>
  </template>