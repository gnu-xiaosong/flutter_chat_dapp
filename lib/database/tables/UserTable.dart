/*
desc: 定义数据库表结构:用户表
 */
import 'package:drift/drift.dart';

// 定义用户表
@DataClassName('User')
class Users extends Table {
  /// 自动增量的用户ID，唯一标识用户
  IntColumn get id => integer().autoIncrement()();

  /// 设备唯一id
  TextColumn get deviceId =>
      text().withLength(min: 1, max: 50).customConstraint('NOT NULL UNIQUE')();

  /// 用户名，要求唯一且长度在1到50之间
  TextColumn get username =>
      text().withLength(min: 1, max: 50).customConstraint('NOT NULL UNIQUE')();

  /// 用户邮箱，要求唯一且长度在1到100之间
  TextColumn get email => text()();

  /// 用户密码的哈希值
  TextColumn get passwordHash => text()();

  /// 用户头像的URL，允许为空
  TextColumn get profilePicture => text().withLength(min: 1, max: 50)();

  /// 用户的状态消息，默认为true
  IntColumn get status => integer().nullable()();

  /// 用户创建时间，默认为当前时间
  TextColumn get createdAt => text().withLength(min: 1, max: 50)();

  /// 用户更新时间，默认为当前时间
  TextColumn get updatedAt => text().withLength(min: 1, max: 50)();
}
