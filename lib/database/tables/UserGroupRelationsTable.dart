/*
desc: 定义数据库表结构:用户群组关系表： 多对多
 */
import 'package:drift/drift.dart';

// 定义用户和群组之间的关系表
@DataClassName('UserGroupRelation')
class UserGroupRelations extends Table {
  /// 自增的关系ID，唯一标识一条关系
  IntColumn get id => integer().autoIncrement()();

  /// 用户ID，表示一个群组成员
  IntColumn get userId => integer()();

  /// 群组ID，表示用户所属的群组
  IntColumn get groupId => integer()();

  /// 用户是否为群组管理员
  BoolColumn get isAdmin => boolean().withDefault(Constant(false))();

  /// 用户加入群组的时间，默认为当前时间
  TextColumn get joinedAt =>
      text().withDefault(Constant(DateTime.now().toIso8601String()))();
}
