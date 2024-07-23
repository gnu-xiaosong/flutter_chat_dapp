/*
权限管理
 */

import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  void requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    if (status.isGranted) {
      // 权限已授予，可以继续发送通知
    } else {
      // 权限请求被拒绝或未授予
    }
  }
}
