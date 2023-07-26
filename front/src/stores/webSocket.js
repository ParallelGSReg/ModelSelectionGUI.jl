import { defineStore } from 'pinia'



export const useWebSocketStore = defineStore('webSocket',{
    state: () => ({message: null}),
    actions: { 
        setWebSocketMessage(message) {
            this.message = message;
        },
        getPercentageOfJob(){
            let data;
            try {
            data = JSON.parse(this.message)
            } catch (error) {
                data = this.message
            }
            return data
        }
    }
})