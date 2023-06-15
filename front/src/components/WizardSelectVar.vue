<template>
  <div class="select variables">
    <h2>{{this.$constants['STEPS'][1].label}}</h2>
    <div id="variables-wrapper" class="boxDiv">
        <div class="first-col">
          <label for="estimatorSelect">Estimator </label>
           <Multiselect class="select" id="estimatorSelect" v-model="estimatorVariable" :options="estimatorOptions" placeholder="estimator" ></Multiselect>
          <div class="col">
            <label for="fixedSelect">Fixed Variable </label>
            <Multiselect class="select" id="fixedSelect" v-model="fixedVariables" :multiple="true" :disabled="isDisabledFixed" :options="fixedVariablesOptions" @select="onSelectFixed" placeholder="Fixed Variable" ></Multiselect>
          </div>  
        </div>
        <div class="second-col">
            <label for="independentSelect">Independent Variable </label>
              <Multiselect class="select" id="independentSelect" v-model="dependentVariable" :options="variablesOptions" @select="onSelectIndependent" placeholder="Dependent Variable"></Multiselect>
            <div class="col">
              <label for="dependentSelect">Dependent Variable </label>
              <Multiselect class="select" id="dependentSelect" v-model="explanatoryVariables" :disabled="isDisabledExp" :multiple="true" :options="expVariablesOptions" placeholder="Explanatory Varaiables"></Multiselect>           
            </div>
        </div>  
        <div class="third-col">
              <label for="methodSelect">Methods </label>
                <Multiselect class="select" id="methodSelect" v-model="methodVariable" :options="methodOptions" placeholder="methods"></Multiselect>
              <div class="col">
                <div class="check form-check form-switch">
                  <input class="form-check-input" type="checkbox" id="interceptCheck" checked>
                  <label class="form-check-label" for="interceptCheck"> Include Intercept </label>
                </div>
              </div>
        </div>
          <div class="fourth-col">
                 <label for="timeSelect">Time variable</label>
                <Multiselect class="select" id="timeSelect" v-model="timeVariable" :options="variablesOptions" placeholder="Time variable"></Multiselect>
              <div class="col">
              <div class="form-group">
                <label for="OutOfSampleObservations">Out-of-sample observations</label>
                <input type="text" class="form-control inputText" id="OutOfSampleObservations" value=0>
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
      isDisabledExp: true,
      isDisabledFixed:true,
      estimatorVariable: null,
      dependentVariable: null,
      fixedVariables: [],
      explanatoryVariables: [],
      methodVariable:null,
      timeVariable:null,
      variablesOptions : [],
      fixedVariablesOptions : [],
      expVariablesOptions : [],
      methodOptions: this.$constants['METHODS'],
      estimatorOptions: this.$constants['ESTIMATOR']
  }
},
setup(){
  const modelSelectionStore = useModelSelectionStore();
  const instance = getCurrentInstance();
 watch(
      () => modelSelectionStore.datanames,
      (newValue) => {
        instance.proxy.setSelectOption()
      }
    );
},
methods:{
    onSelectIndependent(option){
        this.fixedVariables = []
        this.explanatoryVariables =[]      
        this.isDisabledFixed = false  
        this.fixedVariablesOptions = this.variablesOptions.filter((item)=> item != option)
    },
    onSelectFixed(option){
        this.explanatoryVariables = []
        this.isDisabledExp = false
        this.expVariablesOptions = this.fixedVariablesOptions.filter((item)=> (!this.fixedVariables.includes(item)) && (item != option))
    },
    nextButton(){
      if((this.dependentVariable == null) || (this.explanatoryVariables.lenght == 0 ) || (this.fixedVariables.lenght == 0)){
        return false
      }else{
        let intercept = document.getElementById("interceptCheck").checked
        let outOfSample= document.getElementById("OutOfSampleObservations").value
        const modelSelectionStore = useModelSelectionStore();
        modelSelectionStore.setMainSettingsData(this.estimatorVariable,this.dependentVariable,
                                            this.fixedVariables,this.explanatoryVariables,intercept,
                                            this.methodVariable,this.timeVariable,outOfSample)
        return true
      }
    },
    setSelectOption(){
      const modelSelectionStore = useModelSelectionStore();
      this.variablesOptions =  modelSelectionStore.getDatanames()
    }
    }
  }
</script>


<style src="vue-multiselect/dist/vue-multiselect.css"></style>

<style scoped>

#variables-wrapper{
  display: grid;
  grid-template-rows: repeat(2, 1fr);
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
.first-col,.third-col{
  grid-column: 1 / 2;
}
.second-col,.fourth-col{
  grid-column: 2/ 2;
}
.col{
  margin-top: 1%;
}
.check{
  padding-top: 2%;
}

</style>