import { createClient } from '@supabase/supabase-js'
// import { Database } from './database.types'
// export const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
// export const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabaseUrl = "https://yjubwgtvyceswxdhyzxg.supabase.co" //import.meta.env.VITE_SUPABASE_URL
export const supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqdWJ3Z3R2eWNlc3d4ZGh5enhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA3MzMzMTksImV4cCI6MjAzNjMwOTMxOX0.tR3JRnEwt3GjmGjXLn2l-llWW9OjeJY8X9eOSWCVHLA"//import.meta.env.VITE_SUPABASE_ANON_KEY
export const service_role_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqdWJ3Z3R2eWNlc3d4ZGh5enhnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTcyMDczMzMxOSwiZXhwIjoyMDM2MzA5MzE5fQ.i_m4WHA4n3mUQtYqIyAQ690remN1cd1uJQQ0Q9eaQ-8"
const supabaseAdmin = createClient(supabaseUrl, service_role_key, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})
// Access auth admin api
export const adminAuthClient = supabaseAdmin.auth.admin
export const supabase = createClient(supabaseUrl, supabaseAnonKey)
export const supabaseUrlImage = `${supabaseUrl}/storage/v1/object/public`
