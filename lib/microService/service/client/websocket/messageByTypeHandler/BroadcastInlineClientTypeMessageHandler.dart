/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../module/common/unique_device_id.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../../ui/client/model/enum.dart';
import '../../../server/module/MessageQueue.dart';
import 'TypeMessageClientHandler.dart';

class BroadcastInlineClientTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.BROADCAST_INLINE_CLIENT;
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    //处理逻辑
    receiveInlineClients(msgDataTypeMap);
  }

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
    broadcastModule.globalBroadcast(BroadcastType.online);

    printInfo("client chat user msg queue: ${GlobalManager.userMapMsgQueue}");
    printInfo("userMapMsgQueue count:${GlobalManager.userMapMsgQueue.length}");
  }
}
