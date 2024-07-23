/*
client不同消息类型处理模块
 */

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app_template/microService/chat/websocket/model/MessageQueue.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../../database/LocalStorage.dart';
import '../../../../database/daos/ChatDao.dart';
import '../../../../database/daos/UserDao.dart';
import '../../../../manager/GlobalManager.dart';
import 'ClientModel.dart';
import 'Console.dart';
import 'MessageEncrypte.dart';
import 'UserChat.dart';

class ClientMessageModel with Console {
  MessageEncrypte messageEncrypte = MessageEncrypte();
  UserChat userChat = UserChat();
  // 消息类型
  late Map msgDataTypeMap;

  /*
  处理server端广播得到的在线client用户
   */
  Future<void> receiveInlineClients() async {
    print("******************处理从server接收到的在线client***********************");
    // 1.获取deviceId 列表
    List<String> deviceIdList = msgDataTypeMap["info"]["deviceIds"];
    // 2.与数据库中对比:剔除一部分
    List deviceIdListInDatabase = await userChat.selectAllUserChat();
    Set<String> deviceIdList_set = deviceIdList.toSet();
    Set<String> deviceIdListInDatabase_set =
        deviceIdListInDatabase.map((e) => e.toString()).toSet();
    // 集合取交集
    Set<String> commonDeviceIds =
        deviceIdList_set.intersection(deviceIdListInDatabase_set);
    // 3.将其存入缓存中
    List<String> commonList = commonDeviceIds.toList();
    GlobalManager.appCache.setStringList("deviceId_list", commonList);
    // 4.创建为每个clientObject对象，采用list存储
    for (String deviceId in commonList) {
      // 判断全局变量中是否存在该队列
      if (!GlobalManager.userMapMsgQueue.containsKey("")) {
        // 不存在，创建
        GlobalManager.userMapMsgQueue[deviceId] = MessageQueue();
      }
    }

    printInfo("userMapMsgQueue count:${GlobalManager.userMapMsgQueue.length}");
  }

  /*
  扫描Qr添加用户: widget用户UI
   */
  Future<void> scanQrAddUser() async {
    // msgDataTypeMap为明文，未加密
    UserChat userChat = UserChat();
    ClientModel clientModel = ClientModel();

    printInfo('Starting scanQrAddUser'); // 开始执行 scanQrAddUser 函数

    // 判断请求类型: request or response
    if (msgDataTypeMap['info']["type"] == "request") {
      // 请求方处理逻辑
      printInfo('Handling request type'); // 处理请求类型
      await clientModel.addUserMsgQueue(msgDataTypeMap); // 将消息添加到待同意好友消息队列中
      await clientModel.test(); // 异步执行测试函数
    } else {
      // 响应方处理逻辑
      printInfo('Handling response type'); // 处理响应类型
      String status = msgDataTypeMap['info']["status"]; // 获取响应状态
      printInfo('Response status: $status'); // 打印响应状态

      if (status == "agree") {
        // 解密秘钥
        String? secret = await GlobalManager.appCache.getString("chat_secret");
        printInfo('User agreed'); // 对方已同意
        int count = GlobalManager.clientWaitUserAgreeQueue.length; // 获取消息队列数
        while (count-- > 0) {
          // 取出等待同意消息，进行解密
          Map? messageQueue =
              await GlobalManager.clientWaitUserAgreeQueue.dequeue(); // 异步出队列
          Map? tmp_messageQueue = messageQueue; // 牺牲内存换计算性能
          // 解密info字段
          messageQueue?["info"] =
              messageEncrypte.decodeMessage(secret!, messageQueue["info"]);

          if (messageQueue != null &&
              messageQueue["info"]["confirm_key"] ==
                  msgDataTypeMap['info']["confirm_key"]) {
            // 匹配成功，插入数据库中
            printInfo(
                'Matching confirm_key found, adding user chat'); // 匹配 confirm_key 成功
            try {
              print("-------------------there--------------------------");
              userChat.addUserChat(
                  msgDataTypeMap?["info"]["recipient"]["id"],
                  msgDataTypeMap?["info"]["recipient"]["avatar"],
                  msgDataTypeMap?["info"]["recipient"]["username"]);
            } catch (e) {
              printCatch(
                  "add user insert to database failure! more detail: $e");
              // 重新添加进队列中
              GlobalManager.clientWaitUserAgreeQueue.enqueue(tmp_messageQueue!);
            }
          }
        }
      } else if (status == "disagree") {
        printWarn("Other user disagreed"); // 对方拒绝
      } else {
        printWarn("Other user is waiting"); // 处于等待
      }
    }
  }

  /*
   处理server在线client用户
   */
  void requestInlineClient() {
    // 1.获取deviceId 列表
    List<String> deviceIdList = msgDataTypeMap["info"]["deviceId"];
    // 2.将其存入缓存中
    GlobalManager.appCache.setStringList("deviceId_list", deviceIdList);
    // 3.创建为每个clientObject对象，采用list存储
    deviceIdList.map((deviceId) {
      // 为每个deviceId设置一个全局的消息队列
      GlobalManager.userMapMsgQueue[deviceId] = MessageQueue();
    });
    printInfo("userMapMsgQueue:${GlobalManager.userMapMsgQueue}");
  }

  /*
    客户端请求局域网内服务端server的请求
   */
  void scan(WebSocketChannel? channel) {
    // 打印消息
    printInfo("--------------SCAN TASK HANDLER--------------------");
    printTable(msgDataTypeMap);
    try {
      if (int.parse(msgDataTypeMap["info"]["code"]) == 200) {
        // 扫描成功
        printSuccess("INFO: ${msgDataTypeMap["info"]["msg"]}");
      } else {
        // 扫描失败
        printFaile("FAILURE: ${msgDataTypeMap["info"]["msg"]}");
      }
    } catch (e) {
      // 非法字段
      printCatch(
          "ERR:the server is not authen! this conn will interrupt!more detail: ${e.toString()}");

      channel!.sink.close(status.goingAway);
    }

    //************************其他处理: 记录日志等******************************
  }

  /*
    客户端client 第一次请求认证服务端server
   */
  void auth(WebSocketChannel? channel) {
    // 打印消息
    printInfo("--------------AUTH TASK HANDLER--------------------");
    printInfo(">> receive: $msgDataTypeMap");

    try {
      if (int.parse(msgDataTypeMap["info"]["code"]) == 200) {
        // 认证成功
        printSuccess("+INFO: ${msgDataTypeMap["info"]["msg"]}");
        // 存储通讯秘钥secret
        String secret = msgDataTypeMap["info"]["secret"].toString();
        GlobalManager.appCache.setString("chat_secret", secret);
      } else {
        // 扫描失败
        printFaile("-FAILURE: ${msgDataTypeMap["info"]["msg"]}");
      }
    } catch (e) {
      // 非法字段
      printCatch(
          "-ERR: ${e.toString()} server is not authed! this conn will interrupt!");
      channel!.sink.close(status.goingAway);
    }
    //************************其他处理: 记录日志等******************************
  }

  /*
    消息类型
   */
  void message() {
    printInfo("--------------MESSAGE TASK HANDLER--------------------");
    // 调用消息处理函数
    handlerMessgae(msgDataTypeMap);
    //***********************Message Type  Handler*******************************
  }

  //客户端接收消息处理函数
  void handlerMessgae(msgDataTypeMap) {
    // 信息为map类型
    // print("--------------client消息处理函数-------------");
    // 写入数据库中
    // 消息
    Map msgObj = msgDataTypeMap["info"];

    // 1.实例化ChatDao事务操作类
    ChatDao chatDao = ChatDao();

    // 转为字符
    msgObj["content"]["attachments"] =
        msgObj["content"]["attachments"].toString();

    // 写入页面缓存队列中：主要用于，用户页面显示消息取用，省去查询数据库耗时
    String deviceId = msgObj["sender"]["id"]; // 来自发送方deviceId
    GlobalManager.userMapMsgQueue[deviceId]!.enqueue(msgObj);

    // 封装实体
    ChatsCompanion chatsCompanion = ChatsCompanion(
        senderId: msgObj["senderId"], //发送者ID,
        senderUsername: msgObj["sender"]["username"], // 发送者用户名
        senderAvatar: msgObj["sender"]["avatar"], // 发送者头像
        recipientId: msgObj["recipient"]["id"], //接收者ID（对应user表的唯一id），群聊时为群号',
        msgType: msgObj["recipient"]["type"], //接收者类型
        contentText: msgObj["content"]["text"], //文本内容',
        contentAttachments: msgObj["content"]["attachments"], //附件列表',
        timestamp: msgObj["timestamp"], //时间戳,
        metadataMessageId: msgObj["metadata"]["messageId"], //消息ID',
        //消息状态,消息状态，例如 sent, delivered, read
        metadataStatus: msgObj["metadata"]["status"]);
    // 写入数据库中
    chatDao.insertChat(chatsCompanion).then((value) {
      printInfo("+INFO: 插入消息结果:$value");
    });
  }

  /*
 其他未标识消息类型
  */
  void other() {
    // 其他消息类型：明文传输
  }
}
