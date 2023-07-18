import { createApp } from 'vue'
import { createPinia } from 'pinia'

import "bootstrap/dist/css/bootstrap.min.css"
import "bootstrap"
import constants from './constants/index.js'
import errors from './strings/errors.js'
import requestMsg from './strings/requestMsg.js'

import App from './App.vue'
import router from './router'

import './assets/main.css'

const app = createApp(App)


app.config.globalProperties.$constants = constants
app.config.globalProperties.$errors = errors
app.config.globalProperties.$requestMsg = requestMsg
app.use(createPinia())
app.use(router)
app.mount('#app')

