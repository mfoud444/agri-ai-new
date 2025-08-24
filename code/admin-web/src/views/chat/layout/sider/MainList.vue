<script setup lang='ts'>
import {
  ref,
  onMounted,
  computed,
  reactive,
  WritableComputedRef,
  watch
} from 'vue'
import {
  NCollapse,
  NBadge,
  NAvatar,
  NCollapseItem,
  NScrollbar,
  NSkeleton,
  NSpace,
  NButton,
  useMessage
} from 'naive-ui'
import {
  SvgIcon
} from '@/components/common'
import {
  useIconRender
} from '@/hooks/useIconRender';
import {
  t
} from '@/locales';
import {
  useBasicLayout
} from '@/hooks/useBasicLayout';
import ElementConv from './ElementConv.vue'
import {
  useAppStore,
  useChatStore
} from '@/store';

const { iconRender } = useIconRender()
const { isMobile } = useBasicLayout()
const appStore = useAppStore()
const chatStore = useChatStore()
const message = useMessage()

const errorGetData = ref<boolean>(false)
const loadMoreLoading = ref<boolean>(false)
const loadingConversations = ref<boolean>(false)

const typeServices: PublicApp.TypeService[] = [ 'text','AI', 'Agri-Expert'];//'text', 'image', 'research', 'video', 'audio',

// Reactive data structures to hold page size, item counts, and pagination
const pageSize = reactive(
  Object.fromEntries(typeServices.map(type => [type, ref(150)])) as unknown as { [K in PublicApp.TypeService]: number }
);

const itemCount = reactive(
  Object.fromEntries(typeServices.map(type => [type, computed(() => getItemCount(type))])) as unknown as { [K in PublicApp.TypeService]: number }
);

function getItemCount(type: PublicApp.TypeService): number {
  return storeItemCoun.value[type];
}


const pagination = reactive(
  Object.fromEntries(
    typeServices.map(type => [type, { page: 1, pageCount: 1 }])
  ) as { [K in PublicApp.TypeService]: { page: number; pageCount: number } }
);

const dataSources = reactive<Record<PublicApp.TypeService, WritableComputedRef<Chat.ResConv[]>>>(
  Object.fromEntries(
    typeServices.map(type => [type, computed(() => getDataSources(type))])
  ) as unknown as Record<PublicApp.TypeService, WritableComputedRef<Chat.ResConv[]>>
);

const labelTextChat = computed(() => t('chat.chatAI'))
const labelAgriChat = computed(() => t('chat.agriExpert'))
const storeListConversation = computed(() => chatStore.listConversation)
const storeItemCoun = computed(() => chatStore.itemCount)

typeServices.forEach(type => {
  watch(
    () => [itemCount[type], pageSize[type]],
    () => {
      pagination[type].pageCount = Math.ceil(itemCount[type] / pageSize[type]);
    },
    { immediate: true }
  );
});
// Function to get data sources based on TypeService
function getDataSources(type: PublicApp.TypeService) {
  const start = (pagination[type].page - 1) * pageSize[type];
  return  storeListConversation.value
  .filter(conv => conv.type === type)
  .slice(start, start + pageSize[type]);
}

// Handle updating the selected conversation
const handleUpdateValue = (key: string) => {
  chatStore.handelSelectAction(key);
  if (isMobile.value) {
    appStore.setSiderCollapsed(true);
  }
}

// Function to fetch data
async function fetchData(type: PublicApp.TypeService) {
  try {
    const { page } = pagination[type];
    const limit =1000
    const offset = 0
    // const limit = pageSize[type];
    // const offset = (page - 1) * limit + 1;
    console.error(" limit:",limit,"offset", offset)
    await chatStore.getListConversationAction({ limit: limit, offset: offset, type: type });
    errorGetData.value = false;
  } catch (error: any) {
    message.error(t('chat.errorGetData', error.message));
    errorGetData.value = true;
  }
}



// Function to load more data
async function loadMore(type: PublicApp.TypeService) {
  try {
    loadMoreLoading.value = true;
    pagination[type].page += 1; 
    await fetchData(type);
  } catch (error) {
    console.error("Error loading more data:", error);
  } finally {
    loadMoreLoading.value = false;
  }
}

// Function to initialize both text and Agri-Expert data
async function getBothType() {
  loadingConversations.value = true

  await fetchData('AI');
  await fetchData('Agri-Expert');
  loadingConversations.value = false
}

onMounted(() => {
  
  getBothType();
});

type GroupedConversations = {
  [key: string]: {
    label: string;
    key: string;
    disabled: boolean;
  }[];
};

// Group conversations by date
// Group conversations by date
const groupByDate = (conversations: Chat.ResConv[]): any[] => {
  const today = new Date().toLocaleDateString();
  const yesterday = new Date(new Date().setDate(new Date().getDate() - 1)).toLocaleDateString();

  const dateLabels = {
    today: t('chat.today'),
    yesterday: t('chat.yesterday'),
    previous7Days: t('chat.previous7Days'),
  };

  const pinnedConversations = filterConversationByPin(conversations);
  const nonPinnedConversations = filterConversationByNotPin(conversations);

  const groupedByDate: GroupedConversations = nonPinnedConversations.reduce((groups, conversation) => {
    const conversationDate = new Date(conversation.updatedAt).toLocaleDateString();
    const key =
      conversationDate === today ? dateLabels.today :
        conversationDate === yesterday ? dateLabels.yesterday :
          dateLabels.previous7Days;

    if (!groups[key]) {
      groups[key] = [];
    }

    groups[key].push({
      label: conversation.title,
      key: conversation.id,
      disabled: false,
    });

    return groups;
  }, {} as GroupedConversations);

  const sortOrder = [dateLabels.today, dateLabels.yesterday, dateLabels.previous7Days];

  const sortedGroups = sortOrder
    .filter(label => groupedByDate[label]?.length > 0)
    .map(label => ({
      type: 'group',
      label,
      key: label.toLowerCase().replace(' ', '-'),
      children: groupedByDate[label] || [],
    }));

  const pinnedGroup = pinnedConversations.length > 0 ? {
    type: 'group',
    label: t('chat.pinned'),
    key: 'pinned',
    children: pinnedConversations.map(conversation => ({
      label: conversation.title,
      key: conversation.id,
      disabled: false,
    })),
  } : null;

  return pinnedGroup ? [pinnedGroup, ...sortedGroups] : sortedGroups;
};


// Generate menu options for the UI
// Generate menu options for the UI
const menuOptions = computed(() => {
  return typeServices.map(type => {
    const options = groupByDate(filterConversationByType(type));
    return {
      label: type === 'AI' ? labelTextChat.value : labelAgriChat.value,
      key: type,
      icon: iconRender({ icon: getIcon(type) }),
      disabled: false,
      children: options,
    };
  }).filter(option => option.children.length > 0);
});

function filterConversationByType(type: PublicApp.TypeService): Chat.ResConv[] {
  return dataSources[type]; // Access the `.value` of ComputedRef to get the actual array
}

function filterConversationByPin(conversations: Chat.ResConv[]): Chat.ResConv[] {
  return conversations.filter(conversation => conversation.isPin);
}

function filterConversationByNotPin(conversations: Chat.ResConv[]): Chat.ResConv[] {
  return conversations.filter(conversation => !conversation.isPin);
}

// Get icon based on the type of service
function getIcon(type: PublicApp.TypeService) {
  const icons: { [key in PublicApp.TypeService]?: string } = {
    text: 'material-symbols:chat',
    image: 'line-md:image',
    research: 'raphael:paper',
    video: 'material-symbols:play-circle',
    audio: 'material-symbols:audiotrack',
    AI: 'mdi:robot',
    'Agri-Expert': 'mdi:leaf'
  };
  return icons[type] || '';
}

// Retrieve conversation by ID
const getConversationById = (convId: string) => {
  return chatStore.listConversation.find((conv) => conv.id === convId) || null;
};

function getCountBadge(type: PublicApp.TypeService) {
  return storeItemCoun.value[type] ;
}
function showLoadMore(type: PublicApp.TypeService): boolean {
  const displayedCount = dataSources[type].length; // Currently loaded conversations
  const totalCount = storeItemCoun.value[type];; // Total conversations available

  return displayedCount < totalCount;
}

// Get the count badge for each service type
// function getCountBadge(type: PublicApp.TypeService) {
//   return itemCount[type];
// }
const expandedKeys = ref<string[]>([]);
const type = computed(() => chatStore.currentConversation.type);

</script>

<template>
  <!-- {{ menuOptions }} -->

  <NSpace class="px-2 py-2 glass bg-white dark:bg-purple-900" vertical v-if="loadingConversations">
    <template v-for="_ in 30" :key="item">
      <NSkeleton height="2rem" class="mx-1 py-1 md:py-[0.2rem] rounded-2xl" />
    </template>
</NSpace>



  <template v-if="errorGetData">
    <div class="flex flex-col justify-center items-center gap-2 text-center bg-red-50 dark:bg-purple-900 h-full">
      <div class="text-error text-xl font-bold">{{ t('common.errorSomeThing') }}</div>
      <button
        @click="getBothType()"
        class="w-36 flex bg-error text-white justify-center items-center gap-2 p-1 border border-gray-200 rounded-lg dark:border-gray-700"
      >
        <SvgIcon
          class="bounce-in-fwd"
          icon="pajamas:retry"
        />
        <div class="font-bold text-base">{{ t('common.tryAgain') }}</div>
      </button>
    </div>
  </template>

  <template
    v-if="!errorGetData && dataSources['AI'].length === 0 && dataSources['Agri-Expert'].length === 0"
  >
    <div class="flex flex-col justify-center items-center mt-4 text-center bg-white dark:bg-purple-900 h-full">
    
      <div class="text-xl font-bold mt-3 text-purple-500 dark:text-purple-300">{{ t('chat.noChat') }}</div>
      <div class="text-gray-400 dark:text-gray-500">{{ t('chat.noChatDesc') }}</div>
    </div>
  </template>
  <template v-else>
    <NScrollbar class="bg-white dark:bg-purple-900 px-2 py-2">
      <!-- :default-expanded-names="type" -->
        <NCollapse
         
          accordion
          v-if="menuOptions.length > 0"
          class="py-2"
        >


          <NCollapseItem
            class="px-2"
            v-for="(option, index) in menuOptions"
            :key="index"
            :title="option.label"
            :name="option.key"
          >
            <template #header-extra>
              <div class="pr-4">
                <NBadge
                  :value="getCountBadge(option.key as PublicApp.TypeService)"
                  type="info"
                  :max="100"
                  show-zero 
                >
                  <NAvatar
                    color="white"
                    size="small"
                  >
                    <SvgIcon
                      :icon="getIcon(option.key)"
                      class="text-black w-5 h-5"
                    />
                  </NAvatar>

                </NBadge>

              </div>


            </template>




           <div class="flex flex-col gap-2 item-center justify-center">
           
            <div
                v-if="option.children && option.children.length > 0"
                v-for="(child, childIndex) in option.children"
                :key="childIndex"
              >
              <!-- <ElementConv :element="getConversationById(child.id)!" /> -->
                <div class="text-sm text-primary dark:text-white p-1">{{ child.label }}</div>
                <template v-for="(subChild, subChildIndex) in child.children">
                  <div
                    class="my-1"
                    @click="handleUpdateValue(subChild.key)"
                  >

                    <ElementConv :element="getConversationById(subChild.key)!" />
                  </div>
                </template>
              </div> 

              <!-- <div class="pt-2 flex justify-center">
                <NButton
                  v-if="showLoadMore(option.key as PublicApp.TypeService)"
                  type="primary"
                  size="small"
                  :loading="loadMoreLoading"
                  @click="loadMore(option.key)"
                  class="w-full"
                >
                  <div class="font-bold text-base">{{ t('common.loadMore') }}</div>

                </NButton>
              </div> -->

            </div>

          </NCollapseItem>
        </NCollapse>
      </NScrollbar>
</template>
</template>
