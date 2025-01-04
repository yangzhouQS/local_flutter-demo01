import 'package:flutter_demo02/pages/PageFrameViewLocal/PageFrameViewLocal.dart';
import 'package:get/get.dart';
import './PageHome.dart';
import './pages/PageLayout/PageFlex.dart';
import './pages/PageNotFound/PageNotFound.dart';
import './pages/PageLogin/PageLogin.dart';
import 'pages/PageFrameView/PageFrameView.dart';

class PageRouter {
  static final routers = [
    GetPage(name: "/notFound", page: () => PageNotFound(), transition: Transition.fadeIn),
    GetPage(name: "/home", page: () => PageHome(), transition: Transition.fadeIn),
    GetPage(name: "/login", page: () => PageLogin(), transition: Transition.leftToRight),
    GetPage(name: "/PageFlex", page: () => PageFlex(), transition: Transition.fadeIn),
    GetPage(name: "/PageFrameView", page: () => PageFrameView(), transition: Transition.fadeIn),
    GetPage(name: "/PageFrameViewLocal", page: () => PageFrameViewLocal(), transition: Transition.fadeIn),
  ];
}
