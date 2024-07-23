import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text("create group".tr()),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
              onPressed: () {
                // 返回
                Navigator.of(context).pop();
              });
        }),
      ),
      body: Container(
          child: Center(
        child: Text("this is page for 0", style: TextStyle(color: Colors.red)),
      )),
    );
  }
}
