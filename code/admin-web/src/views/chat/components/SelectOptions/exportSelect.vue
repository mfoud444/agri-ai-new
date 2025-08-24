<script setup lang='ts'>
import { computed, ref } from 'vue'
import { NDropdown, useDialog, useMessage } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { useAppStore, useChatStore, useUserStore } from '@/store'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { debounce } from '@/utils/functions/debounce'
import { useIconRender } from '@/hooks/useIconRender'
import { t } from '@/locales'
import {baseURL} from '@/utils/request/axios'
import html2canvas from 'html2canvas'
import axios from 'axios';

const url = baseURL + 'doc/file/'
type exportType = 'chat' | 'conversation' 
type fileType = 'pdf' | 'docx' | 'pptx'

interface Props {
    conv?: Chat.ResConv
    item?: Chat.Item
    type: exportType
    isResearch?:boolean
}

const { iconRender } = useIconRender()
const { isMobile } = useBasicLayout()
const props = defineProps<Props>()
const appStore = useAppStore()
const chatStore = useChatStore()
const userStore = useUserStore()
const dialog = useDialog()
const message = useMessage()

const isResearch = computed(() => props.isResearch)
async function handlePin(event?: MouseEvent | TouchEvent) {
    event?.stopPropagation()
    try {
        if(props.conv?.id){
            await chatStore.pinConvAction(props.conv?.id, !props.conv?.isPin)
        }else{
            message.error(t('common.errorSomeThing'));
        console.error("error in id converstion");
        }
     

    } catch (error: any) {
        message.error(t('common.errorSomeThing'));
        console.error(error.message);

    }
    if (isMobile.value)
        appStore.setSiderCollapsed(true)
}


async function handleDelete(event?: MouseEvent | TouchEvent) {
    console.log("props.item.id", props.conv?.id)
    event?.stopPropagation()
    try {
        await chatStore.deleteConversationAction({ id: props.conv?.id })
    } catch (error: any) {
        message.error(t('common.errorSomeThing'));
        console.error(error.message);

    }
    if (isMobile.value)
        appStore.setSiderCollapsed(true)
}

const handleDeleteDebounce = debounce(handleDelete, 600)




interface Emit {
    (ev: 'export'): void
    (ev: 'handleClear'): void
}
const emit = defineEmits<Emit>()

interface RequestOptionDocument {
    user_id?: string;
    conversation_id: string;
    output_format: fileType;
    message_user_id?: number;
    message_ai_id?: number
    type_data: exportType;
}


const model = ref<RequestOptionDocument>({
    user_id: userStore.userInfo.user?.id,
    conversation_id: chatStore.currentConversation.id,
    output_format: 'pdf',
    message_user_id: props.item?.messageUser.id,
    message_ai_id: props.item?.messageAi[props.item.currentIndex].id,
    type_data: props.type
});

async function convertToFile(outputFormat: fileType) {
    try {
        model.value.output_format = outputFormat
        const data = model.value
        console.log(data)
        const response = await axios.get(url, {
            params: data,
            responseType: 'blob',
        });
        const blob = new Blob([response.data]);
        const blobUrl = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = blobUrl;
        a.download = 'output.' + outputFormat;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        message.success(t('chat.exportSuccess'));
    } catch (error: any) {
        message.error(t('chat.exportFailed'));
        console.error(error.message);

    }
}


async function handleConvertToFile(outputFormat: fileType) {
    const conversionDialog = dialog.success({
        title: t('chat.conversionInProgress'),
        content: t('chat.conversionInProgressMessage'),
        positiveText: t('common.yes'),
        negativeText: t('common.no'),
        onPositiveClick: async () => {
            try {
                conversionDialog.loading = true
                await convertToFile(outputFormat);
            } catch (error) {
                conversionDialog.loading = false
                message.error(t('chat.exportFailed'));
            } finally {
                conversionDialog.loading = false
            }
        }
    });


}


function handleDeleteAction() {
    const deleteDialog = dialog.warning({
        title: t('chat.deleteConfirmation'),
        content: t('chat.deleteConfirmationMessage'),
        positiveText: t('common.yes'),
        negativeText: t('common.no'),
        onPositiveClick: async () => {
            try {
                deleteDialog.loading = true
                await handleDelete();
                message.success(t('chat.deleteSuccess'));
            } catch (error: any) {
                deleteDialog.loading = false
                message.error(t('chat.deleteFailed'));
            } finally {
                deleteDialog.loading = false
            }
        },
    });
}


function handleExport() {
    //   if (loading.value)
    //     return

    const d = dialog.warning({
        title: t('chat.exportImage'),
        content: t('chat.exportImageConfirm'),
        positiveText: t('common.yes'),
        negativeText: t('common.no'),
        onPositiveClick: async () => {
            try {
                d.loading = true
                const ele = document.getElementById('image-wrapper')
                const canvas = await html2canvas(ele as HTMLDivElement, {
                    useCORS: true,
                })
                const imgUrl = canvas.toDataURL('image/png')
                const tempLink = document.createElement('a')
                tempLink.style.display = 'none'
                tempLink.href = imgUrl
                tempLink.setAttribute('download', 'chat-shot.png')
                if (typeof tempLink.download === 'undefined')
                    tempLink.setAttribute('target', '_blank')

                document.body.appendChild(tempLink)
                tempLink.click()
                document.body.removeChild(tempLink)
                window.URL.revokeObjectURL(imgUrl)
                d.loading = false
                message.success(t('chat.exportSuccess'))
                Promise.resolve()
            }
            catch (error: any) {
                message.error(t('chat.exportFailed'))
            }
            finally {
                d.loading = false
            }
        },
    })
}



const options = computed(() => {
    const common = [
        // {
        //     label: t('chat.convertTo'),
        //     key: 'convertTo',
        //     icon: iconRender({ icon: 'lets-icons:export-duotone' }),
        //     children: [
        //         {
        //             disabled: false,
        //             label: t('chat.convertToPDF'),
        //             key: 'convertToPDF',
        //             icon: iconRender({ icon: 'vscode-icons:file-type-pdf2' }),
        //         },
        //         {
        //             label: t('chat.convertToDocx'),
        //             key: 'convertToDocx',
        //             icon: iconRender({ icon: 'vscode-icons:file-type-word' }),
        //         },
        //         {
        //             label: t('chat.convertToPPTX'),
        //             key: 'convertToPPTX',
        //             icon: iconRender({ icon: 'vscode-icons:file-type-powerpoint2' }),
        //         },
        //     ],
        // },

    ];

    let convOptions: any = [];

    if (props.type === 'conversation') {
        convOptions = [
            // {
            //     label: props.conv?.isPin ? t('chat.unPin') : t('chat.pin'),
            //     key: 'pin',
            //     icon: iconRender({ icon: 'mdi:pin' }),
            // },
            {
                label: t('common.delete'),
                key: 'delete',
                icon: iconRender({ icon: 'fluent:delete-32-regular', color: 'red' }),
            },
        ];
    }

    const resultOptions = chatStore.currentConversation.type === 'image'
        ? convOptions
        : [...common, ...convOptions];

    return resultOptions;
});






async function handleSelectAction(key: string): Promise<void> {
    switch (key) {
        case 'delete':
            await handleDeleteAction()
            return;
        case 'convertToDocx':
            await handleConvertToFile('docx');
            return;
        case 'convertToPPTX':
            await handleConvertToFile('pptx');
            return;
        case 'convertToPDF':
            await handleConvertToFile('pdf');
            return;
        case 'exportImage':
            handleExport();
            return;
        case 'pin':
            await handlePin();
            return;
        default:
            // Handle default case
            return;
    }
}

</script>

<template>
    <NDropdown
    v-if="!isResearch"
        trigger="click"
        :options="options"
        @select="handleSelectAction"
    >
        <button class="transition text-base  dark:hover:text-neutral-200">
            <SvgIcon icon="ri:more-2-fill" />
        </button>
    </NDropdown>

    <div 
    class="flex gap-1"
    v-if="isResearch">
    <button 
    @click="handleConvertToFile('pdf')"
    class="bg-red-200 hover:bg-red-300 p-1 gap-1 rounded-lg w-20 flex items-center justify-around">
        <SvgIcon icon="vscode-icons:file-type-pdf2"  class="w-5 h-5"/>
      <div class="font-bold text-red-900">{{ t('chat.convertToPDF') }}</div>
      <SvgIcon icon="material-symbols:download" class="w-5 h-5 dark:text-black" />
    </button>

    <button 
    @click="handleConvertToFile('docx')"
    class="bg-blue-200 hover:bg-blue-300  p-1 rounded-lg gap-1 flex items-center justify-around">
        <SvgIcon icon="vscode-icons:file-type-word" class="w-5 h-5" />
      <div class="font-bold text-blue-900 overflow-hidden">{{  t('chat.convertToDocx')}}</div>
      <SvgIcon icon="material-symbols:download" class="w-5 h-5 dark:text-black" />
    </button>
    </div>
</template>
