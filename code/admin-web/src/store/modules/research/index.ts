// index.ts

import { defineStore } from 'pinia';
import { fetchUniversities, deleteUniversity, updateUniversity, insertUniversity } from './helper';
import { useUsersStore } from  '@/store'
function defaultDoucementOptions(): Research.DoucementOptions {

  return {
    is_cover: true,
    is_border: true,
    is_page_number: true,
    is_index: true
  }
}


function defaultCoverOptions(): Research.CoverOptions {

  return {
    is_name: true,
    is_title: true,
    is_doctor_name: false,
    is_image: false,
    is_years: true,
    is_header: false,
    is_footer: false,
  }
}

function defaultUniversityOptions(): Research.University {

  return {
    id: '',
    name: 'Demo Unversitu',

  }
}
 function defaultResearchOptions(): Research.Research{
  const universityStore = useUsersStore()
  let result: Research.University[] = [];
  try {
    // await universityStore.fetchUniversitiesAction();
    result = universityStore.$state
  } catch (error: any) {
    console.error('Error fetching data:', error.message);

    throw error;
  }
  return {
    id: '',
    fake_title: 'Demo Reserch',
    university_info: result[0],


    topic: '',
    lang: 'en',

    is_actvity: true,
    state: 'pinding',
    is_keywords: false,
    is_refrence: false,
    started_date_time: new Date(),
    end_date_time: new Date('2023-12-20T21:34:17.784Z'),
    created_at: new Date(),
    updated_at: new Date(),
    question: [],
  }
}
function publicSettingResearch(): Research.PublicSettingResearch {

  return {
    max_title_char: 100,
    clearable: false,
  }
}


function defaultResearchState(): Research.ResearchState{

  return {
    public_setting: publicSettingResearch(),
    re_info:  defaultResearchOptions(),
    doc_options: defaultDoucementOptions(),
    cover_options: defaultCoverOptions()
  }
}

export const useResearchStore = defineStore('research-store', {
  state: (): Research.PublicResearchState => ({
    current_re_state: defaultResearchState(),
    list_re_state: [defaultResearchState()]
  }),
  getters: {
    // currentResearch(state): Research.ResearchState | null{
    //  if(!state.id_activity){
    //   return null;
    //  }else{
    //   state.
    //  }

    // }

  },
  actions: {
    // async fetchUniversitiesAction(): Promise<Research.ResearchState> {
    //   try {
    //     const result = await fetchUniversities();
    //     this.$state = result;
    //     return result;
    //   } catch (error: any) {
    //     console.error('Error fetching data:', error.message);
    //     throw error;
    //   }
    // },

    // async insertUniversityAction(newUniversity: Research.ResearchState): Promise<void> {
    //   try {
    //     const insertedUniversity  = await insertUniversity(newUniversity);
    //     // Optionally, you can refresh the list of universities after insertion.
    //     this.$state = [...this.$state, insertedUniversity];
    //   } catch (error: any) {
    //     console.error('Error inserting university:', error.message);
    //     throw error;
    //   }
    // },
    // async deleteUniversityAction(id: string): Promise<void> {
    //   try {
    //     console.error('id', id);
    //     await deleteUniversity(id);
    //     const index = this.$state.findIndex((university) => university.id === id);
    //     if (index !== -1) {
    //       this.$state.splice(index, 1);
    //     }
    //   } catch (error: any) {
    //     console.error('Error deleting university:', error.message);
    //     throw error;
    //   }
    // },

    async updateUniversityAction(payload: { id: string; updates: Partial<Research.ResearchState> }): Promise<void> {
      try {
        await updateUniversity(payload.id, payload.updates);
        //   this.$state = this.$state.map((university) =>
        //   university.id === payload.id ? { ...university, ...payload.updates } : university
        // );
      } catch (error: any) {
        console.error('Error updating university:', error.message);
        throw error;
      }
    },
  },
});
