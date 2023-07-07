<template>
  <div class="content-form-upload">
    <h2>{{this.$constants['STEPS'][3].label}}</h2>
    <div class="variables-wrapper">
      <h3> data cleaning </h3>
      <div id="dataCleaning" class="boxDiv">
        <div class="col">
            <label for="seasonalAdjustmentSelect">seasonal Adjustment</label>
            <Multiselect class="select" id= "seasonalAdjustmentSelect" v-model="seasonaladjustment" :multiple="true" :options="expVars" placeholder="select Seasonal Adjustment"></Multiselect>
        </div>
        <div class="col">
            <div class="check form-check form-switch rigthCheck">
              <input class="form-check-input" type="checkbox" id="removeoutliersCheck" checked>
              <label class="form-check-label" for="removeoutliersCheck"> Remove Outliers </label>
          </div>
        </div>   
      </div>
    <br>
    <h3> feature straction</h3>
    <div id= "featureStraction" class="boxDiv"> 
          <div class="first-col">
                <label for="feSqrSelect">fe_sqr</label>
                <Multiselect class="select" id= "feSqrSelect" v-model="feSqr" :options="expVars" placeholder="Select feSqr"></Multiselect>
              <div class="col">
                <label for="feLogSelect">fe_log</label>
                <Multiselect class="select" id= "feLogSelect" v-model="feLog" :options="expVars" placeholder="Select feLog"></Multiselect>
              </div>  
          </div>
            <div class="second-col">
                <label for="fe_invSelect">fe_inv</label>
                <Multiselect class="select" id= "fe_invSelect" v-model="feInv" :options="expVars" placeholder="Select fe_inv"></Multiselect>
               <div class="col">
                <label for="fe_lagSelect">fe_lag</label>
                <Multiselect class="select" id= "fe_lagSelect" v-model="feLag" :options="expVars" placeholder="Select  fe_lag"></Multiselect>
              </div>  
            </div> 
              <div class="third-col">
                <label for="interactionSelect">interaction</label>
                <Multiselect class="select" id= "interactionSelect" v-model="interaction" :options="expVars" placeholder="Select interaction"></Multiselect>
            </div> 
        </div>
        <br>
        <h3> Preliminary selection and Post selection settings</h3>
        <div id= "PrePostSelectionSettings" class="boxDiv"> 
          <div class="first-col">
                <label for="preliminaryselectionSelect">Preliminary selection</label>
                <Multiselect class="select" id= "preliminaryselectionSelect" v-model="preliminaryselection" :options="preliminaryselectionOption" placeholder="Select preliminaryselection"></Multiselect>
              <div class="col">
               <div class="check form-check form-switch leftCheck">
                <input class="form-check-input" type="checkbox" id="modelavgCheck">
                <label class="form-check-label" for="modelavgCheck"> Model avg </label>
            </div>
               </div>  
          </div>
            <div class="second-col">
               <div class="check form-check form-switch rigthCheck">
                <input class="form-check-input" type="checkbox" id="orderresultsCheck" >
                <label class="form-check-label" for="orderresultsCheck"> Order results </label>
            </div>
               <div class="col">
               <div class="check form-check form-switch rigthCheck">
                  <input class="form-check-input" type="checkbox" id="kfoldcrossvalidationCheck" @change="kfoldcrossvalidationCheckSelected()">
                  <label class="form-check-label" for="kfoldcrossvalidationCheck" > Kfoldcross validation </label>
                </div>
               </div>  
            </div> 
              <div class="third-col">
               <div class="form-group">
                <label for="numfolds">numfolds for kfoldcrossvalidation</label>
                <input type="text" class="form-control inputText" id="numfolds" value=0 disabled="disabled">
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
      feSqr: null,
      feLog: null,
      feInv: null,
      feLag: null,
      interaction: null,
      preliminaryselection:null,
      seasonaladjustment: [],
      expVars : [],
      preliminaryselectionOption: this.$constants['PRELIMINARY_SELECTION'],
    }
  },
  setup(){
  const modelSelectionStore = useModelSelectionStore();
  const instance = getCurrentInstance();
  watch(
        () => modelSelectionStore.job.expvars,
        (newExpVars) => {
          console.log("newExpVars")
          instance.proxy.setExpVarsOptionsnewExpVars(newExpVars)
        }
      );
  },
  methods:{
    setExpVarsOptionsnewExpVars(newExpVars){
      this.expVars =  newExpVars
    },
    nextButton(){
        const modelSelectionStore = useModelSelectionStore();
        if((this.seasonaladjustment.length > 0) && (modelSelectionStore.job.time == null)){
          modelSelectionStore.errors = this.$errors.TIME_VARIABLE_REQUIRED_FOR_SEASONALADJUSTMENT
          return false
        }
        let removeoutliers = document.getElementById("removeoutliersCheck").checked
        let modelavg = document.getElementById("modelavgCheck").checked
        let orderresults = document.getElementById("orderresultsCheck").checked
        let kfoldcrossvalidation = document.getElementById("kfoldcrossvalidationCheck").checked
        let numfolds = document.getElementById("numfolds").value
        modelSelectionStore.setDataCleaningAndFeatureExtrationData(this.seasonaladjustment,removeoutliers,this.feSqr,
                                                                   this.feLog,this.feInv,this.feLag,this.interaction, 
                                                                   this.preliminaryselection,modelavg,orderresults,
                                                                   kfoldcrossvalidation,numfolds)
        modelSelectionStore.toShow(this.$constants['JOB'])
        return true
    },
    kfoldcrossvalidationCheckSelected(){
      let kfoldcrossvalidation = document.getElementById("kfoldcrossvalidationCheck").checked
      let numfolds = document.getElementById("numfolds")
      if(kfoldcrossvalidation){
        numfolds.disabled = false
      }else{
        numfolds.disabled = true
        numfolds.value = '0'
      }
    }
  }
}
</script>

<style scoped>
#dataCleaning,#featureStraction,#PrePostSelectionSettings{
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 10px;
  grid-auto-rows: minmax(100px, auto);
}

.inputText{
  height: 2.7rem;
}

@media screen and (max-width: 450px) {
#dataCleaning,#featureStraction,#PrePostSelectionSettings{
     display:unset;
  }
.rigthCheck{
  padding-top: 1rem; 
}
}

.first-col{
  grid-column: 1 / 2;
  grid-row: 1;
}
.second-col{
  grid-column: 2/ 2;
  grid-row: 1;
}
.col{
  margin-top: 1%;
}
.rigthCheck{
  padding-top: 2rem; 
}
.leftCheck{
  padding-top: 1rem;
}

h3{
  font-weight: bold;
}

</style>