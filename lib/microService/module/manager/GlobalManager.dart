/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 全局管理器工具类
 */
import 'dart:async';
import 'dart:convert';
import 'package:app_template/microService/module/common/unique_device_id.dart';
import 'package:app_template/microService/service/server/module/MessageQueue.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/LocalStorage.dart';
import '../../../manager/HttpManager.dart';
import '../../../manager/TestManager.dart';
import '../../../models/AppModel.dart';
import '../../../models/UserModel.dart';
import '../../service/client/websocket/ChatWebsocketClient.dart';
import '../../service/server/model/ClientObject.dart';
import '../../service/server/module/OffLineMessageQueue.dart';
import '../../service/server/schedule/UserSchedule.dart';
import 'AppLifecycleStateManager.dart';
import '../websocket/ChatWebsocketIsolateManager.dart';
import '../websocket/ChatWebsocketManager.dart';
import 'NotificationsManager.dart';
import 'ToolsManager.dart';

class GlobalManager {
  /***************↓↓↓↓↓↓全局参数变量初始化操作↓↓↓↓↓↓↓******************/
  // 11.是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  // 2.全局配置静态
  static AppModel appConfigModel = ToolsManager.loadAppModelConfig();
  // 3.初始化本地存储：sqlite3
  static LocalDatabase database = LocalDatabase();
  // 4.websocketChatObject list
  static List<ClientObject> webscoketClientObjectList = [];
  // 5.全局离线消息队列初始初
  static OffLineMessageQueue offLineMessageQueue = OffLineMessageQueue();
  // 6.去全局设置server在线client MessageQueue map: 用于client端使用: 页面client面向该编程即可
  static Map<String, MessageQueue> userMapMsgQueue = Map();
  // 7.设置全局客户端等待好友同意消息队列
  static MessageQueue clientWaitUserAgreeQueue = MessageQueue();
  // 8.设置全局buildcontext
  static late BuildContext context;
  // 8.全局add user消息队列
  static MessageQueue offerUserAddQueue = MessageQueue();
  // 9.全局chatWebsocketClient
  static ChatWebsocketClient? chatWebsocketClient;
  // 11.全局deviceId
  static String? deviceId;
  // 12. 全局监听广播流机制变量
  static final StreamController<dynamic> globalStreamController =
      StreamController<dynamic>.broadcast(); // 创建一个广播流控制
  static Stream<dynamic> get globalStream =>
      globalStreamController.stream; // 获取广播流
  // 13.在线状态
  static bool isOnline = false;
  /**************↑↑↑↑↑↑↑↑全局参数变量初始化操作↑↑↑↑↑↑↑↑***************/

  /****************↓↓↓↓↓↓工具类初始化操作↓↓↓↓↓↓↓**********************/
  //1.HttpManager工具类:采用了单例模式,让请求api类该Global类获取该实例化对象
  final HttpManager _http = HttpManager.getInstance();
  HttpManager get GlobalHttp => _http; //用于继承的类访问
  // 2.单例化chat websocket
  final ChatWebsocketManager _chatWebsocketManager =
      ChatWebsocketManager.getInstance(); //实例化chat websocket
  ChatWebsocketManager get GlobalChatWebsocket => _chatWebsocketManager;
  // 2.单例化chat websocket isolate 线程执行
  final ChatWebsocketIsolateManager _chatWebsocketIsolateManager =
      ChatWebsocketIsolateManager.getInstance(); //实例化chat websocket
  ChatWebsocketIsolateManager get GlobalChatWebsocketIsolate =>
      _chatWebsocketIsolateManager;
  // 3.单例化User schedule
  final UserSchedule _userSchedule =
      UserSchedule.getInstance(); //实例化chat websocket
  UserSchedule get GlobalUserSchedule => _userSchedule;

  /****************↑↑↑↑↑↑↑↑↑工具类初始化操作↑↑↑↑↑↑↑↑↑↑↑↑↑*******************/

  /*****************↓↓↓↓↓↓↓全局变量共享状态Model类初始化操作↓↓↓↓↓↓↓↓********/
  /*****************1.声明持续化存储变量*********************/
  static late SharedPreferences _userInfo;
  static late SharedPreferences appCache;

  /*****************2.配置全局变量Model类*********************/
  //1.用户信息Model类
  static UserModel userInfo = UserModel()..theme = 2;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 调试管理器模块
    TestManager.debug();

    // 监测app是否初次启动
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      appFirstRun();
      prefs.setBool('isFirstRun', false);
    }

    // 设置全局deviceId
    deviceId = await UniqueDeviceId.getDeviceUuid();

    // -------------------管理类初始化--------------------
    //1.本地通知初始化(单例模式)
    NotificationsManager notification = NotificationsManager();
    notification.initialize();

    /****************3.持续化存储实例化对象-全局变量类******************/
    _userInfo = await SharedPreferences.getInstance();
    appCache = await SharedPreferences.getInstance();

    /****************4.获取持续化存储的Model对象******************/
    if (!appCache.containsKey("server_ip")) {
      // 不存在时
      appCache.setString("server_ip", "192.168.1.1");
    }

    if (_userInfo.containsKey("userInfo") &&
        _userInfo.getString("userInfo") != null) {
      try {
        var _userInfoData = _userInfo.getString("userInfo");
        //获取Model数据对象
        userInfo = UserModel.fromJson(jsonDecode(_userInfoData!));
      } catch (e) {
        print(e);
      }
    } else {
      //当Model中有一个不存在时
      print("json全局配置文件有误!");
    }
  }

  /**************5.持久化存储AppInfo信息 首先在实例化前先执行*************/
  static saveGlobalInfo() {
    _userInfo.setString("userInfo", jsonEncode(userInfo.toJson()));
    print("已保存");
  }
/*****************↑↑↑↑↑↑↑↑↑↑全局变量共享状态Model类初始化操作↑↑↑↑↑↑↑↑↑↑********/
}
