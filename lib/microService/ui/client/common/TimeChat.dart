/*
时间类
 */

import 'package:jiffy/jiffy.dart';

class TimeChat {
  /*
  格式化日期
   */
  String timeParse(DateTime time) {
    // 设置本地国家代码
    Jiffy.setLocale(Jiffy.now().localeCode);
    // 转化为Jiffy格式 and 格式化输出
    String timeString = Jiffy.parseFromDateTime(time).jm;

    return timeString;
  }
}
