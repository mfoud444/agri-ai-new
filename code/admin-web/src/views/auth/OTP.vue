
<script setup lang="ts">
import { ref } from 'vue';
import { NInput, NButton, useMessage, useLoadingBar,  } from 'naive-ui';
import { t } from '@/locales'
import { useAuthStore, useUserStore }from '@/store'
import { router } from '@/router';
const authStore = useAuthStore()
const userStore = useUserStore()
const email:string = userStore.userInfo.user?.email ?? ''
const loading = ref<boolean>(false)
const obfuscateEmail = (email: string): string => {
  const atIndex = email.indexOf('@');
  if (atIndex >= 0) {
    const username = email.substring(0, atIndex);
    const obfuscatedUsername = username.substring(0, 2) + '*'.repeat(username.length - 2);
    return obfuscatedUsername + email.substring(atIndex);
  }
  return email;
};

const otp = ref<string>('');

const onlyAllowNumber = (value: string) => !value || /^\d+$/.test(value)
const message = useMessage();

function handleInput() {

  // if (position < 6) {
  //   const nextInput = `otp${position + 1}`;
  //   (this as any)[nextInput].focus();
  // }
}
const loadingBar = useLoadingBar()
const disabledRef = ref(true)
function handleStart() {
    loadingBar.start()
    disabledRef.value = false
}
function handleFinish() {
    loadingBar.finish()
    disabledRef.value = true
}

async function verifyOTP() {
    try {
        loading.value = true
        await authStore.verifyOTP(email, otp.value);
        loading.value = false
        handleStart()
        await router.push({ name: 'Chat', params: { uuid: '' } });
        handleFinish()

    } catch (error: any) {
        console.error(error.message)
        loading.value = false
        message.error(t('auth.signInFailed'));
    }
}


async function reSendVerifyOTP() {
    try {
        loading.value = true
        await authStore.reSendVerifyOTP(email);
        loading.value = false
        // handleStart()
        // await router.push({ name: 'Chat', params: { uuid: '' } });
        // handleFinish()
        message.success(' Done ');

    } catch (error: any) {
        console.error(error.message)
        loading.value = false
        message.error(t('auth.signInFailed'));
    }
}

</script>

<template>

<div class="flex flex-col justify-center items-center gap-2 h-full">
  <div>
     
    <div class="flex flex-col md:w-96 p-4 bg-blue-50 h-full items-center justify-center  gap-4 mx-8  relative place-self-center overflow-hidden   glass rounded-lg">
      <div>
      <div class="text-center font-bold text-3xl gtext py-2">
        {{ t('auth.emailVerification') }} 
      </div>
      <div class="text-base text-center">
        {{ t('auth.sendedCode')}}
        <span class="text-primary">{{ obfuscateEmail(email) }}</span>
      </div>
    </div>
        <NInput
        class="w-full"
          v-model:value="otp"
          :allow-input="onlyAllowNumber"
          maxlength="6"
          size="large"
          @input="handleInput"
          placeholder="xxxxxx"
          :show-button=false
          :show-count=true
          @keyup.enter="handleInput"
       
        />
        <NButton 
        type="primary"
        style="width: 100%;"
        :loading="loading"
         @click="verifyOTP">
         {{ t('auth.verfiy') }}
        </NButton>
  

        <div class="flex gap-1 justify-center items-center cursor-pointer">
          <span>{{ t('auth.dontRecieveCode') }}</span>
          <NButton @click="reSendVerifyOTP" class=" underline text-primary">{{ t('auth.reSendCode') }}</NButton>
        </div>
    </div>
  </div>
</div>
  </template>
  

  
  