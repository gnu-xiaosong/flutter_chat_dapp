/*
client不同消息类型处理模块
 */
import 'package:app_template/microService/module/common/BroadcastModule.dart';

import '../../../../database/daos/ChatDao.dart';
import '../../../module/common/CommonModule.dart';
import '../../../module/common/DAO/common.dart';
import '../../../module/dao/UserChat.dart';
import '../../../module/encryption/MessageEncrypte.dart';

class ClientMessageModule extends MessageEncrypte {
  // 子类继承共享
  UserChat userChat = UserChat();
  CommonModel commonModel = CommonModel();
  ChatDao chatDao = ChatDao();
  BroadcastModule broadcastModule = BroadcastModule();
  CommonDao commonDao = CommonDao();
}
