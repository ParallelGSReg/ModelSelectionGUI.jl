<template>
    <div class="multiSelectPairs">
        <div>
        <label :for="this.id+1">{{this.id+1}}</label>
        <Multiselect class="select" :id="this.id+1" v-model="select1" :options="selectOptions1" @select="onSelectOption1" placeholder="Precedent Variable"></Multiselect>      
        </div>
        <div>
        <label :for="this.id+2">{{this.id+2}}</label>
        <Multiselect class="select" :id="this.id+2" v-model="select2" :options="selectOptions2" @select="onSelectOption2" :disabled="isDisabledSelect2" placeholder="Affected Variable"></Multiselect>           
        </div>
         <button type="button" class="btn btn-dark" :disabled="isDisabledButton" @click="addDependency">Add Dependency</button>
        <vue3-tags-input :tags="selectedItems" :allow-duplicates="false" @on-remove="removeItem" />
    </div>  
</template>

<script>
import Multiselect from 'vue-multiselect'
import {useModelSelectionStore} from '../../stores/moldelSelection'
import { watch,getCurrentInstance } from 'vue';
import Vue3TagsInput from 'vue3-tags-input';


export default {
  components: { Multiselect,Vue3TagsInput },
  props: {
      id : String,
      selectedItems: Array
  },
  data(){ 
    return {
    selectOptions1: [],
    selectOptions2:[],
    select1: null,
    select2: null,
    isDisabledSelect2 : true,
    isDisabledButton: true,
    }
  },
  setup(){
  const modelSelectionStore = useModelSelectionStore();
  const instance = getCurrentInstance();
  watch(
        () => modelSelectionStore.job.expvars,
        (newExpVars) => {
          instance.proxy.setSelectedOptions1(newExpVars)
        }
      );
  },
  methods:{
    removeItem(option){
      this.selectedItems.splice(option,option)
    },
    setSelectedOptions1(options){
      this.selectOptions1 = options
    },
    onSelectOption1(option){
      this.isDisabledSelect2 = false 
      this.selectOptions2 = this.selectOptions1.filter((item)=> item != option)
    },
    onSelectOption2(option){
      this.isDisabledButton = false 
    },
    addDependency(){
      this.isDisabledSelect2 =true
      this.isDisabledButton = true
      this.selectedItems.push([this.select1,this.select2])
      this.select1 = null
      this.select2 = null
    },
    removeSelectedItem(event) {
      if (event.target.tagName === 'TEXTAREA') {
        return;
      }
      const clickedItem = event.target.textContent;
      const currentItems = this.textArea.value.split('\n');
      const updatedItems = currentItems.filter((item) => item.trim() !== clickedItem.trim());
      this.textArea.value = updatedItems.join('\n');
    }
  }
}
</script>

<style>
.multiSelectPairs{
  grid-column: span 2;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-gap: 10px;
  grid-auto-rows: minmax(4rem, auto);
}

.inputText{
  height: 2.7rem;
}

@media screen and (max-width: 450px) {
.multiSelectPairs{
     display:unset;
  }
}

button{
  height: fit-content;
  margin-top: auto;
  margin-left: auto;
}
.textArea{
  height: 4rem;
}

.v3ti{
  border: #ffffff !important;
}
</style>

