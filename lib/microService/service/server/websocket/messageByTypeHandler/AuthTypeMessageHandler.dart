/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'dart:convert';
import 'dart:io';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/OtherClientMsgType.dart';
import '../../model/ClientObject.dart';
import '../../schedule/OffLineHandler.dart';
import 'TypeMessageServerHandler.dart';

class AuthTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.AUTH;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 解密info字段
    msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);

    // 客户端client 第一次请求认证服务端server
    auth(request, webSocket, msgDataTypeMap);
    // 广播在线client用户数
    broadcastInlineClients();
  }

  /*
    客户端client 第一次请求认证服务端server
   */
  void auth(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取客户端 IP 和端口
    var clientIp = request.connectionInfo?.remoteAddress.address;
    var clientPort = request.connectionInfo?.remotePort;

    // 1. client认证
    Map clientAuthResult = clientInitAuth(msgDataTypeMap!);

    printInfo("----------------AUTH认证------------------");
    // printInfo(clientAuthResult);

    if (clientAuthResult["result"]) {
      // 通过认证
      // 加密组合
      String data_encry = clientIp.toString() +
          clientPort.toString() +
          DateTime.now().toString();
      String secret = encrypte(data_encry);
      // 2.1 如果认证成功则封装该client为WebsocketClientObject并添加进全局list
      ClientObject client = ClientObject(
        deviceId: msgDataTypeMap?["deviceId"],
        socket: webSocket,
        ip: clientIp.toString(),
        secret: secret,
        port: clientPort!.toInt(),
      );

      // 先剔除全局list中相同deviceID的client对象
      GlobalManager.webscoketClientObjectList = GlobalManager
          .webscoketClientObjectList
          .where((clientItem) => clientItem.deviceId != client.deviceId)
          .toList();
      // 添加进list中
      GlobalManager.webscoketClientObjectList.add(client);

      // 返回消息
      Map re = {
        "type": "AUTH",
        "info": {
          "code": "200", // 代表成功
          "secret": secret, //通信秘钥
          "msg": clientAuthResult["msg"]
        }
      };
      // 消息加密: 认证类的message的key为空
      re["info"] = encodeAuth(re["info"]);
      printInfo("-----------------测试点-------------------------");
      // print(re);
      // 项该client发送认证成功
      webSocket.add(json.encode(re));
      printSuccess(
          'Client connected: IP = $clientIp, Port = $clientPort is connect successful!');

      // ------认证成功被动触发一次离线消息队列处理
      OffLine offLine = OffLine();
      if (offLine.isOffLine) {
        offLine.offLineHandler();
      }
    } else {
      // 2.2.不通过client认证，则返回错误消息
      Map re = {
        "type": "AUTH",
        "info": {"code": "300", "msg": clientAuthResult["msg"]}
      };
      // 消息加密: 认证类的message的key为空
      re["info"] = encodeAuth(re["info"]);
      // 项该client发送认证失败消息
      webSocket.add(json.encode(re));
      // 主动断开该client的连接
      webSocket.close();
    }
  }
}
