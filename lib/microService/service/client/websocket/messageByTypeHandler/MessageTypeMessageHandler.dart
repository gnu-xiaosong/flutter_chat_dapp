/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'package:app_template/microService/module/common/CommonModule.dart';
import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:app_template/microService/module/common/BroadcastModule.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../module/manager/GlobalManager.dart';
import '../../../../module/manager/NotificationsManager.dart';
import '../../../../ui/client/model/enum.dart';
import '../../../../ui/client/module/AudioModule.dart';
import 'TypeMessageClientHandler.dart';

class MessageTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.MESSAGE;

  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 从缓存中取出secret 通讯秘钥
    String? secret = GlobalManager.appCache.getString("chat_secret");
    // 解密info字段
    msgDataTypeMap["info"] = decodeMessage(secret!, msgDataTypeMap["info"]);
    // 接收消息
    printSuccess("receive msg: ${msgDataTypeMap}");
    // 处理
    message(msgDataTypeMap);
  }

  /*
    消息类型:已解密
   */
  void message(Map msgDataTypeMap) {
    BroadcastModule broadcastModule = BroadcastModule();
    printInfo("--------------MESSAGE TASK HANDLER--------------------");
    // 写入数据库
    Map msgObj = msgDataTypeMap["info"];

    // 插入数据库中
    commonDao.insertMessageToDataStorage(msgObj);

    // 写入页面缓存队列中：主要用于，用户页面显示消息取用，省去查询数据库耗时
    String deviceId = msgObj["sender"]["id"]; // 来自发送方deviceId
    printSuccess(
        "inline client userQueue: ${GlobalManager.userMapMsgQueue.length}");
    GlobalManager.userMapMsgQueue[deviceId]!.enqueue(msgObj);

    //****************************自定义业务逻辑*******************************************
    // 广播: 消息来临
    broadcastModule.globalBroadcast(BroadcastType.message);

    // 提示音效
    AudioModel audioModel = AudioModel();
    audioModel.playAudioEffect(Audios.message);
    // 状态栏通知
    NotificationsManager notification = NotificationsManager();
    notification.showNotification(
        title: msgObj["sender"]["username"], body: msgObj["content"]["text"]);
  }
}
