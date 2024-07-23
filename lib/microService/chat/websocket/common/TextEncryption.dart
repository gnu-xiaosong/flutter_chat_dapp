/*
基于移位的加解密算法
 */
import 'dart:convert';

import 'package:app_template/microService/chat/websocket/common/Console.dart';

class TextEncryption with Console {
  String encrypt(String text, int shift, String key) {
    String combinedText = '$text$key';
    String encodedText = base64Encode(utf8.encode(combinedText));
    String encryptedText = '';
    for (int i = 0; i < encodedText.length; i++) {
      int charCode = encodedText.codeUnitAt(i);

      // 只对字母进行移位，其他字符保持不变
      if (charCode >= 65 && charCode <= 90) {
        encryptedText += String.fromCharCode((charCode - 65 + shift) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        encryptedText += String.fromCharCode((charCode - 97 + shift) % 26 + 97);
      } else {
        encryptedText += encodedText[i];
      }
    }
    return encryptedText;
  }

  String decrypt(String encryptedText, int shift, String key) {
    String decodedTextWithoutKey = "";
    try {
      String decodedText = '';
      for (int i = 0; i < encryptedText.length; i++) {
        int charCode = encryptedText.codeUnitAt(i);

        // 只对字母进行反向移位，其他字符保持不变
        if (charCode >= 65 && charCode <= 90) {
          decodedText +=
              String.fromCharCode((charCode - 65 + 26 - shift) % 26 + 65);
        } else if (charCode >= 97 && charCode <= 122) {
          decodedText +=
              String.fromCharCode((charCode - 97 + 26 - shift) % 26 + 97);
        } else {
          decodedText += encryptedText[i];
        }
      }
      decodedTextWithoutKey =
          utf8.decode(base64.decode(decodedText)).replaceAll(key, '');
    } catch (e) {
      printCatch("错误信息:未识别加密字符! ${e.toString()}");
    }

    return decodedTextWithoutKey;
  }
}

class TextEncryptionForJson with Console {
  String decryptString(String encryptedText, int shift, String key) {
    String decodedTextWithoutKey = '';
    try {
      String decodedText = '';
      for (int i = 0; i < encryptedText.length; i++) {
        int charCode = encryptedText.codeUnitAt(i);
        decodedText += String.fromCharCode((charCode - shift + 256) % 256);
      }
      decodedTextWithoutKey =
          utf8.decode(base64.decode(decodedText)).replaceAll(key, '');
    } catch (e) {
      print("Error: Unrecognized encrypted character! ${e.toString()}");
    }
    return decodedTextWithoutKey;
  }

//Function to encrypt a single string
  String encryptString(String plainText, int shift, String key) {
    String encodedText = base64.encode(utf8.encode(plainText + key));
    String encryptedText = '';
    for (int i = 0; i < encodedText.length; i++) {
      int charCode = encodedText.codeUnitAt(i);
      encryptedText += String.fromCharCode((charCode + shift) % 256);
    }
    return encryptedText;
  }

// Function to decrypt a JSON object
  Map<String, dynamic> decryptJson(
      Map<String, dynamic> jsonObj, int shift, String key) {
    Map<String, dynamic> decryptedJson = {};
    jsonObj.forEach((k, v) {
      if (v is String) {
        decryptedJson[k] = decryptString(v, shift, key);
      } else if (v is int) {
        // Decrypt the integer as if it were a string
        String encryptedIntStr = decryptString(v.toString(), shift, key);
        decryptedJson[k] = int.tryParse(encryptedIntStr) ?? v;
      } else if (v is Map) {
        decryptedJson[k] =
            decryptJson(Map<String, dynamic>.from(v), shift, key);
      } else if (v is List) {
        decryptedJson[k] = v.map((item) {
          if (item is String) {
            return decryptString(item, shift, key);
          } else if (item is int) {
            String encryptedIntStr = decryptString(item.toString(), shift, key);
            return int.tryParse(encryptedIntStr) ?? item;
          } else if (item is Map) {
            return decryptJson(Map<String, dynamic>.from(item), shift, key);
          } else {
            return item;
          }
        }).toList();
      } else {
        decryptedJson[k] = v;
      }
    });
    return decryptedJson;
  }

// Function to encrypt a JSON object
  Map<String, dynamic> encryptJson(
      Map<String, dynamic> jsonObj, int shift, String key) {
    Map<String, dynamic> encryptedJson = {};
    jsonObj.forEach((k, v) {
      if (v is String) {
        encryptedJson[k] = encryptString(v, shift, key);
      } else if (v is int) {
        // Encrypt the integer as if it were a string
        encryptedJson[k] = encryptString(v.toString(), shift, key);
      } else if (v is Map) {
        encryptedJson[k] =
            encryptJson(Map<String, dynamic>.from(v), shift, key);
      } else if (v is List) {
        encryptedJson[k] = v.map((item) {
          if (item is String) {
            return encryptString(item, shift, key);
          } else if (item is int) {
            return encryptString(item.toString(), shift, key);
          } else if (item is Map) {
            return encryptJson(Map<String, dynamic>.from(item), shift, key);
          } else {
            return item;
          }
        }).toList();
      } else {
        encryptedJson[k] = v;
      }
    });
    return encryptedJson;
  }
}
