/*
 通讯加密算法： 服务端生成，客户端存储， 主要在第一次认证生成传送给服务端，在两者通讯时进行认证消息的来源
 */
import 'dart:convert';
import 'dart:math';
import 'package:app_template/config/AppConfig.dart';
import 'package:crypto/crypto.dart';

String encrypte(String data) {
  String randomString32 = generateRandomKey();

  // 加上本机特征
  String data_ = (AppConfig.ip.toString() +
      data +
      randomString32.toString() +
      AppConfig.port.toString());
  // 计算 MD5 哈希值
  String md5Hash = md5.convert(utf8.encode(data_)).toString();

  return md5Hash;
}

// 生成32字符长度的随机字符串作为密钥
String generateRandomKey() {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(32, (index) => chars[random.nextInt(chars.length)])
      .join();
}
