<!-- <script setup lang="ts">
import { ref, computed } from 'vue';
import NBreadcrumb from 'naive-ui/lib/breadcrumb';

import NButton from 'naive-ui/lib/button';
import List from './List.vue';
import Add from './Add.vue';
import Update from './Update.vue';
import { useRoute } from 'vue-router';

const showList = ref(true);
const showAddForm = ref(false);
const showUpdateForm = ref(false);
const route = useRoute();
const rowEdit = ref<User.UserData | null>(null);

const breadcrumbs = computed(() => {
  return [
    { label: 'Home', to: '/' },
    { label: route.params.userType === 'Client' ? 'Users' : route.params.userType, to: '/users' },
    { label: showAddForm.value ? 'Add' : showUpdateForm.value ? 'Edit' : 'List', to: null }
  ];
});

function handleShowList() {
  showList.value = true;
  showAddForm.value = false;
  showUpdateForm.value = false;
}

function handleShowAddForm() {
  showList.value = false;
  showAddForm.value = true;
  showUpdateForm.value = false;
}

function handleShowUpdateForm(row: User.UserData) {
  rowEdit.value = row;
  showList.value = false;
  showAddForm.value = false;
  showUpdateForm.value = true;
}
</script>

<template>
  <div>
    <NBreadcrumb>
      <NBreadcrumbItem v-for="(item, index) in breadcrumbs" :key="index" :to="item.to">
        {{ item.label }}
      </NBreadcrumbItem>
    </NBreadcrumb>

    <div class="my-4">
      <template v-if="showList">
        <List @edit="handleShowUpdateForm" />
        <NButton type="primary" @click="handleShowAddForm">
          {{ t('common.add') }}
        </NButton>
      </template>

      <template v-else-if="showAddForm">
        <Add @cancel="handleShowList" />
      </template>

      <template v-else-if="showUpdateForm">
        <Update :item="rowEdit" @cancel="handleShowList" />
      </template>
    </div>
  </div>
</template> -->
