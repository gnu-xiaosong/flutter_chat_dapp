/*
client客户端功能模块
 */
import 'dart:convert';
import 'package:app_template/microService/module/encryption/MessageEncrypte.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../module/manager/GlobalManager.dart';
import '../../../service/client/websocket/ChatWebsocketClient.dart';

class ClientModel extends ChatWebsocketClient {
  late Map decode_msg;

  /*
  好友请求处理方法一: 弹窗提示
  scan Qr instance dialog to show
   */
  addUserMsgQueue(Map data) async {
    try {
      // 通讯秘钥
      String? secret = await GlobalManager.appCache.getString("chat_secret");
      // 加密info字段
      data?["info"] = messageEncrypte.encodeMessage(secret!, data["info"]);

      // 添加进消息队列中
      GlobalManager.clientWaitUserAgreeQueue.enqueue(data);
    } catch (e) {
      printCatch("ERROR: the wait user agree process som error in enqueue!");
    }
  }

  /*
  回复扫码添加好友状态
   */
  replayAddStatus() {
    Map? single = GlobalManager.clientWaitUserAgreeQueue.dequeue();
    singleAgreeUserHandler(single!);
  }

  /*
  处理等待好友同意消息队列: 单条消息信息处理
  mag 铭文未加密
      {
     "type": "REQUEST_SCAN_ADD_USER",
     "info": {
         // 发送方：扫码方
         "sender": {"id": send_deviceId, "username": qr_map["username"]},
         // 接收方: 等待接受
         "recipient": {"id": qr_map["deviceId"], "username": AppConfig.username},
         // 留言
         "content": qr_map["msg"] // 这个字段不是二维码扫描出的，而是用户自定义加上去的
     }
 }
   */
  singleAgreeUserHandler(Map msg) {
    // 数据解密
    // 解密秘钥
    String? secret = GlobalManager.appCache.getString("chat_secret");
    // 解密info字段
    msg?["info"] = messageEncrypte.decodeMessage(secret!, msg["info"]);

    this.decode_msg = msg;

    printSuccess("扫码数据: ${this.decode_msg}");
    return QuickAlert.show(
      context: GlobalManager.context,
      type: QuickAlertType.confirm,
      title: 'add user request'.tr(),
      confirmBtnText: 'Agree'.tr(),
      cancelBtnText: 'Cancel'.tr(),
      barrierDismissible: false,
      confirmBtnColor: Colors.green,
      // customAsset: 'assets/images/logo.png',
      widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 15),
        Text(
          'from'.tr() + ": " + msg["info"]["sender"]["id"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'username'.tr() + ": " + msg["info"]["sender"]["username"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'leave message'.tr() + ": " + msg["info"]["content"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ]),
      onCancelBtnTap: cancelAgreeUser,
      onConfirmBtnTap: confirmAgreeUser,
    );
  }

  /*
  拒绝好友申请
  msg map 已经解密
   */
  cancelAgreeUser() {
    Map msg = this.decode_msg;
    // 发送消息给服务端
    msg["info"]["type"] = "response"; // 响应
    msg["info"]["status"] = "disagree"; // 拒绝

    // sender 与 recipient互换
    Map tmp = msg["info"]["sender"];
    msg["info"]["sender"] = msg["info"]["recipient"];
    msg["info"]["recipient"] = tmp;

    // 消息加密
    msg["info"] = MessageEncrypte().encodeMessage(
        GlobalManager.appCache.getString("chat_secret").toString(),
        msg["info"]);
    // 发送消息
    send(json.encode(msg));
  }

  /*
  同意好友申请,已解密
   */
  confirmAgreeUser() {
    Map msg = this.decode_msg;
    printInfo("------send agreee------");
    printInfo("msg: $msg");
    try {
      // 写入数据库中
      userChat.addUserChat(
          msg["info"]["sender"]["id"].toString(),
          msg["info"]["sender"]["avatar"].toString(),
          msg["info"]["sender"]["username"].toString());

      // 发送消息给服务端
      msg["info"]["type"] = "response"; // 响应
      msg["info"]["status"] = "agree"; // 同意
      // sender 与 recipient互换
      Map tmp = msg["info"]["sender"];
      msg["info"]["sender"] = msg["info"]["recipient"];
      msg["info"]["recipient"] = tmp;

      // 消息加密
      msg["info"] = MessageEncrypte().encodeMessage(
          GlobalManager.appCache.getString("chat_secret").toString(),
          msg["info"]);

      // 发送请求给服务端
      GlobalManager()
          .GlobalChatWebsocket
          .chatWebsocketClient
          .send(json.encode(msg));
      // 打印
      printSuccess("response send to request is successful!");
    } catch (e, stacktrace) {
      printCatch("add user response, more detail : $e"); // 打印异常信息
      printCatch("Stacktrace: $stacktrace"); // 打印调用栈信息
    }
    // 返回
    Navigator.of(GlobalManager.context).pop();
  }
}
