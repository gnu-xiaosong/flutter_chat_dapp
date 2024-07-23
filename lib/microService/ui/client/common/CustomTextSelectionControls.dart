// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class CustomTextSelectionControls extends TextSelectionControls {
//   final List<Map> selectedTextMenus;
//
//   CustomTextSelectionControls(this.selectedTextMenus);
//
//   @override
//   Widget buildHandle(
//       BuildContext context, TextSelectionHandleType type, double textLineHeight,
//       [VoidCallback? onTap]) {
//     final Widget handle = SizedBox(
//       width: 20.0,
//       height: 20.0,
//       child: Material(
//         color: Colors.blue,
//         shape: CircleBorder(),
//         elevation: 4.0,
//       ),
//     );
//     return GestureDetector(
//       onTap: onTap,
//       child: handle,
//     );
//   }
//
//   @override
//   Widget buildToolbar(
//     BuildContext context,
//     Rect globalEditableRegion,
//     double textLineHeight,
//     Offset selectionMidpoint,
//     List<TextSelectionPoint> endpoints,
//     TextSelectionDelegate delegate,
//     ValueListenable<ClipboardStatus>? clipboardStatus,
//     Offset? lastSecondaryTapDownPosition,
//   ) {
//     final double toolbarHeight = 48.0;
//     final double toolbarWidth = 200.0;
//     final Offset anchorAbove = Offset(selectionMidpoint.dx - toolbarWidth / 2,
//         selectionMidpoint.dy - toolbarHeight);
//     final Offset anchorBelow =
//         Offset(selectionMidpoint.dx - toolbarWidth / 2, selectionMidpoint.dy);
//
//     return CompositedTransformFollower(
//       link: LayerLink(),
//       offset: anchorAbove.dy < 0 ? anchorBelow : anchorAbove,
//       child: Container(
//         width: toolbarWidth,
//         height: toolbarHeight,
//         color: Colors.grey[200],
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: selectedTextMenus
//               .map((menu) => menuItemWidget(menu, delegate))
//               .toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget menuItemWidget(Map menu, TextSelectionDelegate delegate) {
//     // 根据不同平台
//     if (Platform.isIOS) {
//       return CupertinoButton(
//           borderRadius: null,
//           color: Colors.black45,
//           onPressed: () {
//             // 调用方法
//             menu["click"](delegate.textEditingValue.selection
//                 .textInside(delegate.textEditingValue.text));
//             delegate.hideToolbar();
//           },
//           padding: const EdgeInsets.all(10.0),
//           pressedOpacity: 0.7,
//           child: SizedBox(
//               width: 200.0,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [menu["icon"], Text(menu["name"])],
//               )));
//     }
//     return MaterialButton(
//         color: Colors.black45,
//         onPressed: () {
//           // 调用方法
//           menu["click"](delegate.textEditingValue.selection
//               .textInside(delegate.textEditingValue.text));
//           delegate.hideToolbar();
//         },
//         padding: const EdgeInsets.all(10.0),
//         child: SizedBox(
//             width: 200.0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [menu["icon"], Text(menu["name"])],
//             )));
//   }
//
//   @override
//   Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
//     switch (type) {
//       case TextSelectionHandleType.left:
//         return Offset(0.0, textLineHeight);
//       case TextSelectionHandleType.right:
//         return Offset(20.0, textLineHeight);
//       case TextSelectionHandleType.collapsed:
//         return Offset(10.0, textLineHeight / 2);
//     }
//   }
//
//   @override
//   Size getHandleSize(double textLineHeight) {
//     return Size(20.0, 20.0);
//   }
// }
