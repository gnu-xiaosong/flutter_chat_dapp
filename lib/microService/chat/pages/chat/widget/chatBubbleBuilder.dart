import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

Widget chatBubbleBuilder(
  Widget child, {
  required message,
  required nextMessageInGroup,
}) {
  print("message:");
  print(message);
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
    return ChatBubble(
      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20),
      backGroundColor: Colors.blue,
      child: Container(
        // constraints: BoxConstraints(
        //   maxWidth: MediaQuery.of(context).size.width * 0.7,
        // ),
        child: Text(
          messageText.toString().tr(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
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
