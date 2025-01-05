import 'package:flutter/material.dart';
import 'package:flutter_demo02/HexColor.dart';

typedef BarConfig(String title, String backgroundColor, String foregroundColor,
    double toolbarOpacity);

class PageSDK {
  String bridgeName = "SDKCommand";
  String _barTitle = "";

  AppBar pageBar = new AppBar();

  get BarTitle => this._barTitle;

  Map<String, dynamic> getNavigationBarConfig() {
    return {
      "title": this.pageBar.title,
      "backgroundColor": 'a', // ColorUtils.color2HEX(this.pageBar.backgroundColor!),
      "foregroundColor": 'a', // ColorUtils.color2HEX(this.pageBar.foregroundColor!),
      "toolbarOpacity": this.pageBar.toolbarOpacity
    };
  }

  /**
   * 动态设置当前页面导航栏
   */
  setNavigationBarConfig(title) {

  }

  /**
   * 动态设置当前页面的标题
   */
  setNavigationBarTitle(title) {

  }

  // 覆盖 == 操作符以确定相等性
  /*@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.name == name &&
        other.age == age;
  }*/

  // 覆盖 noSuchMethod 以处理未定义的方法调用
  @override
  dynamic noSuchMethod(Invocation invocation) {
    print("未定义的方法: ${invocation.memberName}");
    return super.noSuchMethod(invocation);
  }
}
