/*
枚举文件
 */
enum ErrorType {
  system, //系统级
  application, // 应用程序
  network, // 网络原因
  auth, // websocket client身份认证
  clientSendText, // client发送文本类型
  websocketClientConn, // 客户端client连接异常
  websocketServerBoot, // websocket server 启动错误
  websocketClientListen, // 启动 websocket client 监听异常
  connWebsocketServer // 监听server端异常
}
