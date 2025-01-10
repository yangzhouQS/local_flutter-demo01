
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // 用于将字符串转换为字节
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var url = Uri.parse('http://a.itying.com/api/productList');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    print('Response data: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }

  // await getMecthApi();
 // await getYearrowApi();
}

Future<dynamic> getYearrowApi() async {
  const baseURL = 'http://dev.yearrow.com';
  const method = 'get';
  const paramPath = '/facilityServer/record/452353557336064';
  const secretKey = 'nEHUKMe_FleHxZ3srO6sa6uDmteWXN4gx7UD594E';
  const accessId = 'ykzzeGjYcb-LhuZ1NcTJ8';

  var policyItems = [method.toUpperCase()];
  policyItems.add(paramPath);
  policyItems.sort();
  final msg = policyItems.join(',');
  print('msg=$msg');
  var key = utf8.encode(secretKey);
  var bytes = utf8.encode(msg);
  var hmacSha512 = Hmac(sha512, key); // HMAC-SHA256
  var digest = hmacSha512.convert(bytes).toString();
  var authorization = '$accessId:$digest';
  var md5Path = md5.convert(utf8.encode('/facilityServer/record')).toString();
  var date = DateTime.now().toUtc().toString();
  Map<String, String> headers = {
    'authorization': authorization,
    'date': date,
    'x-authorize-gateway': md5Path
  };
  print('headers=$headers');
  var reponse =
      await http.get(Uri.parse('$baseURL$paramPath'), headers: headers);
  print(reponse.body);
}

Future<dynamic>  getMecthApi() async {
  const accessId = 'm7EUXsPB5jhHiZxvSwdd';
  const secretKey = 'wJZApqPSQuJBwm9Qa1oJ2fmLXT2bhrQc9yX5U/3x';
  // const accessId = 'Hc3DH+TMxCtaVfLLhp0m';
  // const secretKey = 'DFd69HKKcmSEmrZWEg7G8pNe2xhfHuyxnYUeeHO22';
  const path = 'http://dev.mctech.vip/api/mquantity/organizations-parent?parentId=-1';
  var options = {
    'accessId': accessId,
    'secret': secretKey,
    'method': 'GET',
    'contentType': 'content-type',
    'path': path,
  };

  var singer = generateSignatureInfo(options);
  print('sing=$singer');
  Response response;
  //等待返回response
  response = await Dio().get(path,options: Options(headers:singer));
  if(response.statusCode == 200){
    print(response.toString());
  }else{
    print("error");
  }

 var reponse = await http.get(Uri.parse(path), headers:singer);

 print(reponse.body);
}

Map<String, String> generateSignatureInfo(option) {
  var method = option['method'].toUpperCase();
  if (method == 'POST' || method == 'PUT' || method == 'PATCH') {
    if (!option['contentType'].isEmpty) {
      print(
          'http请求缺少content-type头。请求方式为[${method}]时，需要在RpcInvoker的headers属性上设置content-type');
    }
  }
  //  'Fri, 27 Dec 2024 03:25:16 GMT'
  var date = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").format(DateTime.now().toUtc());  //toGMTString
  // const date ='Fri, 27 Dec 2024 06:09:39 GMT';
  var signature = computeSignature(option, date);
  return {'authorization': 'IWOP ${option['accessId']}:$signature', 'date': date};
}

String computeSignature(option, date) {
  var policyItems = [option['method'].toUpperCase()];
  policyItems.add(date);
  policyItems.add(option['path']);
  var policy = policyItems.join('\n').toString();
  return hmacSha1(policy, option['secret']);
}

String hmacSha1(String content, String key)  {
  var key1 = utf8.encode(key);
  var bytes = utf8.encode(content);
  var sha = Hmac(sha1, key1);
  var data = sha.convert(bytes);
  // 创建 Base64 编码器
  Base64Encoder encoder = Base64Encoder();
  String base64Encoded = encoder.convert(data.bytes);
  return base64Encoded;
}
