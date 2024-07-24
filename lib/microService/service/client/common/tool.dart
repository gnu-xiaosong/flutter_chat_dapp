import 'dart:io';

import '../../../module/manager/GlobalManager.dart';
import '../../server/model/ClientObject.dart';

mixin ClientTool {
  // 根据deviceId设备ID获取对应于的clientObject对象
  ClientObject? getClientObjectByDeviceId(String deviceId) {
    // 遍历list
    for (ClientObject clientObject in GlobalManager.webscoketClientObjectList) {
      // print(clientObject.deviceId);
      if (clientObject.deviceId == deviceId) return clientObject;
    }
    return null;
  }

  /*
  由HttpRequest request, WebSocket webSocket 获取ClientObject对象
   */
  ClientObject getClientObject(HttpRequest request, WebSocket webSocket) {
    late ClientObject clientObject;
    for (ClientObject clientObject_item
        in GlobalManager.webscoketClientObjectList) {
      // 根据ip地址匹配查找
      if (clientObject_item.ip ==
              request.connectionInfo?.remoteAddress.address ||
          clientObject_item.socket == webSocket) {
        // 匹配成功
        clientObject = clientObject_item;
      }
    }

    return clientObject;
  }
}
