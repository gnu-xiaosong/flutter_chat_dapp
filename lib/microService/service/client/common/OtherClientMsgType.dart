import 'package:web_socket_channel/web_socket_channel.dart';
import '../websocket/WebsocketClient.dart';
import '../websocket/messageByTypeHandler/AuthTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/BroadcastInlineClientTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/MessageTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/RequestInlineClientTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/RequestScanAddUserTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/ScanTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/TestTypeMessageHandler.dart';
// 枚举消息类型
enum MsgType { 
AUTH,
BROADCAST_INLINE_CLIENT,
MESSAGE,
REQUEST_INLINE_CLIENT,
REQUEST_SCAN_ADD_USER,
SCAN,
TEST,
}

// Map访问：通过string访问变量
Map<String, dynamic> msgTypeByString = {
 "AUTH": MsgType.AUTH,
 "BROADCAST_INLINE_CLIENT": MsgType.BROADCAST_INLINE_CLIENT,
 "MESSAGE": MsgType.MESSAGE,
 "REQUEST_INLINE_CLIENT": MsgType.REQUEST_INLINE_CLIENT,
 "REQUEST_SCAN_ADD_USER": MsgType.REQUEST_SCAN_ADD_USER,
 "SCAN": MsgType.SCAN,
 "TEST": MsgType.TEST,
};

class OtherClientMsgType extends WebsocketClient {
  List classNames = [AuthTypeMessageHandler(), BroadcastInlineClientTypeMessageHandler(), MessageTypeMessageHandler(), RequestInlineClientTypeMessageHandler(), RequestScanAddUserTypeMessageHandler(), ScanTypeMessageHandler(), TestTypeMessageHandler()];
  void handler(WebSocketChannel? channel, Map msgDataTypeMap) {
    for (var item in classNames) {
      String messageTypeStr = msgDataTypeMap["type"].toUpperCase();
      MsgType? messageType = msgTypeByString[messageTypeStr] as MsgType;
      
      if (messageType == null) {
              print("Unknown message type: messageType==null");
              return;
      }
      
      if (messageType.toString() == item.type.toString()) {
        item.handler(channel, msgDataTypeMap);
        return;
      }
    }
  }
}
