/*
 console控制打印封装类
 */
import 'package:chalkdart/chalkstrings.dart';
import 'package:chalkdart/chalkstrings_x11.dart';

mixin Console {
  // 正常消息
  printInfo(dynamic info) {
    var data = info.toString().whiteBright;
    print(data);
  }

  // 打印成功消息
  printSuccess(dynamic info) {
    var data = info.toString().green.font10;
    print(data);
  }

  // 打印失败消息
  printFaile(dynamic e) {
    var str = e.toString().redBright.bold;
    print(str);
  }

  //错误信息
  printError(dynamic err) {
    var errstr = err.toString().redBright;
    print(errstr);
  }

  //警告信息
  printWarn(dynamic warn) {
    var warning = warn.toString().keyword("orange");
    print(warning);
  }

  //打印进度条
  printProgress(dynamic data) {
    print(data);
  }

  // 打印表格输出
  printTable(Map data) {}

  // 报错异常catch捕获
  printCatch(dynamic e) {
    var catche = e.toString().redX11;
    print(catche);
  }
}
