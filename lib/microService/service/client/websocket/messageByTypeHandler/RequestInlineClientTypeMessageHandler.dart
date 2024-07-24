/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../module/manager/GlobalManager.dart';
import '../../../server/module/MessageQueue.dart';
import 'TypeMessageClientHandler.dart';

class RequestInlineClientTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.REQUEST_INLINE_CLIENT;
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 从缓存中取出secret 通讯秘钥
    String? secret = GlobalManager.appCache.getString("chat_secret");
    // 解密info字段
    msgDataTypeMap["info"] = decodeMessage(secret!, msgDataTypeMap["info"]);

    // 请求在线client的Map的msgQueue队列
    requestInlineClient(msgDataTypeMap);
  }

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
}
