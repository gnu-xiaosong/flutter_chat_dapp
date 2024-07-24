/*
server 不同消息类型处理模块
 */
import 'dart:convert';
import '../../../../database/daos/ChatDao.dart';
import '../../../module/common/CommonModule.dart';
import '../../../module/dao/UserChat.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/common/BroadcastModule.dart';

class ServerMessageModule extends MessageEncrypte {
  // 子类继承共享
  UserChat userChat = UserChat();
  CommonModel commonModel = CommonModel();
  ChatDao chatDao = ChatDao();
  BroadcastModule broadcastModule = BroadcastModule();

  /*
  获取server在线用户:返回inline client deviceId list
   */
  List<String> getInlineClient(String deviceId) {
    /// 不包括本身
    List<String> deviceList = GlobalManager.webscoketClientObjectList
        .where((clientObject) {
          if (clientObject.deviceId != deviceId && clientObject.connected) {
            return true;
          }
          return false;
        })
        .map((clientObject) => clientObject.deviceId)
        .toList();

    return deviceList;
  }

  /*
   广播在线client用户
   */
  void broadcastInlineClients() {
    print("**************Broadcast Inline Clients*********************");
    // 获取在线的clientObject
    List deviceIdList = [];

    // 遍历clientObject
    for (var clientObject in GlobalManager.webscoketClientObjectList) {
      if (clientObject.connected && clientObject.status == 1) {
        deviceIdList.add(clientObject.deviceId.toString());
      }
    }

    // 数据封装
    Map msg = {
      "type": "BROADCAST_INLINE_CLIENT",
      "info": {"type": "list", "deviceIds": deviceIdList}
    };

    printInfo("inline Clients: ${msg}");
    // 广播发送
    for (var clientObject in GlobalManager.webscoketClientObjectList) {
      // 判断能够发送的client
      if (clientObject.connected && clientObject.status == 1) {
        // 数据加密: 暂时不加密，因为有bug
        // msg["info"] =
        //     messageEncrypte.encodeMessage(clientObject.secret, msg["info"]);
        // 发送
        clientObject.socket.add(json.encode(msg));
      }
    }
  }
}
