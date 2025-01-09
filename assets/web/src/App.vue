<script setup lang="ts">
import {ref} from 'vue'
import {CmpUi} from "./components/cmp-ui";
import {CmpPlatformInfo} from "./components/cmp-platform-info";
import {CmpShare} from "./components/cmp-share";
import {CmpObserver} from "./components/cmp-observer";
import {CmpNavigation} from "./components/cmp-navigation";
import {CmpMedia} from "./components/cmp-media";
import {CmpScannerCode} from "./components/cmp-scanner-code";

const value = ref('ui')
</script>

<template>
  <div class="main-page">
    <nut-tabs v-model="value" title-scroll title-gutter="10">
      <nut-tab-pane title="UI" pane-key="ui">
        <CmpUi/>
      </nut-tab-pane>
      <nut-tab-pane title="获取设备信息" pane-key="CmpPlatformInfo">
        <CmpPlatformInfo/>
      </nut-tab-pane>
      <nut-tab-pane title="蓝牙" pane-key="2"> Content 2</nut-tab-pane>
      <nut-tab-pane title="媒体文件" pane-key="media"><CmpMedia/></nut-tab-pane>
      <nut-tab-pane title="分享" pane-key="share">
        <CmpShare/>
      </nut-tab-pane>
      <nut-tab-pane title="监听" pane-key="observer">
        <CmpObserver/>
      </nut-tab-pane>
      <nut-tab-pane title="导航" pane-key="navigation">
        <CmpNavigation/>
      </nut-tab-pane>
      <nut-tab-pane title="二维码" pane-key="scannerCode">
        <CmpScannerCode/>
      </nut-tab-pane>
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
