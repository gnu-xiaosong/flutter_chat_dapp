/*
 这是server端转client接收端的类
 详情: 当server作为client需要与其他client进行通讯时主要运用该类
 */

import 'dart:convert';
import '../encryption/MessageEncrypte.dart';
import '../manager/GlobalManager.dart';
import 'unique_device_id.dart';
import '../../service/server/model/ClientObject.dart';

class ServerTranslateClientChannel extends MessageEncrypte {
  // server端执行：执行离线消息队列
  Future<void> serverOffLineHandler() async {
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

      /// (2) 根据device获取clientObject对象
      ClientObject? receive_clientObject =
          getClientObjectByDeviceId(receive_deviceId);

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
