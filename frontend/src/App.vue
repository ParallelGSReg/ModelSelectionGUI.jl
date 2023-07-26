<template>
<div class = "app-container">
  <TheHeader/>
  <div class="wrapper">
      <HomeView/>
  </div>
  <TheFooter/>
</div>
</template>


<script setup>
import { RouterLink, RouterView } from 'vue-router'
import TheFooter from './components/TheFooter.vue'
import TheHeader from './components/TheHeader.vue'
import HomeView from './views/HomeView.vue'


</script>

<style>

.app-container{
  min-height: 100vh;
  position: relative;
  padding-bottom: 5rem;
}



.wrapper{
  align-items: center;
  justify-content: center;
}


</style>
