/*
* @Author: xskj
* @Date: 2023-12-29 13:25:12
* @LastEditors: xskj
* @LastEditTime: 2023-12-29 13:40:14
* @Description: 用户身份工具类
*/

import 'package:safe_device/safe_device.dart';

class UserAuthManager {
  /*
    平台状态检测
   */
  Future<Map> platformState() async {
    bool isJailBroken = false;
    bool isMockLocation = false;
    bool isRealDevice = true;
    bool isOnExternalStorage = false;
    bool isSafeDevice = false;
    bool isDevelopmentModeEnable = false;
    try {
      // 检查设备是否越狱在iOS/Android?
      isJailBroken = await SafeDevice.isJailBroken;

      // 这个设备可以模拟位置-不需要root!
      isMockLocation = await SafeDevice.isMockLocation;

      // 是虚拟机还是真机
      isRealDevice = await SafeDevice.isRealDevice;

      // (ANDROID ONLY)检查应用程序是否在外部存储上运行
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;

      // (ANDROID ONLY)检查设备上是否启用了开发选项
      isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;

      //检查设备是否违反上述任何一项
      isSafeDevice = await SafeDevice.isSafeDevice;
    } catch (error) {
      print(error);
    }

    // 封装
    Map result = {
      "isJailBroken": isJailBroken,
      "isMockLocation": isMockLocation,
      "isRealDevice": isRealDevice,
      "isOnExternalStorage": isOnExternalStorage,
      "isDevelopmentModeEnable": isDevelopmentModeEnable,
      "isSafeDevice": isSafeDevice,
    };
    return result;
  }
}
