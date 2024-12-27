import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class PageFrameView extends StatefulWidget {
  PageFrameView({Key? key}) : super(key: key);

  @override
  _PageFrameViewState createState() => _PageFrameViewState();
}

class _PageFrameViewState extends State<PageFrameView> {
  @override
  Widget build(BuildContext context) {
    bool isRendered = false;
    String url = "";
    final argumentData = Get.arguments;
    print("参数：name===================");
    print(argumentData);

    PullToRefreshController? pullToRefreshController;
    double progress = 0.0;
    InAppWebViewController? controller;
    final GlobalKey webViewKey = GlobalKey();
    final uri = Uri.parse('https://example.com/api/fetch?limit=10,20,30&max=100');
    InAppWebViewSettings settings = InAppWebViewSettings(
      // isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      // iframeAllow: "",
      iframeAllowFullscreen: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    );

    void initState() {
      super.initState();
      if (argumentData && argumentData["url"]) {
        url = argumentData["url"];
        isRendered = true;
      } else {
        TDToast.showIconText('打开url参数不存在',
            icon: TDIcons.check_circle,
            direction: IconTextDirection.vertical,
            context: context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("预览页面"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          progress<0 ? LinearProgressIndicator(value: progress) : Container(),
          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialSettings: settings,
              initialUrlRequest: URLRequest(url: WebUri(url)),
              onLoadStart: (controller, url) {
                print("onLoadStart 加载地址：$url");
                setState(() {
                  progress = 0.0;
                });
              },
              onReceivedError: (controller, request, error) {
                // pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {

                });
              },
              onConsoleMessage: (controller, message) {
                print("----------------consoleMessage------------");
                print(message);
              }
            ),
          ),
        ]),
      ),
    );
  }
}
