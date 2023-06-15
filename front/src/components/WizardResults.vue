<template>
  <div class="wizard-Variables">
    <h3>Results</h3>
    <p>results of the model</p>
    <button type="button" class="btn btn-dark" @click="checkstatus">Checkstatus</button>
    <button type="button" class="btn btn-dark" @click="downloadallSubsetRegression">All subset regression</button>
     <button type="button" class="btn btn-dark" @click="downloadCrossValidation">Cross validation</button>
    <button type="button" class="btn btn-dark" @click="downloadText">Summary text</button>
  </div>
</template>


<script >

import axios from 'axios'
import {useModelSelectionStore} from '../stores/moldelSelection'

export default {
  
methods:{
    confirmVariables(){
      console.log("entro al confirm")
    },
    checkstatus(){
      const modelSelectionStore = useModelSelectionStore();
      axios.get(this.$constants.API.host + this.$constants.API.paths.status + "/" + 
                modelSelectionStore.uid)
      .then((response) =>{ 
        console.log(response)
      })
    },
    downloadCrossValidation(){
      this.makePetition(this.$constants.API.paths.results_crossvalidation,"crossValidation.csv")
    },
    downloadallSubsetRegression(){
      this.makePetition(this.$constants.API.paths.results_allsubsetregression,"allSubsetRegresion.csv")
    },
    downloadText(){
      this.makePetition(this.$constants.API.paths.results_summary,"summary.txt")
    },
    makePetition(typeResult,filename){
      axios.get(this.$constants.API.host + this.$constants.API.paths.status + "/" +
               modelSelectionStore.uid + typeResult,{
               responseType: 'blob'})
      .then((response) =>{ 
        console.log(response)
        this.makeDonloadFile(response,filename)
      })
    },
    makeDonloadFile(response,filename){
      const href = URL.createObjectURL(response.data);
      const link = document.createElement('a');
      link.href = href;
      link.setAttribute('download', filename); 
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(href);
    }


    }
  }
</script>