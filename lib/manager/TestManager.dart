/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 测试工具类
 */
import 'package:app_template/microService/chat/websocket/common/Console.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../database/LocalStorage.dart';
import '../database/daos/UserDao.dart';
import '../microService/chat/websocket/common/unique_device_id.dart';

class TestManager with Console {
  // 公共调试函数
  static void debug() {
    print("------------------debug task test-----------");
    // 调试ADO
    testADO();
  }

  //http返回数据打印输出
  static void textPrint(Response response) {
    print("----------------------测试调试-----------------");
    print("请求状态: ${response?.statusCode}");
    print("请求头: ${response?.headers}");
    print("请求参数: ${response?.requestOptions.toString()}");
    print("返回数据: ${response?.data}");
  }

  // sqlite数据库调试
  static Future<void> testADO() async {
    print("************************deviceId********************************");

    // 实例化DAO
    UserDao userDao = UserDao();
    List testUsers = [
      {"deviceId": "b643f058-6863-5662-92c2-2db852aa7c96", "username": '虚拟机'},
      // {"deviceId": "b23d70ea-a5f4-542e-b7d2-59e6dfbb89e6", "username": '小米手机'},
      {"deviceId": "f453f6df-3677-540c-b27f-1d855492cfaa", "username": '小松科技'},
    ];
    try {
      late String deviceId;
      late String username;
      String comp_deviceId = await UniqueDeviceId.getDeviceUuid();
      print(comp_deviceId);
      testUsers.forEach((element) {
        if (element["deviceId"] != comp_deviceId) {
          // 获取
          deviceId = element["deviceId"];
          username = element["username"];
        }
      });

      // 1.数据封装
      UsersCompanion usersCompanion = UsersCompanion.insert(
        deviceId: deviceId,
        username: username,
        status: const Value(1),
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        profilePicture: "profilePicture",
        email: "",
        passwordHash: "",
      );

      await userDao.insertUser(usersCompanion);
    } catch (e, stacktrace) {
      print("插入数据库, more detail : $e");
      print("Stacktrace: $stacktrace");
    }
  }
}
