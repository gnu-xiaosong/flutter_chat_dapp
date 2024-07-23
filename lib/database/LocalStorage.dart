/*
desc: 这是本地数据库存储类:利用sqlite3引擎，drift包
*/
import 'dart:io';
import 'package:app_template/database/tables/ChatTable.dart';
import 'package:app_template/database/tables/GroupTable.dart';
import 'package:app_template/database/tables/PasswdTable.dart';
import 'package:app_template/database/tables/TaskTable.dart';
import 'package:app_template/database/tables/UserGroupRelationsTable.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:app_template/database/tables/UserTable.dart';
// 创建 LocalStorage 类
part 'LocalStorage.g.dart'; // Drift 将生成这个文件

@DriftDatabase(
    tables: [Users, Chats, Groups, UserGroupRelations, Passwords, Tasks])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection()) {
    print("初始化数据库");
  }

  @override
  int get schemaVersion => 1; // 设置数据库模式版本
}

// 打开数据库连接
LazyDatabase _openConnection() {
  // 数据库名
  String dbname = "app";

  // 打开数据库
  return LazyDatabase(() async {
    // Andriod内部存储
    final dbFolder = await getApplicationDocumentsDirectory();
    // 外部存储
    // 获取外部存储目录
    // final dbFolder = await getExternalStorageDirectory();
    final file = File(p.join(dbFolder.path, '$dbname.sqlite'));

    print("****************************数据库创建*******************************");
    print("db location:$file");
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // 创建数据库连接
    final database = NativeDatabase.createInBackground(file);

    // 设置临时缓存目录
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return database;
  });
}
