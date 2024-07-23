/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 聊天websocket管理器类
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:app_template/config/AppConfig.dart';
import 'package:app_template/manager/GlobalManager.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../microService/chat/websocket/Client.dart';
import '../microService/chat/websocket/Server.dart';

class ChatWebsocketIsolateManager {
  // 静态属性，存储唯一实例
  static ChatWebsocketIsolateManager? _instance;
  /*
    选择本机为服务器端还是客户端策略
   */
  // IP地址
  InternetAddress? server_ip = InternetAddress.anyIPv4;
  String _ip = "";
  // 端口port
  final int port = AppConfig.port;
  bool result = true; // 是否作为服务端
  bool isServer = true; // 是否作为服务端
  // 限制扫描最大ip数
  Object limitPort = 100;

  // 私有的命名构造函数，确保外部不能实例化该类
  ChatWebsocketIsolateManager._internal() {
    // 初始化逻辑
    print("-------chatWebsocket instance-----");
  }

  // 提供一个静态方法来获取实例
  static ChatWebsocketIsolateManager getInstance() {
    _instance ??= ChatWebsocketIsolateManager._internal();
    return _instance!;
  }

  Future<bool> selectLocalHostAsServerStrategy(SendPort sendPort) async {
    if (!GlobalManager.appCache.containsKey("server_ip") ||
        GlobalManager.appCache.getString("server_ip")?.length == 0) {
      //设置
      await GlobalManager.appCache.setString("server_ip", "192.168.1.1");
    }

    _ip = GlobalManager.appCache.getString("server_ip")!;

    // 存在server_进行连接性测试
    bool isConnected = await testConnection(_ip, AppConfig.port);

    print("----------isConnected=$isConnected---------------------------");
    if (isConnected) {
      // 检测连接成功
      result = false;
    } else {
      // 1. 获取子网
      // 192.168.0.1
      var wifiIP = await NetworkInfo().getWifiIP();
      sendPort.send("本机: $wifiIP");
      // 192.168.0
      var subnet = ipToCSubnet(wifiIP!);
      sendPort.send("子网ip:$subnet");

      // 2. 进行连接性测试: 策略为ip+端口连接检测

      int i = 1;
      while (result && i != limitPort) {
        sendPort.send("测试地址: $subnet.$i:${AppConfig.port}");
        bool isConnected = await testConnection("$subnet.$i", AppConfig.port);
        if (isConnected) {
          // 服务端ip
          _ip = "$subnet.$i";
          sendPort.send('连接成功！');
          result = false;

          // 存储server的ip地址，备下次直接使用
          await GlobalManager.appCache.setString("server_ip", _ip.toString());
          break;
        } else {
          sendPort.send('连接失败。');
        }
        i++;
      }
    }

    // 3. 如果存在服务端则返回：false 并设置服务端ip地址绑定 启动客户端服务

    return result;
  }

  void isolateBootWebsocket() async {
    // 创建一个接收子线程消息的ReceivePort
    final receivePort = ReceivePort();

    // 启动一个新的Isolate，执行子线程函数
    await Isolate.spawn(bootWebsocket, receivePort.sendPort);

    // 监听子线程传来的消息
    receivePort.listen((message) {
      print('接收到子线程的消息: $message');

      if (message == "close") {
        // 关闭线程
        receivePort.close();
        print("线程已关闭!");
      }
    });
  }

  /*
    启动websocket服务
   */
  void bootWebsocket(SendPort sendPort) async {
    sendPort.send("子线程启动!");
    // 1.判断是否作为server端
    bool isServer = await selectLocalHostAsServerStrategy(sendPort);

    // 2.启动对用的socket
    if (isServer) {
      // 启动server
      // 实例化WebSocketServer
      ChatWebsocketServer chatWebsocketServer = ChatWebsocketServer();
      chatWebsocketServer.ip = AppConfig.ip;
      chatWebsocketServer.port = AppConfig.port;
      // 启动server
      chatWebsocketServer.start();
      // 将是否是server的结果发送回主线程
      sendPort.send("启动server成功!");
    } else {
      // 启动client
      ChatWebsocketClient chatWebsocketClient = ChatWebsocketClient();
      chatWebsocketClient.ip = _ip;
      chatWebsocketClient.port = AppConfig.port;
      // 连接
      chatWebsocketClient.connnect();
      // 将是否是server的结果发送回主线程
      sendPort.send("启动client成功!");
    }
  }

  Future<bool> testConnection(String ipAddress, int port) async {
    try {
      // 尝试连接到指定的IP和端口
      final socket =
          await Socket.connect(ipAddress, port, timeout: Duration(seconds: 1));
      socket.destroy(); // 成功连接后关闭套接字
      return true;
    } catch (e) {
      // 如果连接失败，打印错误信息并返回false
      print('Failed to connect: $e');
      return false;
    }
  }
}
