<template>
  <div class="myTable">
    <table class="table table-bordered align-middle">
        <thead class="table-dark">
          <tr>
            <th colspan="2" scope="col">Dependent Variable {{this.results["depvar"]}}</th>
          </tr>
          <tr>
            <th scope="col">Selected Covariates</th>
            <th scope="col">coef</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(value, key) in this.results['expvars']" :key="key">
            <td>{{key}}</td>
            <td>
              <p class="fw-normal mb-1">{{value["b"]}}</p>
              <p v-if="this.hasTest()" class="text-muted mb-0">({{value["t"]}})</p>
            </td>
          </tr>
          <tr v-for="(value, key) in this.results['fixedvariables']" :key="key">
            <td>{{key}}</td>
            <td>
              <p class="fw-normal mb-1">{{value["b"]}}</p>
              <p v-if="this.hasTest()" class="text-muted mb-0">({{value["t"]}})</p>
            </td>
          </tr>
          <tr>
            <td>nobs</td>
            <td>{{this.results["nobs"]}}</td>
          </tr>
          <tr v-if="this.isAllsubset()">
            <td>F</td>
            <td>{{this.results["F"]}}</td>
          </tr>
          <tr  v-for="key in this.getCriteria(this.results)" :key="key">
            <td>{{key}}</td>
            <td>{{this.results[key]}}</td>
          </tr>
          <tr v-if="!this.isAllsubset()">
            <td>rmseout</td>
            <td>{{this.results["rmseout"]}}</td>
          </tr>


        </tbody>
      </table>
  </div>
</template>

<script>
import {useModelSelectionStore} from '../../stores/moldelSelection' 

export default {
  props: {
    results: {},
  },methods :{
    isAllsubset(){
      return ("F" in this.results)
    },
    getCriteria(results){
      let newCriteria = []
      let criterias = useModelSelectionStore().getCriteria()
      criterias.forEach(function(criteria) {
        if (criteria in results) {
            newCriteria.push(criteria);
        }})
      return newCriteria
    },
    hasCriteria(){
      return useModelSelectionStore().hasCriteria()
    },
    hasTest(){
      return useModelSelectionStore().hasTest()
    }

  }
}
</script>

<style>

.myTable{
  margin-bottom: 2rem;
}

.table{
  border-radius: 1rem !important;
}

</style>

