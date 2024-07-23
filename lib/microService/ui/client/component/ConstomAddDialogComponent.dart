import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_scanner/src/mobile_scanner_controller.dart';
import '../common/Scan.dart';

class CustomScanAddDialog extends StatefulWidget {
  final String deviceId;
  final String username;
  final MobileScannerController controler_scan;

  CustomScanAddDialog({
    required this.deviceId,
    required this.username,
    required this.controler_scan,
  });

  @override
  _CustomScanAddDialogState createState() => _CustomScanAddDialogState();
}

class _CustomScanAddDialogState extends State<CustomScanAddDialog> {
  final TextEditingController controller = TextEditingController();
  String msg = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'add user'.tr(),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 27),
            Icon(
              Icons.phone_android,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              "设备ID".tr() + ':${widget.deviceId}',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '用户名'.tr() + ':${widget.username}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                labelText: 'leave message'.tr(),
                labelStyle: TextStyle(color: Colors.black, fontSize: 10),
                prefixIcon:
                    Icon(Icons.chat_bubble_outlined, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.green,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // 取消时清除文本框
                    widget.controler_scan.start();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.cancel_outlined, color: Colors.white),
                  label: Text(
                    '取消'.tr(),
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // 添加好友
                    Map qrMap = {
                      "deviceId": widget.deviceId,
                      "username": widget.username,
                      "msg": controller.text,
                    };
                    print("msg: $qrMap");
                    Scan().addRequestChatUserByScan(qrMap);
                    widget.controler_scan.start();
                    // Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    '添加'.tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, String deviceId, String username,
    MobileScannerController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomScanAddDialog(
        deviceId: deviceId,
        username: username,
        controler_scan: controller,
      );
    },
    barrierDismissible: false, // 通过设置 barrierDismissible: false 来防止点击对话框之外关闭对话框
  );
}
