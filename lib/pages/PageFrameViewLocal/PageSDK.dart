import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:geolocator/geolocator.dart';


// 蓝牙扫描
late StreamSubscription<List<ScanResult>> _scanRetsSubscription;
late StreamSubscription<bool> _isScanningSubscription;

typedef BarConfig(String title, String backgroundColor, String foregroundColor,
    double toolbarOpacity);

class PageSDK {
  String bridgeName = "SDKCommand";
  String titleText = "hello";

  final Stream<String> _titleStream = getTitleStream(); // 获取标题的Stream
  // 创建一个StreamController来控制标题的更新
  final StreamController<String> _titleStreamController = StreamController<String>();

  AppBar pageBar = AppBar(
    centerTitle: true,
    title: const Text("hello"),
    // 使用StreamBuilder来构建AppBar的标题
    /*title: StreamBuilder<String>(
      stream: _titleStreamController.stream,
      initialData: 'Initial Title', // 初始标题
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // 当有新的数据时，更新标题
        return Text(snapshot.data ?? 'Default Title');
      },
    )*/
  );

  TDNavBar tdNavBar = TDNavBar(
    height: 48,
    titleFontWeight: FontWeight.w600,
    title: "hello",
    screenAdaptation: false,
    useDefaultBack: true,
  );

  Map<String, dynamic> getNavigationBarConfig() {
    return {
      "title": "测试的hello",//this.pageBar.title,
      "backgroundColor": 'a', // ColorUtils.color2HEX(this.pageBar.backgroundColor!),
      "foregroundColor": 'a', // ColorUtils.color2HEX(this.pageBar.foregroundColor!),
      "toolbarOpacity": this.pageBar.toolbarOpacity
    };
  }

  // 模拟更新标题
  static void updateTitle(String newTitle) {
    // 实际应用中，可以通过网络请求或其他方式获取新的标题
    // 这里只是简单地将新标题添加到Stream中
    // _titleStream.add(newTitle);
  }

  // 模拟获取标题的Stream
  static Stream<String> getTitleStream() {
    return Stream.periodic(Duration(seconds: 1), (count) {
      return 'Title $count';
    });
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
  getBluetoothDevices(Function callback) async{

    try {
      var withServices = [Guid("180f")]; // Battery Level Service
      _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    }catch(e){

    }

    try {
      if (_isScanning == false) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      }

    }catch(e){

    }

    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    print('getBluetoothDevices 设置监听器');


    this._scanResultsSubscription = FlutterBluePlus.scanResults.listen((results){
      _scanResults = results;

      print("_scanResults: $_scanResults");

      callback(_scanResults);

      // 停止扫码
      // FlutterBluePlus.stopScan();
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

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'modelName': data.modelName,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'isiOSAppOnMac': data.isiOSAppOnMac,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'modelName': data.modelName,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  // 设备信息获取
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<Map<String, dynamic>> getSystemInfo()async{
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = switch (defaultTargetPlatform) {
          TargetPlatform.android =>
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
          TargetPlatform.iOS =>
              _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
          TargetPlatform.linux =>
              _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
          TargetPlatform.windows =>
              _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
          TargetPlatform.macOS =>
              _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
          TargetPlatform.fuchsia => <String, dynamic>{
            'Error:': 'Fuchsia platform isn\'t supported'
          },
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    deviceData.remove('supported32BitAbis');
    deviceData.remove('supported64BitAbis');

    print("system info: $deviceData");
    print(jsonEncode(deviceData));
    return deviceData;
  }

  chooseImage(Map<String, dynamic> callbackParams) async {
    /*XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery, // 图库选择
      maxWidth: 1000.0, // 设置图片最大宽度，间接压缩了图片的体积
    );

    /// 选取图片失败file为null，要注意判断下。
    /// 获取图片路径后可以上传到服务器上
    print('${file?.path}');*/
  }

  test(){
    print("test");
  }

  // 覆盖 == 操作符以确定相等性
  /*@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.name == name &&
        other.age == age;
  }*/


  // 定位信息获取
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查定位服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 定位服务未启用时，可以引导用户去设置中启用
      return Future.error('定位服务未启用');
    }

    // 检查定位权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 权限被拒绝时，可以告知用户
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 权限被永久拒绝时，可以引导用户去应用设置中手动开启权限
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 获取当前位置
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<dynamic, Object>> getLocation() async {
    Position position = await _determinePosition();
    print('Latitude: ${position.latitude}, Longitude:${position.longitude}');

    return {
      "latitude": position.latitude, // 纬度
      "longitude": position.longitude, // 经度
      "timestamp": position.timestamp.toString(), // 时间戳
      "accuracy": position.accuracy, // 定位精度
      "altitude": position.altitude, // 海拔
      "heading": position.heading, // 方向
      "speed": position.speed, // 速度
      "speedAccuracy": position.speedAccuracy, // 速度精度
    };
  }


  // 覆盖 noSuchMethod 以处理未定义的方法调用
  @override
  dynamic noSuchMethod(Invocation invocation) {
    print("未定义的方法: ${invocation.memberName}");
    return super.noSuchMethod(invocation);
  }
}
