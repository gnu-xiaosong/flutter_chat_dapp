/*
 针对不同消息类型进行处理: client 客户端
 */

import 'package:app_template/microService/module/common/Console.dart';
import 'package:app_template/microService/module/common/tools.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../module/manager/GlobalManager.dart';
import 'ClientMessageModule.dart';
import '../../../module/encryption/MessageEncrypte.dart';

class ClientMessageHandlerByType extends Tool with Console {
  MessageEncrypte messageEncrypte = MessageEncrypte();
  ClientMessageModel clientMessageModel = ClientMessageModel();
  // 消息类型
  late Map msgDataTypeMap;

  // 消息处理函数
  void handler(WebSocketChannel? channel) {
    //***********************Message Type  Handler*******************************
    if (msgDataTypeMap["type"] == "SCAN") {
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeAuth(msgDataTypeMap["info"]);

      clientMessageModel.scan(channel, msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "AUTH") {
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeAuth(msgDataTypeMap["info"]);
      printInfo("解密结果:$msgDataTypeMap");

      clientMessageModel.auth(channel, msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "MESSAGE") {
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // 接收消息
      printSuccess("receive msg: ${msgDataTypeMap}");

      clientMessageModel.message(msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "REQUEST_INLINE_CLIENT") {
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);

      // 请求在线client的Map的msgQueue队列
      clientMessageModel.requestInlineClient(msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "REQUEST_SCAN_ADD_USER") {
      // 通过扫码请求添加好友请求
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // 调用
      clientMessageModel.scanQrAddUser(msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "BROADCAST_INLINE_CLIENT") {
      // 接收server广播得到的在线client用户
      // 从缓存中取出secret 通讯秘钥
      // String? secret = GlobalManager.appCache.getString("chat_secret");
      // // 解密info字段
      // msgDataTypeMap["info"] =
      //     messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      //
      // print("解密: $msgDataTypeMap");
      // 处理server广播得到的在线client
      clientMessageModel.receiveInlineClients(msgDataTypeMap);
    } else {
      printWarn("未标识消息类型");
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);

      clientMessageModel.other(msgDataTypeMap);
    }
  }
}
