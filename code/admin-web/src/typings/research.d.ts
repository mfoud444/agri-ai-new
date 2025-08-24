
declare namespace Research {

    interface University {
        id?: number;
        name: string;
        country_code: string;
        is_active: boolean;
        image_url: string;
        type_added: 'default' | 'personal';
        user_id: string;
        created_at: Date;
        updated_at: Date;
    }

    type College = {
        id: string | null;
        name: string;
        is_active: boolean;
        note?: string;
        created_at: Date;
        updated_at: Date;
    }

    type Major = {
        id: string | null;
        name: string;
        is_active: boolean;
        note?: string;
        image_url?: string;
        created_at: Date;
        updated_at: Date;
    }

    interface Student {
        id: string | null;
        university_info: University;
        university_id: string;
        original_name: string;
        fake_name: string;
        brith_date?: Date;
        major: Major;
        is_active: boolean;
        phone_number?: string;
        email: string;
        note?: string;
        image_url?: string;
        created_at: Date;
        updated_at: Date;
    }



    interface Answer {
        id: string | null;
        orignal_text: string;
        fake_text: string;
        state: string;
        model: Chat.Model;
        created_at: Date;
        updated_at: Date;
    }

    interface Question {
        id: string;
        orignal_text: string;
        fake_text: string;
        state: string;
        answers: Answer[];
        chooses_answer: string;
        created_at: Date;
        updated_at: Date;
    }

    type DoucementOptions = {

        is_cover: boolean
        is_border: boolean
        is_page_number: boolean
        is_index: boolean




    }

    type CoverOptions = {
        is_name: boolean
        is_title: boolean
        is_doctor_name: boolean
        is_image: boolean
        is_years: boolean
        is_header: boolean
        is_footer: boolean


    }

    type Research = {
        id: string;
        student_info?: Student[];
        university_info: University;
        major?: Major;
        college?: College;
        fake_title:string;
        topic: string;
        lang: string;
        is_actvity?: boolean
        state: string;
        note?: string;
        is_keywords: boolean
        is_refrence: boolean;
        started_date_time:Date,
        end_date_time:Date,
        created_at: Date;
        updated_at: Date;
        question: Question[]

    }



    type PublicSettingResearch = {
        max_title_char: number
        clearable: boolean
    }

    type ResearchState = {
        re_info: Research;
        doc_options: DoucementOptions;
        cover_options: CoverOptions;
        public_setting: PublicSettingResearch;
        
    }

    type PublicResearchState = {
      current_re_state:ResearchState 
      list_re_state:ResearchState[]

        
    }
}