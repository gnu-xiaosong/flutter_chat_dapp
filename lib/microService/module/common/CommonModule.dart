/*
公共函数库
 */

import 'dart:convert';
import 'package:app_template/database/daos/ChatDao.dart';
import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../database/LocalStorage.dart';
import '../manager/GlobalManager.dart';

class CommonModel {
  ChatDao chatDao = ChatDao();

  /*
  去除已经掉线的
   */
  void removeOfflineDevices(List<String> commonList) {
    List<String> keysToRemove = [];

    // 收集需要移除的键
    GlobalManager.userMapMsgQueue.forEach((deviceId, queue) {
      if (!commonList.contains(deviceId)) {
        keysToRemove.add(deviceId);
      }
    });

    // 移除并处理这些键
    for (var deviceId in keysToRemove) {
      GlobalManager.userMapMsgQueue[deviceId]?.clear();
      GlobalManager.userMapMsgQueue.remove(deviceId);
    }
  }

  /*
  获取页面传递过来的deviceId
   */
  getDeviceId(BuildContext context) {
    late String? deviceId;
    // 获取路由传递过来的roomId
    try {
      // 正常获取
      deviceId = ModalRoute.of(context)!.settings.arguments.toString();
      // 存储在缓存中
      GlobalManager.appCache.setString("receiveDeviceId", deviceId!);

      // 多层判断
      if (GlobalManager.appCache.containsKey("receiveDeviceId")) {
        deviceId ??= GlobalManager.appCache.getString("receiveDeviceId");
      } else {
        // 提示
        MotionToast.error(
                title: Text("Warning".tr()),
                description: Text(
                    "appCache not did containsKey is receiveDeviceId".tr()))
            .show(context);
      }
    } catch (e) {
      // 页面刷新获取
      if (GlobalManager.appCache.containsKey("receiveDeviceId")) {
        // 存在
        deviceId = GlobalManager.appCache.getString("receiveDeviceId");
      } else {
        // 提示
        MotionToast.error(
                title: Text("Warning".tr()),
                description: Text(
                    "appCache not did containsKey is receiveDeviceId".tr()))
            .show(context);
      }
    }

    // 判断
    if (deviceId == null) {
      // 提示
      MotionToast.error(
              title: Text("System error".tr()),
              description: Text("deviceId is empty!".tr()))
          .show(context);
    }
    return deviceId;
  }
}
