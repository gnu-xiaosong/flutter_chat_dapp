/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../module/dao/UserChat.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../../ui/client/module/ClientModule.dart';
import 'TypeMessageClientHandler.dart';

class RequestScanAddUserTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.REQUEST_SCAN_ADD_USER;
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 通过扫码请求添加好友请求
    // 从缓存中取出secret 通讯秘钥
    String? secret = GlobalManager.appCache.getString("chat_secret");
    // 解密info字段
    msgDataTypeMap["info"] = decodeMessage(secret!, msgDataTypeMap["info"]);
    // 调用
    scanQrAddUser(msgDataTypeMap);
  }

  /*
  扫描Qr添加用户: widget用户UI
   */
  Future<void> scanQrAddUser(Map msgDataTypeMap) async {
    // msgDataTypeMap为明文，未加密
    UserChat userChat = UserChat();
    ClientModel clientModel = ClientModel();

    printInfo('Starting scanQrAddUser'); // 开始执行 scanQrAddUser 函数

    // 判断请求类型: request or response
    if (msgDataTypeMap['info']["type"] == "request") {
      // 来自请求方处理逻辑: 接收方
      printInfo('Handling request type'); // 处理请求类型
      await clientModel.addUserMsgQueue(msgDataTypeMap); // 将消息添加到待同意好友消息队列中
      await clientModel.replayAddStatus(); // 异步执行测试函数
    } else {
      // 来自响应方处理逻辑: 扫码方
      printInfo(
          '****************Handling response type*********************'); // 处理响应类型
      String status = msgDataTypeMap['info']["status"]; // 获取响应状态
      printInfo('Response status: $status'); // 打印响应状态

      // 同意好友请求
      if (status == "agree") {
        // 解密秘钥
        String? secret = await GlobalManager.appCache.getString("chat_secret");
        printInfo('User agreed'); // 对方已同意
        int count = GlobalManager.clientWaitUserAgreeQueue.length; // 获取消息队列数
        print("clientWaitUserAgreeQueue length: ${count}");
        while (count-- > 0) {
          // 取出等待同意消息，进行解密
          Map? messageQueue =
              await GlobalManager.clientWaitUserAgreeQueue.dequeue(); // 异步出队列
          Map? tmp_messageQueue = messageQueue; // 牺牲内存换计算性能
          // 解密info字段
          messageQueue?["info"] = decodeMessage(secret!, messageQueue["info"]);

          if (messageQueue != null &&
              messageQueue["info"]["confirm_key"] ==
                  msgDataTypeMap['info']["confirm_key"]) {
            // 匹配成功，插入数据库中
            printInfo(
                'Matching confirm_key found, adding user chat'); // 匹配 confirm_key 成功
            try {
              printInfo(
                  "-----%%%%--------------handling the response for add user by scan -------------%%%%%%%-------------");
              // print(messageQueue);
              // 添加进数据库  messageQueue
              userChat.addUserChat(
                  messageQueue["info"]["recipient"]["id"],
                  messageQueue["info"]["recipient"]["avatar"],
                  messageQueue["info"]["recipient"]["username"]);
              printSuccess("user add to database is successful!");
            } catch (e) {
              printCatch(
                  "add user insert to database failure! more detail: $e");
              // 重新添加进队列中
              GlobalManager.clientWaitUserAgreeQueue.enqueue(tmp_messageQueue!);
            }
          } else {
            // 队列中msg为空或握手秘钥有误
            printWarn(
                "this clientWaitUserAgreeQueue is empty or both confirm_key is error!");
            printWarn(
                "warning detail: messageQueue=${messageQueue} msgDataTypeMap=${msgDataTypeMap}");
          }
        }
      } else if (status == "disagree") {
        // 同意好友请求拒绝
        printWarn("Other user disagreed"); // 对方拒绝
      } else {
        // 同意好友请求
        printWarn("Other user is waiting"); // 处于等待
      }
    }
  }
}
