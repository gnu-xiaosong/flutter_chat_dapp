/*
  离线消息队列处理类
 */

import 'dart:convert';
import 'package:app_template/microService/module/common/Console.dart';
import 'package:app_template/microService/module/encryption/MessageEncrypte.dart';
import 'package:app_template/microService/module/common/tools.dart';
import 'package:app_template/microService/module/common/unique_device_id.dart';
import 'package:app_template/microService/service/server/model/ClientObject.dart';

import '../../../module/manager/GlobalManager.dart';

class OffLine with Console {
  // 离线消息队列开关
  bool isOffLine = true;

  // 将消息进入离线消息队列中
  Future<bool> enOffLineQueue(String deviceId, Map message) async {
    /*
    参数说明:data  Map
    deviceId  string 发送者设备唯一性id
    msg_map   map    待发送消息  已加密
         必要字段:
          {
             "type":"",
             "info":{
                   "recipient":{
                      "id":"设备唯一性ID"
                      .......
                   },
                   ........
              }
          }
     */
    // 进入离线消息队列中
    try {
      // 获取clientObject
      ClientObject? sendClientObject =
          Tool().getClientObjectByDeviceId(deviceId);
      print("sender:$deviceId");
      if (sendClientObject != null) {
        // 解密
        message["info"] = MessageEncrypte()
            .decodeMessage(sendClientObject!.secret, message["info"]);

        // 内存存储加密
        String key = await UniqueDeviceId.getDeviceUuid();
        message["info"] = MessageEncrypte().encodeMessage(key, message["info"]);

        // 封装离线消息队列Map
        Map offMessage = {"deviceId": deviceId, "msg_map": message};

        GlobalManager.offLineMessageQueue.enqueue(offMessage);
        return true;
      } else {
        // 未发现sender clientObject
        printError("发生程序性错误!未发现sender clientObject!");
        return false;
      }
    } catch (e) {
      printCatch(" msg进入离线消息队列失败!, more detail: $e");
      return false;
    }
  }

  // 执行离线消息队列
  Future<void> offLineHandler() async {
    printInfo("---------Handler Offline Message Queue----------");
    int length = GlobalManager.offLineMessageQueue.length;
    printInfo(
        "OffLine msg counts: ${GlobalManager.offLineMessageQueue.length}");
    while (length-- > 0) {
      printInfo("msg index=$length");
      // 获取当前出队列msg
      Map? msg = GlobalManager.offLineMessageQueue.dequeue();

      // **********切换secret进行文本的加密**********
      String deviceId = msg?["deviceId"]; // 仅仅离线模式才有该字段,发送者
      String secret = await UniqueDeviceId.getDeviceUuid(); // 仅仅离线模式才有该字段，发送者
      printInfo("Offline Msg Type: ${msg?["msg_map"]['type']}");
      // 第一道防护解密: 存储解密
      Map? de_map =
          MessageEncrypte().decodeMessage(secret, msg!["msg_map"]["info"]);

      printInfo("Content msg: $de_map");

      String receive_deviceId = de_map?["recipient"]["id"];

      // client为非server端
      /// (2) 根据device获取clientObject对象
      ClientObject? receive_clientObject =
          Tool().getClientObjectByDeviceId(receive_deviceId);
      if (receive_clientObject == null) {
        // 如果接受者仍然不在线则将该消息重新添加进队列中
        GlobalManager.offLineMessageQueue.enqueue(msg);
      } else {
        /// (3) 根据发送者的secret加密文本
        // 2.第二道防护:加密,通讯秘钥加密
        // (1) 获取目标(接收信息者)的deviceId
        Map reEncode_map = MessageEncrypte().encodeMessage(
            receive_clientObject!.secret, de_map as Map<String, dynamic>);

        // 利用接受者clientObject发送消息
        try {
          // 封装新信息
          Map new_msg = {"type": msg["msg_map"]["type"], "info": reEncode_map};
          receive_clientObject.socket.add(json.encode(new_msg));
        } catch (e) {
          printCatch("离线消息队列发送失败！失败device_id=$deviceId, more detail: $e");
        }
      }
    }

    if (length == 0) {
      printInfo(" 离线消息队列为空!");
    }
  }
}
