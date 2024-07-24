/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:web_socket_channel/status.dart' as status;
import 'package:app_template/microService/service/client/common/OtherClientMsgType.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'TypeMessageClientHandler.dart';

class ScanTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.SCAN;
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 解密info字段
    msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);
    //处理逻辑
    scan(channel, msgDataTypeMap);
  }

  /*
    客户端请求局域网内服务端server的请求
   */
  void scan(WebSocketChannel? channel, Map msgDataTypeMap) {
    // 打印消息
    printInfo("--------------SCAN TASK HANDLER--------------------");
    printTable(msgDataTypeMap);
    try {
      if (int.parse(msgDataTypeMap["info"]["code"]) == 200) {
        // 扫描成功
        printSuccess("INFO: ${msgDataTypeMap["info"]["msg"]}");
      } else {
        // 扫描失败
        printFaile("FAILURE: ${msgDataTypeMap["info"]["msg"]}");
      }
    } catch (e) {
      // 非法字段
      printCatch(
          "ERR:the server is not authen! this conn will interrupt!more detail: ${e.toString()}");

      channel!.sink.close(status.goingAway);
    }

    //************************其他处理: 记录日志等******************************
  }
}
