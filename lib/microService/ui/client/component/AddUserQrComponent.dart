import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../common/Tool.dart';

class AddUserQr extends StatefulWidget {
  const AddUserQr({super.key});

  @override
  State<AddUserQr> createState() => _AddUserQrState();
}

class _AddUserQrState extends State<AddUserQr> {
  // 添加一个方法来获取并编码二维码信息
  Future<String> getQrMessage() async {
    // 生成二维码信息
    Map qrInfo = await UiTool().generateAddUserQrInfo();

    print("qr info: ${qrInfo}");
    return json.encode(qrInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Qr'),
          actions: [],
        ),
        body: Container(
            color: Colors.white54,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.maxFinite,
            child: FutureBuilder<String>(
                future: getQrMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    String qrData = snapshot.data!;
                    if (qrData.length > 288) {
                      return Text("QR data too long: ${qrData.length} > 288");
                    } else {
                      return Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25), // 设置圆角
                              ),
                              width: 250.w,
                              height: 250.h,
                              child: PrettyQr(
                                data: qrData,
                                size: 250,
                                roundEdges: true,
                                errorCorrectLevel: QrErrorCorrectLevel.M,
                                image: AssetImage('assets/images/logo.png'),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return Text("No data available");
                  }
                })));
  }
}
