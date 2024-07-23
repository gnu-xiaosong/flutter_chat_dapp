import 'dart:io';
import 'package:path/path.dart' as p;

void main() async {
  final directoryPath =
      '../lib/microService/service/server/websocket/other'; // 指定你的目录
  final outputFilePath =
      '../lib/microService/service/server/common/OtherMsgType.dart'; // 生成代码的文件路径

  // 获取所有 Dart 文件
  final files = _getDartFiles(directoryPath);

  // 提取类名
  List classNames = <String>[];
  for (var file in files) {
    final fileName =
        p.basename(file.path).split(".")[0]; // Extract file name from file path
    if (fileName != "TypeWebsocketCommunication") classNames.add(fileName);
  }

  final buffer = StringBuffer();

  // 写入文件头部
  buffer.writeln('import \'../model/ClientObject.dart\';');
  buffer.writeln('import \'../websocket/WebsocketServer.dart\';');

  // 写入导入语句
  for (var className in classNames) {
    final fileName = className + '.dart'; // 假设文件名与类名相关
    buffer.writeln('import \'../websocket/other/$fileName\';');
  }

  buffer.writeln();
  buffer.writeln('class OtherMsgType extends WebSocketServer {');
  buffer.writeln('List classNames = ${classNames};');
  buffer.writeln(
      '  void other(Map<String, dynamic> msgDataTypeMap, ClientObject clientObject) {');

  buffer.writeln('''
      for (var item in classNames) {
        if (msgDataTypeMap["type"] == item().type) {
          item().handler(msgDataTypeMap, clientObject);
        }
      }''');

  // 写入文件尾部
  buffer.writeln('  }');
  buffer.writeln('}');

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
