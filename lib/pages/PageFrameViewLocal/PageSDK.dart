import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// FlutterBlue flutterBlue = FlutterBlue.instance;


// 蓝牙扫描
late StreamSubscription<List<ScanResult>> _scanRetsSubscription;
late StreamSubscription<bool> _isScanningSubscription;

typedef BarConfig(String title, String backgroundColor, String foregroundColor,
    double toolbarOpacity);

class PageSDK {
  String bridgeName = "SDKCommand";
  Text barTitle = Text("");

  AppBar pageBar = AppBar(
    centerTitle: true,
    title: const Text("hello"),
  );

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
  setNavigationBarConfig(Map<String, dynamic> config) {

  }

  /**
   * 动态设置当前页面的标题
   */
  setNavigationBarTitle(dynamic title) {

  }


  // ------------------- 蓝牙扫描----------
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  // 获取蓝牙设备
  getBluetoothDevices(Function callback) {
    print('_Task2PageState.build 设置监听器');
    var _scanRets = [];
    this._scanResultsSubscription = FlutterBluePlus.scanResults.listen((results){
      _scanResults = results;

      print("_scanResults: $_scanResults");

      callback(_scanResults);
    },onError: (error){
      print('error: $error');
    },onDone: (){
      print('done');
    });

    this._isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
    });
  }


  // 关闭蓝牙适配器
  closeBluetoothAdapter() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    return "蓝牙关闭成功";
  }

  // ------------------- 蓝牙扫描---------- end

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
