<template>
  <div class="content-form-upload">
    <h3>Drop files to upload</h3>
    <h2>Load your database</h2>
    <p>You should select a Comma-separated values (CSV) file, where the first row is expected to contain the
      variable names (column headers). In this version, variables with string values will not be available for
      calculation.</p>
    <div class="mb-3">
      <label for="formFile" class="form-label">Default file input example</label>
      <input class="form-control" type="file" id="formFile">
    </div>
  </div>
</template>


<script >

import axios from 'axios'
import {useModelSelectionStore} from '../stores/moldelSelection'

export default {

methods:{
    nextButton(){
      const modelSelectionStore = useModelSelectionStore();
      let inputFile = document.getElementById("formFile")
      let file= inputFile.files[0]
      if(file == undefined){
        modelSelectionStore.errors = this.$errors.REQUIRED_UPLOAD_FILE
        return false
      }else{
        this.sendData(file)
        return true
      }
    },
    sendData(file){
      let formData = new FormData();
      formData.append("data",file);
      axios.post(this.$constants.API.host + this.$constants.API.paths.load_database , formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
      }).then((response)=>{
        const modelSelectionStore = useModelSelectionStore();
        modelSelectionStore.initialize(response.data)
     })

    }

    }
  }
</script>

<style scoped>


</style>
