<script setup lang="ts">
import { ref } from 'vue'
import { NMenu, NScrollbar, useLoadingBar } from 'naive-ui'
import type { MenuInst, MenuOption } from 'naive-ui'
import { useRouter } from 'vue-router'
import { useIconRender } from '@/hooks/useIconRender';
import { t } from '@/locales';
import { useBasicLayout } from '@/hooks/useBasicLayout';
import { useAppStore } from '@/store';
const router = useRouter()
const accordionRef = ref(false)
const selectedKeyRef = ref('dashboard')
const menuInstRef = ref<MenuInst | null>(null)
const { iconRender } = useIconRender()
const loadingBar = useLoadingBar()
const { isMobile } = useBasicLayout()
const appStore = useAppStore()
const disabledRef = ref(true)
function handleStart() {
  loadingBar.start()
  disabledRef.value = false
  if (isMobile.value)
    appStore.setSiderCollapsed(true)
}
function handleFinish() {
  loadingBar.finish()
  disabledRef.value = true
}


async function handleUpdateValue(key: string, item: MenuOption) {
  handleStart()


  switch (key) {
    case 'dashboard':
      await router.push({ name: 'dashboard' });
      handleFinish()
      break
    case 'users':
      await router.push({ name: 'users', params: { userType: 'Client' } });
      handleFinish()
      break
    case 'Agri-Expert':
      await router.push({ name: 'users', params: { userType: 'Agri-Expert' } });
      handleFinish()
      break
    case 'admins':
      await router.push({ name: 'users', params: { userType: 'Admin' } });
      handleFinish()
      break
    case 'companyai':
      await router.push({ name: 'companyai' });
      handleFinish()
      break
    case 'modelsai':
      await router.push({ name: 'modelsai' });
      handleFinish()
      break
    case 'chat':
      await router.push({ name: 'main-chat' });
      handleFinish()
      break
    case 'profile':
      await router.push({ name: 'profile' });
      handleFinish()
      break
    case 'settingsapp':
      await router.push({ name: 'settingsapp' });
      handleFinish()
      break
      case 'edit-terms-of-use':
        await router.push({ name: 'edit-terms-of-use' });
        break;
      case 'edit-privacy-policy':
        await router.push({ name: 'edit-privacy-policy' });
        break;
    case 'major':
      await router.push({ name: 'major' });
      handleFinish()
      break
      case 'translation':
      await router.push({ name: 'translation' });
      handleFinish()
      break
      case 'filesmanager':
      await router.push({ name: 'filesmanager' });
      handleFinish()
      break 
      case 'themes':
      await router.push({ name: 'themes' });
      handleFinish()
      break 

      case 'settings':
      await router.push({ name: 'settings' });
      handleFinish()
      break 

      case 'country':
      await router.push({ name: 'country' });
      handleFinish()
      break 
      
      
  }

}
const accordion = accordionRef
const selectedKey = selectedKeyRef
const menuOptions: MenuOption[] = [
  {
    type: 'group',
    label: t('common.dashboard'),
    key: 'Dashboard',

    children: [
      {
        label: t('common.dashboard'),
        key: 'dashboard',
        icon: iconRender({ icon: 'material-symbols:dashboard' }),

      },
      {
        label: t('common.users'),
        key: 'users',
        disabled: false,
        icon: iconRender({ icon: 'mdi:users' }),


      },
      {
        label: t('common.agriculturalExpert'),
        key: 'Agri-Expert',
        icon: iconRender({ icon: 'mdi:account-student' }),



      },
      {
        label: t('common.admins'),
        key: 'admins',
        icon: iconRender({ icon: 'eos-icons:admin' }),



      }

    ]
  },

  {
    type: 'group',
    label: 'AI Settings',
    key: 'public',
    children: [
      {
        label: t('common.companes'),
        key: 'companyai',

        icon: iconRender({ icon: 'hugeicons:ai-network' }),

      },
      {
        label: t('common.modelsai'),
        key: 'modelsai',

        icon: iconRender({ icon: 'arcticons:ask-ai' }),

      },

      // {
      //   label: t('common.apiKeys'),
      //   key: 'major',
      //   disabled: false,
      //   icon: iconRender({ icon: 'game-icons:house-keys' }),

      // },


    ],
  },
  // {
  //   type: 'group',
  //   label: t('common.notifications'),
  //   key: 'notification',

  //   children: [
  //     {
  //       label: t('common.addNotification'),
  //       key: 'notification',
  //       icon: iconRender({ icon: 'ic:baseline-notification-add' }),

  //     },


  //   ],
  // },

  {
    type: 'group',
    label: t('common.chatsManager'),
    key: 'chats-user-ai',

    children: [
      {
        label: t('common.chatsUser'),
        key: 'chat',
        icon: iconRender({ icon: 'bx:chat' }),

      },

      // {
      //   label: t('common.chatsUserAgri'),
      //   key: 'chatAgri',
      //   icon: iconRender({ icon: 'bx:chat' }),

      // },


    ],
  },

  // {
  //   type: 'group',
  //   label: t('common.plans'),
  //   key: 'plans',

  //   children: [
  //     {
  //       label: t('common.plans'),
  //       key: 'Settings',
  //       icon: iconRender({ icon: 'noto:package' }),

  //     },
  //     {
  //       label: t('common.plansFeather'),
  //       key: 'profile',
  //       icon: iconRender({ icon: 'mingcute:vip-2-fill' }),


  //     },
 
  //   ],
  // },


  {
    type: 'group',
    label: t('common.settings'),
    key: 'settings',

    children: [
      {
        label: t('common.settingsAPP'),
        key: 'settingsapp',
        icon: iconRender({ icon: 'mdi:settings-outline' }),
      

      },
      {
  label: t('common.translation'),
  key: 'translation',
  icon: iconRender({ icon: 'mdi:translate' }), // Translation icon
},
{
  label: t('common.themes'),
  key: 'themes',
  icon: iconRender({ icon: 'mdi:palette' }), // Themes icon
},
{
  label: t('common.filesmanager'),
  key: 'filesmanager',
  icon: iconRender({ icon: 'mdi:file-cabinet' }), // File manager icon
},
{
  label: t('common.settings'),
  key: 'settings',
  icon: iconRender({ icon: 'mdi:cog-outline' }), // Settings icon
},
{
  label: t('common.editTermsOfUse'),
  key: 'edit-terms-of-use',
  icon: iconRender({ icon: 'mdi:book-edit' }), // Terms of Use icon
},
{
  label: t('common.editPrivacyPolicy'),
  key: 'edit-privacy-policy',
  icon: iconRender({ icon: 'mdi:book-lock' }), // Privacy Policy icon
},


{
  label: t('common.country'),
  key: 'country',
  icon: iconRender({ icon: 'mdi:world' }), 
},
      {
        label: t('common.profile'),
        key: 'profile',
        icon: iconRender({ icon: 'gg:profile' }),


      },
 
    ],
  }
];


const inverted = ref(false)
</script>

<template>
  <NScrollbar class="">
    <NMenu
      :inverted="inverted"
      ref="menuInstRef"
      :accordion="accordion"
      :collapsed-width="64"
      :collapsed-icon-size="22"
      :options="menuOptions"
      @update:value="handleUpdateValue"
    />
  </NScrollbar>
</template>
