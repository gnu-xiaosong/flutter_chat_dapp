import 'dart:io';

import '../../../module/common/Console.dart';
import '../../../module/common/tools.dart';
import '../../../module/manager/GlobalManager.dart';
import '../module/ServerMessageHandlerByType.dart';
import '../module/ServerMessageModule.dart';
import '../schedule/MessageQueueTask.dart';
import './WebsocketServer.dart';

class ChatWebsocketServer extends WebSocketServer with Console {
  Tool tool = Tool();
  // 实例化消息处理类
  ServerMessageHandlerByType messageHandlerByType =
      ServerMessageHandlerByType();

  /*
   计算与该服务端连接的clientd的数量
   */
  Map getClientsCount() {
    // 与server连接成功的client数量
    int ClientCount = super.clients.length;

    // 连接成功并且经过认证为client客户端
    int chatClientCount = GlobalManager.webscoketClientObjectList.length;

    // 封装
    Map result = {"Client": ClientCount, "chatClientCount": chatClientCount};
    return result;
  }

  /*
  处理客户端断开连接
   */
  @override
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    printInfo("-------------客户端中断处理--------------");
    var ip = request.connectionInfo?.remoteAddress.address;

    // 更改全局 list 中 websocketClientObj 的状态，并移除具有相同 IP 的对象
    GlobalManager.webscoketClientObjectList =
        GlobalManager.webscoketClientObjectList.where((websocketClientObj) {
      if (websocketClientObj.ip == ip) {
        printInfo(
            "ip=${ip} port=${request.connectionInfo?.remotePort} 已从缓存list中移除");

        return false; // 移除具有相同 IP 的对象
      }
      return true; // 保留其他对象
    }).toList();
    printInfo(
        "缓存中剩余websocketObject数: ${GlobalManager.webscoketClientObjectList.length}");

    // 广播client在线用户: 注意数据解密
    ServerMessageModel().broadcastInlineClients();
  }

  /*
    处理接受到的消息
   */
  @override
  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {
    // 将string重构为Map
    Map? msgDataTypeMap = tool.stringToMap(message.toString());

    messageHandlerByType.msgDataTypeMap = msgDataTypeMap!;
    // 调用消息处理函数
    messageHandlerByType.handler(request, webSocket);

    //****************************待处理位置execOnceWebsocketServerMessageBusQueueScheduleTask*******************************************

    // *****************被动调用bus Queue总消息队列任务************************
    MessageQueueTask messageQueueTask = MessageQueueTask();
    messageQueueTask.execOnceWebsocketServerMessageBusQueueScheduleTask();

    // super.messageHandler(request, webSocket, message);
  }
}
