<template>
  <div class="myTable">
    <table class="table">
        <thead>
          <tr>
            <th scope="col">Dependent Variable {{this.results["depvar"]}}</th>
          </tr>
          <tr>
            <th scope="col">Selected Covariates</th>
            <th scope="col">coef</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(value, key) in this.results['expvars']" :key="key">
            <td>{{key}}</td>
            <td>{{value["b"]}}</td>
          </tr>
          <tr v-for="(value, key) in this.results['fixedvariables']" :key="key">
            <td>{{key}}</td>
            <td>{{value["b"]}}</td>
          </tr>
        </tbody>
      </table>
  </div>
</template>

<script>
export default {
  props: {
    results: {},
  }
}
</script>

<style>

.myTable{
  margin-bottom: 2rem;
}

</style>

