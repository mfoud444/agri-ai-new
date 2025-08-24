<script lang="ts" setup>
import Hero from './Hero.vue'
import Navbar from './Navbar.vue'
import Carousel from './Carousel.vue'
import Company from './Company.vue'
import News from './News.vue'
import Features from './Features.vue'

import { Footer } from '@/components/common';
import { MainHeader } from '@/components/common';

import { h } from 'vue'
import { NLayout, NLayoutHeader, NLayoutContent, NLayoutFooter, NMenu, NButton, NCard, NIcon, NRate } from 'naive-ui'
import { 
  TextOutline, 
  ImageOutline, 
  ChatboxEllipsesOutline, 
  SchoolOutline,
  CashOutline,
  DocumentTextOutline,
  ServerOutline,
  SparklesOutline,
  PhonePortraitOutline,
  LogoGooglePlaystore,
  LogoApple,
  PersonCircleOutline,
  CheckmarkCircleOutline
} from '@vicons/ionicons5'

const menuOptions = [
  {
    label: () => h('a', { href: '#' }, 'Home'),
    key: 'home'
  },
  {
    label: () => h('a', { href: '#' }, 'Services'),
    key: 'services'
  },
  {
    label: () => h('a', { href: '#' }, 'Research Academy'),
    key: 'academy'
  },
  {
    label: () => h('a', { href: '#' }, 'Mobile App'),
    key: 'app'
  },
  {
    label: () => h('a', { href: '#' }, 'Pricing'),
    key: 'pricing'
  },
  {
    label: () => h('a', { href: '#' }, 'Contact'),
    key: 'contact'
  }
]

const aiServices = [
  {
    title: 'Text Generation',
    description: 'Create high-quality content with our advanced text generation AI.',
    icon: TextOutline
  },
  {
    title: 'Image Generation',
    description: 'Transform your ideas into stunning visuals with our AI-powered image generator.',
    icon: ImageOutline
  },
  {
    title: 'AI Chat Bot',
    description: 'Engage in intelligent conversations with our sophisticated AI chatbot.',
    icon:  ChatboxEllipsesOutline
  },
  {
    title: 'Research Academy',
    description: 'Join our academy to explore and advance AI technology.',
    icon: SchoolOutline
  }
]

const testimonials = [
  {
    name: 'Sarah Johnson',
    comment: 'Rand AI has revolutionized my workflow. The text generation feature is incredibly accurate and time-saving!',
    rating: 5
  },
  {
    name: 'Michael Chen',
    comment: 'As a researcher, the access to advanced AI models through Rand AI has been invaluable. Highly recommended!',
    rating: 5
  },
  {
    name: 'Emily Rodriguez',
    comment: 'The mobile app is fantastic! I can now use Rand AI\'s powerful features on the go. Great job!',
    rating: 4
  }
]

const pricingPlans = [
  {
    name: 'Basic',
    price: 'Free',
    features: [
      'Access to basic AI models',
      'Limited text and image generation',
      'Standard customer support'
    ]
  },
  {
    name: 'Pro',
    price: '$19.99/month',
    features: [
      'Access to all AI models',
      'Unlimited text and image generation',
      'Priority customer support',
      'Mobile app access'
    ]
  },
  {
    name: 'Enterprise',
    price: 'Custom',
    features: [
      'Custom AI model development',
      'Dedicated account manager',
      '24/7 premium support',
      'On-premise deployment options'
    ]
  }
]
</script>

<template>
   <div class="min-h-screen bg-gradient-to-br from-purple-600 via-blue-500 to-cyan-400">
    <n-layout>
      <n-layout-header class="p-4 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg">
        <div class="container mx-auto flex justify-between items-center">
          <h1 class="text-3xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-pink-500 to-yellow-500">
            Rand AI
          </h1>
          <n-menu mode="horizontal" :options="menuOptions" />
        </div>
      </n-layout-header>

      <n-layout-content>
        <!-- Hero Section -->
        <section class="py-20 text-center ">
          <h2 class="text-5xl font-extrabold mb-4 text-transparent bg-clip-text bg-gradient-to-r from-green-300 via-blue-500 to-purple-600">
            Welcome to Rand AI
          </h2>
          <p class="text-xl mb-8">Empowering your creativity with advanced AI solutions</p>
          <n-button type="primary" size="large">Get Started</n-button>
        </section>

        <!-- AI Services Section -->
        <section class="py-16 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg">
          <div class="container mx-auto">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-red-500">
              Our AI Services
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
              <n-card v-for="service in aiServices" :key="service.title">
                <template #cover>
                  <div class="h-40 flex items-center justify-center bg-gradient-to-r from-cyan-500 to-blue-500">
                    <n-icon size="48" :component="service.icon" />
                  </div>
                </template>
                <h4 class="text-xl font-semibold mb-2">{{ service.title }}</h4>
                <p>{{ service.description }}</p>
              </n-card>
            </div>
          </div>
        </section>

        <!-- Features Section -->
        <section class="py-16">
          <div class="container mx-auto ">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-500">
              Why Choose Rand AI?
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="flex items-start space-x-4">
                <div class="flex-shrink-0">
                  <n-icon size="36" color="#10B981">
                    <CashOutline />
                  </n-icon>
                </div>
                <div>
                  <h4 class="text-xl font-semibold mb-2">Free and No Ads</h4>
                  <p>Enjoy our services without any cost or advertisements.</p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <div class="flex-shrink-0">
                  <n-icon size="36" color="#3B82F6">
                    <DocumentTextOutline />
                  </n-icon>
                </div>
                <div>
                  <h4 class="text-xl font-semibold mb-2">Direct Export</h4>
                  <p>Export your chat to PDF, PowerPoint, Word, and more formats.</p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <div class="flex-shrink-0">
                  <n-icon size="36" color="#8B5CF6">
                    <ServerOutline />
                  </n-icon>
                </div>
                <div>
                  <h4 class="text-xl font-semibold mb-2">Advanced AI Models</h4>
                  <p>Access to over 31 company AIs and 101 AI models.</p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <div class="flex-shrink-0">
                  <n-icon size="36" color="#EC4899">
                    <SparklesOutline />
                  </n-icon>
                </div>
                <div>
                  <h4 class="text-xl font-semibold mb-2">Versatile AI Solutions</h4>
                  <p>From text generation to image creation and chatbots.</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- Research Academy Section -->
        <section class="py-16 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg">
          <div class="container mx-auto ">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-indigo-400 to-pink-500">
              Research Academy
            </h3>
            <div class="flex flex-col md:flex-row items-center justify-between">
              <div class="md:w-1/2 mb-8 md:mb-0">
                <h4 class="text-2xl font-semibold mb-4">Advancing AI Technology</h4>
                <p class="mb-4">Join our Research Academy to explore the cutting-edge of AI technology. Collaborate with experts, access advanced resources, and contribute to the future of artificial intelligence.</p>
                <n-button type="primary">Learn More</n-button>
              </div>
              <div class="md:w-1/2">
                <n-card>
                  <template #cover>
                    <div class="h-64 flex items-center justify-center bg-gradient-to-r from-purple-500 to-pink-500">
                      <n-icon size="64" color="#ffffff">
                        <SchoolOutline />
                      </n-icon>
                    </div>
                  </template>
                  <h5 class="text-xl font-semibold mb-2">Research Opportunities</h5>
                  <ul class="list-disc list-inside">
                    <li>Access to state-of-the-art AI models</li>
                    <li>Collaboration with industry experts</li>
                    <li>Publication opportunities</li>
                    <li>Regular workshops and seminars</li>
                  </ul>
                </n-card>
              </div>
            </div>
          </div>
        </section>

        <!-- Mobile App Section -->
        <section class="py-16">
          <div class="container mx-auto ">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 to-orange-500">
              Rand AI on the Go
            </h3>
            <div class="flex flex-col md:flex-row items-center justify-between">
              <div class="md:w-1/2 mb-8 md:mb-0">
                <h4 class="text-2xl font-semibold mb-4">Download Our Mobile App</h4>
                <p class="mb-4">Access Rand AI's powerful features anytime, anywhere with our mobile app. Available for both Android and iOS devices.</p>
                <div class="flex space-x-4">
                  <n-button type="primary">
                    <template #icon>
                      <n-icon><LogoGooglePlaystore /></n-icon>
                    </template>
                    Android
                  </n-button>
                  <n-button type="primary">
                    <template #icon>
                      <n-icon><LogoApple /></n-icon>
                    </template>
                    iOS
                  </n-button>
                </div>
              </div>
              <div class="md:w-1/2">
                <n-card>
                  <template #cover>
                    <div class="h-64 flex items-center justify-center bg-gradient-to-r from-blue-500 to-green-500">
                      <n-icon size="64" color="#ffffff">
                        <PhonePortraitOutline />
                      </n-icon>
                    </div>
                  </template>
                  <h5 class="text-xl font-semibold mb-2">Mobile Features</h5>
                  <ul class="list-disc list-inside">
                    <li>Seamless synchronization with desktop</li>
                    <li>Offline mode for on-the-go productivity</li>
                    <li>Voice commands for hands-free operation</li>
                    <li>Mobile-optimized UI for easy navigation</li>
                  </ul>
                </n-card>
              </div>
            </div>
          </div>
        </section>

        <!-- User Testimonials Section -->
        <section class="py-16 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg">
          <div class="container mx-auto ">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-green-300 to-blue-500">
              What Our Users Say
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
              <n-card v-for="testimonial in testimonials" :key="testimonial.name">
                <template #cover>
                  <div class="h-32 flex items-center justify-center bg-gradient-to-r from-purple-400 to-pink-500">
                    <n-icon size="48" color="#ffffff">
                      <PersonCircleOutline />
                    </n-icon>
                  </div>
                </template>
                <div class="text-center">
                  <h5 class="text-xl font-semibold mb-2">{{ testimonial.name }}</h5>
                  <p class="italic mb-4">"{{ testimonial.comment }}"</p>
                  <div class="flex justify-center">
                    <n-rate :value="testimonial.rating" readonly />
                  </div>
                </div>
              </n-card>
            </div>
          </div>
        </section>

        <!-- Pricing Section -->
        <section class="py-16">
          <div class="container mx-auto ">
            <h3 class="text-3xl font-bold mb-8 text-center text-transparent bg-clip-text bg-gradient-to-r from-pink-400 to-red-500">
              Pricing Plans
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
              <n-card v-for="plan in pricingPlans" :key="plan.name">
                <template #cover>
                  <div class="h-32 flex items-center justify-center bg-gradient-to-r from-blue-400 to-indigo-500">
                    <h4 class="text-2xl font-bold ">{{ plan.name }}</h4>
                  </div>
                </template>
                <div class="text-center">
                  <p class="text-3xl font-bold mb-4">{{ plan.price }}</p>
                  <ul class="text-left mb-6">
                    <li v-for="feature in plan.features" :key="feature" class="mb-2 flex items-center">
                      <n-icon color="#10B981" class="mr-2">
                        <CheckmarkCircleOutline />
                      </n-icon>
                      {{ feature }}
                    </li>
                  </ul>
                  <n-button type="primary" block>Choose Plan</n-button>
                </div>
              </n-card>
            </div>
          </div>
        </section>

        <!-- Call to Action -->
        <section class="py-20 text-center ">
          <h3 class="text-4xl font-bold mb-4 text-transparent bg-clip-text bg-gradient-to-r from-purple-400 via-pink-500 to-red-500">
            Ready to Experience the Future of AI?
          </h3>
          <p class="text-xl mb-8">Join Rand AI today and unlock limitless possibilities!</p>
          <n-button type="primary" size="large">Sign Up Now</n-button>
        </section>
      </n-layout-content>

      <n-layout-footer class="p-4 bg-white bg-opacity-10 backdrop-filter backdrop-blur-lg  text-center">
        © 2023 Rand AI. All rights reserved.
      </n-layout-footer>
    </n-layout>
  </div>

    <!-- <div class="background">
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
            <span></span>
        </div> -->
        <!-- <div
      style="width: 100vw; min-height: 100vh; position: fixed; z-index: -1; display: flex; justify-content: center; padding: 120px 24px 160px 24px; pointer-events: none;">
      <div
        style="background: radial-gradient(circle, rgba(2, 0, 36, 0) 0, #fafafa 100%); position: absolute; content: ''; z-index: 2; width: 100%; height: 100%; top: 0;">
      </div>
    
      <div
        style="z-index: 3; width: 100%; max-width: 640px; background-image: radial-gradient(at 27% 37%, hsla(215, 98%, 61%, 1) 0px, transparent 0%), radial-gradient(at 97% 21%, hsla(125, 98%, 72%, 1) 0px, transparent 50%), radial-gradient(at 52% 99%, hsla(354, 98%, 61%, 1) 0px, transparent 50%), radial-gradient(at 10% 29%, hsla(256, 96%, 67%, 1) 0px, transparent 50%), radial-gradient(at 97% 96%, hsla(38, 60%, 74%, 1) 0px, transparent 50%), radial-gradient(at 33% 50%, hsla(222, 67%, 73%, 1) 0px, transparent 50%), radial-gradient(at 79% 53%, hsla(343, 68%, 79%, 1) 0px, transparent 50%); position: absolute; height: 100%; filter: blur(100px) saturate(150%); top: 80px; opacity: 0.15;">
      </div>
    </div>
    <div style="background: #bb9ce6;background: -webkit-linear-gradient(151deg, #bb9ce6 0%, #ddd4e9 100%);background: linear-gradient(151deg, #bb9ce6 0%, #ddd4e9 100%);"></div> -->
  <!-- <div class="container pb-1 dark:bg-violet-950">
    <div class="sticky top-0 z-50">
     <MainHeader/>
      <Navbar />
    </div>
      <main class="relative flex flex-col gap-4">
       
        <Hero/>
        <Company/>
        <Features/>
        <Carousel/> 
    <News/>
      </main>



    <CustomerReview/>
   
    <Footer/>
  </div> -->

</template>
