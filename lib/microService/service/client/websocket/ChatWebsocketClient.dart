import 'dart:convert';
import 'package:app_template/microService/module/common/tools.dart';
import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../module/common/Console.dart';
import '../../../module/common/enum.dart';
import '../../../module/common/unique_device_id.dart';
import '../../../module/dao/UserChat.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../ui/client/model/CommunicationMessageObject.dart';
import '../../server/model/ErrorObject.dart';
import '../common/tool.dart';

class ChatWebsocketClient extends OtherClientMsgType
    with ClientTool, CommonTool, Console {
  UserChat userChat = UserChat();
  CommunicationMessageObject communicationMessageObject =
      CommunicationMessageObject();
  MessageEncrypte messageEncrypte = MessageEncrypte();

  /*
  client与server连接成功时
   */
  @override
  Future<void> conn_success(WebSocketChannel? channel) async {
    String plait_text = "I am websocket client that want to authenticate";
    String key = "sjkvsbkjdvbsdjvhbsjhvbdsjhvbsdjhvbsdjhvbsdvjs";
    // 设备唯一标识:为了防止安全可以在之前进行安全性检查
    String deviceId = await UniqueDeviceId.getDeviceUuid();
    // 发起身份认证
    Map auth_req = {
      "type": "AUTH",
      "deviceId": deviceId,
      "info": {
        "plait_text": plait_text,
        "key": key,
        "encrypte": generateMd5Secret(key + plait_text)
      }
    };
    // print("-------------------auth encode---------------");
    // 消息加密:采用AUTH级别
    auth_req["info"] = messageEncrypte.encodeAuth(auth_req["info"]);

    // 发送
    try {
      printInfo(">> send: $auth_req");
      channel?.sink.add(json.encode(auth_req));
    } catch (e) {
      printError("-ERR:发送AUTH认证失败!请重新发起认证，连接将中断!");
      // 认证身份异常
      ErrorObject errorObject = ErrorObject(
          type: ErrorType.auth,
          content: "发送AUTH认证失败!请重新发起认证，连接将中断! 详情: ${e.toString()}");
      // 异常处理
      handlerClientError(errorObject);
      // 关闭连接
      channel!.sink.close(status.goingAway);
    }
    // 调用
    super.conn_success(channel);
  }

  /*
  监听消息处理程序
   */
  @override
  void listenMessageHandler(message) {
    printInfo(
        "------------Listened Client Msg Task Successful--------------------");
    // 将string重构为Map
    Map? msgDataTypeMap = stringToMap(message.toString());
    printSuccess(">> receive: $msgDataTypeMap");
    // 根据不同消息类型处理程序
    super.handler(channel, msgDataTypeMap!);
    // 调用
    // super.listenMessageHandler(message);
  }

  /*
  连接中断时
   */
  @override
  void interruptHandler(WebSocketChannel channel) {
    printInfo("+INFO:The client connect is interrupted!");
    // 调用
    // super.interruptHandler(channel);
  }

  /*
  发送获取在线用户deviceId的请求
   */
  void sendRequestInlineClient() {
    Map req = {
      "type": "REQUEST_INLINE_CLIENT",
      "info": {
        "deviceId": UniqueDeviceId.getDeviceUuid(), //请求客户端的设备唯一性id
      }
    };
    // 从缓存中加载秘钥
    String secret = GlobalManager.appCache.getString("chat_secret") ?? "";
    // 加密
    req["info"] =
        MessageEncrypte().encodeMessage(secret, req as Map<String, dynamic>);
    // 发送
    send(json.encode(req));
  }

  /*
  send方法:该方法负责客户端的chat  MESSAGE类型消息发送函数
   */
  bool sendMessage(
      {required String recipientId,
      String? groupOrUser,
      required String contentText,
      String? timestamp,
      String? username,
      String? senderId,
      String? avatar,
      String? msgType,
      Map metadata = const {
        "messageId": "msg123", // 消息的唯一标识符
        "status": "sent" // 消息状态，例如 sent, delivered, read
      },
      List<Map> attachments = const [
        // 附件列表，如图片、文件等（可选）
        {"type": "", "url": "", "name": ""}
      ]}) {
    // 消息封装
    Map msg = communicationMessageObject.message(
        msgType: msgType,
        senderId: senderId,
        username: username,
        avatar: avatar,
        recipientId: recipientId,
        groupOrUser: groupOrUser,
        contentText: contentText,
        attachments: attachments,
        timestamp: timestamp,
        metadata: metadata);

    printError("发送消息: ${msg}");
    String secret = GlobalManager.appCache.getString("chat_secret") ?? "";
    if (secret.isEmpty) {
      print("-warning: 通讯秘钥 'chat_secret' 为空！消息加密失败。");
      return false;
    }

    try {
      msg["info"] = MessageEncrypte().encodeMessage(secret, msg["info"]);
      send(json.encode(msg));
      return true;
    } catch (e) {
      print("发送消息失败：$e");
      return false;
    }
  }
}
