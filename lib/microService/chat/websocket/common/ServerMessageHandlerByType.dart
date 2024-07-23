/*
 针对不同消息类型进行处理
 */
import 'dart:convert';
import 'dart:io';

import 'package:app_template/microService/chat/websocket/common/Console.dart';
import 'package:app_template/microService/chat/websocket/common/secret.dart';
import 'package:app_template/microService/chat/websocket/common/tools.dart';
import 'package:app_template/microService/chat/websocket/common/unique_device_id.dart';
import '../../../../manager/GlobalManager.dart';
import '../model/ClientObject.dart';
import 'MessageEncrypte.dart';
import 'OffLineHandler.dart';
import 'ServerMessageModel.dart';
import 'WaitAgreeUserAddClientHandler.dart';

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
      serverMessageModel.msgDataTypeMap = msgDataTypeMap;
      serverMessageModel.scan(request, webSocket);
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
      serverMessageModel.msgDataTypeMap = msgDataTypeMap;
      serverMessageModel.auth(request, webSocket);
      // 广播在线client用户数
      ServerMessageModel().broadcastInlineClients();
    } else if (msgDataTypeMap["type"] == "MESSAGE") {
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);

      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);
      // 为消息类型
      serverMessageModel.msgDataTypeMap = msgDataTypeMap;
      serverMessageModel.message(request, webSocket);
    } else if (msgDataTypeMap["type"] == "REQUEST_INLINE_CLIENT") {
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);
      //请求在线客户端client
      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);
      // 请求在线用户
      serverMessageModel.msgDataTypeMap = msgDataTypeMap;
      serverMessageModel.requestInlineClient(request, webSocket);
    } else if (msgDataTypeMap["type"] == "REQUEST_SCAN_ADD_USER") {
      printInfo("-------------REQUEST_SCAN_ADD_USER-----------------");

      // 用于扫码添加好友
      // 获取websoket对应的ClientObject对象
      ClientObject clientObject = tool.getClientObject(request, webSocket);
      //请求在线客户端client
      // 解密info字段
      msgDataTypeMap["info"] = messageEncrypte.decodeMessage(
          clientObject.secret, msgDataTypeMap["info"]);

      // 请求在线用户
      serverMessageModel.msgDataTypeMap = msgDataTypeMap;
      serverMessageModel.responseScanAddUser(request, webSocket);
    } else {
      // 未标识消息类型
      printWarn("未识别消息类型: ${msgDataTypeMap.toString()}");
    }
  }
}
