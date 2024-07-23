/*
client不同消息类型处理模块
 */

import 'package:app_template/microService/module/common/unique_device_id.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app_template/microService/service/server/module/MessageQueue.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../module/manager/GlobalManager.dart';
import '../../../module/manager/NotificationsManager.dart';
import '../../../module/model/CommonModule.dart';
import '../../../ui/client/model/enum.dart';
import '../../../ui/client/module/AudioModule.dart';
import '../../../ui/client/module/BroadcastModule.dart';
import '../../../ui/client/module/ClientModule.dart';
import '../../../module/common/Console.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/dao/UserChat.dart';

class ClientMessageModel extends CommonModel with Console {
  MessageEncrypte messageEncrypte = MessageEncrypte();
  UserChat userChat = UserChat();
  BroadcastModel broadcastModel = BroadcastModel();
  CommonModel commonModel = CommonModel();

  // 音效类
  AudioModel audioModel = AudioModel();
  /*
  处理server端广播得到的在线client用户
   */
  Future<void> receiveInlineClients(Map msgDataTypeMap) async {
    printSuccess(
        "******************处理从server接收到的在线client***********************");

    print("local deviceId: ${await UniqueDeviceId.getDeviceUuid()}");
    // 1.获取deviceId 列表
    List<dynamic> dynamicDeviceIdList = msgDataTypeMap["info"]["deviceIds"];
    printWarn("server user:${dynamicDeviceIdList}");
    List<String> deviceIdList =
        dynamicDeviceIdList.map((e) => e.toString()).toList();

    // 2.与数据库中对比:剔除一部分
    List deviceIdListInDatabase =
        await userChat.selectAllUserDeviceIdChat(); //获取数据库中所有user的DeviceId
    printWarn("database user:${deviceIdListInDatabase}");
    Set<String> deviceIdList_set = deviceIdList.toSet(); //转化为集合
    Set<String> deviceIdListInDatabase_set =
        deviceIdListInDatabase.map((e) => e.toString()).toSet();
    // 集合取交集
    Set<String> commonDeviceIds =
        deviceIdList_set.intersection(deviceIdListInDatabase_set);
    // 3.将其存入缓存中
    List<String> commonList = commonDeviceIds.toList();
    GlobalManager.appCache.setStringList("inline_deviceId_list", commonList);

    // 4.创建为每个clientObject对象，采用list存储
    for (String deviceId in commonList) {
      // 判断全局变量中是否存在该队列
      if (!GlobalManager.userMapMsgQueue.containsKey(deviceId)) {
        // 不存在，创建
        GlobalManager.userMapMsgQueue[deviceId] = MessageQueue();
      }
    }
    // 5.去除全局中已经掉线的item
    commonModel.removeOfflineDevices(commonList);

    // 6.广播: 请求在线用户数online、消息来临message
    broadcastModel.globalBroadcast(BroadcastType.online);

    printInfo("client chat user msg queue: ${GlobalManager.userMapMsgQueue}");
    printInfo("userMapMsgQueue count:${GlobalManager.userMapMsgQueue.length}");
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
          messageQueue?["info"] =
              messageEncrypte.decodeMessage(secret!, messageQueue["info"]);

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

  /*
  发送消息给server以响应请求方scan扫码添加好友的请求
   */
  // sendMsgToServerResponseScanRequest(Map msgDataTypeMap) {
  //   // 修改关键数据
  //   msgDataTypeMap["info"]["type"] = "response";
  //   late Map temp;
  //   temp = msgDataTypeMap["info"]["sender"];
  //   msgDataTypeMap["info"]["sender"] = msgDataTypeMap["info"]["recipient"];
  //   msgDataTypeMap["info"]["recipient"] = temp;
  //
  //   // 加密
  //   msgDataTypeMap["info"] = MessageEncrypte().encodeMessage(
  //       GlobalManager.appCache.getString("chat_secret").toString(),
  //       msgDataTypeMap["info"]);
  //
  //   // 发送
  //   GlobalManager()
  //       .GlobalChatWebsocket
  //       .chatWebsocketClient
  //       .send(json.encode(msgDataTypeMap));
  // }

  /*
   处理server在线client用户:调用即可
   */
  void requestInlineClient(Map msgDataTypeMap) {
    printSuccess(
        "*****************requestInlineClient***************************");
    // 1.获取deviceId 列表
    List<String> deviceIdList = msgDataTypeMap["info"]["deviceId"];
    // 2.将其存入缓存中
    GlobalManager.appCache.setStringList("deviceId_list", deviceIdList);
    // 3.创建为每个clientObject对象，采用list存储
    for (String deviceId in deviceIdList) {
      // 为每个deviceId设置一个全局的消息队列
      GlobalManager.userMapMsgQueue[deviceId] = MessageQueue();
    }
    printInfo("userMapMsgQueue:${GlobalManager.userMapMsgQueue}");
  }

  /*
    客户端请求局域网内服务端server的请求
   */
  void scan(WebSocketChannel? channel, Map msgDataTypeMap) {
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
  void auth(WebSocketChannel? channel, Map msgDataTypeMap) {
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
    消息类型:已解密
   */
  void message(Map msgDataTypeMap) {
    printInfo("--------------MESSAGE TASK HANDLER--------------------");
    // 写入数据库
    Map msgObj = msgDataTypeMap["info"];

    // 插入数据库中
    insertMessageToDataStorage(msgObj);

    // 写入页面缓存队列中：主要用于，用户页面显示消息取用，省去查询数据库耗时
    String deviceId = msgObj["sender"]["id"]; // 来自发送方deviceId
    printSuccess(
        "inline client userQueue: ${GlobalManager.userMapMsgQueue.length}");
    GlobalManager.userMapMsgQueue[deviceId]!.enqueue(msgObj);

    //****************************自定义业务逻辑*******************************************
    // 广播: 消息来临
    broadcastModel.globalBroadcast(BroadcastType.message);

    // 提示音效
    AudioModel audioModel = AudioModel();
    audioModel.playAudioEffect(Audios.message);
    // 状态栏通知
    NotificationsManager notification = NotificationsManager();
    notification.showNotification(
        title: msgObj["sender"]["username"], body: msgObj["content"]["text"]);
  }

  /*
 其他未标识消息类型
  */
  void other(Map msgDataTypeMap) {
    // 其他消息类型：明文传输
    printInfo("receive other  msg:${msgDataTypeMap}");
  }
}
