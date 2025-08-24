// index.ts

import { defineStore } from 'pinia';
import {
  fetchData, deleteData, updateData, insertData
} from './helper';
import { useUserStore } from '@/store';
import { fetchDataFromTable, getImageUrl, updateDataInTable } from '@/utils/supabasehelper';
export function initState(): User.UserData {
  const userStore = useUserStore()
  const user_id: string = userStore.userInfo!.user!.id!;
  return {
    id: '',
    firstName: "",
    lastName: "",
    email: null,
    password: null,
    avatarUrl: "https://example.com/avatar.jpg",
    dateOfBirth: "1990-01-01",
    state: true,
    gender: "Male",
    userType: "Client",
    country: "USA",
    createdAt: "2024-01-01T00:00:00Z",
    updatedAt: "2024-01-01T00:00:00Z"

  }
}
const tableName = 'users';

export const useUsersStore = defineStore('users-store', {
  state: () => ({
    listUsers: [] as User.UserData[],
    usersInfo: initState(),
    loadingInit: false,
    showList:true,
    showAdd: false,
    showUpdate: false,
    countTotalData: 0,
    bucket: 'company'
  }),
  actions: {
    initState(): User.UserData {
      const userStore = useUserStore()
      const user_id: string = userStore.userInfo!.user!.id!;
      return {

        id: '',
        firstName: '',
        lastName: '',
        email: '',
        password: '',
        avatarUrl: "",
        dateOfBirth: "",
        state: true,
        gender: "Male",
        userType: "Client",
        country: "USA",
        createdAt: "2024-01-01T00:00:00Z",
        updatedAt: "2024-01-01T00:00:00Z"
      }
    },

    async fetchDataAction({ limit, offset, userType }: { limit: number; offset: number, userType: string }): Promise<void> {
      try {
        // const userStore = useUserStore()
        // const user_id: string = userStore.userInfo!.user!.id!;
        // console.log(userStore.userInfo!.user)
        // const { data, totalCount } = await fetchDataFromTable<APIAI.CompanyAI>('users', limit, offset);
        // this.listCompanies = data;


        const { data, totalCount } = await fetchData({ limit: limit, offset: offset, userType: userType });

        const uniqueUsers = data.filter(newUser => !this.listUsers.some(existingUser => existingUser.id === newUser.id));
        this.countTotalData = totalCount;
        this.listUsers = [...this.listUsers, ...uniqueUsers];
       
      } catch (error: any) {
        throw error;
      }
    },


    async fetchDataActionById(id:string): Promise<User.UserData> {
      try {
        const filters = { id: id };
        const { data, totalCount } = await fetchDataFromTable<User.UserData>('users', 1, 0, filters);
        // this.listCompanies = data;


      

        // const uniqueUsers = data.filter(newUser => !this.listUsers.some(existingUser => existingUser.id === newUser.id));
        // this.countTotalData = totalCount;
        // this.listUsers = [...this.listUsers, ...uniqueUsers];
        return data[0];
       
      } catch (error: any) {
        throw error;
      }
    },
    async insertDataAction(newUniversity: User.UserData): Promise<void> {
      try {
        const insertedData = await insertData(newUniversity);

        this.listUsers = [insertedData, ...this.listUsers];
      } catch (error: any) {
        throw error;
      }
    },
    async deleteDataAction(id: string): Promise<void> {
      try {
        await deleteData(id);
        const index = this.listUsers.findIndex((university) => university.id === id);
        if (index !== -1) {
          this.listUsers.splice(index, 1);
        }
      } catch (error: any) {
        throw error;
      }
    },

    async updateDataAction(data: User.UserData): Promise<void> {
      try {
        
        await updateDataInTable<User.UserData>(tableName, data);
        if (data.avatarUrl) {
          data.avatarUrl = await getImageUrl(this.bucket, data.avatarUrl);
        }
        this.listUsers = this.listUsers.map(user =>
          user.id === data.id ? { ...user, ...data } : user
        );
      } catch (error: any) {
        console.log(error.message)
        throw error;
      }
    }
   
  },
});
