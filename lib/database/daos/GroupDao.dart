/*
desc: UserDao类DAO操作: DAO类集中管理 CRUD 操作
*/
import 'package:app_template/database/LocalStorage.dart';
import 'package:app_template/database/daos/BaseDao.dart';

import '../../microService/module/manager/GlobalManager.dart';

class GroupDao implements BaseDao<Group> {
  // 查询数据
  Future<List> selectGroup(GroupsCompanion groupsCompanion) async {
    // 获取database单例
    var db = GlobalManager.database;

    // 构建查询
    final query = db.select(db.groups)
      ..where((tbl) => tbl.id.equals(groupsCompanion.id.value));
    // 获取查询结果
    final result = await query.get();

    // 将查询结果转换为 UserData 的列表
    return result.toList();
  }

  // 插入数据
  Future<dynamic> insertGroup(GroupsCompanion groupsCompanion) async {
    // 获取database单例
    var db = GlobalManager.database;

    // 构建
    final result = await db.batch((batch) {
      batch.insertAll(db.groups, [groupsCompanion]);
    });

    return result;
  }

  // 更新数据
  Future<int> updateGroup(GroupsCompanion groupsCompanion) async {
    // 获取database单例
    var db = GlobalManager.database;
    int result = 0;
    await db.update(db.groups)
      ..where((tbl) => tbl.id.equals(groupsCompanion.id.value))
      ..write(groupsCompanion).then((value) {
        print("update result: $value");
        result = value;
      });

    return result;
  }

  // 删除数据
  int deleteGroup(GroupsCompanion groupsCompanion) {
    // 获取database单例
    var db = GlobalManager.database;
    // 删除条数
    int result = 0;
    db.delete(db.groups)
      ..where((tbl) => tbl.id.equals(groupsCompanion.id.value))
      ..go().then((value) {
        print("delete data count: $value");
        result = value;
      });

    return result;
  }
}
