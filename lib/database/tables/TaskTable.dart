import 'package:drift/drift.dart';

// 定义用户表
@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()(); // 自增id字段
  TextColumn get taskId => text().customConstraint('UNIQUE')(); // 任务ID，保证唯一性
  TextColumn get userId => text().nullable()(); // 用户ID，本地存储时不重要
  TextColumn get name => text().withLength(min: 1, max: 255)(); // 任务名，用户自定义
  TextColumn get label => text().nullable()(); // 标签，多个标签用 | 分割
  TextColumn get category => text().nullable()(); // 分类，根据用户自定义的进行分类
  TextColumn get description => text().nullable()(); // 描述，用户自定义描述
  TextColumn get priority =>
      text().withLength(min: 1, max: 10)(); // 级别，三个级别: low, medium, high
  TextColumn get status => text().withLength(
      min: 1, max: 15)(); // 状态，三个状态: pending（待定）、in progress（进行中）、completed（完成）
  DateTimeColumn get createAt => dateTime().nullable()(); // 创建时间
  DateTimeColumn get updateAt => dateTime().nullable()(); // 更新时间
  DateTimeColumn get startTime => dateTime().nullable()(); // 开始执行时间
  DateTimeColumn get endTime => dateTime().nullable()(); // 结束执行时间
}
