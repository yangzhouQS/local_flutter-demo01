import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_demo02/pages/PageFrameViewLocal/PageSDK.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert' as convert;
import 'package:get/get.dart';
import '../../HexColor.dart';

class PageFrameViewLocal extends StatefulWidget {
  PageFrameViewLocal({Key? key}) : super(key: key);

  @override
  PageFrameViewLocalState createState() => PageFrameViewLocalState();
}

class PageFrameViewLocalState extends State<PageFrameViewLocal> {
  String barTitle = "";
  bool isRendered = false;
  String url = "";

  // 导航栏背景色
  Color backgroundColor = HexColor.fromHex("#ffffff");
  // 设置AppBar的前景颜色，例如标题、图标等
  Color foregroundColor = Colors.white;
  final argumentData = Get.arguments;
  InAppWebViewController? webViewController;

  // 创建一个StreamController来控制标题的更新
  final StreamController<String> _titleStreamController =
      StreamController<String>();

  TextStyle titleTextStyle = TextStyle(color: Colors.white);

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
    super.initState();
    print(argumentData);

    this.url = argumentData["url"] ?? "";
    this.isRendered = true;

    this.pageSDK.test();
  }

  // 销毁
  @override
  void dispose() {
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
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        // 使用StreamBuilder来构建AppBar的标题
        title: StreamBuilder<String>(
          stream: _titleStreamController.stream,
          initialData: url, // 初始标题
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            print("snapshot.data: ${snapshot.data} url: $url");
            // 当有新的数据时，更新标题
            return Text(
                snapshot.data ?? url,
                style: titleTextStyle // TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialSettings: settings,
              initialUrlRequest: null,
              initialFile: this.url,
              // "assets/html/demo.html",
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
        callback: (JavaScriptHandlerFunctionData argument) async {
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
                  result = {
                    "title": barTitle,
                    //this.pageBar.title,
                    "backgroundColor": backgroundColor.toHex8(),
                    "foregroundColor": foregroundColor.toHex8(),
                    "toolbarOpacity": 0.1,
                  };
                  break;
                case "setNavigationBarConfig":
                  // 设置标题
                  if (callbackParams["title"] != null) {
                    barTitle = callbackParams["title"];
                    _titleStreamController.add(callbackParams["title"]);
                  }

                  var newColor = HexColor.fromHex(callbackParams["backgroundColor"] ?? "#FFFFFF");
                  Color _foregroundColor = Colors.white;
                  if(callbackParams["foregroundColor"]=='white'){
                      _foregroundColor = Colors.white;
                  }else if(callbackParams["foregroundColor"]=='black'){
                    _foregroundColor = Colors.black;
                  }

                  setState(() {
                    backgroundColor = newColor;
                    foregroundColor = _foregroundColor;
                  });

                  result = true;
                  break;
                case "setNavigationBarTitle":
                  _titleStreamController.add(callbackParams["title"]);
                  barTitle = callbackParams["title"];
                  result = true;
                  break;
                case "getBluetoothDevices":
                  this.pageSDK.getBluetoothDevices((_scanResults) {
                    result = _scanResults;
                  });
                  break;
                case "closeBluetoothAdapter":
                  result = this.pageSDK.closeBluetoothAdapter();
                  break;
                case "getSystemInfo":
                  result = await this.pageSDK.getSystemInfo();

                  break;
                case "chooseImage":
                  // result = await this.pageSDK.chooseImage(callbackParams);

                  // List<AssetEntity>? result = await AssetPicker.pickAssets(context);
                  print("entity = --------------");

                  break;

                // ----------------- UI -----------------
                case "showToast":
                  var text = callbackParams["text"] ?? "提示";
                  TDToast.showText(text, context: context);
                  result = true;
                  break;
                case "showModal":
                  var type = callbackParams["type"] ?? "confirm";
                  var title = callbackParams["title"] ?? "标题";
                  var content = callbackParams["content"] ?? "";

                  var confirmText = callbackParams["confirmText"] ?? "确定";
                  var cancelText = callbackParams["cancelText"] ?? "取消";

                  if (type == "confirm") {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (BuildContext buildContext,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return TDConfirmDialog(
                          title: title,
                          content: content,
                          contentMaxHeight: 300,
                          buttonText: confirmText,
                        );
                      },
                    );
                  } else if (type == "alert") {
                    showGeneralDialog(
                      context: context,
                      pageBuilder: (BuildContext buildContext,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return TDAlertDialog(
                            title: title,
                            content: content,
                            leftBtn: TDDialogButtonOptions(
                                title: cancelText,
                                action: () {
                                  print('leftBtn click');
                                  Navigator.pop(context);
                                }),
                            rightBtn: TDDialogButtonOptions(
                                title: confirmText,
                                action: () {
                                  print('rightBtn click');
                                  Navigator.pop(context);
                                }));
                      },
                    );
                  }

                  result = true;
                  break;
                default:
              }

              print("callbackId = $callbackId");
              controller.evaluateJavascript(
                  source:
                      "window.flutterApp.triggerSuccess('$callbackId',${convert.jsonEncode(result)});");
              print("result = $result");
            } catch (e) {
              print("error = $e");
              controller.evaluateJavascript(
                  source:
                      "window.flutterApp.triggerFail('$callbackId',${convert.jsonEncode(e)});");
            }
          }

          return {
            "data": "Hello, JS!",
            "status": "success",
          };
        });
  }
}
