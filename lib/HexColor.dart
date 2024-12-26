import 'package:flutter/material.dart';

extension ColorUtils on Color {
  // 转换Color对象为8位16进制字符串
  String toHex8({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  // 转换Color对象为6位16进制字符串
  String toHex6({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class HexColor {
  // 解析16进制字符串为Color对象
  static Color fromHex(String hexString) {
    String hex = hexString.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex; // 默认透明度为1（FF）
    } else if (hex.length == 3) {
      hex = 'FF' + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2]; // 简写形式
    }
    return Color(int.parse(hex, radix: 16));
  }
}