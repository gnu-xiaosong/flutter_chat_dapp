/*
desc: 这是封装好的websocket服务端，作为中继服务器
 */
import 'dart:io';
import 'dart:ui';
import 'package:app_template/microService/module/common/enum.dart';

class WebSocketServer {
  // IP地址
  InternetAddress? ip = InternetAddress.anyIPv4;

  // 处理服务器错误的回调函数
  ErrorCallback? onError;

  // 端口port
  int port;

  WebSocketServer({
    this.port = 1314,
  });

  // 初始化HttpServer服务
  late HttpServer _server;

  // websocket 连接的client客户端列表
  final List<WebSocket> _clients = [];
  List get clients => _clients;

  // websocket server启动
  Future<void> start() async {
    try {
      // 绑定ip和端口
      _server = await HttpServer.bind(ip, port, shared: true);
      print(
          "server>> WebSocket server running on ${_server.address}:${_server.port}");

      // 遍历处理与之连接的websocket client客户端
      await for (var request in _server) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          //  判断接收到的请求是否是WebSocket升级请求。如果是的话，说明客户端希望将HTTP连接升级为WebSocket连接
          _handleWebSocket(request);
        } else {
          // 处理普通的HTTP请求
          _handleRegularHttpRequest(request);
        }
      }
    } catch (e, stackTrace) {
      // 处理server异常: 错误类型
      handleServerError(e, stackTrace, ErrorType.websocketServerBoot);
    }
  }

  /*
   处理服务器错误
   */
  void handleServerError(
      Object error, StackTrace stackTrace, ErrorType errorType) {
    print('服务器遇到错误: $error');
    //
  }

  // 处理websocket client客户端的请求
  void _handleWebSocket(HttpRequest request) async {
    try {
      WebSocket webSocket = await WebSocketTransformer.upgrade(request);
      print(
          '+INFO: WebSocket client connected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
      // 连接成功添加进列表中
      _clients.add(webSocket);

      // 监听消息
      webSocket.listen((message) {
        // print("-------------测试点-----------------");
        // print(message);
        // print('server>> Received message: $message');
        // ***************监听消息并处理**************
        this.messageHandler(request, webSocket, message);
        //****************监听消息并处理**************
      }, onDone: () {
        // websocket连接中断
        print(
            '+INFO: WebSocket client disconnected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
        // ***************连接中断**************
        this.interruptHandler(request, webSocket);
        //****************连接中断**************
        // 移除当前中断的websocket
        _clients.remove(webSocket);
      });
    } catch (e, stackTrace) {
      // 处理server端异常: 启动监听异常
      handleServerError(e, stackTrace, ErrorType.websocketClientListen);
    }
  }

  void messageHandler(
      HttpRequest request, WebSocket webSocket, dynamic message) {
    /*
      desc: 对于监听到消息进行处理操作,用户继承该类并重写该方法来实现
      parameters:
          request
          webSocket  WebSocket  中断的WebSocket
          message    dict  对象字典
     */

    // 向所有客户端广播消息
    // broadcast('$message');
  }

  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    /*
      desc: 对于连接中断的处理操作,用户继承该类并重写该方法来实现
      parameters:
          webSocket  WebSocket  中断的WebSocket
     */

    print(
        '+INFO: WebSocket client disconnected from ip=${request.connectionInfo?.remoteAddress} port=${request.connectionInfo?.remotePort}');
    ;
  }

  // 处理普通http请求
  void _handleRegularHttpRequest(HttpRequest request) {
    print("---------------Http请求------------------");
    // 默认提示websocket请求
    request.response
      ..statusCode = HttpStatus.methodNotAllowed
      ..write('WebSocket connections only')
      ..close();
  }

  // server向client广播消息
  void broadcast(String message) {
    print('server>> Broadcast message: $message');
    for (var client in _clients) {
      // 返回数据给client客户端
      client.add(message);
    }
  }

  // websocket server停止
  Future<void> stop() async {
    await _server.close();
    print('WebSocket server stopped.');
  }
}
