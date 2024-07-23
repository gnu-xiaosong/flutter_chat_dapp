/*
音效类
 */
import 'package:app_template/microService/module/common/Console.dart';
import 'package:just_audio/just_audio.dart';

// 枚举音效
enum Audios { message, scan }

class AudioModel with Console {
  /*
  播放
   */
  _play(String url) async {
    final player = AudioPlayer(); // Create a player
    // player.playerStateStream.listen((state) {
    //   switch (state.processingState) {
    //     case ProcessingState.completed:
    //       // 去除
    //       print("play is completed");
    //   }
    // });
    await player.setAsset(url); // Schemes: (https: | file: | asset: )
    player.play();
  }

  /*
  播放音效
   */
  playAudioEffect(Audios audios) {
    printSuccess("play message effect");
    late String url;
    // 聊天音效
    if (audios == Audios.message) {
      // 获取路径
      url = "assets/audios/messageAudio.wav";
    } else if (audios == Audios.scan) {
      // 获取路径
      url = "assets/audios/scanAudio.wav";
    }

    // 播放
    _play(url);
  }
}
