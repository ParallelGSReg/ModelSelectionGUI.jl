<template>
  <div class="wizard-Variables">
    <h3>Results</h3>
    <p>results of the model</p>
    <button type="button" class="btn btn-dark" @click="confirmVariables">Download Latex</button>
  </div>
</template>


<script >

export default {
methods:{
    confirmVariables(){
      console.log("entro al confirm")
    }
    }
  }
</script>