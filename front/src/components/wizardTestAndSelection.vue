<template>
  <div class="select variables">
    <h2>{{this.$constants['STEPS'][2].label}}</h2>
    <div id="variables-wrapper" class="boxDiv">
        <div class="first-col">
          <label for="criteriaSelect">Criteria</label>
           <Multiselect class="select" id="criteriaSelect" :multiple="true" v-model="criteriaVariable" :options="criteriaOptions" placeholder="criteria" ></Multiselect>
          <div class="col">
              <div class="check form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="ttestCheck" >
                  <label class="form-check-label" for="ttestCheck"> Include ttest </label>
              </div>
          </div>  
        </div>
        <div class="second-col">
                <div class="check form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="ztestCheck" >
                  <label class="form-check-label" for="ztestCheck"> Include ztest </label>
                </div>
            <div class="col">
                <div class="check form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="residualtestCheck" >
                  <label class="form-check-label" for="residualtestCheck"> Include residual test </label>
                </div>
            </div>
        </div>  
  </div>
  </div>
</template>


<script >

import Multiselect from 'vue-multiselect'
import {useModelSelectionStore} from '../stores/moldelSelection'
import { watch,getCurrentInstance } from 'vue';




export default {
components: { Multiselect },
data(){
  return{
      estimator: 'OLS',
      criteriaVariable: [],
      criteriaOptions: Object.keys(this.$constants['CRITERIA_OLS']),
  }
},
setup(){
  const modelSelectionStore = useModelSelectionStore();
  const instance = getCurrentInstance();
   watch(
      () => modelSelectionStore.job.estimator,
      (newValue) => {
        instance.proxy.setSelectCriteriaOption(newValue)
      }
    );
},
methods:{
    nextButton(){
      const modelSelectionStore = useModelSelectionStore()
      let ttest = document.getElementById("ttestCheck").checked
      let ztest = document.getElementById("ztestCheck").checked
      let residualtest = document.getElementById("residualtestCheck").checked
      let checks = [ttest,ztest,residualtest]
      if (checks.filter(elem => elem ==true).length > 1 ) {
        modelSelectionStore.errors = this.$errors.TTEST_ZTEST_RESIDUALTEST_MUTUALLY_EXCLUSIVE
        return false
      }
      let criteria = []
      if(this.criteriaVariable.length >0){
        this.criteriaVariable.forEach(element => {
          criteria.push(this.$constants["CRITERIA_"+this.estimator][element])
        });
      }
      modelSelectionStore.setTestAndSelectionData(criteria,ttest,ztest,residualtest)
      return true
    },
    setSelectCriteriaOption(estimator){
      const modelSelectionStore = useModelSelectionStore();
      this.estimator = estimator.toUpperCase()
      let criteria = 'CRITERIA_'+ this.estimator
      this.criteriaOptions =  Object.keys(this.$constants[criteria])
    }
    }
  }
</script>


<style src="vue-multiselect/dist/vue-multiselect.css"></style>

<style scoped>

#variables-wrapper{
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 10px;
  grid-auto-rows: minmax(100px, auto);
}


@media screen and (max-width: 450px) {
#variables-wrapper{
     display:initial;
  }
.check{
  margin: 1rem;
}
}

.check{
  margin-top: 1.5rem;
}
.first-col{
  grid-column: 1 / 2;
}
.second-col{
  grid-column: 2/ 2;
}
.col{
  margin-top: 1%;
}
.check{
  padding-top: 2%;
}
</style>