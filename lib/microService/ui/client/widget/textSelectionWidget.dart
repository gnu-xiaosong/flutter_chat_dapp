import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';

import '../common/NotificationInApp.dart';

class EditableTextToolbarBuilderExampleApp extends StatefulWidget {
  String messageText;
  EditableTextToolbarBuilderExampleApp(this.messageText, {super.key});

  @override
  State<EditableTextToolbarBuilderExampleApp> createState() =>
      _EditableTextToolbarBuilderExampleAppState(messageText);
}

class _EditableTextToolbarBuilderExampleAppState
    extends State<EditableTextToolbarBuilderExampleApp> {
  String messageText;
  _EditableTextToolbarBuilderExampleAppState(this.messageText);
  late MaterialTextSelectionControls _selectionControls;
  late String? selectedText;

  /*
  文本选中按钮菜单
   */
  List<Map> selectedTextMenus = [
    {
      "name": "copy".tr(),
      "icon": Iconify(Ion.copy),
      "click": (String selectedText) {
        // 点击函数
        // 将文本包装在ClipboardData对象中
        ClipboardData clipboardData = ClipboardData(text: selectedText);
        NotificationInApp().success("copy successful!");
        // 使用Clipboard.setData方法将文本复制到剪贴板
        Clipboard.setData(clipboardData).then((_) {
          print("copy: ${selectedText}");
          // 复制成功
          NotificationInApp().success("copy successful".tr());
        }).catchError((Object error) {
          // 复制失败
          NotificationInApp()
              .success('Failed to copy text to clipboard: $error');
        });
      }
    },
    {
      "name": "selectAll".tr(),
      "icon": Icon(Icons.select_all),
      "click": (String selectedText) {
        // 点击函数
      }
    },
    {
      "name": "search".tr(),
      "icon": Iconify(Mdi.search_web),
      "click": (String selectedText) {
        // 点击函数
      }
    },
  ];

  @override
  void initState() {
    super.initState();
    // On web, disable the browser's context menu since this example uses a custom
    // Flutter-rendered context menu.
    if (kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    _selectionControls = MaterialTextSelectionControls();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (kIsWeb) {
      BrowserContextMenu.enableContextMenu();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      messageText.toString().tr(),
      // selectionControls: _selectionControls,
      onSelectionChanged:
          (TextSelection selection, SelectionChangedCause? cause) {
        // 选取文本
        selectedText = messageText.substring(selection.start, selection.end);
      },
      contextMenuBuilder:
          (BuildContext context, EditableTextState editableTextState) {
        // 设置必选菜单
        List<Widget> menus =
            selectedTextMenus.map((Map menu) => menuItemWidget(menu)).toList();

        // 自定义toolbar
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          // Build the default buttons, but make them look custom.
          // In a real project you may want to build different
          // buttons depending on the platform.
          children: menus,
        );
      },
    );
  }

  /*
  menu单style
   */
  Widget menuItemWidget(Map menu) {
    // 更具不同平台
    if (Platform.isIOS) {
      return CupertinoButton(
          borderRadius: null,
          color: Colors.white,
          disabledColor: const Color(0xffaaaaff),
          onPressed: () {
            // 调用方法
            menu["click"](selectedText);
            setState(() {});
            // _selectionControls
          },
          padding: const EdgeInsets.all(10.0),
          pressedOpacity: 0.7,
          child: SizedBox(
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  menu["icon"],
                  SizedBox(
                    width: 20,
                  ),
                  Text(menu["name"])
                ],
              )));
    }
    return MaterialButton(
        color: Colors.white,
        disabledColor: const Color(0xffaaaaff),
        onPressed: () {
          menu["click"](selectedText);
          setState(() {});
        },
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                menu["icon"],
                SizedBox(
                  width: 20,
                ),
                Text(menu["name"])
              ],
            )));
  }
}
