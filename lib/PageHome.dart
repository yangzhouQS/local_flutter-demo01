import 'package:flutter/material.dart';
import 'package:flutter_demo02/HexColor.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}


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
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Column(children: <Widget>[
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
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: HexColor.fromHex('#d1d1d1'),
            child: Text('下半部分'),
          ),
        )
      ]),
    );
  }
}
