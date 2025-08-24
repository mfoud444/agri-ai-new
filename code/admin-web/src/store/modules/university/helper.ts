import { PostgrestResponse } from '@supabase/supabase-js';
import { supabase } from '@/utils/supabase';
// import {fetchAllUniversities} from '@/utils/drizzle/index';
export const fetchTotalCount = async (): Promise<number> => {
  try {
    const { count, error } = await supabase
      .from('universities')
      .select('*', { count: 'exact', head: true })

    if (error) {
      throw error;
    }
    // const allUniversities = await fetchAllUniversities();
    // console.log(allUniversities);
    // console.log('allUniversities:', yy);
    return count ? count[0] : 0;
  } catch (error: any) {
    console.error('Error fetching total count from Supabase:', error.message);
    throw error;
  }
};


export const fetchUniversities = async ({ limit, offset }: { limit: number; offset: number }): Promise<Research.University[]> => {
  try {
    const { data, error }: PostgrestResponse<Research.University> = await supabase
    .from('universities')
    .select('*')
    .order('updated_at')
    .range(offset, offset + limit - 1); 

    if (error) {
      throw error;
    }

    return data || [];
  } catch (error: any) {
    console.error('Error fetching universities from Supabase:', error.message);
    throw error;
  }
};


export const insertUniversity = async (university: Research.University): Promise<Research.University> => {
  try {
    const { data, error } = await supabase
      .from('universities')
      .insert([university])
      .select();

    if (error) {
      throw error;
    }
    const insertedUniversity = data ? data[0] : null;

    if (!insertedUniversity) {
      throw new Error('No data returned after insertion');
    }

    return insertedUniversity

  } catch (error: any) {
    throw error;
  }
};

export const deleteUniversity = async (id:  number): Promise<void> => {
  try {
    const { error } = await supabase
      .from('universities')
      .delete()
      .eq('id', id);

    if (error) {
      throw error;
    }
  } catch (error: any) {
    throw error;
  }
};

export const updateUniversity = async (id: number, updates: Partial<Research.University>): Promise<void> => {
  try {
    const { error } = await supabase
      .from('universities')
      .update(updates)
      .eq('id', id);

    if (error) {
      throw error;
    }
  } catch (error: any) {
    throw error;
  }
};
