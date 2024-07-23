/*
  消息加密和解密算法
 */
import 'package:app_template/microService/module/common/Console.dart';
import 'package:app_template/microService/module/encryption/TextEncryption.dart';
import 'package:app_template/microService/module/common/tools.dart';
import 'package:encrypt/encrypt.dart';

class MessageEncrypte extends Tool with Console {
  // auth 加解密key
  String auth_key = "5eb63bbbe01eeed093cb22bb8f5acdc3";
  int shift = 3; //移位
  //**********************************消息文本加解密******************************************************

  /*
   为map的每一个键值进行加密
   */
  Map encodeMessage(String key_secret, Map<String, dynamic> data_map) {
    // 加密
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.encryptJson(data_map, shift, key_secret);

    return endata_map;
  }

  /*
   为map的每一个键值进行解密
   */
  Map? decodeMessage(String key_secret, Map<String, dynamic> data_map) {
    // 加密
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.decryptJson(data_map, shift, key_secret);

    return endata_map;
  }

  /*
  其中key为通讯秘钥secret
   */
  // 消息加密算法AES
  String encodeTextASE(String key, String plainText) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key))); // 32位秘钥
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return encrypted.base64;
  }

  // 消息解密算法
  String? decodeTextASE(String key, var base64String) {
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key.fromUtf8(key))); // 32位秘钥
    try {
      Encrypted encrypted = Encrypted.fromBase64(base64String);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      print('解密失败: $e');
      return null;
    }
  }

  // 认证消息加密算法
  Map encodeAuth(Map<String, dynamic> data_map) {
    // 加密
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.encryptJson(data_map, shift, auth_key);

    return endata_map;

    // // return data_map;
    // data_map.forEach((key, value) {
    //   data_map[key] = TextEncryption()
    //       .encrypt(value.toString(), shift, auth_key.toString());
    // });
    //
    // return data_map;
  }

  // 认证消息解密算法
  Map decodeAuth(Map<String, dynamic> data_map) {
    TextEncryptionForJson textEncryptionForJson = TextEncryptionForJson();
    Map endata_map =
        textEncryptionForJson.decryptJson(data_map, shift, auth_key);

    return endata_map;

    // data_map.forEach((key, value) {
    //   String text = TextEncryption()
    //       .decrypt(value.toString(), shift, auth_key.toString());
    //   data_map[key] = text;
    // });
    // return data_map;
  }

  //*****************************************************************************************
  /*
   client客户端有效性认证认证
   */
  Map clientInitAuth(Map data_) {
    bool result = false;
    String msg = "AUTH: 该client客户端认证成功!";

    try {
      String? key = data_["info"]["key"];
      String? plainText = data_["info"]["plait_text"];
      String? encrypte = data_["info"]["encrypte"];

      if (key == null || plainText == null || encrypte == null) {
        print("缺失info的关键字段: key or plait_text or encrypte");
      }

      String computedHash = generateMd5Secret(key! + plainText!);

      if (computedHash == encrypte) {
        result = true;
      } else {
        msg = "AUTH: 认证失败，秘钥不匹配";
      }
    } catch (e) {
      msg = "AUTH: 认证失败，$e";
    }

    return {"result": result, "msg": msg};
  }
}
