import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/foundation.dart' as foundation;

import '../../../module/manager/GlobalManager.dart';
import '../module/ChatPageModule.dart';
import '../widget/ChatBottomToolWidget.dart';

class ChatBottom extends StatefulWidget {
  late ChatPageModel chatPageModel;
  ChatBottom(this.chatPageModel, {super.key});

  @override
  State<ChatBottom> createState() => _ChatBottomState(chatPageModel);
}

class _ChatBottomState extends State<ChatBottom> {
  late ChatPageModel chatPageModel;
  String? myDeviceId;
  late TextEditingController _textController = TextEditingController();
  bool _emojiShowing = false;
  String? deviceId;
  late AnimationController animControl;
  bool animate = false;
  // 底部可变高度
  double _changeHeight = 200.h;
  bool _isText = false;
  final FocusNode _focusNode = FocusNode();
  final _emoController = TextEditingController();
  final _scrollController = ScrollController();

  // 初始化
  _ChatBottomState(this.chatPageModel);

  @override
  void dispose() {
    _focusNode.dispose();
    _emoController.dispose();
    _textController.dispose(); // 确保释放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MessageBar(
      // replyingTo: "回复消息",
      messageBarHitText: "Type your message here".tr(),
      messageBarHintStyle: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 15,
          overflow: TextOverflow.ellipsis),
      onTextChanged: (text) {
        setState(() {
          _isText = text.isNotEmpty;
        });
        print(_isText);
        // print("text change: $text");
      },
      // prefixIcon:
      suffixIcon: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: InkWell(
          child:
              // 切换
              _isText
                  ? InkWell(
                      child: Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 24,
                      ),
                      onTap: () {
                        // 创建一个新的 PartialText 对象并设置其文本
                        var message = types.PartialText(metadata: {
                          "status": GlobalManager.isOnline
                              ? types.Status.sent
                              : types.Status.delivered,
                        }, text: _textController.text.toString() ?? '');
                        // 发送消息
                        chatPageModel.handleSendPressed(message);

                        setState(() {
                          _isText = false;
                          // 清空消
                          _textController.clear();
                        });

                        // 打印发送确认
                        print("Message sent successfully.");
                      })
                  : SocialMediaRecorder(
                      // 滑动部分
                      slideToCancelText: "slide to cancel".tr(),
                      // 锁定部分
                      cancelText: "cancel".tr(),
                      cancelTextBackGroundColor: Colors.transparent,
                      // 背景颜色
                      backGroundColor: Colors.transparent,
                      recordIconBackGroundColor: Colors.blue,
                      counterBackGroundColor: Colors.transparent,

                      // fullRecordPackageHeight: 80,
                      radius: BorderRadius.circular(25),
                      // maxRecordTimeInSecond: 5,
                      startRecording: () {
                        // function called when start recording
                        print("startRecording");
                      },
                      stopRecording: (_time) {
                        // function called when stop recording, return the recording time
                        print("stopRecording");
                      },
                      sendRequestFunction: (soundFile, _time) {
                        //  print("the current path is ${soundFile.path}");
                        print("sendRequestFunction");
                      },
                      encode: AudioEncoderType.AAC,
                    ),
          onTap: () {
            setState(() {
              // 关闭键盘
              print("----------------------open emo-----------------");
              FocusScope.of(context).unfocus();
              _emojiShowing = !_emojiShowing;
              print("open emo: $_emojiShowing");
            });
            // // 弹出emos
            // openEmjo();
          },
        ),
      ),
      rightAction: [
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: InkWell(
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              setState(() {
                // 关闭键盘
                print("----------------------open emo-----------------");
                FocusScope.of(context).unfocus();
                _emojiShowing = false;

                // _changeHeight = (_changeHeight == 0.0 ? 300.0 : 0.0); // 切换高度
                animate = !animate;
                print("_changeHeight: $_changeHeight");
              });
            },
          ),
        ),
      ],
      // left左边功能
      actions: [
        InkWell(
          child: Icon(
            Icons.file_present,
            color: Colors.black,
            size: 28,
          ),
          onTap: () {
            print("open file");
            // 打开sheet显示图片和文件
            chatPageModel.handleAttachmentPressed();
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 3, right: 5),
          child: InkWell(
            child: Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              setState(() {
                // 关闭键盘
                print("----------------------open emo-----------------");
                FocusScope.of(context).unfocus();
                animate = false;
                // _changeHeight = (_changeHeight == 0.0 ? 300.0 : 0.0); // 切换高度
                _emojiShowing = !_emojiShowing;
                print("open emo: $_emojiShowing");
              });
              // // 弹出emos
              // openEmjo();
            },
          ),
        )
      ],
      //
    );
  }

  Widget MessageBar(
      {replying = false,
      replyingTo = "",
      actions = const [],
      replyWidgetColor = const Color(0xffF4F4F5),
      replyIconColor = Colors.blue,
      replyCloseColor = Colors.black12,
      messageBarColor = const Color(0xffF4F4F5),
      sendButtonColor = Colors.blue,
      messageBarHitText = "Type your message here",
      messageBarHintStyle = const TextStyle(fontSize: 16),
      onTextChanged,
      onTapCloseReply,
      suffixIcon,
      rightAction = const [],
      prefixIcon}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            replying
                ? Container(
                    color: replyWidgetColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.reply,
                          color: replyIconColor,
                          size: 24,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              'Re : ' + replyingTo,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: onTapCloseReply,
                          child: Icon(
                            Icons.close,
                            color: replyCloseColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ))
                : Container(),
            // 底部功能
            Container(
              color: messageBarColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: <Widget>[
                  ...actions,
                  Expanded(
                    child: Container(
                      child: TextField(
                        // readOnly: true, // 不弹出键盘
                        focusNode: _focusNode,
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 3,
                        onChanged: onTextChanged,
                        decoration: InputDecoration(
                          prefixIcon: prefixIcon,
                          suffixIcon: suffixIcon,
                          hintText: messageBarHitText,
                          hintMaxLines: 1,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          hintStyle: messageBarHintStyle,
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 0.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...rightAction,
                ],
              ),
            ),
            // 可扩展区域
            Column(children: [if (animate) const ChatBottomTool(), emoj()])
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 增加监听器监听聚焦操作
    _focusNode.addListener(() {
      print("-------------focusNode------------------");
      if (_focusNode.hasFocus) {
        print("TextField 获得焦点");
        // 关闭emo和add
        setState(() {
          _emojiShowing = false;
          animate = false;
          _changeHeight = (_changeHeight == 0.0 ? 300.0 : 0.0); // 切换高度
          print("_changeHeight: $_changeHeight");
        });
      } else {
        print("TextField 失去焦点");
      }
    });
  }

  // 底部聊天输入框1
  Widget BottomSheet() {
    final _formKey = GlobalKey<FormBuilderState>();
    final _messageFieldKey = GlobalKey<FormBuilderFieldState>();
    // 存储信息
    String? msgText;

    return Container(
        padding: EdgeInsets.fromLTRB(0, 3.sp, 0, 3.sp),
        color: Colors.grey,
        width: double.infinity,
        height: 50.h,
        child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: StaggeredGrid.count(
              crossAxisCount: 6,
              // mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              children: [
                // left
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Center(
                    child: Icon(Icons.emoji_emotions),
                  ),
                ),
                //center
                StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 1,
                  child: FormBuilder(
                      key: _formKey,
                      child: FormBuilderTextField(
                        key: _messageFieldKey,
                        name: 'text',
                        onChanged: (text) {
                          msgText = text;
                          print("msg content: $msgText");
                        },
                        decoration: InputDecoration(
                            // 提示
                            hintText: "input message",
                            // 设置背景色为灰色
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            // 确保在不同状态下使用相同的圆角边框
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(27.sp),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            suffixIcon: MaterialButton(
                                child: Icon(
                                  Icons.send,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  // 打印发送的消息文本
                                  print("Send: $msgText");
                                  // 创建一个新的 PartialText 对象并设置其文本
                                  var message =
                                      types.PartialText(text: msgText ?? '');

                                  // 发送消息
                                  chatPageModel.handleSendPressed(message);

                                  // 打印发送确认
                                  print("Message sent successfully.");
                                }),
                            prefixIcon: MaterialButton(
                                child: Icon(
                                  Icons.emoji_emotions,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  print("emo..........");
                                })),
                      )),
                ),
                // right
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Center(
                    child: Icon(
                      Icons.add_circle_outlined,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget emoj() {
    // 开始播放
    return Offstage(
        offstage: !_emojiShowing,
        child: SizedBox(
            height: 250,
            child: EmojiPicker(
              textEditingController: _emoController,
              scrollController: _scrollController,
              onEmojiSelected: (category, emoji) {
                print(emoji);
                if (emoji is Emoji) {
                  // 添加进文本
                  print("==================emoj=============================");
                  String text = _textController.text;
                  // 更新
                  setState(() {
                    _textController.text += emoji.emoji.toString();
                    _isText = true;
                    print("emoj msg: $text");
                  });
                }
              },
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                swapCategoryAndBottomBar: true,
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(
                    backgroundColor: Color(0xFFEBEFF2),
                    buttonIconColor: Colors.black,
                    buttonColor: Color(0xFFEBEFF2)),
                searchViewConfig:
                    const SearchViewConfig(backgroundColor: Color(0xFFEBEFF2)),
              ),
            )));
  }
}
