import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../module/manager/GlobalManager.dart';
import '../model/enum.dart';

class UserOnlineStatus extends StatefulWidget {
  String? deviceId;
  UserOnlineStatus(this.deviceId, {super.key});

  @override
  State<UserOnlineStatus> createState() => _IndexState(deviceId);
}

class _IndexState extends State<UserOnlineStatus> {
  String? deviceId;
  late StreamSubscription<dynamic> _subscription;
  late bool isInline;
  _IndexState(this.deviceId);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅广播流: 判断用户在线状态
    _subscription =
        GlobalManager.globalStreamController.stream.listen((broadcastType) {
      print("****************广播: online**********************");

      if (broadcastType == BroadcastType.online) {
        // 监听逻辑处理
        setState(() {
          isInline = GlobalManager.userMapMsgQueue.containsKey(deviceId);
          // 全局
          GlobalManager.isOnline = isInline;
        });
      }
    });
  }

  @override
  void dispose() {
    // 取消订阅
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isInline = GlobalManager.userMapMsgQueue.containsKey(deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      isInline ? "online".tr() : "offline".tr(),
      style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isInline ? Colors.green : Colors.red),
    );
  }
}
