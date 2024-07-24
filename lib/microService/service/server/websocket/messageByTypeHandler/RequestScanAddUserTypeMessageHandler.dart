/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'dart:convert';
import 'dart:io';
import '../../../../module/common/unique_device_id.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/OtherClientMsgType.dart';
import '../../model/ClientObject.dart';
import '../../schedule/WaitAgreeUserAddClientHandler.dart';
import 'TypeMessageServerHandler.dart';

class RequestScanAddUserTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.REQUEST_SCAN_ADD_USER;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取ClientObject
    ClientObject clientObject = getClientObject(request, webSocket);

    // 获取秘钥通讯加解密key
    String secret = clientObject.secret.toString();

    // 解密info字段
    msgDataTypeMap["info"] = deSecretMessage(secret, msgDataTypeMap["info"]);

    // 调用
    responseScanAddUser(request, webSocket, msgDataTypeMap);
  }

  /*
   用于扫码添加好友
   */
  Future<void> responseScanAddUser(
      HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) async {
    // 接收方deviceId
    String recive_deviceId = msgDataTypeMap?["info"]["recipient"]["id"] ?? "";
    // 发送者
    String send_deviceId = msgDataTypeMap?["info"]["sender"]["id"] ?? "";

    // 根据deviceId获取clientObject
    ClientObject? receive_clientObject =
        getClientObjectByDeviceId(recive_deviceId);

    /// 1.封装数据
    Map? send_data = msgDataTypeMap;

    // 判断对方是否在线
    if (receive_clientObject == null) {
      //***************************待测试需要找第三个设备: 存在bug******************
      printInfo("对方不在线");

      // 2.第一道防护存储加密: 获取接收方的通讯秘钥
      // 不在线，进入离线消息队列等待： 利用设备生成的设备唯一性ID作为key进行加密数据
      String? key = (await UniqueDeviceId.getDeviceUuid()) ??
          GlobalManager.appCache.getString("deviceId");
      send_data["info"] = encodeMessage(key!, send_data["info"]);

      printWarn(
          "because receiver is offline for REQUEST_SCAN_ADD_USER,so the msg data enter the offLineMessageQueue");
      // 进入离线消息队列
      WaitAgreeUserAddClientHandler waitAgreeUserAddClientHandler =
          WaitAgreeUserAddClientHandler();
      if (waitAgreeUserAddClientHandler.isWaitAgreeUserAdd) {
        waitAgreeUserAddClientHandler.enAgreeUserAddQueue(
            send_deviceId, send_data); // 利用设备生成的设备唯一性ID作为key进行加密数据
      }
      printSuccess("msg alreaded to the AgreeUserAddQueue!");
    } else {
      //***************************待测试需要找第三个设备******************
      print("对方在线");
      // 在线直接发起add user请求
      /// 2.加密数据
      send_data["info"] =
          encodeMessage(receive_clientObject.secret, send_data["info"]);

      /// 3.发送
      try {
        receive_clientObject.socket.add(json.encode(send_data));
        printInfo("server send REQUEST_SCAN_ADD_USER: successful!");
      } catch (e) {
        printCatch(
            "server send REQUEST_SCAN_ADD_USER: failure!,more detail: $e");
      }
    }
  }
}
