<!--  -->


  <template>
  <ListBase
    title="Users"
    :items="users"
    :columns="columns"
    keyField="id"
    :totalItems="totalUsers"
    @update:page="fetchUsers"
    @update:pageSize="fetchUsers"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import ListBase from './ListBase.vue'
import { NTag } from 'naive-ui'
import type { DataTableColumns } from 'naive-ui'


  const users = ref<API.UserMetaData[]>([
    {
  
      fristName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
avatar:"",
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
  
  }
  
  const editUser = (user: API.UserMetaData) => {
    // Implement edit user logic here
  
  }

const totalUsers = ref(0)

const columns: DataTableColumns = [
  {
    title: 'Name',
    key: 'name',
    render: (row) => `${row.firstName} ${row.lastName}`
  },
  {
    title: 'Email',
    key: 'email'
  },
  {
    title: 'State',
    key: 'state',
    render: (row) => h(NTag, { type: row.state ? 'success' : 'error' }, { default: () => row.state ? 'Active' : 'Inactive' })
  },
  // ... other columns
]

const fetchUsers = (page = 1, pageSize = 10) => {
  // Implement API call to fetch users based on page and pageSize
  // Update users and totalUsers refs
}

// Initial fetch
fetchUsers()
</script>