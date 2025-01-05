import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import './PageHome.dart';
import 'PageRoutes.dart';
import './pages/PageNotFound/PageNotFound.dart';

final InAppLocalhostServer localhostServer = new InAppLocalhostServer(documentRoot: "assets");

void main() async {
  // 初始化flutter绑定，确保在调用任何Flutter API之前完成。
  WidgetsFlutterBinding.ensureInitialized();

  // start the localhost server
  if (!kIsWeb) {
    await localhostServer.start();
  }

  if(Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

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


    [Permission.bluetoothScan, Permission.bluetoothConnect, Permission.bluetooth].request().then((status) {
      print(status);
      //只会有一个弹窗，android端多个权限，但一般一般显示了一个就结束了，主要看ios的
      //android端注意定位权限, Permission.locationWhenInUse 即可
      if (status[Permission.bluetooth] != PermissionStatus.granted) {
        print("没有蓝牙权限"); //这一个是都有的，可以用这个判断，当然最好分平台判断
        TDToast.showText('没有蓝牙权限', context: context);
      }else{
        TDToast.showIconText('蓝牙权限已开启',
            icon: TDIcons.check_circle, context: context);
      }
    });

    return GetMaterialApp(
      title: '演示应用',
      theme: ThemeData(
        extensions: [TDThemeData.defaultData()],
        colorScheme: ColorScheme.light(primary: TDThemeData.defaultData().brandNormalColor),
        primarySwatch: Colors.blue,
        // 统一设置顶部导航颜色
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, ),
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
      ),
      // home: const MyHomePage(url: 'https://test.yearrow.com'),
      home: PageHome(),

      // 设置初始路由
      initialRoute: "/home",

      // 隐藏debug 图标
      debugShowCheckedModeBanner: false,
      // 设置页面切换动画效果
      defaultTransition: Transition.rightToLeftWithFade,
      // 设置找不到路由时的页面
      unknownRoute: GetPage(name: "/404", page: () => PageNotFound()),

      /*routingCallback: (value) => {
        print("routingCallback: ${value}")
      },*/

      // 存在问题, 所有页面在应用启动时会全部初始化好
      getPages: PageRouter.routers,
    );
  }
}

