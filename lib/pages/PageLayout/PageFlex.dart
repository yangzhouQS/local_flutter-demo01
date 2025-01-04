import 'package:flutter/material.dart';

class PageFlex extends StatefulWidget {
  @override
  _PageFlexState createState() => _PageFlexState();
}

class _PageFlexState extends State<PageFlex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Page Flex 布局测试, 全屏展示"),
      ),
    );
  }
}
