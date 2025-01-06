import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PageFrameView extends StatefulWidget {
  PageFrameView({Key? key}) : super(key: key);

  @override
  _PageFrameViewState createState() => _PageFrameViewState();
}

class _PageFrameViewState extends State<PageFrameView> {
  String title = "页面";
  bool isRendered = false;
  String url = "http://dev.yearrow.com";
  final argumentData = Get.arguments;
  InAppWebViewController? webViewController;

  @override
  void didUpdateWidget(PageFrameView oldWidget) {
    super.didUpdateWidget(oldWidget);
    isRendered = false;
    url = '';
    if (argumentData && argumentData["url"]) {
      url = argumentData["url"];
      isRendered = true;
    } else {
      url = "";
      isRendered = false;
      TDToast.showIconText('打开url参数不存在',
          icon: TDIcons.check_circle,
          direction: IconTextDirection.vertical,
          context: context);
    }
    print("-------------url = $url");
  }

  // 创建
  @override
  void initState() {
    print("-------------initState-------------------");
    super.initState();
    print("参数：name===================");
    print(argumentData);
    print("url=================== $url");

    this.url = argumentData["url"] ?? "";
    this.isRendered = true;
    print("参数：url=================== $url");

    /*if (argumentData && argumentData["url"]) {
      this.url = argumentData["url"];
      this.isRendered = true;
    } else {
      TDToast.showIconText('打开url参数不存在',
          icon: TDIcons.check_circle,
          direction: IconTextDirection.vertical,
          context: context);
    }*/
  }

  // 销毁
  @override
  void dispose() {
    super.dispose();
    print("-------------dispose-------------------");
    super.dispose();
    url = "";
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey webViewKey = GlobalKey();
    InAppWebViewSettings settings = InAppWebViewSettings(
      // 设置true为允许水平滑动手势触发前后列表导航。默认值为true
      allowsBackForwardNavigationGestures: true,
      // 设置为true以防止 HTML5 音频或视频自动播放。默认值为true
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialSettings: settings,
              initialUrlRequest: URLRequest(url: WebUri(this.url)),
              // initialUserScripts: UnmodifiableListView(),
              onWebViewCreated: (controller)  {
                webViewController = controller;

                // 执行JS代码
                /*controller.evaluateJavascript(source: "alert('JS Running')").then((result){
                  debugPrint("JS Running: $result");
                });*/
                

                // 以下是如何注册 JavaScript 处理程序的示例：
                controller.addJavaScriptHandler(handlerName: "myHandlerName", callback: (arguments){
                  print("arguments = $arguments");

                  return {
                    "data": "Hello, JS!",
                    "status": "success",
                  };
                });
              },
              onLoadStart: (controller, url) {
                print("onLoadStart 加载地址：$url");
              },
              onReceivedError: (controller, request, error) {
                print("-----------------------error: $error");
              },
              onProgressChanged: (controller, progress) {},
              onConsoleMessage: (controller, message) {
                print("----------------consoleMessage------------$message");
              },
              onLoadStop: (controller, url) {
                
              },
              onTitleChanged: (controller, title) {
                print("onTitleChanged: $title");
                this.title = title ?? '页面';
              },
            ),
          )
        ]),
      ),
    );
  }
}
