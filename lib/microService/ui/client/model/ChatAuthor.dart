/*
第三方聊天用户实体
 */
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:app_template/microService/ui/client/model/User.dart';

import '../../../module/manager/GlobalManager.dart';

class ChatAuthor extends User {
  // 创建日期: 秒
  int? createdAt;
  // 用户唯一标识符
  String? id = GlobalManager.deviceId.toString();
  // 姓
  String? firstName;
  // 名
  String? lastName;
  // 头像链接
  String? imageUrl;
  // 数据元
  Map<String, dynamic>? metadata;
  // 角色: 默认角色用户
  types.Role? role = types.Role.user;
  // 更新日期: 秒
  int? updatedAt;

  /*
  chat的user，本机
   */
  types.User user() {
    return types.User(
      // 创建日期: 秒
      createdAt: createdAt,
      // 用户唯一标识符
      id: id.toString(), // 唯一用户 ID
      // 姓
      firstName: firstName,
      // 名
      lastName: lastName,
      // 头像链接
      imageUrl: imageUrl,
      // 数据元
      metadata: metadata,
      // 角色
      role: role,
      // 更新日期: 秒
      updatedAt: updatedAt,
    );
  }
}
