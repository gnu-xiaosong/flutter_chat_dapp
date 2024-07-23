/*
总线调度
 */
import '../../../module/manager/GlobalManager.dart';
import '../model/ClientObject.dart';
import 'UserSchedule.dart';

class BusSchedule {
  // 私有的命名构造函数
  BusSchedule._internal();

  // 保存单例实例的静态私有变量（懒加载）
  static BusSchedule? _instance;

  // 工厂构造函数，返回单例实例
  factory BusSchedule() {
    // 如果实例为空，则创建一个新的实例
    _instance ??= BusSchedule._internal();
    return _instance!;
  }

  // 总线调度：返回WebsocketClientObject对象,单词调用一次message
  ClientObject? busSchedule() {
    // 获取横向坐标: 调用userSchedule
    UserSchedule userSchedule = GlobalManager().GlobalUserSchedule;
    // 获取纵向坐标：按时间先后顺序
    ClientObject? websocketClientObject = userSchedule.getNextClientObject();

    return websocketClientObject;
  }
}
