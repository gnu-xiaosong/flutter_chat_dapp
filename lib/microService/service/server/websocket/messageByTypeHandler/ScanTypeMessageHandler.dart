/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'dart:convert';
import 'dart:io';
import 'package:app_template/microService/service/server/model/ClientObject.dart';
import '../../../client/common/OtherClientMsgType.dart';
import 'TypeMessageServerHandler.dart';

class ScanTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.SCAN;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    print("SCAN");
    // 获取ClientObject
    ClientObject clientObject = getClientObject(request, webSocket);

    // 获取秘钥通讯加解密key
    String secret = clientObject.secret.toString();

    // 解密info字段
    msgDataTypeMap["info"] = deSecretMessage(secret, msgDataTypeMap["info"]);

    print("解密： ${msgDataTypeMap}");
    // 客户端请求局域网内服务端server的请求
    scan(request, webSocket, msgDataTypeMap);
  }

  /*
    客户端请求局域网内服务端server的请求
   */
  void scan(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取客户端 IP 和端口
    var clientIp = request.connectionInfo?.remoteAddress.address;
    var clientPort = request.connectionInfo?.remotePort;

    // 不进行加密，直接明文返回
    Map re = {
      "type": "SCAN",
      "info": {"code": 200, "msg": "I am server for websocket!"}
    };

    printInfo("有主机: $clientIp:$clientPort 扫描本机!");
    // 算法加密:采用auth加解密算法
    re["info"] = encodeAuth(re["info"]);

    // 发送消息给client
    webSocket.add(json.encode(re));
    // 主动关闭连接
    webSocket.close();
  }
}
