import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import './pages/PageLogin/PageLogin.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import './HexColor.dart';
import './PageHome.dart';
import 'pages/PageLayout/PageFlex.dart';

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
    return GetMaterialApp(
      title: '演示应用',
      theme: ThemeData(
        extensions: [TDThemeData.defaultData()],
        colorScheme: ColorScheme.light(primary: TDThemeData.defaultData().brandNormalColor),
        primarySwatch: Colors.blue,
        // 统一设置顶部导航颜色
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
      ),
      // home: const MyHomePage(url: 'https://test.yearrow.com'),
      home: PageHome(),
      // initialRoute: "/home",

      // 隐藏debug 图标
      debugShowCheckedModeBanner: false,
      // 设置页面切换动画效果
      defaultTransition: Transition.rightToLeftWithFade,
      getPages: [
        GetPage(name: "/", page: () => PageHome()),
        GetPage(name: "/home", page: () => PageHome()),
        GetPage(name: "/login", page: () => PageLogin()),
        // GetPage(name: "/PageFlex", page: () => PageFlex()),
      ],
    );
  }
}

