/*
desc: 定义数据库表结构:群组表
 */
import 'package:drift/drift.dart';

// 定义群组表
@DataClassName('Group')
class Groups extends Table {
  /// 自增的群组ID，唯一标识一个群组
  IntColumn get id => integer().autoIncrement()();

  /// 群组名称，必须唯一且长度在1到50个字符之间
  TextColumn get name => text()
      .withLength(min: 1, max: 50)
      .nullable()
      .customConstraint('NOT NULL UNIQUE')();

  /// 群组描述，可为空
  TextColumn get description => text().nullable()();

  /// 群组创建时间，默认为当前时间
  TextColumn get createdAt =>
      text().withDefault(Constant(DateTime.now().toIso8601String()))();

  /// 群组更新时间，默认为当前时间
  TextColumn get updatedAt =>
      text().withDefault(Constant(DateTime.now().toIso8601String()))();
}
