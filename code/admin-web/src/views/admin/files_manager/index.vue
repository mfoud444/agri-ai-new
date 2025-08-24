<template>
  <div class="container mx-auto p-4">
    <n-card title="File Manager" class="mb-4">
      <template #header-extra>
        <n-button @click="handleUpload" type="primary" class="mr-2">
          <template #icon>
            <n-icon><cloud-upload-icon /></n-icon>
          </template>
          Upload
        </n-button>
        <n-button @click="showCreateFolderModal = true">
          <template #icon>
            <n-icon><create-icon /></n-icon>
          </template>
          New Folder
        </n-button>
      </template>
      <n-space vertical>
        <n-breadcrumb>
          <n-breadcrumb-item @click="navigateTo('')">
            Home
          </n-breadcrumb-item>
          <n-breadcrumb-item v-for="(folder, index) in currentPath.split('/')" :key="index" @click="navigateTo(currentPath.split('/').slice(0, index + 1).join('/'))">
            {{ folder }}
          </n-breadcrumb-item>
        </n-breadcrumb>
        <n-data-table
          :columns="columns"
          :data="filteredFiles"
          :pagination="pagination"
          @update:sorter="handleSort"
        />
      </n-space>
    </n-card>

    <!-- Upload Modal -->
    <n-modal v-model:show="showUploadModal">
      <n-card
        style="width: 600px"
        title="Upload Files"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <n-upload
          multiple
          directory-dnd
          :default-upload="false"
          @change="handleFileChange"
        >
          <n-upload-dragger>
            <div class="flex flex-col items-center justify-center py-8">
              <n-icon size="48" depth="3">
                <cloud-upload-icon />
              </n-icon>
              <p class="text-lg mt-4">Click or drag files to this area to upload</p>
            </div>
          </n-upload-dragger>
        </n-upload>
        <template #footer>
          <div class="flex justify-end space-x-4">
            <n-button @click="showUploadModal = false">Cancel</n-button>
            <n-button type="primary" @click="confirmUpload" :disabled="!filesToUpload.length">
              Upload
            </n-button>
          </div>
        </template>
      </n-card>
    </n-modal>

    <!-- Create Folder Modal -->
    <n-modal v-model:show="showCreateFolderModal">
      <n-card
        style="width: 400px"
        title="Create New Folder"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <n-input v-model:value="newFolderName" placeholder="Enter folder name" />
        <template #footer>
          <div class="flex justify-end space-x-4">
            <n-button @click="showCreateFolderModal = false">Cancel</n-button>
            <n-button type="primary" @click="createFolder" :disabled="!newFolderName">
              Create
            </n-button>
          </div>
        </template>
      </n-card>
    </n-modal>

    <!-- Rename Modal -->
    <n-modal v-model:show="showRenameModal">
      <n-card
        style="width: 400px"
        :title="`Rename ${fileToRename?.type}`"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <n-input v-model:value="newFileName" :placeholder="`Enter new ${fileToRename?.type} name`" />
        <template #footer>
          <div class="flex justify-end space-x-4">
            <n-button @click="showRenameModal = false">Cancel</n-button>
            <n-button type="primary" @click="confirmRename" :disabled="!newFileName">
              Rename
            </n-button>
          </div>
        </template>
      </n-card>
    </n-modal>

    <!-- File Preview Modal -->
    <n-modal v-model:show="showPreviewModal" style="width: 90%; max-width: 1200px;">
      <n-card
        :title="fileToPreview?.name"
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <div class="flex justify-center items-center">
          <img v-if="isImage(fileToPreview)" :src="fileToPreview?.url" alt="File preview" class="max-w-full max-h-[80vh]" />
          <video v-else-if="isVideo(fileToPreview)" :src="fileToPreview?.url" controls class="max-w-full max-h-[80vh]"></video>
          <vue-pdf-embed v-else-if="isPdf(fileToPreview)" :source="fileToPreview?.url" class="max-w-full max-h-[80vh]" />
          <vue-doc-preview v-else-if="isPreviewableDocument(fileToPreview)" :url="fileToPreview?.url" :file-name="fileToPreview?.name" class="max-w-full max-h-[80vh]" />
          <div v-else class="text-center">
            <n-icon size="48"><document-icon /></n-icon>
            <p class="mt-4">Preview not available for this file type</p>
          </div>
        </div>
      </n-card>
    </n-modal>
  </div>
</template>

<script setup>
import { ref, computed, h } from 'vue'
import { 
  NCard, 
  NButton, 
  NSpace, 
  NBreadcrumb, 
  NBreadcrumbItem, 
  NDataTable, 
  NModal, 
  NUpload, 
  NUploadDragger,
  NIcon,
  NInput,
  useMessage
} from 'naive-ui'
import { 
  CloudUpload as CloudUploadIcon, 
  Create as CreateIcon, 
  Document as DocumentIcon, 
  Folder as FolderIcon,
  TrashBin as TrashBinIcon,
  PencilSharp as PencilSharpIcon,
  Image as ImageIcon,
  Videocam as VideocamIcon,
  DocumentText as PdfIcon,
  Grid as ExcelIcon,
  Albums as PowerPointIcon
} from '@vicons/ionicons5'
import VuePdfEmbed from '@tato30/vue-pdf'
import VueDocPreview from 'vue-doc-preview'

const message = useMessage()

const showUploadModal = ref(false)
const showCreateFolderModal = ref(false)
const showRenameModal = ref(false)
const showPreviewModal = ref(false)
const currentPath = ref('')
const newFolderName = ref('')
const newFileName = ref('')
const fileToRename = ref(null)
const fileToPreview = ref(null)

const files = ref([
  { name: 'Document.pdf', type: 'file', size: 1024000, lastModified: new Date('2023-01-15'), url: 'https://example.com/document.pdf' },
  { name: 'Images', type: 'folder', size: null, lastModified: new Date('2023-02-20') },
  { name: 'Spreadsheet.xlsx', type: 'file', size: 512000, lastModified: new Date('2023-03-10'), url: 'https://example.com/spreadsheet.xlsx' },
  { name: 'Presentation.pptx', type: 'file', size: 2048000, lastModified: new Date('2023-04-05'), url: 'https://example.com/presentation.pptx' },
  { name: 'Image.jpg', type: 'file', size: 307200, lastModified: new Date('2023-05-20'), url: 'https://example.com/image.jpg' },
  { name: 'Video.mp4', type: 'file', size: 10485760, lastModified: new Date('2023-06-15'), url: 'https://example.com/video.mp4' },
  { name: 'Document.docx', type: 'file', size: 153600, lastModified: new Date('2023-07-01'), url: 'https://example.com/document.docx' },
  { name: 'Code.js', type: 'file', size: 5120, lastModified: new Date('2023-07-10'), url: 'https://example.com/code.js' },
])

const filesToUpload = ref([])

const getFileIcon = (file) => {
  if (file.type === 'folder') return FolderIcon
  const extension = file.name.split('.').pop().toLowerCase()
  switch (extension) {
    case 'pdf': return PdfIcon
    case 'xlsx': case 'xls': return ExcelIcon
    case 'pptx': case 'ppt': return PowerPointIcon
    case 'jpg': case 'jpeg': case 'png': case 'gif': return ImageIcon
    case 'mp4': case 'avi': case 'mov': return VideocamIcon
    default: return DocumentIcon
  }
}

const columns = [
  {
    title: 'Name',
    key: 'name',
    sorter: 'default',
    render: (row) => {
      return h(
        'div',
        {
          class: 'flex items-center space-x-2',
          style: {
            cursor: 'pointer'
          },
          onClick: () => handleFileClick(row)
        },
        [
          h(NIcon, null, { default: () => h(getFileIcon(row)) }),
          h('span', null, row.name),
          row.type === 'file' && (isImage(row) || isVideo(row)) ? h('img', {
            src: row.url,
            class: 'w-8 h-8 object-cover ml-2',
            alt: 'Preview'
          }) : null
        ]
      )
    }
  },
  {
    title: 'Size',
    key: 'size',
    sorter: (a, b) => a.size - b.size,
    render: (row) => row.type === 'folder' ? '-' : formatFileSize(row.size)
  },
  {
    title: 'Last Modified',
    key: 'lastModified',
    sorter: (a, b) => a.lastModified - b.lastModified,
    render: (row) => row.lastModified.toLocaleString()
  },
  {
    title: 'Actions',
    key: 'actions',
    render: (row) => {
      return h(
        NSpace,
        null,
        {
          default: () => [
            h(
              NButton,
              {
                size: 'small',
                onClick: () => handleDelete(row)
              },
              { icon: () => h(NIcon, null, { default: () => h(TrashBinIcon) }) }
            ),
            h(
              NButton,
              {
                size: 'small',
                onClick: () => handleRename(row)
              },
              { icon: () => h(NIcon, null, { default: () => h(PencilSharpIcon) }) }
            )
          ]
        }
      )
    }
  }
]

const pagination = {
  pageSize: 10
}

const filteredFiles = computed(() => {
  return files.value.filter(file => {
    const pathParts = currentPath.value.split('/')
    return pathParts.every((part, index) => {
      if (index === pathParts.length - 1) {
        return file.name.startsWith(part)
      }
      return file.name.split('/')[index] === part
    })
  })
})

const handleSort = (sorter) => {
  if (sorter) {
    const { columnKey, order } = sorter
    files.value.sort((a, b) => {
      const compareResult = a[columnKey] > b[columnKey] ? 1 : -1
      return order === 'descend' ? -compareResult : compareResult
    })
  }
}

const navigateTo = (path) => {
  currentPath.value = path
}

const handleUpload = () => {
  showUploadModal.value = true
}

const createFolder = () => {
  if (newFolderName.value) {
    files.value.push({
      name: newFolderName.value,
      type: 'folder',
      size: null,
      lastModified: new Date()
    })
    message.success(`Folder "${newFolderName.value}" created successfully`)
    showCreateFolderModal.value = false
    newFolderName.value = ''
  }
}

const handleDelete = (file) => {
  const index = files.value.findIndex(f => f.name === file.name && f.type === file.type)
  if (index !== -1) {
    files.value.splice(index, 1)
    message.success(`${file.type === 'folder' ? 'Folder' : 'File'} "${file.name}" deleted successfully`)
  }
}

const handleRename = (file) => {
  fileToRename.value = file
  newFileName.value = file.name
  showRenameModal.value = true
}

const confirmRename = () => {
  if (newFileName.value && fileToRename.value) {
    const index = files.value.findIndex(f => f.name === fileToRename.value.name && f.type === fileToRename.value.type)
    if (index !== -1) {
      files.value[index].name = newFileName.value
      message.success(`${fileToRename.value.type === 'folder' ? 'Folder' : 'File'} renamed to "${newFileName.value}" successfully`)
      showRenameModal.value = false
      fileToRename.value = null
      newFileName.value = ''
    }
  }
}

const handleFileChange = (options) => {
  const { fileList } = options
  filesToUpload.value = fileList
}

const confirmUpload = () => {
  filesToUpload.value.forEach(file => {
    files.value.push({
      name: file.name,
      type: 'file',
      size: file.file?.size || 0,
      lastModified: new Date(),
      url: URL.createObjectURL(file.file)
    })
  })
  message.success(`Uploaded ${filesToUpload.value.length} files`)
  
  showUploadModal.value = false
  filesToUpload.value = []
}

const formatFileSize = (bytes) => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

const isImage = (file) => {
  const imageExtensions = ['jpg', 'jpeg', 'png', 'gif']
  return file.type === 'file' && imageExtensions.includes(file.name.split('.').pop().toLowerCase())
}

const isVideo = (file) => {
  const videoExtensions = ['mp4', 'avi', 'mov']
  return file.type === 'file' && videoExtensions.includes(file.name.split('.').pop().toLowerCase())
}

const isPdf = (file) => {
  return file.type === 'file' && file.name.toLowerCase().endsWith('.pdf')
}

const isPreviewableDocument = (file) => {
  const previewableExtensions = ['md', 'docx', 'pptx', 'xlsx', 'txt', 'js', 'html', 'css', 'java', 'json', 'ts', 'cpp', 'xml', 'bash', 'less', 'nginx', 'php', 'powershell', 'python', 'scss', 'shell', 'sql', 'yaml', 'ini']
  return file.type === 'file' && previewableExtensions.includes(file.name.split('.').pop().toLowerCase())
}

const handleFileClick = (file) => {
  if (file.type === 'folder') {
    navigateTo(`${currentPath.value}/${file.name}`)
  } else {
    fileToPreview.value = file
    showPreviewModal.value = true
  }
}
</script>