/*
聊天用户事务操作
 */

import 'package:app_template/microService/chat/websocket/common/Console.dart';
import 'package:drift/drift.dart';
import '../../../../database/LocalStorage.dart';
import '../../../../database/daos/UserDao.dart';

class UserChat with Console {
  // 实例化DAO
  UserDao userDao = UserDao();
  /*
  查询所有user中的deviceId
   返回deviceId 列表
   */

  Future<List> selectAllUserChat() async {
    List<User> data = await userDao.selectAllUsers();
    List<String> deviceIds = [];
    for (var user in data) {
      deviceIds.add(user.deviceId);
    }
    return deviceIds;
  }

  /*
   添加聊天用户,进入数据库
   */
  Future<void> addUserChat(
      String deviceId, String profilePicture, String username) async {
    try {
      // 1.数据封装
      UsersCompanion usersCompanion = UsersCompanion.insert(
        deviceId: deviceId,
        username: username,
        status: const Value(1),
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        profilePicture: profilePicture,
        email: "",
        passwordHash: "",
      );

      await userDao.insertUser(usersCompanion);
    } catch (e, stacktrace) {
      printCatch("插入数据库, more detail : $e");
      printCatch("Stacktrace: $stacktrace");
    }
  }
}
