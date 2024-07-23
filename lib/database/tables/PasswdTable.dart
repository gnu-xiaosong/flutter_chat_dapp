// 定义 Passwords 表
import 'package:drift/drift.dart';

// 定义群组表
@DataClassName('Password')
class Passwords extends Table {
  // 自增 ID
  IntColumn get id => integer().autoIncrement()();
  // 用户名:登录密码、支付密码、访问密码、应用密码
  TextColumn get username => text().withLength(min: 1, max: 50)();
  // 服务名
  TextColumn get service => text().withLength(min: 1, max: 50)();
  // 密码
  TextColumn get password => text().withLength(min: 1, max: 100)();
  // 类别
  TextColumn get category => text().withLength(min: 1, max: 50)();
  // 创建时间，默认值为当前时间
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  // 更新时间，默认值为当前时间
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
