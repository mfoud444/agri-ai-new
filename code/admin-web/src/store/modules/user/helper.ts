import { ss } from '@/utils/storage'
import { Session, User } from '@supabase/supabase-js'

const LOCAL_NAME = 'userStorage'


export interface UserState {
  user: User | null
  session: Session | null
  userMetaData: API.UserMetaData
  
}



export function defaultSetting(): UserState {
  return {
    session: null,
    user: null,
    userMetaData: {
      avatar: '',
      fristName: '',
      description: '',
      lastName: '',
      avatarUrl: '',
      dateOfBirth: '', 
      state: true,
      gender: 'Male' ,
      userType: 'Client' ,
      country: '',
      createdAt: '', 
      updatedAt: '', 
    }
   
  }

}

export function getLocalState(): UserState {
  const localSetting: UserState | undefined = ss.get(LOCAL_NAME)
  return { ...defaultSetting(), ...localSetting }
}

export function setLocalState(setting: UserState): void {
  ss.set(LOCAL_NAME, setting)
}
