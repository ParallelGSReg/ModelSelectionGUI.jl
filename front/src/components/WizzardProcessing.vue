<template>
  <div class="wizard-Variables">
    <h2>Processing Data</h2>
    <h3>{{this.steps[0].label}}</h3>
    <h3>{{this.steps[1].label}}</h3>
    <h3>{{this.steps[2].label}}</h3>
    <h3>{{this.steps[3].label}}</h3>
    <button type="button" class="btn btn-dark" @click="confirmVariables">ConfirmVariables</button>
  </div>
</template>


<script >
import {useModelSelectionStore} from '../stores/moldelSelection'

export default {
  data(){
    return {
      steps : this.$constants['STEPS'],
      modelSelectionStore : useModelSelectionStore(),
      //job: this.modelSelectionStore.toShow(), check how to do this
    }
  },
  methods:{
        nextButton(){
        const modelSelectionStore = useModelSelectionStore();
        modelSelectionStore.setDataCleaningAndFeatureExtrationData(this.seasonaladjustment,removeoutliers,this.feSqr,
                                                                   this.feLog,this.feInv,this.feLag,this.interaction, 
                                                                   this.preliminaryselection,modelavg,orderresults,
                                                                   kfoldcrossvalidation,numfolds)
        return true
    }
      }
    }
</script>


<style scoped>

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