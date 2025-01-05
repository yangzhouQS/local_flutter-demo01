import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo02/pages/PageFrameViewLocal/PageSDK.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert' as convert;

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

  PageSDK pageSDK = PageSDK();

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

      // 设置为true以启用 JavaScript。默认值为 true
      javaScriptBridgeEnabled: true,

      // 为允许来源或将其设置为null，意味着它将允许每个来源
      javaScriptBridgeOriginAllowList: {"*"},
    );

    // 设置 JavaScript 桥接名称
    InAppWebViewController.setJavaScriptBridgeName(this.pageSDK.bridgeName);
    return Scaffold(
      appBar: this.pageSDK.pageBar,
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

    /*controller.evaluateJavascript(source: """
         var event = new CustomEvent("demoJavaScriptListener", {detail: {a:1,b:2});
        window.dispatchEvent(event); """);*/

    // 设置 JavaScript 桥接名称
    // InAppWebViewController.setJavaScriptBridgeName("FlutterSDK");

    var bridgeName = await InAppWebViewController.getJavaScriptBridgeName();
    print("bridgeName: $bridgeName");


    /*if(defaultTargetPlatform!=TargetPlatform.android || await WebViewFeature.isFeatureSupported(WebViewFeature.WEB_MESSAGE_LISTENER)){
      print("支持");
      await controller.addWebMessageListener(WebMessageListener(
        jsObjectName: "myObject",
        allowedOriginRules: Set.from(["*"]),
        onPostMessage: (message, sourceOrigin, isMainFrame, replyProxy) {
          replyProxy.postMessage("Got it!" as WebMessage);
        },
      ));
    }*/

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
    controller.addJavaScriptHandler(
        handlerName: "command",

        // 参数类型是个list
        callback: (JavaScriptHandlerFunctionData argument) {
          var params = argument.args;
          // print("arguments params= $params");
          // arguments params= JavaScriptHandlerFunctionData{args: [{callbackId: callback_0, command: getNavigationBarConfig, params: {}}], isMainFrame: true, origin: file:///, requestUrl: file:///android_asset/flutter_assets/assets/html/demo.html}
          // print("arguments params= $params");
          // Map<String,dynamic> param = new Map<String,dynamic>();
          var param = {};
          if (params.length > 0 && params[0] != null) {
            param = params[0];
          }

          // print(param);
          // print(param.runtimeType);

          if (!param.isEmpty) {
            var command = param["command"] ?? "";
            var callbackId = param["callbackId"] ?? '';
            var callbackParams = param["params"] as Map<String, dynamic>;

            print("-----------callbackParams------------");
            print(callbackParams.runtimeType);


            var result;
            try {
              switch (command) {
                case "getNavigationBarConfig":
                  result = this.pageSDK.getNavigationBarConfig();
                  break;
                case "setNavigationBarConfig":
                  result = this.pageSDK.setNavigationBarConfig(callbackParams);
                  break;
                case "setNavigationBarTitle":
                  result = this.pageSDK.setNavigationBarTitle(callbackParams);
                  break;
                case "getBluetoothDevices":
                  this.pageSDK.getBluetoothDevices((_scanResults){
                    result = _scanResults;
                  });
                  break;
                case "closeBluetoothAdapter":
                  result = this.pageSDK.closeBluetoothAdapter();
                  break;
                default:
              }

              print("callbackId = $callbackId");
              controller.evaluateJavascript(
                  source: "window.flutterApp.triggerSuccess('$callbackId',${convert
                      .jsonEncode(result)});");
              print("result = $result");
            } catch (e) {
              print("error = $e");
              controller.evaluateJavascript(
                  source: "window.flutterApp.triggerFail('$callbackId',${convert
                      .jsonEncode(e)});");
            }
          }

          return {
            "data": "Hello, JS!",
            "status": "success",
          };
        }
    );
  }
}
