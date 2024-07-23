import 'package:app_template/database/LocalStorage.dart';
import 'package:app_template/manager/GlobalManager.dart';
import 'package:app_template/microService/chat/widget/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/AppConfig.dart';
import '../../../../database/daos/UserDao.dart';
import 'package:random_avatar/random_avatar.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  _ChatListState() {
    userList = [];
  }
  UserDao userDao = UserDao();
  GlobalKey btnKeyMenu = GlobalKey();
  PopupMenu? menu;
  int page = 1; //页码
  int pageNum = 10; // 每页数量
  late List userList;
  late final controller = SlidableController(this as TickerProvider);
  //获取控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    // 加载websocket
    GlobalManager().GlobalChatWebsocket.bootWebsocket();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          iconTheme: IconThemeData(
            color: Colors.blue,
            opacity: 0.5,
          ),
          leadingWidth: 50,
          titleSpacing: 1,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.chat_bubble_outlined,
                color: Colors.blue,
              ),
              onPressed: () {
                //
              },
            );
          }),
          title: Column(children: [
            Text(
              AppConfig.appConfig['name'].toString().tr(),
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "我是小标题".tr(),
              style: const TextStyle(fontSize: 10),
            ),
          ]),
          actions: [
            IconButton(
              key: btnKeyMenu,
              onPressed: () {
                showMenu();
              },
              icon: const Icon(
                Icons.add,
                size: 35,
              ),
            )
          ],
          actionsIconTheme: IconThemeData(
            color: Colors.blue,
          ),
          shadowColor: Theme.of(context).shadowColor,
          flexibleSpace: SizedBox(
            width: double.infinity,
            height: 160,
            child: Image.network(
              "https://ts1.cn.mm.bing.net/th/id/R-C.d4822697ad0424efafe6b62e5e6e0d1d?rik=ZdcMlu%2f2ng6ltA&riu=http%3a%2f%2fimg95.699pic.com%2fphoto%2f40141%2f5356.gif_wh860.gif&ehk=OMCk8kp7dU8UKPdcHORkcrjitRqABE0xoh7sa%2baGN4k%3d&risl=1&pid=ImgRaw&r=0",
              fit: BoxFit.cover,
            ),
          ),
        ),
        body: listUser());
  }

  Widget listUser() {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (context, index) {
        User item = userList[index];
        return Slidable(
          key: ValueKey(item),
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
          child: ListTile(
            onTap: () {
              // 点击跳转
              Navigator.pushNamed(context, 'chatPage',
                  arguments: item.deviceId.toString());
            },
            leading: randomAvatar('saytoonz', height: 50, width: 50),
            subtitle: Text(item.createdAt),
            trailing: Text(item.id.toString()),
            title: Text(item.username),
          ),
        );
      },
    );
  }

  void doNothing(BuildContext context) {}

  void onClickMenu(PopUpMenuItemProvider item) {
    for (var menu in topMenus()) {
      if (menu["menu"] == item) {
        menu["click"](context);
      }
    }
    print('Click menu -> ${item.menuTitle}');
  }

  void showMenu() {
    PopupMenu menu = PopupMenu(
      context: context,
      config: const MenuConfig(
        type: MenuType.grid,
        backgroundColor: Colors.black,
        lineColor: Colors.white70,
        maxColumn: 2,
      ),
      items: <PopUpMenuItem>[for (var item in topMenus()) item["menu"]],
      onClickMenu: onClickMenu,
      onDismiss: onDismiss,
    );
    menu.show(widgetKey: btnKeyMenu);
  }
}
