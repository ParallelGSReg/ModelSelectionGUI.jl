import { defineStore } from 'pinia'
import { toRaw } from "vue";

const default_job ={
  estimator: null, 
  depvar: null,
  fixedvariables: [], 
  expvars: [],
  intercept: true, 
  method:null,
  //panel: null, // no esta implementado aun nombre de una variable
  time: null, 
  outsample: 0,
  ttest: false,  
  ztest: false,  
  residualtest: false,
  criteria: [], 
  seasonaladjustment: [], 
  removeoutliers: true, 
  fe_sqr: null,     
  fe_log: null,  
  fe_inv: null,
  fe_lag: null, 
  interaction: null, 
  preliminaryselection: null, 
  modelavg: false, 
  orderresults: false, 
  kfoldcrossvalidation: false,
  numfolds: 0  
}


export const useModelSelectionStore = defineStore('moldelSelection',{
  state: () => ({errors: null,datanames : [], filehash : null, uid:null,
  loadingJobResponse: true,
  job: default_job,
  result_job: {},
  }),
  actions: { 
  initialize(data){
    this.job = {...default_job}
    this.filehash = data.filehash
    this.datanames = data.datanames
  },
  setMainSettingsData(estimator,depvar,fixedvariables,expvars,intercept,method,time,outsample){
    this.job.estimator=estimator 
    this.job.depvar= depvar 
    this.job.fixedvariables= fixedvariables 
    this.job.expvars= expvars
    this.job.intercept= intercept
    this.job.method=method 
    this.job.time= time 
    this.job.outsample =outsample 
  },
  setTestAndSelectionData(criteria,ttest,ztest,residualtest){
    this.job.criteria =criteria
    this.job.ttest =ttest
    this.job.ztest =ztest
    this.job.residualtest =residualtest
  },
  setDataCleaningAndFeatureExtrationData(seasonaladjustment,removeoutliers,fe_sqr,fe_log,fe_inv,fe_lag,interaction,
                                          preliminaryselection,modelavg,orderresults,kfoldcrossvalidation,numfolds){
    this.job.seasonaladjustment=seasonaladjustment
    this.job.removeoutliers = removeoutliers
    this.job.fe_sqr = fe_sqr
    this.job.fe_log =fe_log
    this.job.fe_inv =fe_inv
    this.job.fe_lag =fe_lag
    this.job.interaction =interaction
    this.job.preliminaryselection =preliminaryselection
    this.job.modelavg = modelavg
    this.job.orderresults = orderresults
    this.job.kfoldcrossvalidation = kfoldcrossvalidation
    this.job.numfolds = numfolds
  },
  getDatanames(){
    return toRaw(this.datanames)
  },
  getJsonToSend(){
    let jobRequest = {}
    let myJob= toRaw(this.job)
    let equation =  this.job["depvar"] + " "  
    myJob["expvars"].forEach((exp) => equation=equation+ exp + " ")
    jobRequest["equation"] = equation
    for(var key in myJob) {
      if((myJob[key] != default_job[key]) && (key != "expvars") && (key != "depvar") && (!this.checkEmptyArray(myJob[key]))){
        if((key == "outsample") || (key == "numfolds")){
          myJob[key] = +myJob[key]
        }
        jobRequest[key] = myJob[key]
      }
    }
    return JSON.stringify(jobRequest)
  },
  toShow(job){
    let myJob= toRaw(this.job)
    for (let index in job) {
      var internalDict = {}
      for(let key in job[index]){
        let actualValue = !myJob[key] ? "Not set":  myJob[key]
        internalDict[key] = [actualValue,job[index][key]]
      }
      this.result_job[index] = internalDict
    }
  },
  checkEmptyArray(array){
    if(typeof(array) == 'object'){
      return array && array.length ? false : true
    }
    return false
  }
}
})
