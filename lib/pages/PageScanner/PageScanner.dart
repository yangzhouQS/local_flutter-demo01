import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class PageScanner extends StatefulWidget {
  PageScanner({Key? key}) : super(key: key);

  @override
  _PageScannerState createState() => _PageScannerState();
}

class _PageScannerState extends State<PageScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _scan() {
    Navigator.of(context).pushNamed('/scanner');
  }


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }


  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

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
            ],
          ),
          SizedBox(height: 20,),
          Container(
            width: 300,
            height: 300,
            //移动扫描仪组件
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: (result != null)
                        ? Text(
                        'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                        : Text('Scan a code'),
                  ),
                )
              ],
            )
          ),
          SizedBox(height: 20,),
        ]),
      ),
    );
  }
}
