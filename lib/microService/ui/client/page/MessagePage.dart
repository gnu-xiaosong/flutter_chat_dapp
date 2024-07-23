import 'package:app_template/microService/ui/client/config/menuConfig.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import '../../../../config/AppConfig.dart';
import '../../../module/manager/GlobalManager.dart';
import '../component/MessageListComponent.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  _ChatListState() {}
  GlobalKey btnKeyMenu = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 加载websocket
    GlobalManager().GlobalChatWebsocket.bootWebsocket();
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
        body: Container(child: ListUser()));
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

  void onClickMenu(PopUpMenuItemProvider item) {
    for (var menu in topMenus()) {
      if (menu["menu"] == item) {
        menu["click"](context);
      }
    }
    print('Click menu -> ${item.menuTitle}');
  }
}
