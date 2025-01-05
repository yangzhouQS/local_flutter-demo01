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


  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex, {double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16, (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0, alpha);
  }

  /// 十六进制颜色字符串，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColorString(String hexColor) {
    Color color = Color(ColorUtils.getColorFromHex(hexColor));
    return color;
  }

  static int getColorFromHex(String hexColor) {
    if (hexColor.startsWith("#")) {
      hexColor = hexColor.toUpperCase().replaceAll("#", "");
    } else {
      hexColor = hexColor.toUpperCase();
    }
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  /// 颜色检测只保存 #RRGGBB格式 FF透明度
  /// [color] 格式可能是材料风/十六进制/string字符串
  /// 返回[String] #rrggbb 字符串
  static String? color2HEX(Color color) {
    // 0xFFFFFFFF
    //将十进制转换成为16进制 返回字符串但是没有0x开头
    String temp = color.value.toRadixString(16);
    if (temp.isNotEmpty) {
      if (temp.length == 8) {
        String hexColor = "#" + temp;
        return hexColor.toLowerCase();
      } else {
        String hexColor = "#" + temp;
        return hexColor.toLowerCase();
      }
    }

    return null;
  }
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