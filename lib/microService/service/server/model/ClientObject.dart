/*
  websocket client实体对象
 */
import 'dart:io';
import '../module/MessageQueue.dart';

class ClientObject {
  // 唯一标识client客户端基于设备的ID
  String deviceId;

  // client websocket
  WebSocket socket;

  // 连接ip
  String ip;

  // 客户端连接端口
  int port; // 端口使用整数类型

  // websocket连接状态
  bool connected;

  // 通讯秘钥: 加密算法见文档，服务端生成，客户端存储
  String secret;

  // 客户端状态: 0 暂时拒收消息 1 可接受信息 2 标记为危险客户端 3 被ban
  int status;

  // 连接时间戳：记录最近一次连接时间， 自动创建
  DateTime connectionTime;

  // 等待发送消息队列:这里利用队列这种数据结构作为存储,初始化为
  MessageQueue messageQueue;

  // 构造函数
  ClientObject({
    required this.deviceId,
    required this.socket,
    required this.ip,
    required this.port,
    required this.secret,
    this.connected = true, // 默认未连接
    this.status = 1, // 默认可接受消息
    DateTime? connectionTime, // 可选参数，如果未提供则初始化为当前时间
    MessageQueue? messageQueue, // 可选参数，默认为空的消息队列
  })  : this.connectionTime = connectionTime ?? DateTime.now(), // 如果未提供，则使用当前时间
        this.messageQueue = messageQueue ?? MessageQueue(); // 如果未提供，则初始化为新的消息队列
}
