
<script setup lang='ts'>
import { computed, onMounted,ref, h} from 'vue'
import { NInput, NPopconfirm,MenuOption,NMenu,
   NScrollbar, NDropdown, useMessage, NSkeleton, NSpace } from 'naive-ui'
import { SvgIcon} from '@/components/common'
import { expoortSelect } from '../../components/index'
import { useAppStore, useChatStore } from '@/store'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { debounce } from '@/utils/functions/debounce'
import ElementConv from './ElementConv.vue'
import { useIconRender } from '@/hooks/useIconRender'
const appStore = useAppStore()
const chatStore = useChatStore()
const loadingConversations = computed(() => chatStore.loadingConversationsText)
const loadMore = ref<boolean>(false)
const { isMobile } = useBasicLayout()
const dataSources = computed(() => chatStore.listConversation)
async function getDataAsync() {
  try {
    chatStore.loadingConversationsText = true
    //{ limit: 10 , offset: 1 }
   await chatStore.getListConversationAction();

  } catch (error) {
  console.log(error)
  } finally {
    chatStore.loadingConversationsText = false
  }
};

onMounted(async () => {
 getDataAsync();
})

async function handleSelect(conv:Chat.ResConv) {
  chatStore.handelSelectAction(conv.id)
  if (isMobile.value)
    appStore.setSiderCollapsed(true)
}

function handleEdit(conversation:Chat.ResConv, isEdit: boolean, event?: MouseEvent) {
  event?.stopPropagation()
  // chatStore.updateHistory(uuid, { isEdit })
}

function handleDelete(index: number, event?: MouseEvent | TouchEvent) {
  event?.stopPropagation()
  // chatStore.deleteHistory(index)
  if (isMobile.value)
    appStore.setSiderCollapsed(true)
}

const handleDeleteDebounce = debounce(handleDelete, 600)

function handleEnter(conversation:Chat.ResConv, isEdit: boolean, event: KeyboardEvent) {
  event?.stopPropagation()
  // if (event.key === 'Enter')
    // chatStore.updateHistory(uuid, { isEdit })
}


const scrollThreshold = 100; 
const canLoadMore = ref(true);

function handleScroll(event: Event) {
  const target = event.target as HTMLElement;
  const scrollPosition = target.scrollTop;
  const maxScroll = target.scrollHeight - target.clientHeight;
  if (maxScroll - scrollPosition < scrollThreshold && canLoadMore.value) {
    loadMoreConversations();
  }
}
async function loadMoreConversations() {
  try {
    // canLoadMore.value = false;
    // loadMore.value = true
    // const additionalConversations: Chat.History[] = await chatStore.getMoreConversationData();
    // if (additionalConversations.length > 0) {
     
    //   chatStore.history = [...chatStore.history, ...additionalConversations];
    //   canLoadMore.value = true;
    // }else {
    //   canLoadMore.value = false;
    // }

  } catch (error) {
    throw error;
  } finally {   
    loadMore.value = false
  }
}

function isActive(conversation:Chat.ResConv) {
  return conversation.id === chatStore.currentConversation.id
}

</script>

<template>

<NScrollbar class="px-2 py-2 glass bg-[#fff]" @scroll="handleScroll">
    <div class="flex flex-col gap-1  text-[0.95rem] ">
      <NSpace vertical v-if="loadingConversations">
        <template v-for="_ in 30" :key="item">
          <NSkeleton height="2.7rem" class=" px-3 mx-1 py-2 md:py-[0.6rem] rounded-2xl" />
        </template>
      </NSpace>

      <template v-else>
        <template v-if="!dataSources.length">
          <div class="flex flex-col items-center mt-4 text-center ">
            <SvgIcon icon="ri:inbox-line" class="mb-8 text-3xl" />
            <span>{{ $t('common.noData') }}</span>
          </div>
        </template>

        <template v-else>
          <div v-for="(item, index) of dataSources" :key="index">
            <a class="relative flex items-center gap-3 px-3 mx-1 py-2 md:py-[0.3rem] break-all   rounded-2xl cursor-pointer bg-neutral-50  hover:bg-neutral-100  group dark:border-neutral-800 dark:hover:bg-[#24272e]"
              :class="isActive(item) && ['border-primary','bg-primary','hover:bg-primary','text-white', 'dark:bg-[#24272e]', 'dark:border-primary', 'pr-14' , 'rounded-2xl']"
              @click="handleSelect(item)">
              <span>
                <SvgIcon icon="material-symbols:chat" class="" />
              </span>
              <div class="relative flex-1 overflow-hidden break-all text-ellipsis whitespace-nowrap">
                <NInput v-if="item.isEdit" v-model:value="item.title" size="tiny"
                  @keypress="handleEnter(item, false, $event)" />
                <span v-else>{{ item.title.charAt(0).toUpperCase() + item.title.slice(1) }}</span>
              </div>
              <div v-if="isActive(item)" class="absolute z-10 flex visible right-1">
                <template v-if="item.isEdit">
                  <button class="p-1" @click="handleEdit(item, false, $event)">
                    <SvgIcon icon="ri:save-line" />
                  </button>
                </template>
                <template v-else>

                  <button class="p-1">
                    <SvgIcon icon="material-symbols:edit" @click="handleEdit(item, true, $event)" />
                  </button>

                  <!-- <NPopconfirm placement="bottom" @positive-click="handleDeleteDebounce(index, $event)">
                    <template #trigger>
                      <button class="p-1">
                        <SvgIcon icon="fluent:delete-32-regular" class="text-red-900" />
                      </button>
                    </template>
                    {{ $t('chat.deleteHistoryConfirm') }}
                  </NPopconfirm> -->
                  <expoortSelect :item="item" :index="index" />
                </template>
              </div>
            </a>
          </div>

          <NSpace vertical v-if="loadMore">
            <!-- Skeleton Loading Elements -->
            <template v-for="_ in 2" :key="index">
              <NSkeleton height="3rem" class="px-3 mx-1 py-2 md:py-[0.6rem] rounded-2xl" />
            </template>
          </NSpace>
          <!-- <LoadingIcon  v-if="loadMore"/> -->
        </template>
      </template>
    </div>

  </NScrollbar>
   <!-- <NScrollbar class="">
  <NMenu
    :inverted="inverted"
    ref="menuInstRef"
    :accordion="accordion"
    :collapsed-width="64"
    :collapsed-icon-size="22"
    :options="menuOptions"
    @update:value="handleUpdateValue"
  />
  </NScrollbar> -->
</template>

