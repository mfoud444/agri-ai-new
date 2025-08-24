// index.ts

import { defineStore } from 'pinia';
import { fetchUniversities, deleteUniversity, updateUniversity, insertUniversity ,
  fetchTotalCount} from './helper';
import { useUserStore } from '@/store';
export function  initStateUnversity(): Research.University {
  const userStore = useUserStore()
  const user_id: string = userStore.userInfo!.user!.id!;
  return {
    name: '',
    country_code: 'SA',
    type_added: 'default',
    is_active: true,
    image_url: '',
    user_id: user_id,
    created_at: new Date(),
    updated_at: new Date(),
  }
}


export const useUniversityStore = defineStore('university-store', {
  state: (): ResearchState.Users => ({
    listUsers:[],
    usersInfo:initStateUnversity(),
    loadingInit:false,
    showModelAdd:false,
    showModelUpdate:false,
    countTotalData:null
  }),
  actions: {
    initState(): Research.University {
      const userStore = useUserStore()
      const user_id: string = userStore.userInfo!.user!.id!;
      return {
      
        name: '',
        country_code: 'SA',
        type_added: 'default',
        is_active: true,
        image_url: '',
        user_id: user_id,
        created_at: new Date(),
        updated_at: new Date(),
      }
    },
    async countTotalDataAction(): Promise<void> {
      try {
        this.countTotalData = await fetchTotalCount();
    
      } catch (error: any) {
        throw error;
      }
    },
    async fetchUniversitiesAction({ limit, offset }: { limit: number; offset: number }): Promise<void> {
      try {
        const userStore = useUserStore()
        const user_id: string = userStore.userInfo!.user!.id!;
        console.log(userStore.userInfo!.user)
        const result = await fetchUniversities({ limit: limit, offset: offset } );
        this.listUsers = [...this.listUsers, ...result];
      } catch (error: any) {
        throw error;
      }
    },

    async insertUniversityAction(newUniversity: Research.University): Promise<void> {
      try {
        const insertedUniversity = await insertUniversity(newUniversity);

        this.listUsers = [insertedUniversity, ...this.listUsers];
      } catch (error: any) {
        throw error;
      }
    },
    async deleteUniversityAction(id: number): Promise<void> {
      try {
        await deleteUniversity(id);
        const index = this.listUsers.findIndex((university) => university.id === id);
        if (index !== -1) {
          this.listUsers.splice(index, 1);
        }
      } catch (error: any) {
        throw error;
      }
    },

    async updateUniversityAction(payload: { id: number; updates: Partial<Research.University> }): Promise<void> {
      try {
        await updateUniversity(payload.id, payload.updates);
        this.listUsers = this.listUsers.map((university) =>
          university.id === payload.id ? { ...university, ...payload.updates } : university
        );
      } catch (error: any) {
        throw error;
      }
    },
  },
});
