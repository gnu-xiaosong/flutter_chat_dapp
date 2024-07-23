import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBottomTool extends StatefulWidget {
  const ChatBottomTool({super.key});

  @override
  State<ChatBottomTool> createState() => _ChatBottomToolState();
}

class _ChatBottomToolState extends State<ChatBottomTool> {
  // 底部可变高度
  double _changeHeight = 200.h;
  List<Map> tabs = [
    {
      "tab": Tab(
        icon: Icon(Icons.directions_transit),
        text: "transit",
      ),
      "view": Center(
        child: Icon(Icons.directions_car),
      ),
    },
    {
      "tab": Tab(
        icon: Icon(Icons.directions_transit),
        text: "transit",
      ),
      "view": Center(
        child: Icon(Icons.directions_car),
      ),
    },
    {
      "tab": Tab(
        icon: Icon(Icons.directions_transit),
        text: "transit",
      ),
      "view": Center(
        child: Icon(Icons.directions_car),
      ),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 400), // 动画持续时间
        height: _changeHeight, // 动态高度
        color: Colors.blueAccent, // 容器颜色
        child: Container(
          width: double.infinity,
          height: 100.h,
          color: Colors.blueAccent,
          child: DefaultTabController(
            length: tabs.length,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  backgroundColor: Colors.red,
                  tabs: [for (var item in tabs) item["tab"]],
                ),
                Expanded(
                  child: TabBarView(
                    children: [for (var item in tabs) item["view"]],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
