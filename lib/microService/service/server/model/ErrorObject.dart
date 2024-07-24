/*
异常或错误实体
 */

import '../../../module/common/enum.dart';

class ErrorObject {
  // 异常发生时间
  DateTime time;

  // 异常内容
  String? content;

  // 错误类别
  ErrorType? type;

  // 错误位置
  List? position;

  // 构造函数
  ErrorObject({
    DateTime? time,
    this.content,
    this.type,
    this.position,
  }) : time = time ?? DateTime.now();

  // 返回错误对象的字符串表示形式
  @override
  String toString() {
    return 'ErrorObject(time: $time, content: $content, type: $type, position: $position)';
  }
}
