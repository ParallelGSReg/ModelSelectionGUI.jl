export default {
    'API': {
      'host': 'http://localhost:8000',
      'paths': {
        'server_info': '/server-info',
        'load_database': '/upload-file',
        'run': '/run',
        'status' : '/status',
        'results_summary': '/results/summary',
        'results_allsubsetregression': '/results/allsubsetregression',
        'results_crossvalidation': '/results/crossvalidation'
      }
    },
    'INSAMPLE_MIN_SIZE': 20,
    'STEPS': [
      {
        'label': 'Upload Data',
        'icon': 'database',
        'component': 'WizardUploadFile'
      },
      {
        'label': 'Main Settings',
        'icon': 'select',
        'component': 'WizardSelectVar'
      },
      {
        'label': 'Diagnostic tests and selection criteria',
        'icon': 'tests',
        'component': 'WizardTestAndSelection'
      },
      {
        'label': 'Data cleaning and feature extraction',
        'icon': 'settings',
        'component': 'WizardSettings'
      },
      {
        'label': 'Processing',
        'icon': 'process',
        'component': 'WizzardProcessing'
      },
      {
        'label': 'Results',
        'icon': 'results',
        'component': 'WizardResults'
      }
    ],
    'CRITERIA_OLS': {
      'r2adj': 'Adjusted R²',
      'bic': 'BIC',
      'aic': 'AIC',
      'aicc': 'AIC Corrected',
      'cp': 'Mallows\'s Cp',
      'rmse': 'RMSE',
      'rmseout': 'RMSE OUT',
      'sse': 'SSE'
    },
    'CRITERIA_LOGIT': {
      'bic': 'BIC',
      'aic': 'AIC',
    },
    'METHODS': [
      'fast',
      'precise'
    ],
    //proximamente deberiamos agregar estas opciones y sacar fast y precise
    //"qr_64", "cho_64", "svd_64", "qr_32", "cho_32", "svd_32", "qr_16", "cho_16", "svd_16"
    'PRELIMINARY_SELECTION':[
      'lasso'
    ],
    'ESTIMATOR':[
      'ols',
      'logit'
    ],
    'JOB':{
       1 :{
        'estimator' : 'Estimator:',
        'depvar' :'Dependent variable:',
        'fixedvariables' : 'Fixed variables:',
        'expvars' : 'Explanatory variables:',
        'intercept': 'Include intercept:',
        'method' : 'Calculation Precision:',
        'time' : 'Time variable:',
        'outsample' : 'Out-of-sample observations:'
      },
      2:{
        'ttest' : 'Estimate ttest:',
        'ztest' : 'Estimate ztest:',
        'residualtest' : 'Estimate residualtest:',
        'criteria': 'Ordering criteria:'
      },
      3:{
        'fe_sqr': 'fe_sqr:', 
        'fe_log': 'fe_log:', 
        'fe_inv': 'fe_inv:', 
        'fe_lag': 'fe_lag:', 
        'interaction': 'interaction:',
        'preliminaryselection': 'preliminaryselection:',
        'modelavg': 'Display model averagin results:',
        'orderresults': 'Sort results:',
        'kfoldcrossvalidation': 'kfoldcrossvalidation:',
        'numfolds' : 'numfolds:'
      }
    }
  }
  