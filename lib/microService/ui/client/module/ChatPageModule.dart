/*
 cahtPage页面的函数业务模块
 */
import 'dart:convert';
import 'dart:io';
import 'package:app_template/config/AppConfig.dart';
import 'package:app_template/microService/ui/client/model/ChatAuthor.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/LocalStorage.dart';
import '../../../../database/daos/ChatDao.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../service/client/websocket/ChatWebsocketClient.dart';
import '../model/ChatMessage.dart';
import '../model/ChatUser.dart';
import '../model/CommunicationMessageObject.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'CommonModule.dart';

class ChatPageModel extends ChatWebsocketClient {
  String? deviceId; //对方deviceId
  String? myDeviceId = GlobalManager.deviceId; // 本机deviceId
  List<types.Message> _messages = []; //数据列表
  ChatUser chatUser = ChatUser(); // 客户机User实体
  ChatAuthor chatAuthor = ChatAuthor(); // 本机Uer
  ChatDao chatDao = ChatDao(); // chat数据操作类
  MessageEncrypte messageEncrypte = MessageEncrypte(); // 数据加解密类
  Function addMessageCallback; // 回调函数：用于message消息list变更调用: 参数为：新增的message
  Function changeMessageCallback; // 回调函数：用于改变message列表时调用，参数为：更改后的数据
  CommunicationMessageObject communicationMessageObject =
      CommunicationMessageObject(); // 消息实体
  CommonModel commonModel = CommonModel(); // 公共功能模块

  /*
  初始化model类
   */
  ChatPageModel(
      {required this.addMessageCallback, required this.changeMessageCallback});

  /*
   封装chat页面的message数据: 接收来自客户机的消息转Message
   */
  messageInChat(Map message) {
    // printSuccess("text translate Message: ${message}");
    // 消息类型
    String msgType = message["msgType"];
    // 发送者, 客户机
    chatUser.id = message["sender"]["id"];
    chatUser.lastName = message["sender"]["username"]; // 姓
    chatUser.firstName = message["sender"]["username"]; // 名
    final _chatUser = chatUser.user();

    // 解耦附件列表，字符串结构
    List<Map<String, dynamic>> attachmentsList;
    if (message["content"]["attachments"] is List) {
      List<dynamic> jsonList = message["content"]["attachments"];
      // 显式地将每个元素转换为 Map<String, dynamic>
      attachmentsList =
          jsonList.map((item) => item as Map<String, dynamic>).toList();
      // 打印结果
      // print("Attachments list: $attachmentsList");
    } else {
      // print(
      //     "Unexpected type for attachments: ${message["content"]["attachments"].runtimeType}");
      attachmentsList = [];
    }

    // 聊天消息实体
    ChatMessage chatMessage = ChatMessage(
        type: msgType,
        author: _chatUser,
        id: message["metadata"]["messageId"],
        attachmentsList: attachmentsList,
        name: message["content"]["text"], // 默认文本
        createdAt: DateTime.parse(message["timestamp"]).millisecondsSinceEpoch,
        text: message["content"]["text"]);

    // 转化为Message对象
    var message0 = chatMessageByMsgType(chatMessage);

    return message0;
  }

  /*
  根据不同类型封装消息实体
   */
  types.Message? chatMessageByMsgType(ChatMessage chatMessage) {
    // print("chatMessage.type = ${chatMessage.type}");
    late types.Message? _message;
    // 根据不同消息类型判断
    if (chatMessage.type == "text") {
      // ***************文本:先测试********************
      _message = types.TextMessage(
          author: chatMessage.author!,
          id: chatMessage.id.toString(),
          text: chatMessage.text.toString(),
          createdAt: chatMessage.createdAt);
    } else if (chatMessage.type == "custom") {
      // 自定义
    } else if (chatMessage.type == "file") {
      // 文件
      _message = types.FileMessage(
        author: chatMessage.author!,
        createdAt: chatMessage.createdAt,
        id: chatMessage.id.toString(),
        // mimeType: lookupMimeType(result.files.single.path!),
        name: chatMessage.attachmentsList?[0]["name"],
        size: chatMessage.size!.toInt(), //result.files.single.size,
        uri: chatMessage.attachmentsList?[0]["url"],
      );
    } else if (chatMessage.type == "image") {
      // 图片
      _message = types.ImageMessage(
        author: chatMessage.author!,
        createdAt: chatMessage.createdAt,
        // height: image.height.toDouble(),
        id: chatMessage.id.toString(),
        name: chatMessage.attachmentsList?[0]["name"],
        size: chatMessage.size!.toInt(), //bytes.length,
        uri: chatMessage.attachmentsList?[0]["url"],
        // width: image.width.toDouble(),
      );
    } else if (chatMessage.type == "system") {
      // 系统
    } else if (chatMessage.type == "audio") {
      // 音频
      _message = types.AudioMessage(
          author: chatMessage.author!,
          duration: Duration(),
          id: chatMessage.id.toString(),
          name: chatMessage.attachmentsList?[0]["name"],
          size: chatMessage.size!.toInt(),
          uri: chatMessage.attachmentsList?[0]["url"]);
    } else if (chatMessage.type == "video") {
      // 视频
      _message = types.VideoMessage(
          author: chatMessage.author!,
          id: chatMessage.id.toString(),
          name: chatMessage.attachmentsList?[0]["name"],
          size: chatMessage.size!.toInt(),
          uri: chatMessage.attachmentsList?[0]["url"]);
    } else if (chatMessage.type == "unsupported") {
      // 不支持的类型
    } else {
      // 未知类型
      _message = null;
      print("未知消息类型");
    }

    return _message;
  }

  /*
  格式转换: Chat 转 Message, 从数据库中提取聊天记录在转化为Message
   */
  Future<List<types.Message>> chatToMessageTypeList(List<Chat> chatList) async {
    // 存储的消息内容
    List<types.Message> messageList = [];
    // 遍历转化
    for (Chat chat in chatList) {
      // print("**********************************");
      // print(chat.msgType);
      // 用户user
      chatUser.id = chat.senderId.toString();
      chatUser.lastName = chat.senderUsername; // 姓
      chatUser.firstName = chat.senderUsername; // 名
      final _user = chatUser.user();
      // 解耦附件列表，字符串结构
      // print(chat.contentAttachments.toString());

      // 解码 JSON 字符串
      List<dynamic> jsonList = json.decode(chat.contentAttachments.toString());

      // 转换为 List<Map<String, dynamic>>
      List<Map<String, dynamic>> attachmentsList =
          List<Map<String, dynamic>>.from(
              jsonList.map((item) => item as Map<String, dynamic>));

      // 打印结果
      // print("Attachments list: $attachmentsList");

      // 聊天消息实体
      ChatMessage chatMessage = ChatMessage(
          type: chat.msgType, // 消息类型
          author: _user, //用户
          id: chat.metadataMessageId, //消息唯一标识
          attachmentsList: attachmentsList,
          name: chat.contentText, // 默认文本
          createdAt: chat.timestamp.millisecondsSinceEpoch,
          text: chat.contentText);

      // print("chatMessage.type = ${chatMessage.type}");

      // 转化为Message对象
      var message = chatMessageByMsgType(chatMessage);
      // 跳过
      if (message == null) continue;
      // 增加
      messageList.add(message);
    }
    return messageList.reversed.toList();
  }

  /*
  获取聊天记录
   */
  Future<List<Chat>> getUserChatMessagesByDeviceId(
      {required String userDeviceId, required String myselfDeviceId}) async {
    // 封装查询
    ChatsCompanion chatsCompanion = ChatsCompanion.insert(
        senderUsername: "senderUsername",
        contentText: "contentText",
        metadataMessageId: "metadataMessageId",
        metadataStatus: "metadataStatus",
        timestamp: DateTime.now(),
        // 查询参数:
        senderId: Value(myselfDeviceId),
        recipientId: Value(userDeviceId),
        msgType: 'recipientType',
        isGroup: 0);
    // 查询数据库
    List<Chat> chatMsgList =
        await chatDao.selectChatMessagesByDeviceId(chatsCompanion);

    // 倒序

    return chatMsgList;
  }

  // 添加消息到消息列表
  Future<void> addMessage(
    types.Message message,
  ) async {
    // print("-------------------------------------");
    // print(message.toJson()["text"]);

    // print("recipientId:${deviceId}");
    // 设置消息元
    Map metadata = {
      "messageId": message.id, // 消息的唯一标识符
      "status": "sent" // 消息状态，例如 sent, delivered, read
    };

    bool result = GlobalManager.chatWebsocketClient!.sendMessage(
        senderId: myDeviceId,
        recipientId: deviceId!,
        contentText: message.toJson()["text"],
        metadata: metadata);

    if (result) {
      // add message to messageList
      addMessageCallback(message);
    }
  }

  // 处理附件按钮点击事件
  void handleAttachmentPressed() {
    // 弹出一个底部弹窗，显示照片和文件选项
    showModalBottomSheet<void>(
      context: GlobalManager.context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleImageSelection(); // 处理图片选择
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'), // 显示“照片”选项
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleFileSelection(); // 处理文件选择
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'), // 显示“文件”选项
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'), // 显示“取消”选项
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 处理文件选择
  void handleFileSelection() async {
    // 弹出文件选择器，允许选择任意类型的文件
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      // 封装文件消息
      final message = types.FileMessage(
        author: chatAuthor.user(), // 本机
        createdAt: DateTime.now().millisecondsSinceEpoch, // 当前时间戳
        id: const Uuid().v4(), // 生成唯一消息 ID
        mimeType: lookupMimeType(result.files.single.path!), // 文件类型
        name: result.files.single.name, // 文件名
        size: result.files.single.size, // 文件大小
        uri: result.files.single.path!, // 文件路径
      );

      addMessage(message); // 添加消息
    }
  }

  // 处理图片选择
  void handleImageSelection() async {
    // 弹出图片选择器，选择来自图库的图片
    final result = await ImagePicker().pickImage(
      imageQuality: 70, // 图片质量压缩比例
      maxWidth: 1440, // 图片最大宽度
      source: ImageSource.gallery, // 图片来源：图库
    );

    if (result != null) {
      final bytes = await result.readAsBytes(); // 读取图片字节
      final image = await decodeImageFromList(bytes); // 解码图片

      // 封装图片消息
      final message = types.ImageMessage(
        author: chatAuthor.user(), // 当前用户
        createdAt: DateTime.now().millisecondsSinceEpoch, // 当前时间戳
        height: image.height.toDouble(), // 图片高度
        id: const Uuid().v4(), // 生成唯一消息 ID
        name: result.name, // 图片名称
        size: bytes.length, // 图片大小
        uri: result.path, // 图片路径
        width: image.width.toDouble(), // 图片宽度
      );

      addMessage(message); // 添加消息
    }
  }

  // 处理消息点击事件
  void handleMessageTap(BuildContext _, types.Message message) async {
    // 如果消息是文件消息类型
    if (message is types.FileMessage) {
      // 获取本地路径
      var localPath = message.uri;

      // 如果文件是通过网络加载的
      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true, // 显示加载状态
          );
          _messages[index] = updatedMessage; // 更新消息列表
          // 回调更新数据
          changeMessageCallback(_messages);

          // 下载文件
          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes; // 获取文件字节
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}'; // 文件保存路径

          // 如果文件不存在，则写入文件
          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null, // 取消加载状态
          );
          _messages[index] = updatedMessage;
          // 回调更新数据
          changeMessageCallback(_messages);
        }
      }

      // 打开文件
      await OpenFilex.open(localPath);
    }
  }

  // 处理预览数据加载完成事件
  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    // 更新消息中的预览数据
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    // 更改特定数据
    _messages[index] = updatedMessage;
    // 回调更新messages数据
    changeMessageCallback(_messages);
  }

  // 处理发送文本消息
  Future<void> handleSendPressed(types.PartialText message) async {
    // 创建文本消息
    final textMessage = types.TextMessage(
      status: message.metadata?["status"],
      author: chatAuthor.user(), // 当前用户
      createdAt: DateTime.now().millisecondsSinceEpoch, // 当前时间戳
      id: const Uuid().v4(), // 生成唯一消息 ID
      text: message.text, // 消息文本
    );
    // ******* 插入数据库中 ************
    // 封装消息
    Map msgObj = await communicationMessageObject.message(
        msgType: "text",
        senderId: GlobalManager.deviceId,
        username: AppConfig.username,
        avatar: chatAuthor.imageUrl,
        recipientId: deviceId,
        groupOrUser: "user",
        contentText: message.text,
        timestamp: DateTime.fromMillisecondsSinceEpoch(textMessage.createdAt!)
            .toString(),
        metadata: {
          "messageId": textMessage.id,
          // 消息的唯一标识符
          "status": justifyStatus(
              message.metadata?["status"]) // 消息状态，例如 sent, delivered, read
        });
    // print("**********************插入数据库*****************************");
    // print(msgObj);

    // 插入数据库中
    commonModel.insertMessageToDataStorage(msgObj["info"]);
    // 添加消息
    addMessage(textMessage);
  }

  /*
  加载数据
   */
  Future<List<types.Message>> loadMessages() async {
    print("******************load data***************************");

    // 本地deviceId
    String myselfDeviceId = GlobalManager.deviceId.toString();
    //
    // print(
    //     "userDeviceId=${deviceId.toString()}   myselfDeviceId=${myselfDeviceId}");

    // 从数据库中获取聊天信息
    List<Chat> chatMessagesList = await getUserChatMessagesByDeviceId(
        userDeviceId: deviceId.toString(), myselfDeviceId: myselfDeviceId);

    // 打印长字符串
    // ToolsManager().printLongString("chatMessagesList=${chatMessagesList}");

    // 将Chat实体list转化为Message对象list
    _messages = await chatToMessageTypeList(chatMessagesList);

    return _messages;
  }

  /*
  判断消息状态用于封装进入数据库
   */
  justifyStatus(types.Status status) {
    String? statusString;
    switch (status) {
      case types.Status.delivered:
        // 已提交: 传达到了服务器
        statusString = "delivered";
        break;
      case types.Status.error:
        // 有误
        statusString = "error";
        break;
      case types.Status.seen:
        // 对方已查看
        statusString = "seen";
        break;
      case types.Status.sending:
        // 正在发送
        statusString = "sending";
        break;
      case types.Status.sent:
        // 已送达
        statusString = "sent";
        break;
    }

    return statusString;
  }
}
