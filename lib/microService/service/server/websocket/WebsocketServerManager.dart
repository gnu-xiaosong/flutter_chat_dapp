/*
管理websocketServer
 */

import 'dart:io';

import 'package:app_template/microService/service/server/model/ClientObject.dart';
import 'package:app_template/microService/service/server/model/ErrorObject.dart';

import 'ChatWebsocketServer.dart';
import '../../../module/common/enum.dart';
import '../../../module/manager/GlobalManager.dart';

class WebsocketServerManager extends ChatWebsocketServer {
  WebsocketServerManager._internal();
  static final WebsocketServerManager _instance =
      WebsocketServerManager._internal();
  // 回调函数: 处理当连接中断 参数为中断连接的client信息 this, clientObject
  late Function whenHasClientConnInterrupt;
  // 回调函数：server异常
  late Function whenServerError;
  // Factory constructor
  factory WebsocketServerManager() {
    return _instance;
  }

  /*
  配置参数
   */
  setConfig(
      {
      // ip地址
      String? ip,
      // port端口
      int? port,
      // 回调函数: 处理当连接中断 参数为中断连接的client信息
      Function? whenHasClientConnInterrupt,
      // 回调函数：server异常
      Function? whenServerError}) {
    // 初始化参数
    super.ip = ip as InternetAddress?;
    super.port = port!;
    this.whenHasClientConnInterrupt = whenHasClientConnInterrupt!;
    this.whenServerError = whenServerError!;
  }

  /*
  重载server异常
   */
  @override
  void handleServerError(
      Object error, StackTrace stackTrace, ErrorType errorType) {
    // 封装ErrorObject实体
    ErrorObject errorObject = ErrorObject(
        // 错误内容
        content: error.toString(),
        // 类别
        type: errorType);
    // 处理回调处理
    whenServerError(this, error, stackTrace, errorObject);
    // 调用
    super.handleServerError(error, stackTrace, errorType);
  }

  /*
  重载中断处理方法
   */
  @override
  void interruptHandler(HttpRequest request, WebSocket webSocket) {
    var ip = request.connectionInfo?.remoteAddress.address;
    var port = request.connectionInfo?.remotePort;
    late ClientObject clientObject;
    // 更改全局 list 中 websocketClientObj 的状态，并移除具有相同 IP 的对象
    GlobalManager.webscoketClientObjectList.forEach((clientObjectItem) {
      if (clientObjectItem.ip == ip && clientObjectItem.port == port) {
        clientObject = clientObjectItem;
      }
    });
    // 回调函数调用:this   和 断开的clientObject
    whenHasClientConnInterrupt(this, clientObject);
    // 执行父
    super.interruptHandler(request, webSocket);
  }

  // 初始化 操作
  void initialize() {}

  // 启动websocketServer
  void boot() {
    // Your boot logic here
  }

  // 中断处理策略
  void interruptRetryStrategy() {
    // Your retry strategy logic here
  }
}
