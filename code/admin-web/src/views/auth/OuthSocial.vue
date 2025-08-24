<script setup lang="ts">
import { SvgIcon } from '@/components/common';
import { t } from '@/locales';
import { useUserStore } from '@/store';
import { supabase } from '@/utils/supabase';
import { Provider } from '@supabase/supabase-js';

async function signInWithOAuth(provider: Provider) {
  try {
    const { data, error } = await supabase.auth.signInWithOAuth({ provider });
    if (error) {
      throw error;
    }
    if (data) {
      // const userStore = useUserStore()
      // userStore.updateUserInfo({ user: data.user, session: data.session })

    }

  } catch (error) {

    throw error;
  }

}

function handleSignUpClick(provider: Provider) {

  signInWithOAuth(provider);

}
</script>
<template>
  <button @click="() => handleSignUpClick('google')"
    class="px-4 bg-white py-3 md:py-2 grid grid-cols-4 gap-3 content-center place-content-center border-[1px] border-black rounded-lg cursor-pointer">
    <SvgIcon icon="flat-color-icons:google" class="text-2xl text-primary place-self-end" />
    <div class="text-base col-span-3">{{ t('auth.signUpGoogle') }}</div>
  </button>
  <!-- <button @click="() => handleSignUpClick('facebook')" class="px-4 bg-blue-800 text-white  py-3 md:py-2 grid grid-cols-4 gap-3 content-center place-content-center  rounded-lg cursor-pointer">
        <SvgIcon icon="logos:facebook" class="text-2xl text-primary place-self-end" />
        <div class="text-base col-span-3">{{ t('auth.signUpFacebook') }}</div>
      </button> -->
</template>