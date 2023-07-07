import { defineStore } from 'pinia'



export const useWebSocketStore = defineStore('webSocket',{
    state: () => ({message: null}),
    actions: { 
        setWebSocketMessage(message) {
            this.message = message;
        },
        getPercentageOfJob(){
            return JSON.parse(this.message)["data"]
        }
    }
})