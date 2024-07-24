/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import '../../../client/common/OtherClientMsgType.dart';
import 'TypeMessageServerHandler.dart';

class TestTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.TEST;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(msgDataTypeMap, clientObject) {
    //
  }
}
