import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import './HexColor.dart';
import './PageHome.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '演示应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // 统一设置顶部导航颜色
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          elevation: 0,
          backgroundColor: Colors.blue,
        )
      ),
      // home: const MyHomePage(url: 'https://test.yearrow.com'),
      home: PageHome(),
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

class Controller extends GetxController {
  var count = 0.obs;
  void increment() {
    count++;
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
        backgroundColor: HexColor.fromHex('#165dff'),
        title: Text("测试"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

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
