
<script lang="ts" setup>
import { ref } from 'vue'
import webDesign from '@/assets/web-design.jpg'
import d3 from '@/assets/sphere_3d_shape.png'

const cards = ref([
    {
        id: 1,
        title: 'HomeWork',
        description: 'description description description description description',
        image: webDesign,
    },
    {
        id: 2,
        title: 'Graduation Research',
        description: 'description description description description description.',
        image: webDesign,
    },
    // Add more card objects as needed
]);
</script>
<template>
    <div class="flex flex-col gap-6">

        <div class="flex justify-center px-24 pb-12 gap-8 flex-wrap">
            <div v-for="(card) in cards" :key="card.id" class="flex  w-96  glass shadow-xl">

                <div class="avatar">
                    <div class="w-24 rounded-full">
                        <img :src="card.image" />
                    </div>
                </div>
           
                <div class="card-body">
                    <h2 class="card-title text-2xl">{{ card.title }}</h2>
                    <p>{{ card.description }}</p>
                    <div class="card-actions">
                        <a href="#" class="btn btn-primary w-full">Get Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


