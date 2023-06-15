<template>
  <div class="wizard-Variables boxDiv" >
    <h2>Processing Data</h2>
    <div v-for="(job, jobId) in modelSelectionStore.result_job" :key="jobId">
      <h3>{{steps[jobId].label}}</h3>
      <div class="contentListResult">
      <ul v-for="(value, key) in job" :key="key">
        <li><b>{{value[1]}}</b> {{value[0]}}</li>
      </ul>
      </div>
    </div>
    <button type="button" class="btn btn-dark" @click="confirmVariables">ConfirmVariables</button>
  </div>
</template>


<script setup>
import {useModelSelectionStore} from '../stores/moldelSelection'
import { ref } from 'vue'; 
import constants from '../constants/index.js'
import axios from 'axios'

const modelSelectionStore = useModelSelectionStore();

const steps= ref(constants.STEPS);

function nextButton (){
  let data = modelSelectionStore.getJsonToSend()
  console.log(data)
  axios.post(constants.API.host + constants.API.paths.run + "/" + modelSelectionStore.filehash,
  data, {headers: {"Content-Type": "application/json"}})
  .then((response)=>{
    modelSelectionStore.uid = response.data.id
    console.log(response)
})
  return true;
}

defineExpose({nextButton})

</script>




<style >

.contentListResult{
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-gap: 0px;
    grid-auto-rows: minmax(1rem, auto);
    padding-bottom: 20px;
}

.btn{
  width: fit-content;
}

h1 {
  font-weight: 500;
  font-size: 2rem;
}

h3 {
  font-size: 1.2rem;
}

</style>