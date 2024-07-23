/*
广播机制模块
 */

import '../../../module/manager/GlobalManager.dart';

class BroadcastModel {
  /*
  全局广播
   */
  void globalBroadcast(dynamic data) {
    // 广播
    GlobalManager.globalStreamController.sink.add(data);
  }
}
