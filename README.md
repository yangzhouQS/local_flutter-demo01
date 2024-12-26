# flutter_demo02

A new Flutter project.


## Getting Started

Flutter与WebView通信方案示例详解
https://www.jb51.net/article/271650.htm



## 无法加载http地址添加配置
``` 
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="flutter_demo02"
        android:name="${applicationName}"
        + android:usesCleartextTraffic="true"
        android:icon="@mipmap/ic_launcher">
.......
</manifest>

```

### https加载问题排查
https://www.jianshu.com/p/5f062c8728f5



