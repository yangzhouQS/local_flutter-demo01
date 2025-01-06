import { createApp } from 'vue'
import './style'
import App from './App.vue'
import NutUI from "@nutui/nutui";
import './sdk/flutter-app.js'
// import "@nutui/nutui/dist/style.css";
createApp(App).use(NutUI).mount("#app");
