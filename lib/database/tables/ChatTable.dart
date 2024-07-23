import 'package:drift/drift.dart';

// 定义聊天表
@DataClassName('Chat')
class Chats extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增主键
  TextColumn get senderId =>
      text().withLength(min: 1, max: 50).nullable()(); // 发送者ID
  TextColumn get senderUsername =>
      text().withLength(min: 1, max: 50)(); // 发送者用户名
  TextColumn get senderAvatar => text().nullable()(); // 发送者头像
  TextColumn get recipientId =>
      text().withLength(min: 1, max: 50).nullable()(); // 接收者ID
  IntColumn get isGroup => integer()(); // 是否为群聊： 0 不是 1 是
  TextColumn get msgType => text().withLength(min: 1, max: 20)(); // 消息类型
  TextColumn get contentText => text().withLength(min: 1, max: 1000)(); // 文本内容
  TextColumn get contentAttachments => text().nullable()(); // 附件列表
  DateTimeColumn get timestamp => dateTime()(); // 时间戳
  TextColumn get metadataMessageId =>
      text().withLength(min: 1, max: 50)(); // 消息ID
  TextColumn get metadataStatus => text().withLength(min: 1, max: 20)(); // 消息状态
}
