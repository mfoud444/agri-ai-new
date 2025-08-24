<script setup lang="ts">
import { computed, onBeforeMount, onMounted, onUpdated, ref, watch } from 'vue'
import { NTree, NInput, NPopconfirm, NScrollbar, NDropdown, useMessage, NSkeleton, NSpace } from 'naive-ui'
import { SvgIcon } from '@/components/common'
import { TreeOption } from 'naive-ui'
const unit = ["Unversity", "Student", "Research"]
const childUnit = ["Add ", "List "]
function createData() {
  return [
    {
      label: 'Unversity',
      key: 1,
      isLeaf: false
    },
    {
      label: 'Student',
      key: 2,
      isLeaf: false,

      
    },
    {
      label: 'Research',
      key: 3,
      isLeaf: false
    }
  ]
}


function findSiblingsAndIndex(
  node: TreeOption,
  nodes?: TreeOption[]
): [TreeOption[], number] | [null, null] {
  if (!nodes) return [null, null]
  for (let i = 0; i < nodes.length; ++i) {
    const siblingNode = nodes[i]
    if (siblingNode.key === node.key) return [nodes, i]
    const [siblings, index] = findSiblingsAndIndex(node, siblingNode.children)
    if (siblings && index !== null) return [siblings, index]
  }
  return [null, null]
}

function handleLoad(node: TreeOption) {
  return new Promise<void>((resolve) => {
    setTimeout(() => {
      node.children = [
        {
          label: "Add " + node.label,
          key: node.key + "Add",
          isLeaf: true
        },
        {
          label: "List  " + node.label,
          key: node.key + "List",
          isLeaf: true
        }
      ]
      resolve()
    }, 0)
  })
}

const expandedKeysRef = ref<string[]>([])
const checkedKeysRef = ref<string[]>([])
const dataRef = ref(createData())
const data = dataRef
const expandedKeys = expandedKeysRef
const checkedKeys = checkedKeysRef
function handleExpandedKeysChange(expandedKeys: string[]) {
  expandedKeysRef.value = expandedKeys
}
function handleCheckedKeysChange(checkedKeys: string[]) {
  checkedKeysRef.value = checkedKeys
}

</script>

<template>
  <NScrollbar class="px-2 py-2 glass bg-[#fff]">
    <div class="p-4 bg-blue-50">
      <NTree block-line :expanded-keys="expandedKeys" :data="data" @update:checked-keys="handleCheckedKeysChange"
        @update:expanded-keys="handleExpandedKeysChange" :on-load="handleLoad" electable />
    </div>
  </NScrollbar>
</template>
