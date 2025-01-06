<script setup lang="ts">
import {ref} from 'vue'
import {CmpUi} from "./components/cmp-ui";
import {CmpPlatformInfo} from "./components/cmp-platform-info";

const value = ref('ui')
</script>

<template>
  <div class="main-page">
    <nut-tabs v-model="value">
      <nut-tab-pane title="UI" pane-key="ui">
        <CmpUi/>
      </nut-tab-pane>
      <nut-tab-pane title="获取设备信息" pane-key="CmpPlatformInfo">
        <CmpPlatformInfo/>
      </nut-tab-pane>
      <nut-tab-pane title="蓝牙" pane-key="2"> Content 2</nut-tab-pane>
      <nut-tab-pane title="媒体文件" pane-key="3"> Content 3</nut-tab-pane>
    </nut-tabs>
  </div>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}

.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}

.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
