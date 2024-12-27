import 'package:flutter/material.dart';
import 'package:flutter_demo02/HexColor.dart';
import 'package:flutter_demo02/pages/PageLayout/PageFlex.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

Widget? _selectedIcon;

Widget? _unSelectedIcon;

class _PageHomeState extends State<PageHome> {
  /// 获取子项目
  Widget getItem(int index) {
    return Container(
      // 宽高设置 60
      width: 60,
      height: 60,
      // 设置背景色
      color: Colors.orange.shade200,
      // 设置间隙
      margin: EdgeInsets.all(2),
      // 设置子项居中
      alignment: Alignment.center,
      // 设置子项
      child: Text('$index'),
    );
  }

  @override
  Widget build(BuildContext context) {

    _selectedIcon = Icon(
      TDIcons.app,
      size: 20,
      color: TDTheme.of(context).brandNormalColor,
    );
    _unSelectedIcon = Icon(
      TDIcons.app,
      size: 20,
      color: TDTheme.of(context).brandNormalColor,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Column(children: <Widget>[
        // 水平排列
        Flex(direction: Axis.horizontal, children: <Widget>[
          TDButton(
            text: "flex布局测试",
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
            onTap: () => {
              // Get.to(PageFlex())
              /*GetPage(
                name: 'PageFlex',
                page: () => PageFlex(),
              )*/
              // Get.toNamed(RouteGet.PageFlex);
            },
          ),
          TDButton(
            text: '描边按钮',
            icon: TDIcons.app,
            size: TDButtonSize.large,
            type: TDButtonType.outline,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
          )
        ]),
        Row(
          children: List.generate(3, (index) => getItem(index)),
        ),
        Flexible(
          flex: 2,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: HexColor.fromHex('#165dff'),
            child: Text('首页'),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(
          flex: 1,
          child: TDBottomTabBar(TDBottomTabBarBasicType.iconText,
              useVerticalDivider: false,
              navigationTabs: [
                TDBottomTabBarTabConfig(
                  tabText: '首页',
                  selectedIcon: _selectedIcon,
                  unselectedIcon: _unSelectedIcon,
                  onTap: () {
                    print("首页");
                  },
                ),
                TDBottomTabBarTabConfig(
                  tabText: '消息',
                  selectedIcon: _selectedIcon,
                  unselectedIcon: _unSelectedIcon,
                  onTap: () {
                    print("message");
                  },
                ),
                TDBottomTabBarTabConfig(
                  tabText: '我的',
                  selectedIcon: _selectedIcon,
                  unselectedIcon: _unSelectedIcon,
                  onTap: () {
                    print("标签1");
                  },
                ),
              ]),
        )
      ]),
    );
  }
}
