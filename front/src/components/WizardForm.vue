<template>
  <FormWizard @on-complete="onComplete" color="#dd9c1d"  ref="formWizard" >
    <div v-for="(step, index) in this.$constants.STEPS" :key="index" class="col step-button-container">
      <TabContent ref="formTab" :title= "step.label" :customIcon= "`<img  src='/icons/step_icons/${step.icon}.ico' />`" :tabindex="index">
        <div id="component-container">
          <component :is="step.component" :ref= step.component ></component>
          <span id="errorsSpan" v-if="this.errors != null">{{this.errors}}</span>
        </div>
        <br>
      </TabContent>
    </div>
    <template v-slot:footer="props">
      <div class="wizard-footer-left">
        <button v-if="props.activeTabIndex > 0 && !props.isLastStep" :style="props.fillButtonStyle" v-on:click="props.prevTab()" class="wizard-button">
          Previous test
        </button>
      </div> 
      <div class="wizard-footer-right">
        <button ref = "formButton" v-if="!props.isLastStep" v-on:click="beforeChangeHandler(props.activeTabIndex)" class="wizard-button" :style="props.fillButtonStyle">
          Next
        </button>
        <button  v-else @click="confirmMethod" class="finish-button" :style="props.fillButtonStyle">
          {{ props.isLastStep ? "Done" : "Next" }}
        </button>
      </div>
    </template>
  </FormWizard>
</template>

<script>

import { FormWizard, TabContent } from "vue3-form-wizard";
import "vue3-form-wizard/dist/style.css";
import WizardUploadFile from './WizardUploadFile.vue'
import WizardSelectVar from './WizardSelectVar.vue'
import WizardTestAndSelection from './wizardTestAndSelection.vue';
import WizardSettings from './WizardSettings.vue';
import WizardResults from './WizardResults.vue';
import WizzardProcessing from './WizzardProcessing.vue';
import {useModelSelectionStore} from '../stores/moldelSelection'
import {useWebSocketStore} from '../stores/webSocket'
import { watch,getCurrentInstance } from 'vue';


export default {
  //component code
 components: {
    FormWizard,
    TabContent,
    WizardUploadFile,
    WizardSelectVar,
    WizardTestAndSelection,
    WizardSettings,
    WizzardProcessing,
    WizardResults
  },
  data(){
    return {
      component: WizardUploadFile,
      errors: null,
      socket: null
    }
  },
  setup(){
    const modelSelectionStore = useModelSelectionStore();
    const instance = getCurrentInstance();
    watch(
          () => modelSelectionStore.errors,
          (newValue) => {
            instance.proxy.errors =  newValue
          }
        );
  },
  created(){
    this.initializeWebSocket();
  },
  methods: {
    initializeWebSocket() {
      const webSocketStore = useWebSocketStore();
      this.socket = new WebSocket(this.$constants["WS"]["host"]);
      this.socket.onopen = () => this.socket.send(JSON.stringify(this.$constants["WS"]["msg"]));
      this.socket.onmessage = (event) => {
        webSocketStore.setWebSocketMessage(event.data) 
      }
    },
    onComplete() {
      alert("Yay. Done!");
    },   
    beforeChangeHandler(index) {
      let componentRef = this.$constants["STEPS"][index].component
      this.$nextTick(() => {
        let formProxy = this.$refs.formWizard
        let form = Object.assign({}, formProxy)
        let componentProxy = this.$refs[componentRef][0]
        let component = Object.assign({}, componentProxy)
        if(component.nextButton()){
          this.errors = null
          form.nextTab()
        }
    })
   }
  },
};
</script>
<style>

.btn{
  width: fit-content;
}

#errorsSpan{
  color:red;
}

h1 {
  font-weight: 500;
  font-size: 2rem;
}

h3 {
  font-size: 1.2rem;
}

h4 {
  font-size: 1rem;
}

</style>
