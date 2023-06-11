
import { defineStore } from 'pinia'
import { toRaw } from "vue";
const default_job ={
  estimator: 'ols', 
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
  criteria: null, 
  seasonaladjustment: [], 
  removeoutliers: false, 
  fe_sqr: [],     
  fe_log: [],  
  fe_inv: [],
  fe_lag: [], 
  interaction: [], 
  preliminaryselection: null, 
  modelavg: false, 
  orderresults: false, 
  kfoldcrossvalidation: false,
  numfolds: 0  
}


export const useModelSelectionStore = defineStore('moldelSelection',{
  state: () => ({datanames : [], filehash : null,
  job:null,
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
    for(var key in this.job) {
      if(!this.job[key]) {
          delete this.job[key];
      }
    }
    return JSON.stringify(this.job)
  },
  toshow(){
    const job =this.$constants['job']
    let jobWithDescription = {}
    //TODO: iterate for constant job generatin new Dict with structure:
    // {step1 :{jobVar: (description,value),jobVar: (description,value)...},step2:{jobVar: (description,value),jobVar: (description,value)...}...}
  }
}
})
