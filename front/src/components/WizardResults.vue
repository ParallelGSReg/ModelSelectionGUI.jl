<template>
  <div class="wizard-Variables">
    <div v-if='loadingJobResponse' class="loadingJob">
      <div class="modal-body" id="modal">
        <div class="spinner-border mySpinner" role="status"></div>
          <br>
        <span class="sr-only">Model Selection Job is until Running...</span>
      </div>
    </div>

    <div v-else>
      <h2>Results</h2>
      <div id="allsubsterRegressionSection">
        <h3>All subset regression</h3>
        <BaseTableCovar :results="this.results['allsubsetregression']"></BaseTableCovar>
      </div> 
      <div id="kfoldCrossValidationSection" v-if="isSetKcrossValidation">
        <h3>Cross validation</h3>
        <h4>Average</h4>
        <BaseTableCovar :results="this.results['crossvalidation']['average']"></BaseTableCovar>
        <h4>Median</h4>
        <BaseTableCovar :results="this.results['crossvalidation']['median']"></BaseTableCovar>
      </div> 
      <br>
      <button type="button" class="btn btn-dark" @click="downloadallSubsetRegression">All subset regression</button>
      <button type="button" class="btn btn-dark" @click="downloadText">Summary text</button>
      <button v-if='isSetKcrossValidation' type="button" class="btn btn-dark" @click="downloadCrossValidation">Cross validation</button>
    
    </div>
  
  </div>
</template>


<script >

import axios from 'axios'
import {useModelSelectionStore} from '../stores/moldelSelection'
import {useWebSocketStore} from '../stores/webSocket'
import { watch,getCurrentInstance } from 'vue';
import BaseTableCovar from './BaseComponent/BaseTableCovar.vue';




export default {
  components:{
    BaseTableCovar
  },
  data(){
    return{
      results : {}
    }
  },
  setup(){
  const webSocketStore = useWebSocketStore();
  const instance = getCurrentInstance();
  watch(
      () => webSocketStore.message,
      (newMessage) => {
        console.log(webSocketStore.getPercentageOfJob())
        if(webSocketStore.getPercentageOfJob()["progress"] == 100){
          instance.proxy.checkstatus()
        }
      }
    );
  },
 computed: {
    loadingJobResponse(){
        return useModelSelectionStore().loadingJobResponse
      },
    isSetKcrossValidation(){
      return useModelSelectionStore().job["kfoldcrossvalidation"]
    }
  },
  methods:{
    checkstatus(){
      const modelSelectionStore = useModelSelectionStore();
      axios.get(this.$constants.API.host + this.$constants.API.paths.status + "/" + 
                modelSelectionStore.uid)
      .then((response) =>{ 
        this.results = response["data"]["results"]
        console.log(response)
        modelSelectionStore.loadingJobResponse = false
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
      const modelSelectionStore = useModelSelectionStore();
      axios.get(this.$constants.API.host + this.$constants.API.paths.status + "/" +
               modelSelectionStore.uid + typeResult,{
               responseType: 'blob'})
      .then((response) =>{ 
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
<style>

.loadingJob{
  text-align: center;

}
.mySpinner{
  width: 10rem; 
  height: 10rem;
  padding: 1rem;
}

h2{
  margin-bottom: 2rem;
}

</style>
