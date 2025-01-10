import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int id = 0;

///@author zhc 2022/6/8 10:59 上午
///通知管理工具
class Notification {
  initialize() async {
  }
  //点击通知回调事件
  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
      // todo 这里根据自己的业务处理
    }
  }
  // 展示通知
  Future<bool> showNotification({String? title, String? body}) async {
    /*const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, "消息标题", "消息内容", notificationDetails,
        payload: 'item x');*/

    return true;
  }
}

var notification = Notification();

