/*
 * @Author: xskj
 * @Date: 2023-12-29 16:45:45
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 17:36:13
 * @Description: 路由设置
 */
import 'package:app_template/pages/Introduction/Introduction1.dart';
import 'package:app_template/pages/logins/default/index/index.dart';
import 'package:flutter/material.dart';
//导入layout文件
import '../Layouts/mobile/MobileLayout1.dart';
import '../microService/ui/client/page/ChatPage.dart';
import '../pages/Introduction/introduction2/introduction_animation_screen.dart';
import '../pages/adaptive/Home.dart';

//路由表
Map<String, WidgetBuilder> routes = {
  "/": (context) =>
      AdaptiveHome(), // WorkStation(), // AddTaskPage(), //  WorkStation(), // AddTaskPage(), //  const CipherBookPage(), // const AdaptiveHome(), //AddUserQr(), // , //const MobileLayout1(), ChatPage(),
  //const MobileLayout1(), //注册根路由:默认第一个为系统根路由： initialRoute: "/",
  "home": (context) => const MobileLayout1(), // home 页路由
  "introduce": (context) => Introduction1(), //介绍页路由
  "login": (context) => const Login(),
  'chatPage': (context) => ChatPage(),
  "introductionAnimation": (context) =>
      const IntroductionAnimationScreen() //介绍页路由
};

//路由拦截处理
Function onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
  print("--------------------");
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
  return null;
};
