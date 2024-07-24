import 'dart:io';
import '../websocket/WebsocketServer.dart';
import '../websocket/messageByTypeHandler/AuthTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/MessageTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/RequestInlineClientTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/RequestScanAddUserTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/ScanTypeMessageHandler.dart';
import '../websocket/messageByTypeHandler/TestTypeMessageHandler.dart';
// 枚举消息类型
enum MsgType { 
AUTH,
MESSAGE,
REQUEST_INLINE_CLIENT,
REQUEST_SCAN_ADD_USER,
SCAN,
TEST,
}

// Map访问：通过string访问变量
Map<String, dynamic> msgTypeByString = {
 "AUTH": MsgType.AUTH,
 "MESSAGE": MsgType.MESSAGE,
 "REQUEST_INLINE_CLIENT": MsgType.REQUEST_INLINE_CLIENT,
 "REQUEST_SCAN_ADD_USER": MsgType.REQUEST_SCAN_ADD_USER,
 "SCAN": MsgType.SCAN,
 "TEST": MsgType.TEST,
};

class OtherMsgType extends WebSocketServer {
      List classNames = [AuthTypeMessageHandler(), MessageTypeMessageHandler(), RequestInlineClientTypeMessageHandler(), RequestScanAddUserTypeMessageHandler(), ScanTypeMessageHandler(), TestTypeMessageHandler()];
      void handler(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
          for (var item in classNames) {
            String messageTypeStr = msgDataTypeMap["type"].toUpperCase();
            MsgType? messageType = msgTypeByString[messageTypeStr] as MsgType;
            
            if (messageType == null) {
              print("Unknown message type: messageType==null");
              return;
            }
            
            if (messageType.toString() == item.type.toString()) {
              item.handler(request, webSocket, msgDataTypeMap);
              return;
            }
          }
        }
   }
