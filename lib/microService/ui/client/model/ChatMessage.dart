/*
封装的聊天消息实体
 */
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  // 消息类型:
  String? type;
  // 作者
  types.User? author;
  // 音频、视频的时长
  Duration? duration;
  // 消息唯一标识
  String? id;
  // 附件等的名称
  String? name;
  // 文件大小
  int? size;
  // 文件等的链接
  String? url;
  // 创建日期:秒数
  int? createdAt = DateTime.now().millisecondsSinceEpoch;
  // 文本内容
  String? text;
  // 附件
  List<Map>? attachmentsList;

  ChatMessage(
      {this.type = "text",
      required this.author,
      required this.id,
      this.duration = Duration.zero,
      this.name,
      this.size = 0,
      this.url,
      this.createdAt,
      this.text,
      this.attachmentsList});

  @override
  String toString() {
    return 'ChatMessage('
        'type: $type, '
        'author: $author, '
        'duration: $duration, '
        'id: $id, '
        'name: $name, '
        'size: $size, '
        'url: $url, '
        'createdAt: $createdAt, '
        'text: $text, '
        'attachmentsList: $attachmentsList'
        ')';
  }
}
