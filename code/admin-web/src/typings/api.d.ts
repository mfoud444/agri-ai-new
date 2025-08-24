declare namespace API {

  type inputOutputData = 'Text' | 'Image' | 'Audio' | 'Video' | 'Documents'
  type userType  = 'Client' | 'Agri-Expert' | 'Admin';
  type userGender  = 'Male' | 'Female' | 'Other';

  interface UserMetaData{
    avatar: string
    fristName: string
    description?: string
    lastName?: string;
    avatarUrl?: string;
    dateOfBirth?: string; 
    state?: boolean;
    gender?: userGender
    userType?:userType
    country?: string;
    email?:string
    password?:string
    createdAt?: string; 
    updatedAt?: string; 
  }

  interface CompanyAI {
    id?: string; 
    name: string;
    apiUrl: string;
    apiKey: string;
    companyUrl?: string;
    logoUrl?: string;

    isActivate: boolean;
    createdAt: string;
    updatedAt: string;
  }


  interface DashboardState {
    clientCount: number
    expertCount: number
    adminCount: number
    aiCompanyCount: number
    aiModelCount: number
    questionCount: number
    convAICount: number
    convExpertCount: number
    monthlyData: MonthlyData[]
    monthlyDataLoading: boolean
  }

  interface ModelAI {
    id?: string;
    companyId: string;
    name: string;
    modelCode: string;
    description?: string;
    isActivate: boolean;
    version?: string;
    createdAt: string;
    updatedAt: string;
    inputData?: inputOutputData[];
    outputData?: inputOutputData[];
    maxTokens?: number;
    temperature?: number;
    topP?: number;
    topK?: number;
    repetitionPenalty?: number;
    stop?: string[];
    stream?: boolean;
  }


  interface Dashboard {
    clientCount: number;
    expertCount: number;
    adminCount: number;
    aiCompanyCount: number;
    aiModelCount: number;
    questionCount: number;
  }


  interface Country {
    id?: string; // optional unique identifier
    name: string;
    alpha_2: string; // 2-character country code
    alpha_3: string; // 3-character country code
    countryCode: string; // numeric country code
    iso_31662?: string; // optional ISO 3166-2 code
    region: string;
    subRegion: string;
    intermediateRegion?: string; // optional intermediate region
    regionCode: string;
    subRegionCode: string;
    intermediateRegionCode?: string; // optional intermediate region code
    isActivate: boolean;
    createdAt: string;
    updatedAt: string;
  }
}
