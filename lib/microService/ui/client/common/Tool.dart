import 'dart:convert';

import '../../../../config/AppConfig.dart';
import '../../../module/common/unique_device_id.dart';

class UiTool {
  /*
  生成加好友二维码的存储信息
   */
  Future<Map> generateAddUserQrInfo() async {
    // 设备唯一性id
    String deviceId = await UniqueDeviceId.getDeviceUuid();
    // 用户名
    String username = AppConfig.username;
    // 封装
    Map re = {"type": "ADD_USER", "deviceId": deviceId, "username": username};

    return re;
  }
}
