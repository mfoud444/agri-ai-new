<script lang="ts" setup>
import { t } from '@/locales'
import { useRouter } from 'vue-router'
import { useLoadingBar, NButton } from 'naive-ui'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import hero from '@/assets/hero.svg'
import { ref, onMounted, onBeforeUnmount, Ref, UnwrapRef } from 'vue';
import P5 from 'p5';
import * as THREE from 'three';
import NET from 'vanta/dist/vanta.net.min';
const router = useRouter()
async function goService() {
  handleStart()
  await router.push('/chat')
  handleFinish()
}

const { isMobile } = useBasicLayout()
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

const vantaContainer = ref<HTMLElement | null>(null); // Define vantaContainer as ref

const vantaEffect = ref<null | { destroy: () => void }>(null);

onMounted(() => {
  // Initialize Vanta.js effect
  // vantaEffect.value = NET({
  //   el: vantaContainer.value,



  //   scale: 1.00,
  //   scaleMobile: 1.00,
  //   color: 0x257a0c,
  //   backgroundColor: 0x23153c,
  //   points: 16.00,
  //   THREE: THREE
  // });
});

onBeforeUnmount(() => {
  // Cleanup when the component is destroyed
  if (vantaEffect.value) {
    vantaEffect.value.destroy();
  }
});
</script>

<template>
  <div
    class="bg-blue-100 dark:bg-gray-950 dark:text-white flex py-24 px-8  w-full  overflow-hidden h-[550px]   rounded-lg  gap-22"
  >
    <div class="w-36 h-36 absolute top-0 right-0">
      <svg
        id="10015.io"
        viewBox="0 0 1200 630"
        xmlns="http://www.w3.org/2000/svg"
      >
        <defs>
          <pattern
            id="svg-pattern"
            x="0"
            y="0"
            width="62"
            height="62"
            patternUnits="userSpaceOnUse"
            patternTransform="translate(30, 30) rotate(0) skewX(0)"
          ><svg
              width="32"
              height="32"
              viewBox="0 0 100 100"
            >
              <g
                fill="rgba(68, 12, 237, 0.28)"
                opacity="1"
              >
                <circle
                  cx="50"
                  cy="50"
                  r="50"
                ></circle>
              </g>
            </svg></pattern>
        </defs>
        <rect
          x="0"
          y="0"
          width="100%"
          height="100%"
          fill="rgba(246, 246, 247, 0)"
        ></rect>
        <rect
          x="0"
          y="0"
          width="100%"
          height="100%"
          fill="url(#svg-pattern)"
        ></rect>
      </svg>
    </div>

    <div class="flex flex-col justify-between">
      <div
        class=" 
   
    first-letter:font-bold
    first-letter:text-blue-700
    first-letter:font-serif
    font-bold gtext"
        :class="[isMobile ? 'first-letter:text-7xl text-5xl' : ' first-letter:text-9xl text-7xl']"
      > {{ t('common.nameApp') }}</div>
      <div class="font-bold g-text-hero text-2xl  md:text-5xl leading-relaxed text-justify">
        {{ t('app.descApp') }}

      </div>
      <button
        class="btn btn-primary font-bold text-2xl w-56"
        @click="goService"
      >
        {{ t('app.start') }}
      </button>
    </div>

    <!-- <div class="h-full w-full" ref="vantaContainer" v-slots></div> -->

    <!-- <img :src="hero" class=" rounded-lg h-86 w-86"/> -->



  </div>
</template>
