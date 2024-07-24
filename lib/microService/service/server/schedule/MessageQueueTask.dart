/*
 websocket server端处理主线bus消息队列
 */

import 'dart:convert';
import 'package:app_template/microService/module/encryption/MessageEncrypte.dart';
import 'package:app_template/microService/module/common/tools.dart';
import 'package:app_template/microService/service/client/common/tool.dart';
import '../../../module/common/Console.dart';
import '../../../module/manager/GlobalManager.dart';
import 'OffLineHandler.dart';
import '../../../service/server/model/ClientObject.dart';

class MessageQueueTask with Console, CommonTool, ClientTool {
  // 私有构造函数
  MessageQueueTask._internal();

  // 静态私有变量，但不立即初始化
  static MessageQueueTask? _instance;

  // 工厂构造函数
  factory MessageQueueTask() {
    _instance ??= MessageQueueTask._internal();
    return _instance!;
  }

  // 执行一次webscoket serverbus消息队列任务调度一次
  Future<void> execOnceWebsocketServerMessageBusQueueScheduleTask() async {
    // 单例模式: 实例化 busSchedule
    // BusSchedule busSchedule = BusSchedule();

    // 循环处理
    int clientCount = GlobalManager.webscoketClientObjectList.length;
    int index = 0;
    printInfo("client count: $clientCount");
    // 循环调度
    while (index < clientCount) {
      printInfo("client index=$index");
      // 获取 调度的clientObj
      ClientObject? clientObject =
          GlobalManager.webscoketClientObjectList[index];

      if (clientObject == null) {
        printWarn("BusSchedule returned a null clientObject");
        index++; // 增加 index 避免死循环
        continue;
      }

      // 执行
      if (clientObject.connected && clientObject.status == 1) {
        printInfo("-----------------busSchedule---------------");
        // 发送 send 消息
        printInfo("client index=$index");

        if (clientObject.messageQueue.length == 0) {
          printWarn(
              "由于该clientOdject的消息队列为空，故忽略该 client: ${clientObject.ip}:${clientObject.port} connect=${clientObject.connected} status=${clientObject.status}");
          // 消息队列为空
          index++; // 增加 index 避免死循环
          continue;
        }
        //*******************正式开始发送消息给目标客户端策略：在线直接发送，不在线append离线消息队列中*****************************
        // 1. 获取消息对象: 这里必须要修改调GlobalManager.webscoketClientObjectList[index]的消息队列
        Map? msg_map = GlobalManager
            .webscoketClientObjectList[index].messageQueue
            .dequeue();

        // 解密消息
        msg_map!["info"] = MessageEncrypte()
            .decodeMessage(clientObject.secret, msg_map["info"]);
        printSuccess("解密消息: $msg_map");
        // 2.获取接受者的deviceId
        String receive_deviceId = msg_map["info"]["recipient"]["id"];

        // 3.获取接受者的clientObject
        ClientObject? receive_clientObject =
            getClientObjectByDeviceId(receive_deviceId);
        if (receive_clientObject == null ||
            receive_clientObject.connected == false) {
          // 接收者处于离线状态: 将消息append进入离线消息队列中
          if (await OffLine().enOffLineQueue(clientObject.deviceId, msg_map)) {
            printInfo("data=$msg_map  进入离线消息队列successful!");
          }
        } else {
          // client在线直接发送消息给receiveClient
          if (receive_clientObject.status == 1) {
            // 4.加密消息
            msg_map["info"] = MessageEncrypte()
                .encodeMessage(receive_clientObject!.secret, msg_map["info"]);
            // 5.发送
            try {
              receive_clientObject.socket.add(json.encode(msg_map));
              printInfo("发送给接受方成功!");
            } catch (e) {
              printCatch(
                  "MESSAGE: send to ${receive_clientObject.ip}:${receive_clientObject.port} deviceId=${receive_clientObject.deviceId} is failure!");
              printCatch("more detail: $e");
            }
          } else {
            // 该client处于异常状态
            printWarn(
                "该client处于异常状态: status code=${receive_clientObject.status}");
          }
        }
      } else {
        printWarn(
            "该clientObject 由于connected=${clientObject.connected} status=${clientObject.status} 故被忽略");
        index++;
        continue;
      }
      index++; // 防止死循环
    }

    printSuccess("完成一次消息阵列调度");
  }
}
