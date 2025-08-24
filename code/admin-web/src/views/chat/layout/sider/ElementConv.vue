<script setup lang='ts'>
import { computed, ref } from 'vue'
import { NInput, useMessage , NEllipsis} from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { expoortSelect } from '../../components/index'
import { useAppStore, useChatStore } from '@/store';
import { put } from '@/utils/request'
import { t } from '@/locales';
import { useBasicLayout } from '@/hooks/useBasicLayout';

interface Props {
  element: Chat.ResConv
}
const props = defineProps<Props>()
const item = computed(() => props.element)
const chatStore = useChatStore()
const isActive = computed(() => item.value.id === chatStore.currentConversation.id)
const {isMobile} = useBasicLayout()
const appStore = useAppStore()
const loadingMessage = computed(() => chatStore.loadingMessage);
const tooltip = ref(true)

async function handleSelect(conv: Chat.ResConv) {

  await chatStore.resetController()
  chatStore.handelSelectAction(conv.id)
  if (isMobile.value)
    appStore.setSiderCollapsed(true)
    tooltip.value = false
}


const title = ref(props.element.title)
const message = useMessage()


async function handlePin(id: string, isPin: boolean, event?: MouseEvent | TouchEvent) {
  event?.stopPropagation()
  try {
    await chatStore.pinConvAction(id, isPin)
  } catch (error: any) {
    message.error(t('common.errorSomeThing'));
    console.error(error.message);

  }
}

async function handleEdit(isEdit: boolean, item:  Chat.ResConv, event?: MouseEvent) {
  event?.stopPropagation();
 console.log("isEdit", isEdit)
  if (isEdit) {
    item.isEdit = isEdit;

  } else {
    item.title = title.value;
    item.isEdit = isEdit;
     
    const data = {
      title: item.title
    }
   
    try {
      const result = await put<Chat.ReqConv>({
        url: `conversation/${chatStore.currentConversation.id}/`,
        data
      });

      console.log('PUT Success:', result);
    } catch (error: any) {
      console.error('PUT Error:', error.message);


    }
    // chatStore.currentConversation.isEdit = isEdit;
       // chatStore.currentConversation.title = title
  }


}

function updateTitle(value: string, event?: MouseEvent) {
  event?.stopPropagation();
  title.value = value;
}

function handleExport(event?: MouseEvent) {
  event?.stopPropagation();

}

</script>

<template>
  <div>

    <div
      class="relative flex justify-between items-center gap-1 pl-2 pr-2 mx-1 py-2 md:py-[0.3rem] break-all   rounded-lg cursor-pointer bg-neutral-50  hover:bg-neutral-100  group dark:bg-neutral-800 dark:border-neutral-800 dark:hover:bg-[#24272e] dark:text-white"
      :class="isActive ? ['border-primary', 'bg-primary', 'hover:bg-primary', 'text-white', 'dark:bg-violet-950', 'dark:border-primary', 'pr-14', 'rounded-2xl'] : ''"
      @click="handleSelect(item)"
    >

      <span>
        <SvgIcon
          icon="material-symbols:chat"
          class=""
        />
      </span>

      <div class="flex-1 w-8">
        <NInput
          v-if="item.isEdit"
          v-model:value="title"
          size="tiny"
          @input="updateTitle($event)"
          @keyup.enter="handleEdit(false, item)"
        />
        <NEllipsis
         :tooltip=tooltip
         v-else> {{ item.title }} </NEllipsis>
      </div>



      <div class="flex items-center">
        <!-- <template v-if="item.isPin">
          <button>
            <SvgIcon
              icon="mdi:pin"
              :class="!isActive ? 'text-primary' : 'text-white'"
              @click="handlePin(item.id, !item.isPin, $event)"
            />
          </button>
        </template> -->

        <template v-if="isActive">
          <template v-if="item.isEdit">
            <button @click="handleEdit(false, item, $event)">
              <SvgIcon icon="ri:save-line" />
            </button>
          </template>
          <template v-else>
            <!-- <button>
              <SvgIcon
              v-if="!loadingMessage"
                icon="material-symbols:edit"
                @click="handleEdit(true, item, $event)"
            />
          </button> -->

          <div  @click="handleExport($event)">
            <expoortSelect
            v-if="!loadingMessage"
              type="conversation"
              :conv="item"
            />
          </div>
        </template>
      </template>
    </div>
  </div>
</div></template>