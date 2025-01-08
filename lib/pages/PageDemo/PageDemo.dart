import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class PageDemo extends StatefulWidget {
  @override
  _PageDemoState createState() => _PageDemoState();
}

class _PageDemoState extends State<PageDemo> {
  bool _isScanning = false;

  ///当前已经连接的蓝牙设备
  List<BluetoothDevice> _systemDevices = [];

  ///扫描到的蓝牙设备
  List<ScanResult> _scanResults = [];

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  // 蓝牙适配器状态
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  // 蓝牙适配器状态订阅
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  // https://medium.com/@sparkleo/the-essentials-core-ble-concepts-and-flutter-blue-plus-1df8820b9651

  @override
  void initState() {
    super.initState();
    _initBluetooth();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (error) {
      print('Scan Error:$error');
    });
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _initBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("此设备不支持蓝牙");
      return;
    }

    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // 等待蓝牙适配器开启
    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first;
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();

    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  // 请求用户开启蓝牙
  Future<void> _requestBluetoothPermissions() async {
    if (_adapterState != BluetoothAdapterState.on) {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }

      /*final bool isOn = await flutterBlue.requestEnable();
      if (isOn) {
        print('蓝牙已开启');
      } else {
        print('用户拒绝开启蓝牙');
        // 这里可以添加更多的用户反馈逻辑
      }*/
    }
  }

  // https://ithelp.ithome.com.tw/articles/10346918
  Future<void> _startScan() async {
    if (_adapterState != BluetoothAdapterState.on) {
      print('蓝牙未开启');
      TDToast.showText('请先开启蓝牙', context: context);
      return;
    } else {
      print('开始扫描');
    }

    // 重置
    setState(() {
      _scanResults.clear();
      _isScanning = true;
    });

    try {
      // 开始扫描, 扫描持续15秒
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults = results;
        });
      });
    } catch (e) {
      print('扫描出错：$e');
    }
  }

  Future<void> _stopScan() async {
    await FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
    TDToast.showText('停止扫描', context: context);
    print('停止扫描');
  }

  Widget _buildScanList() {
    return ListView.builder(
      itemCount: _scanResults.length,
      itemBuilder: (context, index) {
        final result = _scanResults[index];
        return ListTile(
          title: Text(result.device.platformName.isNotEmpty
              ? result.device.platformName
              : result.device.remoteId.toString()),
          subtitle: Text(result.device.advName),
          trailing: Text('${result.rssi} dBm'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Demo')),
      body: _buildScanList(),
      /*body: Container(
          child: Column(
        children: [
          TDButton(
            onTap: () {
              _startScan();
            },
            text: '开始扫描',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.primary,
          ),
          TDButton(
            onTap: () {
              _stopScan();
            },
            text: '停止扫描',
            size: TDButtonSize.large,
            type: TDButtonType.fill,
            shape: TDButtonShape.rectangle,
            theme: TDButtonTheme.danger,
          ),
          _buildScanList(),
        ],
      )),*/
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? _stopScan : _startScan,
        child: Icon(
          _isScanning ? Icons.stop : Icons.search,
        ),
      ),
    );
  }
}
