import 'package:app_template/states/DarkState.dart';
import 'package:bruno/bruno.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../microService/ui/client/page/AddUserPage.dart';
import '../../microService/ui/client/page/CreateGroupPage.dart';
import '../../microService/ui/client/page/ScanPage.dart';

class DropdownButton1 extends StatefulWidget {
  const DropdownButton1({super.key});

  @override
  State<DropdownButton1> createState() => _DropdownButton1State();
}

class _DropdownButton1State extends State<DropdownButton1> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
        customButton: const Icon(
          Icons.add_circle_outline,
          size: 34,
          color: Colors.blueAccent,
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          //分割线
          const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          ...MenuItems.secondItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 170,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Color(0xFF232323),
          ),
          offset: const Offset(0, 0),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 0, right: 0),
        ));
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [
    add,
    group,
  ];
  static const List<MenuItem> secondItems = [scan];

  //配置
  static const add =
      MenuItem(text: 'add user', icon: Icons.add_outlined); // 添加用户
  static const group =
      MenuItem(text: 'create group', icon: Icons.groups); // 创建群组
  static const scan =
      MenuItem(text: 'scan', icon: Icons.scanner_outlined); // 探测器

  //点击事件
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white70, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text.tr(),
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.add:
        //Do something
        // Provider.of<DarkState>(context, listen: false).changeDarkMode();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return const AddUser();
            },
          ),
        );
        break;
      case MenuItems.group:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return const CreateGroup();
            },
          ),
        );
        break;
      case MenuItems.scan:
        //本地通知测试
        // NotificationsManager notice = GlobalManager.GlobalLocalNotification;
        // notice.showNotification(title: "通知", body: "我是通知内容");
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return ScanPage();
            },
          ),
        );
        break;
    }
  }
}

/// 切换语言
void _changeLocale(BuildContext context) async {
  print("当前语言:" + context.locale.toString());
  print("------------------语言切换---------------------");
  if (context.locale.toString() == 'zh_CH') {
    await context.setLocale(context.supportedLocales[0]);
  } else {
    await context.setLocale(context.supportedLocales[1]);
  }
}

//显示dialog
void showDialog(BuildContext context) {
  BrnDialogManager.showConfirmDialog(context,
      title: "标题内容标题内容标题内容标题内容", cancel: '取消', confirm: '确定', onCancel: () {
    EasyLoading.showError("failse");
  }, onConfirm: () {
    EasyLoading.showSuccess("ok");
  });
  // Dialogs.materialDialog(
  //     msg: 'Are you sure ? you can\'t undo this',
  //     title: "Delete",
  //     color: Colors.white,
  //     context: context,
  //     dialogWidth: kIsWeb ? 0.3 : null,
  //     onClose: (value) => print("returned value is '$value'"),
  //     actions: [
  //       IconsOutlineButton(
  //         onPressed: () {
  //           Navigator.of(context).pop(['Test', 'List']);
  //         },
  //         text: 'Cancel',
  //         iconData: Icons.cancel_outlined,
  //         textStyle: TextStyle(color: Colors.grey),
  //         iconColor: Colors.grey,
  //       ),
  //       IconsButton(
  //         onPressed: () {},
  //         text: "Delete",
  //         iconData: Icons.delete,
  //         color: Colors.red,
  //         textStyle: TextStyle(color: Colors.white),
  //         iconColor: Colors.white,
  //       ),
  //     ]);
}

//显示toast
void showToast(context) {
  /*
  * 配置文档地址：https://pub-web.flutter-io.cn/packages/flutter_easyloading
  *
  * */
  // EasyLoading.show(status: 'loading...');

  // EasyLoading.showProgress(0.3, status: 'downloading...');
  EasyLoading.showSuccess('Great Success!'.tr());
  // EasyLoading.showError('Failed with Error');
  // EasyLoading.showInfo('Useful Information.');
  // EasyLoading.showToast('Toast');
  // EasyLoading.dismiss();
}
