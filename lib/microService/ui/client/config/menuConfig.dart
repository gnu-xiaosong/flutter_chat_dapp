import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import 'package:app_template/microService/ui/client/page/AddUserPage.dart';
import 'package:app_template/microService/ui/client/page/CreateGroupPage.dart';
import 'package:app_template/microService/ui/client/page/ScanPage.dart';

import '../component/AddUserQrComponent.dart';

List menus = <Map>[
  {
    "menu": PopUpMenuItem(
        title: 'add user'.tr(),
        image: const Icon(Icons.add_outlined, color: Colors.white)),
    "click": (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const AddUser();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'scan'.tr(),
        image: const Icon(Icons.scanner_outlined, color: Colors.white)),
    "click": (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const CreateGroup();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'scan'.tr(),
        image: const Icon(Icons.scanner_outlined, color: Colors.white)),
    "click": (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ScanPage();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'socket'.tr(),
        image: const Icon(Icons.settings_input_antenna_rounded,
            color: Colors.white)),
    "click": (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const AddUser();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'QR'.tr(),
        image: const Icon(Icons.qr_code, color: Colors.white)),
    "click": (BuildContext context) {
      print("-----------------error---------------------");
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const AddUserQr();
          },
        ),
      );
    }
  },
];

// 顶部下拉菜单栏
List topMenus() {
  return menus;
}

void onDismiss() {
  print('Menu is dismiss');
}

void onShow() {
  print('Menu is show');
}
