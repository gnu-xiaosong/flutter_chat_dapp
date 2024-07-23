/*
  user 级别任务调度
 */
import '../../../module/manager/GlobalManager.dart';
import '../model/ClientObject.dart';

class UserSchedule {
  // 单例实例
  static UserSchedule? _instance;

  // 索引index，用于获取用户client
  int index = 0;

  // 私有构造函数
  UserSchedule._();

  // 获取单例实例
  static UserSchedule getInstance() {
    _instance ??= UserSchedule._();
    return _instance!;
  }

  /*
   * 获取下一个 WebsocketClientObject
   */
  ClientObject? getNextClientObject() {
    print("debug: ${GlobalManager.webscoketClientObjectList.length}");
    // 获取横向客户端index:选取策略
    if (GlobalManager.webscoketClientObjectList.length == 0) {
      print("无在线client");
      return null;
    }

    // 获取对象client
    ClientObject clientObject = GlobalManager.webscoketClientObjectList[index];
    // 执行调度策略:index+1
    clientScheduleStrategyByOrder();

    return clientObject;
  }

  // 调度user client的策略1: 逐步自增
  void clientScheduleStrategyByOrder() {
    if (index++ == (GlobalManager.webscoketClientObjectList.length - 1))
      index = 0;
    print("index=$index");
  }
}
