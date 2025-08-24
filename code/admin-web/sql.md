
```sql

-- Users Table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  avatar_url TEXT,
  date_of_birth DATE,
  state BOOLEAN DEFAULT TRUE,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')) NOT NULL DEFAULT 'Male',
  user_type VARCHAR(20) CHECK (user_type IN ('Client', 'Agri-Expert', 'Admin')) NOT NULL,
  country VARCHAR(50) ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.users IS 'Holds all user profile information';

-- Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Public profiles are viewable by everyone." ON public.users
  FOR SELECT USING (true);

CREATE POLICY "Users can manage their own profile." ON public.users
  FOR ALL USING (auth.uid() = id) WITH CHECK (auth.uid() = id);


-- Triggers for updating timestamps
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_timestamp BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();


-- inserts a row into public.profiles
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = ''
AS $$
BEGIN
  INSERT INTO public.users (
    id,
    first_name,
    last_name,
    avatar_url,

    state,
    gender,
    user_type,
    country
  )
  VALUES (
    new.id,
    new.raw_user_meta_data ->> 'first_name',
    new.raw_user_meta_data ->> 'last_name',
    new.raw_user_meta_data ->> 'avatar_url',

    COALESCE((new.raw_user_meta_data ->> 'state')::BOOLEAN, TRUE),
    COALESCE(new.raw_user_meta_data ->> 'gender', 'Male'),
    new.raw_user_meta_data ->> 'user_type',
    new.raw_user_meta_data ->> 'country'
  );
  RETURN new;
END;
$$;


-- trigger the function every time a user is created
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();







CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
  conv_id UUID;
BEGIN
  -- Generate a UUID for the conversation ID
  conv_id := gen_random_uuid();

  -- Insert into the users table
  INSERT INTO public.users (
    id,
    first_name,
    last_name,
    email,
    avatar_url,
    state,
    gender,
    user_type,
    country,
    conv_agri_id
  )
  VALUES (
    new.id,
    new.raw_user_meta_data ->> 'first_name',
    new.raw_user_meta_data ->> 'last_name',
    new.raw_user_meta_data ->> 'email',
    new.raw_user_meta_data ->> 'avatar_url',
    COALESCE((new.raw_user_meta_data ->> 'state')::BOOLEAN, TRUE),
    COALESCE(new.raw_user_meta_data ->> 'gender', 'Male'),
    new.raw_user_meta_data ->> 'user_type',
    new.raw_user_meta_data ->> 'country',
    conv_id 
  );

  -- Check if the user is a Client
  IF new.raw_user_meta_data ->> 'user_type' = 'Client' THEN
    -- Insert into the conversation table with a specific title for Agricultural Expert
    INSERT INTO public.conversation (
      id,
      user_id,
      title,
      created_at,
      updated_at,
      type
    )
    VALUES (
      conv_id,               
      new.id,                
      new.raw_user_meta_data ->> 'first_name', 
      NOW(),
      NOW(),
      'Agri-Expert'          
    );
  END IF;

  RETURN new;
END;
$$;




-- AI Company Table
CREATE TABLE IF NOT EXISTS public.ai_company (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  company_url TEXT,
  logo_url TEXT,
  api_url TEXT NOT NULL,
  is_activate BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.ai_company IS 'Stores AI companies that provide generative AI models.';

-- Enable Row Level Security
ALTER TABLE public.ai_company ENABLE ROW LEVEL SECURITY;

-- Policies
-- CREATE POLICY "AI companies are viewable by everyone." ON public.ai_company
--   FOR SELECT USING (true);

CREATE POLICY "Users can manage AI companies." ON public.ai_company
  FOR ALL USING (true);

-- Trigger for updating timestamps
CREATE TRIGGER update_ai_company_timestamp BEFORE UPDATE ON public.ai_company
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();
















-- AI Model Table
CREATE TABLE IF NOT EXISTS public.ai_model (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES public.ai_company(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  model_code VARCHAR(100) NOT NULL,
  description TEXT,
  is_activate BOOLEAN DEFAULT FALSE,
  version VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.ai_model IS 'Stores AI models provided by AI companies.';

-- AI Model Input Data Table
CREATE TABLE IF NOT EXISTS public.ai_model_input_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id UUID REFERENCES public.ai_model(id) ON DELETE CASCADE,
  input_data VARCHAR(40) CHECK (input_data IN ('Text', 'Image', 'Audio', 'Video', 'Documents')) NOT NULL
);

COMMENT ON TABLE public.ai_model_input_data IS 'Stores input data types for AI models.';

-- AI Model Output Data Table
CREATE TABLE IF NOT EXISTS public.ai_model_output_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id UUID REFERENCES public.ai_model(id) ON DELETE CASCADE,
  output_data VARCHAR(40) CHECK (output_data IN ('Text', 'Image', 'Audio', 'Video', 'Documents')) NOT NULL
);

COMMENT ON TABLE public.ai_model_output_data IS 'Stores output data types for AI models.';

-- Enable Row Level Security
ALTER TABLE public.ai_model ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_model_input_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_model_output_data ENABLE ROW LEVEL SECURITY;

-- Policies
-- CREATE POLICY "AI models are viewable by everyone." ON public.ai_model
--   FOR SELECT USING (true);

CREATE POLICY "Users can manage AI models." ON public.ai_model
  FOR ALL USING (true);

-- CREATE POLICY "AI model input data are viewable by everyone." ON public.ai_model_input_data
--   FOR SELECT USING (true);

CREATE POLICY "Users can manage AI model input data." ON public.ai_model_input_data
  FOR ALL USING (true);

-- CREATE POLICY "AI model output data are viewable by everyone." ON public.ai_model_output_data
--   FOR SELECT USING (true);

CREATE POLICY "Users can manage AI model output data." ON public.ai_model_output_data
  FOR ALL USING (true);

-- Trigger for updating timestamps
CREATE TRIGGER update_ai_model_timestamp BEFORE UPDATE ON public.ai_model
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();


-- Create index on company_id
CREATE INDEX idx_ai_model_company_id ON public.ai_model(company_id);







CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  avatar_url TEXT,
  date_of_birth DATE,
  state BOOLEAN DEFAULT TRUE,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')) NOT NULL DEFAULT 'Male',
  user_type VARCHAR(20) CHECK (user_type IN ('Client', 'Agri-Expert', 'Admin')) NOT NULL,
  country VARCHAR(50) ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);


-- Conversation Table
CREATE TABLE IF NOT EXISTS public.conversation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Question Table
CREATE TABLE IF NOT EXISTS public.question (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES public.conversation(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);



COMMENT ON TABLE public.conversation IS 'Tracks conversations between users and AI or agricultural experts.';

-- Enable Row Level Security
ALTER TABLE public.conversation ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own conversations." ON public.conversation
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can manage their own conversations." ON public.conversation
  FOR ALL USING (auth.uid() = user_id);

-- Trigger for updating timestamps
CREATE TRIGGER update_conversation_timestamp BEFORE UPDATE ON public.conversation
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Create index on user_id
CREATE INDEX idx_conversation_user_id ON public.conversation(user_id);


ALTER TABLE public.conversation
ADD COLUMN type VARCHAR(20) CHECK (type IN ('AI', 'Agri-Expert')) NOT NULL DEFAULT 'AI';


ALTER TABLE public.answer
ADD COLUMN status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'rejected') OR status IS NULL);





-- answer Media Table
CREATE TABLE IF NOT EXISTS public.answer_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  answer_id UUID REFERENCES public.answer(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type VARCHAR(40) CHECK (media_type IN ('Image', 'Audio', 'Video', 'Documents')) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.answer_media IS 'Stores media entries associated with answers.';
ALTER TABLE public.answer_media ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER update_answer_media_timestamp BEFORE UPDATE ON public.answer_media
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE POLICY "Users can manage answer_media in their conversations." ON public.answer_media
  FOR ALL USING (true);




-- Question Table
CREATE TABLE IF NOT EXISTS public.question (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES public.conversation(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);



CREATE VIEW conversation_with_questions AS
SELECT c.*
FROM conversation c
JOIN question q ON c.id = q.conversation_id
WHERE c.type = 'Agri-Expert';


COMMENT ON TABLE public.question IS 'Logs questions within a conversation.';

-- Question Media Table
CREATE TABLE IF NOT EXISTS public.question_media (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID REFERENCES public.question(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type VARCHAR(40) CHECK (media_type IN ('Image', 'Audio', 'Video', 'Documents')) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.question_media IS 'Stores media entries associated with questions.';

-- Enable Row Level Security
ALTER TABLE public.question ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.question_media ENABLE ROW LEVEL SECURITY;

-- Policies for question table
CREATE POLICY "Users can view questions in their conversations." ON public.question
  FOR SELECT USING (auth.uid() IN (SELECT user_id FROM public.conversation WHERE id = question.conversation_id));

CREATE POLICY "Users can manage questions in their conversations." ON public.question
  FOR ALL USING (auth.uid() = user_id);

-- Policies for question_media table
CREATE POLICY "Users can view media for their questions." ON public.question_media
  FOR SELECT USING (auth.uid() IN (SELECT user_id FROM public.conversation WHERE id = (SELECT conversation_id FROM public.question WHERE id = question_media.question_id)));

CREATE POLICY "Users can manage media for their questions." ON public.question_media
  FOR ALL USING (auth.uid() IN (SELECT user_id FROM public.question WHERE id = question_media.question_id));

-- Trigger for updating timestamps
CREATE TRIGGER update_question_timestamp BEFORE UPDATE ON public.question
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_question_media_timestamp BEFORE UPDATE ON public.question_media
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Create index on conversation_id for question table
CREATE INDEX idx_question_conversation_id ON public.question(conversation_id);




Chat APP like whatsapp i want all feather execpt i have only one room for users write full schema coorect

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  avatar_url TEXT,
  date_of_birth DATE,
  state BOOLEAN DEFAULT TRUE,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female', 'Other')) NOT NULL DEFAULT 'Male',
  user_type VARCHAR(20) CHECK (user_type IN ('Client', 'Agri-Expert', 'Admin')) NOT NULL,
  country VARCHAR(50) ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- message Table
CREATE TABLE IF NOT EXISTS public.message (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID REFERENCES public.users(room_id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
);

COMMENT ON TABLE public.message IS 'Logs messages within a conversation.';

-- Enable Row Level Security
ALTER TABLE public.message ENABLE ROW LEVEL SECURITY;

-- Policies

CREATE POLICY "Users can manage thier own messages." ON public.message
  FOR ALL USING (true);

-- Trigger for updating timestamps
CREATE TRIGGER update_message_timestamp BEFORE UPDATE ON public.message
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Create index on question_id
CREATE INDEX idx_message_question_id ON public.message(question_id);


--  Media Data Table
CREATE TABLE IF NOT EXISTS public.media_data (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID REFERENCES public.question(id) ON DELETE CASCADE,
  media_url TEXT NOT NULL,
  media_type VARCHAR(40) CHECK (media_type IN ('Image', 'Audio', 'Video', 'Documents')) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.media_data IS 'Stores media entries associated with questions.';

-- Enable Row Level Security
ALTER TABLE public.media_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage media." ON public.media_data
  FOR ALL USING (true);

-- Create index on question_id for media_data table
CREATE INDEX idx_media_data_question_id ON public.media_data(question_id);



















-- Answer Table
CREATE TABLE IF NOT EXISTS public.answer (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID REFERENCES public.question(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.answer IS 'Logs answers within a conversation.';

-- Enable Row Level Security
ALTER TABLE public.answer ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view answers to their questions." ON public.answer
  FOR SELECT USING (auth.uid() IN (SELECT user_id FROM public.question WHERE id = answer.question_id));

CREATE POLICY "Users can manage their own answers." ON public.answer
  FOR ALL USING (auth.uid() = user_id);

-- Trigger for updating timestamps
CREATE TRIGGER update_answer_timestamp BEFORE UPDATE ON public.answer
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Create index on question_id
CREATE INDEX idx_answer_question_id ON public.answer(question_id);











CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  text TEXT NOT NULL,
image VARCHAR(255),
name VARCHAR(255),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.notifications IS 'Stores notifications for users.';


CREATE POLICY "admin users can manage app notifications." ON public.notifications
  FOR ALL USING (true);


ALTER TABLE public.app_setting
ADD COLUMN versionApp VARCHAR(255);


-- App Setting Table
CREATE TABLE IF NOT EXISTS public.app_setting (
  default_ai_model UUID REFERENCES public.ai_model(id),
  default_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);


COMMENT ON TABLE public.app_setting IS 'Stores application-wide settings, including default AI model and messages.';

-- Enable Row Level Security
ALTER TABLE public.app_setting ENABLE ROW LEVEL SECURITY;

-- Policies
-- CREATE POLICY "App settings are viewable by everyone." ON public.app_setting
--   FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage app settings." ON public.app_setting
  FOR ALL USING (true);

-- Trigger for updating timestamps
CREATE TRIGGER update_app_setting_timestamp BEFORE UPDATE ON public.app_setting
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();




```

### Subscriptions and Payments

```sql
-- Subscription Packages
CREATE TABLE IF NOT EXISTS public.subscription_packages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  features TEXT[],
  usage_limits JSONB,
  price NUMERIC(10, 2) NOT NULL,
  discount NUMERIC(5, 2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.subscription_packages IS 'Defines subscription packages and their features, limits, and prices.';

-- User Subscriptions
CREATE TABLE IF NOT EXISTS public.user_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  package_id UUID REFERENCES public.subscription_packages(id) ON DELETE SET NULL,
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ,
  status VARCHAR(20) CHECK (status IN ('Active', 'Expired', 'Cancelled')) NOT NULL DEFAULT 'Active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.user_subscriptions IS 'Tracks user subscriptions and their statuses.';

-- Payments
CREATE TABLE IF NOT EXISTS public.payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  subscription_id UUID REFERENCES public.user_subscriptions(id) ON DELETE SET NULL,
  amount NUMERIC(10, 2) NOT NULL,
  payment_method VARCHAR(50) CHECK (payment_method IN ('Stripe', 'PayPal', 'Credit Card')) NOT NULL,
  payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Completed', 'Failed')) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.payments IS 'Logs payments made by users for their subscriptions.';
```

### Notifications and Settings

```sql
-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(100) NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE public.notifications IS 'Stores notifications for users.';
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);



```

### Administrative Controls

```sql
-- Admins
CREATE TABLE IF NOT EXISTS public.admins (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE
);

COMMENT ON TABLE public.admins IS 'Stores information about administrators.';

-- Supervisors
CREATE TABLE IF NOT EXISTS public.supervisors (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  salary NUMERIC(10, 2)
);

COMMENT ON TABLE public.supervisors IS 'Stores information about supervisors and their salaries.';

-- Agricultural Experts
CREATE TABLE IF NOT EXISTS public.agricultural_experts (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  supervisor_id UUID REFERENCES public.supervisors(user_id) ON DELETE SET NULL,
  salary NUMERIC(10, 2)
);

COMMENT ON TABLE public.agricultural_experts IS 'Stores information about agricultural experts and their salaries.';
```

### Indexes and Triggers

```sql
-- Indexes for optimization
CREATE INDEX idx_user_subscriptions_user_id ON public.user_subscriptions(user_id);
CREATE INDEX idx_payments_user_id ON public.payments(user_id);



CREATE TRIGGER update_subscription_timestamp BEFORE UPDATE ON public.user_subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_timestamp();


```

This schema covers user management, authentication, subscription handling, conversation tracking, administrative roles, and AI integration, aligning with the described application functionality. Additional logic for Stripe integration, notifications, and other specific features would be implemented within the application code and through Supabase's authentication and real-time capabilities.
