import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PageScanner extends StatefulWidget {
  PageScanner({Key? key}) : super(key: key);

  @override
  _PageScannerState createState() => _PageScannerState();
}

class _PageScannerState extends State<PageScanner> {

  void _scan() {
    Navigator.of(context).pushNamed('/scanner');
  }

  Barcode? _barcode;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ///移动扫描仪控制器
    var _controller = MobileScannerController(torchEnabled: false);
    var zt = true;


    return Scaffold(
      appBar: AppBar(
        title: Text("扫码"),
      ),
      body: Container(
        child: Column(children: <Widget>[
          Row(
            children: [
              TDButton(
                onTap: (){
                  _scan();
                },
                text: '点击扫码',
                size: TDButtonSize.large,
                type: TDButtonType.fill,
                shape: TDButtonShape.rectangle,
                theme: TDButtonTheme.primary,
              ),
              _buildBarcode(_barcode),
            ],
          ),
          SizedBox(height: 20,),
          Container(
            width: 300,
            height: 300,
            //移动扫描仪组件
            child: MobileScanner(
              //允许重复
              // allowDuplicates: true,
              //控制器
              controller: _controller,
              //扫描仪扫描结果回调
              onDetect: (BarcodeCapture barcodes) {
                if (mounted) {
                  setState(() {
                    _barcode = barcodes.barcodes.firstOrNull;
                  });
                }
                TDToast.showText(barcodes.barcodes.firstOrNull as String?, context: context);
                //打印扫描结果
                print(barcodes);
                TDToast.showText('轻提示文字内容', context: context);
                TDToast.showText(jsonEncode(barcodes.raw), context: context);
              },
            ),
          ),
          SizedBox(height: 20,),

          ///开启关闭闪光灯
          MaterialButton(
            onPressed: () {
              // _controller.analyzeImage('path'); //加载图片
              _controller.toggleTorch(); //切换闪光灯状态
            },
            child: Text('开启闪光灯'),
          ),
          ///开始暂定
          MaterialButton(
            onPressed: () {
              zt ? _controller.stop() : _controller.start();
              zt = !zt;
            },
            child: Text('开始/暂停'),
          ),
          ///相机切换
          MaterialButton(
            onPressed: () {
              _controller.switchCamera(); //
            },
            child: Text('相机切换'),
          ),
        ]),
      ),
    );
  }
}
