import 'package:app_template/microService/ui/client/widget/textSelectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../module/manager/GlobalManager.dart';

Widget chatBubbleBuilder(
  Widget child, {
  required message,
  required nextMessageInGroup,
}) {
  // 消息位置
  List msgPosition = messagePosition(message);

  // 从消息对象中提取文本
  String messageText = '';
  if (message is types.TextMessage) {
    messageText = message.text ?? ''; // 如果消息为空，则默认为空字符串
  }

  // 判断消息类型
  if (message.type == types.MessageType.image) {
    // 图片bubble
  } else if (message.type == types.MessageType.text) {
    // 文本bubble
    return chatTextBubble(msgPosition: msgPosition, messageText: messageText);
  } else if (message.type == types.MessageType.audio) {
    // 音频bubble
  } else if (message.type == types.MessageType.file) {
    // 文件bubble
  } else if (message.type == types.MessageType.system) {
    // 系统消息bubble
  } else if (message.type == types.MessageType.video) {
    // 视频bubble
  } else if (message.type == types.MessageType.unsupported) {
    // 不支持的bubble
  } else if (message.type == types.MessageType.custom) {
    // 自定义的类型bubble
  }

  return Text("遇到程序性错误!");
}

/*
 确定message消息的显示位置
 */
List messagePosition(types.Message message) {
  // 根据与本地deviceId对比确定是否为本机发送消息
  // 获取本地deviceId

  String deviceId = GlobalManager.deviceId.toString();
  // 获取消息的deviceId
  String msgDeviceId = message.author.id;

  if (deviceId == msgDeviceId) {
    // 本机
    return [BubbleType.sendBubble, Alignment.topRight];
  } else {
    // 对方
    return [BubbleType.receiverBubble, Alignment.topLeft];
  }
}

/*
统一封装选择聊天气泡
 */
Widget chatTextBubble(
    {
    // 消息位置
    required List msgPosition,
    // 文本内容
    required String messageText}) {
  // 根据所选择的index选取ChatBubble
  return ChatBubble(
      // sender or receive
      clipper: ChatBubbleClipper3(type: msgPosition[0]),
      // 根据deviceId判断位置
      alignment: msgPosition[1],
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: Colors.blue,
      child: EditableTextToolbarBuilderExampleApp(messageText.toString()));
}
