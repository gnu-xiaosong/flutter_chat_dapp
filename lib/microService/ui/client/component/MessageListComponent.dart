import 'dart:async';
import 'package:app_template/microService/service/server/module/MessageQueue.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:app_template/database/LocalStorage.dart';
import 'package:random_avatar/random_avatar.dart';
import '../../../../database/daos/UserDao.dart';
import '../../../module/manager/GlobalManager.dart';
import '../model/ChatMessage.dart';
import '../common/TimeChat.dart';
import '../model/ChatUser.dart';
import '../model/enum.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  _ListUserState() {
    userList = [];
  }
  TimeChat timeChat = TimeChat();
  late StreamSubscription<dynamic> _subscription;
  UserDao userDao = UserDao();
  PopupMenu? menu;
  int page = 1; //页码
  int pageNum = 10; // 每页数量
  late List userList;
  late final controller = SlidableController(this as TickerProvider);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loaddata();
    // 设置订阅监听
    _subscription = GlobalManager.globalStream.listen((broadcastType) {
      print("************广播: 消息来临****************");
      if (broadcastType == BroadcastType.message ||
          broadcastType == BroadcastType.refresh ||
          broadcastType == BroadcastType.online) {
        // 刷新UI
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // 取消广播订阅
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          // 对应的user
          User user = userList[index];
          // 获取最新消息
          ChatMessage? message = newMessage(user);
          print("message = ${message}");
          return Slidable(
            key: ValueKey(user),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: doNothing,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: (_) => controller.openEndActionPane(),
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: (_) => controller.close(),
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              child: ListTile(
                onTap: () {
                  // 刷新
                  setState(() {
                    // 清空对应的消息队列: bug 在清空meesage会触发监控
                    GlobalManager.userMapMsgQueue[user.deviceId]?.clear();
                  });
                  // 关闭订阅
                  // _subscription.cancel();
                  // 点击跳转
                  Navigator.pushNamed(context, 'chatPage',
                      arguments: user.deviceId.toString());
                },
                leading: AdvancedAvatar(
                  statusSize: 8,
                  size: 43.w,
                  statusColor:
                      GlobalManager.userMapMsgQueue.containsKey(user.deviceId)
                          ? Colors.green
                          : Colors.blueGrey,
                  // name: user.username,
                  child: RandomAvatar(
                    'saytoonz',
                    fit: BoxFit.fill,
                  ),
                  // image:
                  //     const NetworkImage('https://picsum.photos/id/237/5000/5000'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16.0,
                      ),
                    ],
                  ),
                  children: [
                    AlignCircular(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 0.5,
                          ),
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                            (GlobalManager.userMapMsgQueue
                                        .containsKey(user.deviceId)
                                    ? GlobalManager
                                        .userMapMsgQueue[user.deviceId]!.length
                                    : 0)
                                .toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
                // 最新消息
                subtitle: Text(
                    (message == null
                            ? "not message" // 离线
                            : message.text)
                        .toString()
                        .replaceAll("\n", " ")
                        .tr(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    )), // 在线
                trailing: Text(
                    (message == null
                            ? timeChat.timeParse(DateTime.now()) // 离线
                            : timeChat.timeParse(
                                DateTime.fromMillisecondsSinceEpoch(
                                    message.createdAt!)))
                        .toString()
                        .tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    )),
                title: Text(user.username),
              ),
            ),
          );
        },
      ),
    );

    ;
  }

  /*
  加载数据
   */
  loaddata() {
    // 加载数据
    userDao.selectUserByPage(page, pageNum).then((value) {
      print("------------用户分页显示: page=$page pageNum=$pageNum-----------");
      // 页面重构渲染数据
      setState(() {
        userList = value;
      });
      print(userList);
    });
  }

  /*
  最新消息
   */
  ChatMessage? newMessage(User user) {
    // 封装用户信息
    ChatUser chatUser = ChatUser();
    chatUser.id = user.deviceId;
    chatUser.imageUrl = user.profilePicture;
    chatUser.createdAt = DateTime.parse(user.createdAt).millisecondsSinceEpoch;
    chatUser.updatedAt = DateTime.parse(user.updatedAt).millisecondsSinceEpoch;
    chatUser.firstName = user.username;
    chatUser.lastName = user.username;

    // 封装消息实体
    late ChatMessage? chatMessage;
    // 获取目标MessageQueue对象
    if (GlobalManager.userMapMsgQueue.containsKey(user.deviceId)) {
      // 在线
      MessageQueue? messageQueue = GlobalManager.userMapMsgQueue[user.deviceId];
      // 最新的消息: 不移除
      Map? newMsgMap = messageQueue?.last();

      // 保证存在消息
      if (newMsgMap != null) {
        print("newMsgMap=${newMsgMap}");
        // 封装实体
        chatMessage = ChatMessage(
            type: newMsgMap?["msgType"],
            author: chatUser.user(),
            createdAt: DateTime.parse(newMsgMap?["timestamp"])
                    .millisecondsSinceEpoch ??
                DateTime.now().millisecondsSinceEpoch,
            text: newMsgMap?["content"]["text"],
            url: newMsgMap?["content"]["attachments"].toString(),
            name: newMsgMap?["content"]["attachments"].toString(),
            id: newMsgMap?["metadata"]["messageId"]);
      } else {
        // 否则为空
        chatMessage = null;
      }
    } else {
      chatMessage = null;
    }

    return chatMessage;
  }

  void doNothing(BuildContext context) {}
  /*
  刷新
   */
  Future<void> _onRefresh() async {
    // 重新加载获取数据
    setState(() {
      loaddata();
    });
  }
}
