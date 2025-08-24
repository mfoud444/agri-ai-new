<template>
    <div class="p-4 bg-gray-100 min-h-screen">
      <n-list bordered>
        <n-list-item v-for="user in users" :key="user.id">
          <div class="flex items-center space-x-4">
            <n-avatar
              :src="user.avatarUrl || 'https://via.placeholder.com/40'"
              :fallback-src="'https://via.placeholder.com/40'"
              :size="40"
            />
            <div class="flex-grow">
              <div class="font-semibold text-lg">
                {{ user.firstName }} {{ user.lastName }}
              </div>
              <div class="text-sm text-gray-600">{{ user.email }}</div>
              <div class="text-sm text-gray-500">
                <span class="mr-2">
                  <SvgIcon icon="mdi:calendar" class="inline-block mr-1" />
                  {{ formatDate(user.dateOfBirth) }}
                </span>
                <span class="mr-2">
                  <SvgIcon icon="mdi:account" class="inline-block mr-1" />
                  {{ user.gender }}
                </span>
                <span class="mr-2">
                  <SvgIcon icon="mdi:briefcase" class="inline-block mr-1" />
                  {{ user.userType }}
                </span>
                <span>
                  <SvgIcon :icon="`flagpack:${user.country?.toLowerCase()}`" class="inline-block mr-1" />
                  {{ user.country }}
                </span>
              </div>
            </div>
            <div class="flex items-center space-x-2">
              <n-switch v-model:value="user.state" @update:value="updateUserState(user)" />
              <n-button type="primary" @click="editUser(user)">
                <template #icon>
                  <SvgIcon icon="mdi:pencil" />
                </template>
                Edit
              </n-button>
            </div>
          </div>
        </n-list-item>
      </n-list>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref } from 'vue'
  import { NList, NListItem, NAvatar, NSwitch, NButton } from 'naive-ui'

  // Mock data for demonstration
  const users = ref<API.UserMetaData[]>([
    {
  
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',

      dateOfBirth: '1990-01-01',
      state: true,
      gender: 'Male' ,
      userType: 'Admin' ,
      country: 'US',
      createdAt: '2023-01-01T00:00:00Z',
      updatedAt: '2023-01-01T00:00:00Z',
    },
    // Add more mock users here
  ])
  
  const formatDate = (dateString: string | null): string => {
    if (!dateString) return 'N/A'
    return new Date(dateString).toLocaleDateString()
  }
  
  const updateUserState = (user: API.UserMetaData) => {
    // Implement state update logic here
    console.log(`Updated state for user ${user.id} to ${user.state}`)
  }
  
  const editUser = (user: API.UserMetaData) => {
    // Implement edit user logic here
    console.log(`Editing user ${user.id}`)
  }
  </script>