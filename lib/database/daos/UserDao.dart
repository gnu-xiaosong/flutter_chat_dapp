/*
desc: UserDao类DAO操作: DAO类集中管理 CRUD 操作
*/
import 'package:app_template/database/LocalStorage.dart';
import 'package:app_template/database/daos/BaseDao.dart';
import 'package:drift/drift.dart';
import '../../microService/module/common/Console.dart';
import '../../microService/module/manager/GlobalManager.dart';

class UserDao extends BaseDao with Console {
  // 获取database单例
  LocalDatabase db = GlobalManager.database;

  // 获取所有user
  Future<List<User>> selectAllUsers() async {
    // 构建查询
    List<User> query = await (db.select(db.users)).get();

    // 将查询结果转换为 User 的列表
    return query;
  }

  /*
  根据deviceId获取user
   */
  Future<User> selectUserByDeviceId(String deviceId) async {
    // 构建查询
    final query = db.select(db.users)
      ..where((tbl) => tbl.deviceId.equals(deviceId));

    // 查询
    List<User> result = (await query.get());

    return result[0];
  }

  // 获取用户，分页查询，按时间查询
  Future<List> selectUserByPage(int page, int pageNum) {
    /*
      page: 页面 1,2.。。。
      pageNum: 每页数量
     */
    final offset = (page - 1) * pageNum;
    // 构建查询
    final query = (db.select(db.users)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ])
          ..limit(pageNum, offset: offset))
        .get();

    // 将查询结果转换为 User 的列表
    return query;
  }

  // 插入数据
  Future<bool> insertUser(UsersCompanion usersCompanion) async {
    try {
      await db.into(db.users).insert(usersCompanion);
      return true; // 插入成功，返回 true
    } catch (e, stacktrace) {
      printCatch("用户插入失败: $e");
      printCatch("Stacktrace: $stacktrace");
      return false;
    }
  }

  // 更新数据
  updateUser(UsersCompanion usersCompanion) async {
    int result = 0;
    await db.update(db.users)
      ..where((tbl) => tbl.id.equals(usersCompanion.id as int))
      ..write(usersCompanion).then((value) {
        print("update result: $value");
        result = value;
      });

    return result;
  }

  // 删除数据
  int deleteUser(UsersCompanion usersCompanion) {
    // 删除条数
    int result = 0;
    db.delete(db.users)
      ..where((tbl) => tbl.id.equals(usersCompanion.id as int))
      ..go().then((value) {
        print("delete data count: $value");
        result = value;
      });

    return result;
  }
}
