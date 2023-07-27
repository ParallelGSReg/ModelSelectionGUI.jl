export default {
    'API': {
      'host': 'http://localhost:8000',
      'paths': {
        'server_info': '/server-info',
        'load_database': '/upload-file',
        'run': '/job-enqueue/',
        'status' : '/jobs',
        'results_summary': '/results/summary',
        'results_allsubsetregression': '/results/allsubsetregression',
        'results_crossvalidation': '/results/crossvalidation'
                                             
      }
    },
    'WS':{
      'host': 'ws://127.0.0.1:8000',
      'msg' : {
        'channel': 'sync',
        'message': 'subscribe',
        'payload': {}
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
      'Adjusted R²' : 'r2adj',
      'BIC' : 'bic',
      'AIC' : 'aic',
      'AIC Corrected' : 'aicc',
      'Mallows\'s Cp' : 'cp',
      'RMSE' : 'rmse',
      'RMSE OUT' : 'rmseout',
      'SSE' : 'sse'
    },
    'CRITERIA_LOGIT': {
      'BIC' : 'bic',
      'AIC' : 'aic',
    },
    'METHODS': [
      'qr_64',
      'cho_64',
      "svd_64",
      "qr_32",
      "cho_32",
      "svd_32",
      "qr_16",
      "cho_16",
      "svd_16"
    ],
    'METHODS_LOGIT': [
      'cho_64',
      'cho_32',
      'cho_16',
    ],
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
  