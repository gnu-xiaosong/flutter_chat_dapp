import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final directoryPath =
      '../lib/microService/service/server/websocket/messageByTypeHandler'; // 指定你的目录
  final outputFilePath =
      '../lib/microService/service/server/common/OtherMsgType.dart'; // 生成代码的文件路径

  // 获取所有 Dart 文件
  final files = _getDartFiles(directoryPath);

  // 提取类名
  List classNames = <String>[];
  for (var file in files) {
    final fileName =
        p.basename(file.path).split(".")[0]; // Extract file name from file path
    if (fileName != "TypeMessageServerHandler") classNames.add(fileName);
  }

  final buffer = StringBuffer();

  // 写入文件头部
  buffer.writeln('''import 'dart:io';
import '../websocket/WebsocketServer.dart';''');

  // 写入导入语句
  for (var className in classNames) {
    final fileName = className + '.dart'; // 假设文件名与类名相关
    buffer.writeln('''import '../websocket/messageByTypeHandler/$fileName';''');
  }

  buffer.writeln("// 枚举消息类型");

  // 生成消息类别的枚举
  buffer.writeln('enum MsgType { ');
  for (var className in classNames) {
    String type = className.toString().replaceAll("TypeMessageHandler", "");
    type = _addUnderscores(type).toUpperCase();
    buffer.writeln('${type},');
  }
  buffer.writeln('}');
  buffer.writeln();

  // 生成Map通过String访问变量
  buffer.writeln('''// Map访问：通过string访问变量
Map<String, dynamic> msgTypeByString = {''');
  for (var className in classNames) {
    String type = className.toString().replaceAll("TypeMessageHandler", "");
    type = _addUnderscores(type).toUpperCase();
    // 枚举与键名相同
    buffer.writeln(''' "${type}": MsgType.${type},''');
  }
  buffer.writeln('};');
  buffer.writeln();

  buffer.writeln('''class OtherMsgType extends WebSocketServer {
      List classNames = ${classNames.map((e) => e.toString() + "()").toList()};
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
   }''');

  // 写入文件
  await File(outputFilePath).writeAsString(buffer.toString());
  print('代码生成完毕，文件路径：$outputFilePath');
}

List<File> _getDartFiles(String directoryPath) {
  final dir = Directory(directoryPath);
  return dir
      .listSync(recursive: true)
      .where((file) {
        return file is File && file.path.endsWith('.dart');
      })
      .cast<File>()
      .toList();
}

String _addUnderscores(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
    return '${match.group(1)}_${match.group(2)}';
  });
}
