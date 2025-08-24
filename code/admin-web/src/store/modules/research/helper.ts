





// helper.ts

import { PostgrestResponse } from '@supabase/supabase-js';
import { supabase } from '@/utils/supabase';

export const fetchUniversities = async (): Promise<Research.ResearchState> => {
  try {
    const { data, error }: PostgrestResponse<Research.ResearchState> = await supabase
      .from('universities')
      .select('*')
      .order('updated_at');;

    if (error) {
      throw error;
    }

    return data || [];
  } catch (error: any) {
    console.error('Error fetching universities from Supabase:', error.message);
    throw error;
  }
};

export const insertUniversity = async (university: Research.ResearchState): Promise<Research.ResearchState> => {
  try {
    const { data, error } = await supabase
      .from('universities')
      .insert([university])
      .select();

    if (error) {
      throw error;
    }

    // Assuming that insert operation returns an array, and you want the first element
    const insertedUniversity = data ? data[0] : null;

    if (!insertedUniversity) {
      throw new Error('No data returned after insertion');
    }

    return insertedUniversity

  } catch (error: any) {
    console.error('Error inserting university into Supabase:', error.message);
    throw error;
  }
};

export const deleteUniversity = async (id:  string): Promise<void> => {
  try {
    const { error } = await supabase
      .from('universities')
      .delete()
      .eq('id', id);

    if (error) {
      throw error;
    }
  } catch (error: any) {
    console.error('Error deleting university from Supabase:', error.message);
    throw error;
  }
};

export const updateUniversity = async (id:  string, updates: Partial<Research.ResearchState>): Promise<void> => {
  try {
    const { error } = await supabase
      .from('universities')
      .update(updates)
      .eq('id', id);

    if (error) {
      throw error;
    }
  } catch (error: any) {
    console.error('Error updating university in Supabase:', error.message);
    throw error;
  }
};
