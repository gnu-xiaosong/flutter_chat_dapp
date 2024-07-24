/*
公共数据库DAO
 */

import 'dart:convert';

import 'package:app_template/database/daos/ChatDao.dart';
import 'package:drift/drift.dart';

import '../../../../database/LocalStorage.dart';

class CommonDao {
  ChatDao chatDao = ChatDao();
  /*
  本机发送的聊天数据插入数据库
  Map msgObj 仅为info字段传入
   */
  insertMessageToDataStorage(Map msgObj) {
    //**********************插入数据库*****************************
    // 封装实体
    ChatsCompanion chatsCompanion = ChatsCompanion.insert(
      senderId: Value(msgObj["sender"]["id"]),
      senderUsername: msgObj["sender"]["username"],
      msgType: msgObj["msgType"],
      contentText: msgObj["content"]["text"],
      timestamp: DateTime.parse(msgObj["timestamp"]) ?? DateTime.now(),
      metadataMessageId: msgObj["metadata"]["messageId"],
      //消息状态,消息状态，例如 sent, delivered, read
      metadataStatus: msgObj["metadata"]["status"],
      isGroup: msgObj["recipient"]["type"] == "user" ? 0 : 1,
      senderAvatar: Value(msgObj["sender"]["avatar"]), // 发送者头像
      recipientId:
          Value(msgObj["recipient"]["id"]), //接收者ID（对应user表的唯一id），群聊时为群号',
      contentAttachments:
          Value(json.encode(msgObj["content"]["attachments"])), //附件列表',
    );
    chatDao.insertChat(chatsCompanion);
  }
}
