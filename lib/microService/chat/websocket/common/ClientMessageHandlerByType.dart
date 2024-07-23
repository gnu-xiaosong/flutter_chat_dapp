/*
 针对不同消息类型进行处理: client 客户端
 */
import 'package:app_template/manager/GlobalManager.dart';
import 'package:app_template/microService/chat/websocket/common/Console.dart';
import 'package:app_template/microService/chat/websocket/common/tools.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'ClientMessageModel.dart';
import 'MessageEncrypte.dart';

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
      // 处理该类型的返回
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.scan(channel);
    } else if (msgDataTypeMap["type"] == "AUTH") {
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeAuth(msgDataTypeMap["info"]);
      printInfo("解密结果:$msgDataTypeMap");

      // 客户端client 第一次请求认证服务端server
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.auth(channel);
    } else if (msgDataTypeMap["type"] == "MESSAGE") {
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // 为消息类型
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.message();
    } else if (msgDataTypeMap["type"] == "REQUEST_INLINE_CLIENT") {
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // 处理在线client
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.requestInlineClient();
    } else if (msgDataTypeMap["type"] == "REQUEST_SCAN_ADD_USER") {
      // 通过扫码请求添加好友请求
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // printInfo(msgDataTypeMap);
      // 处理在线client
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.scanQrAddUser();
    } else if (msgDataTypeMap["type"] == "BROADCAST_INLINE_CLIENT") {
      // 接收server广播得到的在线client用户
      // 从缓存中取出secret 通讯秘钥
      String? secret = GlobalManager.appCache.getString("chat_secret");
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeMessage(secret!, msgDataTypeMap["info"]);
      // 处理server广播得到的在线client
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.receiveInlineClients();
    } else {
      // 为表示消息类型: 明文传输
      printWarn("为标识消息类型");
      clientMessageModel.msgDataTypeMap = msgDataTypeMap;
      clientMessageModel.other();
    }
  }
}
