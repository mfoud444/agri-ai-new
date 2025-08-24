import { defineStore } from 'pinia'
import { getToken, removeToken, setToken } from './helper'
import { store } from '@/store/helper'
// import { fetchSession } from '@/api'
import { supabase } from '@/utils/supabase'
import { AuthError, Session, User } from '@supabase/supabase-js'
import { useUserStore, useChatStore, useUsersStore } from '@/store'
import { get, post, del } from '@/utils/request'
import { camelToSnake } from '@/utils/functions'
export interface AuthState {
  token: string | undefined
  error: AuthError | null;
  api: 'ChatGPTAPI' | 'ChatGPTUnofficialProxyAPI' | 'AlharaqApi'
  userAuth: User.UserAuth
}


export const useAuthStore = defineStore('auth-store', {
  state: (): AuthState => ({
    token: getToken(),
    error: null,
    api: 'AlharaqApi',
    userAuth: {
      firstName: '',
      lastName: '',
      email: '',
      password: '',
      reenteredPassword: '',
    },
  }),

  getters: {
    isChatGPTAPI(state): boolean {
      return state.api === 'ChatGPTAPI'
    },
    isAlharaqApi(state): boolean {
      return state.api === 'AlharaqApi'
    },

  },

  actions: {

    async signUp(userData: User.UserData): Promise<void> {
      try {

        if (!userData.email || !userData.password) {
          throw new Error('Email and password are required');
        }
        const snakeData =[userData].map(camelToSnake);
        
        console.log(userData)
          const { data, error } = await supabase.auth.signUp({
            email: userData.email,
            password: userData.password,
            options: {
              data: snakeData[0],
            }
         
          }
          
          );

          if (error) {
            throw error;
          }


          // User exists, but is fake. See https://supabase.com/docs/reference/javascript/auth-signup
          if (data.user && data.user.identities && data.user.identities.length === 0) {
            console.log("data.user", data.user)
            const authError = {
              name: "AuthApiError",
              message: "User already exists",
            };
            try {
              await this.Login(userData.email, userData.password)

            } catch (error) {
              this.error = error as AuthError;
              throw error;
            }

            // throw authError as AuthError;
          } else {
            // if(){

            // }
            const usersStore = useUsersStore()
            console.log("data.user", data.user)
            userData.id = data.user?.id!
            usersStore.listUsers.unshift(userData)
            // await this.reSendVerifyOTP(email)
            // const userStore = useUserStore()
            // userStore.updateUserInfo({ user: data.user, session: data.session, name: (firstName + " " + lastName) })

          }

          this.error = null;
      
      } catch (error) {
        this.error = error as AuthError;
        throw error;
      }
    },

    async Login(email: string, password: string): Promise<void> {
      try {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });

        if (error) {
          throw error;
        }

        if (data) {
          console.log("OOOOOOOOOOOOOOOO")
          if(data.user.user_metadata.user_type == 'Admin'){
          const userStore = useUserStore()
          userStore.updateUserState({ user: data.user, session: data.session })
          this.error = null;
        }else{
          throw new Error('The User not Invalid ');
        }
      }

      } catch (error) {
        this.error = error as AuthError;
        throw error;
      }
    },

    async verifyOTP(email: string, token: string): Promise<void> {
      try {
        const { data, error } = await supabase.auth.verifyOtp({ email, token, type: 'email' });

        if (error) {
          throw error;
        }

        console.log("data:", data)
        console.log("data:", data)
        const userStore = useUserStore()
        userStore.updateUserState({ user: data.user, session: data.session })

        this.error = null;
      } catch (error) {
        this.error = error as AuthError;
        throw error;
      }
    },

    async reSendVerifyOTP(email: string, type: "signup" | "email_change" = "signup"): Promise<void> {
      try {
        const { data, error } = await supabase.auth.resend({
          type: type,
          email: email,
        })
        if (error) {
          throw error;
        }

        if (data) {

          // const userStore = useUserStore()
          // userStore.updateUserInfo({ user: data.user, session: data.session })

          // this.error = null;
        }

      } catch (error) {
        this.error = error as AuthError;
        throw error;
      }
    },




    async signOut(): Promise<void> {
      try {
        const { error } = await supabase.auth.signOut();

        if (error) {
          throw error;
        }
        const userStore = useUserStore()
        const chatStore = useChatStore()
        userStore.resetUserState()
        chatStore.resetChatState()
      } catch (error) {
        this.error = error as AuthError;
        throw error;
      }
    },

    async refreshToken() {

      const userStore = useUserStore();
      const refreshToken = userStore.session?.access_token;
      if (!refreshToken) {
        throw new Error('No refresh token available');
      }

      const { data, error } = await supabase.auth.refreshSession({ refresh_token: refreshToken });

      if (error) {
        throw new Error('Unable to refresh token');
      }


      userStore.updateUserState({ user: data.user, session: data.session })

    },
    isAuthenticated(): boolean {
      const userStore = useUserStore()
      return userStore.user !== null && userStore.session !== null;
    },

    // async getSession() {
    //   try {
    //     const { data, error } = await supabase.auth.getSession();

    //     if (error) {
    //       // Handle any errors
    //       return Promise.reject(error.message);
    //     }

    //     this.session = { auth:data !== null, model: 'AlharaqApi' }; 
    //     return Promise.resolve(this.session);
    //   } catch (error) {
    //     return Promise.reject(error);
    //   }
    // },


    // async getSession() {

    //   try {
    //     const { data } = await fetchSession<SessionResponse>()

    //     this.session = { ...data }
    //     return Promise.resolve(data)
    //   }
    //   catch (error) {
    //     return Promise.reject(error)
    //   }
    // },

    setToken(token: string) {
      this.token = token
      setToken(token)
    },
    removeToken() {
      this.token = undefined
      removeToken()
    },
  },
})

export function useAuthStoreWithout() {
  return useAuthStore(store)
}
