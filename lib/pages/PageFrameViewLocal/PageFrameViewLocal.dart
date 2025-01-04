import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PageFrameViewLocal extends StatefulWidget {
  PageFrameViewLocal({Key? key}) : super(key: key);

  @override
  PageFrameViewLocalState createState() => PageFrameViewLocalState();
}

class PageFrameViewLocalState extends State<PageFrameViewLocal> {
  String title = "页面";
  bool isRendered = false;
  String url = "http://dev.yearrow.com";
  final argumentData = Get.arguments;
  InAppWebViewController? webViewController;

  // 下拉刷新
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings =
      PullToRefreshSettings(color: Colors.red);
  bool pullToRefreshEnabled = true;

  @override
  void didUpdateWidget(PageFrameViewLocal oldWidget) {
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
              initialUrlRequest: null,
              initialFile: "assets/html/demo.html",
              onWebViewCreated: customWebViewCreated,
              // 当 WebView 开始加载某个 URL 时触发该事件
              onLoadStart: (controller, url) {
                print("onLoadStart 加载地址：$url");
              },

              // 当 WebView 完成一个 URL 的加载时触发该事件；
              onLoadStop: (controller, url) {},

              onReceivedError: (controller, request, error) {
                print("-----------------------error: $error");
              },
              onProgressChanged: (controller, progress) {},
              onConsoleMessage: (controller, message) {
                print("----------------consoleMessage------------$message");
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

  void customWebViewCreated(controller) async {
    webViewController = controller;
    // await InAppWebViewController.setJavaScriptBridgeName("");

    // 执行JS代码
    /*controller.evaluateJavascript(source: "alert('JS Running')").then((result){
                debugPrint("JS Running: $result");
              });*/

    // 设置 JavaScript 桥接名称
    InAppWebViewController.setJavaScriptBridgeName("FlutterSDK");

    var bridgeName = await InAppWebViewController.getJavaScriptBridgeName();
    print("bridgeName: $bridgeName");

    // 以下是如何注册 JavaScript 处理程序的示例：
    controller.addJavaScriptHandler(
        handlerName: "myHandlerName",
        callback: (JavaScriptHandlerFunctionData data) {
          print("arguments data= $data");

          return {
            "data": "Hello, JS!",
            "status": "success",
          };
        });
  }
}
