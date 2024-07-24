/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'dart:convert';
import 'dart:io';
import '../../../client/common/OtherClientMsgType.dart';
import '../../model/ClientObject.dart';
import 'TypeMessageServerHandler.dart';

class RequestInlineClientTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.REQUEST_INLINE_CLIENT;

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

    handleRequestInlineClients(request, webSocket, msgDataTypeMap);
  }

  /*
   广播server端在线client用户
   */
  void handleRequestInlineClients(
      HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    String deviceId = msgDataTypeMap?["info"]["deviceId"];
    // 1.客户端身份验证
    bool _auth = clientAuth(deviceId, request, webSocket);

    if (_auth) {
      // 认证成功
      // 1. 根据deviceId获取在线client的deviceId
      List inlineDeviceId = getInlineClient(deviceId);
      // 2.根据deviceId获取接收方clientObject
      ClientObject? clientObject = getClientObjectByDeviceId(deviceId);
      // 3.封装消息
      Map re = {
        "type": "REQUEST_INLINE_CLIENT",
        "info": {"deviceId": inlineDeviceId}
      };
      // 4.加密
      re["info"] = encodeMessage(clientObject!.secret, re["info"]);
      // 5.发送
      try {
        printSuccess("-----REQUEST_INLINE_CLIENT------");
        clientObject.socket.add(json.encode(re));
      } catch (e) {
        printCatch("转发REQUEST_INLINE_CLIENT 消息给client失败, more detail: $e");
      }
    } else {
      // 3.1 认证失败返回数据相应给客户端
      Map re = {
        "type": "AUTH",
        "info": {
          "code": 500, //代表ip+ip验证失败
          "msg":
              "REQUEST_INLINE_CLIENT: this client for ip or port is  in pass for auth !"
        }
      };
      // 加密消息:采用auth加密
      re["info"] = encodeAuth(re["info"]);

      printSuccess(">> send:$re");
      // 发送
      webSocket.add(json.encode(re));
      // 3.2 主动关闭该不信任的client客户端
      webSocket.close();
    }
  }
}
