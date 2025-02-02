import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import '../lib/HexColor.dart';

// import 'package:url_launcher/url_launcher.dart';

void main() async {
  // 初始化flutter绑定，确保在调用任何Flutter API之前完成。
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  // 初始化下载器
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  // 相机权限申请
  await Permission.camera.request();

  // 麦克风权限申请
  await Permission.microphone.request();

  // 存储文件的权限申请
  await Permission.storage.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '演示应用',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff165dff)),
        // colorScheme: ColorScheme.fromSeed(seedColor: HexColor.fromHex('#165dff')),
        // useMaterial3: false,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          // iconTheme: theme.iconTheme,
          // brightness: Brightness.light,
          // backgroundColor: HexColor.fromHex('#165dff'),
          // surfaceTintColor: Colors.white,
        )
      ),
      home: const MyHomePage(url: 'https://test.yearrow.com'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class JSBridge {
  final InAppWebViewController controller;
  final MethodChannel channel;

  JSBridge(this.controller, this.channel) {
    channel.setMethodCallHandler((call) async {
      // 处理从H5发起的调用
      if (call.method == 'executeFlutterCommand') {
        // 执行Flutter命令
        // ...
      }
    });
  }

  void sendToFlutter(String message) {
    channel.invokeMethod('fromWebView', {'message': message});
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  InAppWebViewController? controller;
  final GlobalKey webViewKey = GlobalKey();
  final uri = Uri.parse('https://example.com/api/fetch?limit=10,20,30&max=100');
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    // iframeAllow: "",
    iframeAllowFullscreen: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );

  PullToRefreshController? pullToRefreshController;
  String currentUrl = "";
  double progress = 0.0;
  final urlController = TextEditingController();
  JSBridge? jsBridge;

  initState() {
    super.initState();
    // 隐藏顶部和底部状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void dispose() {
    // 恢复顶部和底部状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  set url(String url) {
    currentUrl = url;
  }

  String get url {
    return currentUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("测试"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialSettings: settings,
              initialUrlRequest: URLRequest(url: WebUri("http://dev.yearrow.com")),
              // initialFile: "assets/demo.html",
              onWebViewCreated: (ctr) {
                setState(() {
                  controller = ctr;
                  jsBridge = JSBridge(
                      ctr,
                      MethodChannel('your.channel.name')
                  );
                });
              },
              onLoadStart: (controller, url) {
                print("onLoadStart 加载地址：$url");
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                print("加载地址：$url");
                pullToRefreshController?.endRefreshing();

                // 发送消息到H5 销毁WebView时，发送消息到H5
                jsBridge?.sendToFlutter("WebView loaded");
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                if (kDebugMode || true) {
                  print(
                      "----------------------------consoleMessage---------------------");
                  print(consoleMessage);
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
