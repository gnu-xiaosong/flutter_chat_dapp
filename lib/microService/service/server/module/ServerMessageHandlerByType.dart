/*
 针对不同消息类型进行处理
 */
import 'dart:io';
import 'package:app_template/microService/module/common/Console.dart';
import 'package:app_template/microService/module/common/tools.dart';
import '../model/ClientObject.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import 'ServerMessageModule.dart';

class ServerMessageHandlerByType with Console {
  MessageEncrypte messageEncrypte = MessageEncrypte();
  // 消息类型
  late Map msgDataTypeMap;
  Tool tool = Tool();
  ServerMessageModel serverMessageModel = ServerMessageModel();

  // 消息处理函数
  void handler(HttpRequest request, WebSocket webSocket) {
    //***********************Message Type  Handler*******************************
    if (msgDataTypeMap["type"] == "SCAN") {
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeAuth(msgDataTypeMap["info"]);

      // 客户端请求局域网内服务端server的请求
      serverMessageModel.scan(request, webSocket, msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "AUTH") {
      //************************测试************************************
      // msgDataTypeMap["info"] =
      //     MessageEncrypte.encodeAuth(msgDataTypeMap["info"]);
      // print("加密结果: $msgDataTypeMap");
      //***************************************************************
      // 解密info字段
      msgDataTypeMap["info"] =
          messageEncrypte.decodeAuth(msgDataTypeMap["info"]);
      printInfo("解密结果:$msgDataTypeMap");

      // 客户端client 第一次请求认证服务端server
      serverMessageModel.auth(request, webSocket, msgDataTypeMap);
      // 广播在线client用户数
      serverMessageModel.broadcastInlineClients();
    } else if (msgDataTypeMap["type"] == "MESSAGE") {
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);

      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);
      // 为消息类型
      serverMessageModel.message(request, webSocket, msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "REQUEST_INLINE_CLIENT") {
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);
      //请求在线客户端client
      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);
      // 请求在线用户
      serverMessageModel.handleRequestInlineClients(
          request, webSocket, msgDataTypeMap);
    } else if (msgDataTypeMap["type"] == "REQUEST_SCAN_ADD_USER") {
      printInfo("-------------REQUEST_SCAN_ADD_USER-----------------");

      // 用于扫码添加好友
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);
      //请求在线客户端client
      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);

      // 响应
      serverMessageModel.responseScanAddUser(
          request, webSocket, msgDataTypeMap);
      // 广播在线client用户数
      serverMessageModel.broadcastInlineClients();
    } else {
      // 未标识消息类型
      printWarn("未识别消息类型: ${msgDataTypeMap.toString()}");
    }
  }
}
