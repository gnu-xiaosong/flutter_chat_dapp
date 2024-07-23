/*
封装在应用内的通知与提示，区别于系统层的通知
 */
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/clarity.dart';

class NotificationInApp {
  NotificationInApp() {
    // 全局配置
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }
  /*
  提示toast: success
   */
  success(String text) {
    EasyLoading.instance
      ..animationStyle = EasyLoadingAnimationStyle.offset
      // ..textPadding = EdgeInsets.all(5)
      ..contentPadding = EdgeInsets.fromLTRB(5, 8, 5, 8);
    EasyLoading.showToast(text, toastPosition: EasyLoadingToastPosition.bottom);
  }

  /*
  提示toast: error
   */
  error(String text) {
    var cancel =
        BotToast.showCustomText(toastBuilder: (void Function() cancelFunc) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          Iconify(Clarity.error_standard_line), // widget
          // 文字显示
          Text(text)
        ],
      );
    });
  }

  /*
  提示toast: warning
   */
  warning(String text) {
    var cancel =
        BotToast.showCustomText(toastBuilder: (void Function() cancelFunc) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          Iconify(Clarity.warning_standard_line), // widget
          // 文字显示
          Text(text)
        ],
      );
    });
  }

  /*
  toast: 信息提示
   */
  info(String text) {
    var cancel =
        BotToast.showCustomText(toastBuilder: (void Function() cancelFunc) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          Iconify(Clarity.info_standard_line), // widget
          // 文字显示
          Text(text)
        ],
      );
    });
  }

  /*
  toast: custom自定义
   */
  customToast(Widget icon, String text) {
    var cancel =
        BotToast.showCustomText(toastBuilder: (void Function() cancelFunc) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 图标
          icon,
          // 文字显示
          Text(text)
        ],
      );
    });
  }
}
