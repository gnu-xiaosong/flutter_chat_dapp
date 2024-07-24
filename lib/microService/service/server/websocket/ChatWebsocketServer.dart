import 'dart:io';

import 'package:app_template/microService/service/server/common/OtherMsgType.dart';

import '../../../module/common/Console.dart';
import '../../../module/common/tools.dart';
import '../../../module/manager/GlobalManager.dart';
import '../module/ServerMessageModule.dart';
import '../schedule/MessageQueueTask.dart';

class ChatWebsocketServer extends OtherMsgType with Console, CommonTool {
  ServerMessageModule serverMessageModel = ServerMessageModule();
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
    int? port = request.connectionInfo?.remotePort;
    // 更改全局 list 中 websocketClientObj 的状态，并移除具有相同 IP 的对象
    GlobalManager.webscoketClientObjectList =
        GlobalManager.webscoketClientObjectList.where((websocketClientObj) {
      if (websocketClientObj.ip == ip && websocketClientObj.port == port) {
        printInfo(
            "ip=${ip} port=${request.connectionInfo?.remotePort} 已从缓存list中移除");

        return false; // 移除具有相同 IP 的对象
      }
      return true; // 保留其他对象
    }).toList();
    printInfo(
        "缓存中剩余websocketObject数: ${GlobalManager.webscoketClientObjectList.length}");

    // 广播client在线用户: 注意数据解密
    serverMessageModel.broadcastInlineClients();
  }

  /*
    处理接受到的消息
   */
  @override
  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {
    // 将string重构为Map
    Map? msgDataTypeMap = stringToMap(message.toString());
    // 这里采用分层层级式处理监听的消息： 每一层逻辑单独
    /*
   针对待处理的其它层的逻辑开发: 由于不同消息类型处理层1，本身为该执行区块，因此
   因此推荐用户如果有其他业务逻辑需求时，不需要再此添加其它层, 采用super.handler处理不同消息类型进行开发
   如果不满足特别需求，可以采用继承该类，然后对该方法进行重写
   例子：
   class CustomWebsocket extends ChatWebsocketServer {
        @override
        void messageHandler(
            HttpRequest request, WebSocket webSocket, dynamic message){
         // 不影响其他逻辑，记得
         super.messageHandler(
            HttpRequest request, WebSocket webSocket, dynamic message);

         // ................其它层逻辑开发.........
        }
   }
    */

    // 1.必要层级: 调用不同消息类型处理  ——> 继承自OtherMsgType类中的handler方法
    super.handler(request, webSocket, msgDataTypeMap!);

    //****************************待处理位置execOnceWebsocketServerMessageBusQueueScheduleTask*******************************************
    // 2.必要层级: *****************被动调用bus Queue总消息队列任务************************
    MessageQueueTask messageQueueTask = MessageQueueTask();
    messageQueueTask.execOnceWebsocketServerMessageBusQueueScheduleTask();
    // super.messageHandler(request, webSocket, message);

    // 3.其他待拓展层......
  }
}
