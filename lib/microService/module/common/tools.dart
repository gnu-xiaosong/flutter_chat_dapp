/*
工具函数
 */
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../../../database/daos/ChatDao.dart';

mixin CommonTool {
  ChatDao chatDao = ChatDao();

  Map? stringToMap(String data) {
    // print("------json decode for string to map--------");
    // print("待转string: $data");
    try {
      // 检查输入字符串是否是有效的JSON格式
      if (data != null && data.isNotEmpty) {
        // 使用json.decode将JSON字符串解析为Map
        Map re = json.decode(data);
        // print("转换map: $re");
        return re;
      } else {
        print("Input data is empty or null");
      }
    } catch (e) {
      // 处理解析错误，输出错误信息并返回一个空的Map
      print('Error parsing JSON: $e');
      return {};
    }
  }

  //auth认证加密算法认证:md5算法
  String generateMd5Secret(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // 生成32字符长度的随机字符串作为密钥
  String generateRandomKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
