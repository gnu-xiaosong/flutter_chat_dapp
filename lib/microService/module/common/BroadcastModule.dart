/*
广播机制模块
 */

import '../manager/GlobalManager.dart';

class BroadcastModule {
  /*
  全局广播
   */
  void globalBroadcast(dynamic data) {
    // 广播
    GlobalManager.globalStreamController.sink.add(data);
  }
}
