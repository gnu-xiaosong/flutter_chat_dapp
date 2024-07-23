/*
该类文件为websocket通讯传输消息实体封装类
 */
import '../../../../config/AppConfig.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../module/model/MessageObject.dart';

class CommunicationMessageObject extends MessageObject {
  /*
  type: MESSAGE
  普通消息
   */
  Map message(
      {String? msgType, //消息类型
      senderId, // 发送者设备唯一ID
      username, //发送者用户名
      avatar, //发送者头像
      recipientId, // 接受者设备唯一性ID
      groupOrUser, //接收者类型，例如 group 表示群组消息，user 表示私聊消息
      contentText, // 发送信息文本
      List<Map>? attachments = const [
        {
          "type": "image",
          "url": "https://example.com/image.jpg",
          "name": "image.jpg"
        }
      ], // 附件：list
      String? timestamp, // 时间
      // 数据元
      required Map metadata}) {
    Map msg = {
      "type": "MESSAGE",
      "info": {
        "msgType": msgType ?? "text", // 消息类型: text,file,link......
        "sender": {
          "id": senderId ?? GlobalManager.deviceId, // , // 设备唯一标识
          // 发送者的唯一标识符
          "username": username ?? AppConfig.username, //,
          // 发送者用户名
          "avatar": avatar ?? "avatar" // 发送者头像（可选）
        },
        "recipient": {
          "id": recipientId, // 私聊设备唯一标识,群聊为群号
          "type": groupOrUser ?? "user" //接收者类型，例如 group 表示群组消息，user 表示私聊消息
        },
        "content": {
          "text": contentText, // 文本消息内容
          /*附件：list
            [ // 附件列表，如图片、文件等（可选）
            {
              "type": "image",
              "url": "https://example.com/image.jpg",
              "name": "image.jpg"
            }]
           */
          "attachments": attachments
        },
        // 消息发送时间戳
        "timestamp": timestamp ?? DateTime.now().toString(),
        /*必选字段
            {
          "messageId": "msg123",
          // 消息的唯一标识符
          "status": "sent" // 消息状态，例如 sent, delivered, read
        }
         */
        "metadata": metadata
      }
    };
    return msg;
  }
}
