/*
  消息队列类： 存储map类
 */

import 'dart:async';
import 'dart:collection';

class MessageQueue {
  // 定义队列
  final Queue<Map> _queue = Queue<Map>();
  // 设置队列变化监听器
  final StreamController<Map> _controller = StreamController.broadcast();
  Stream<Map>? get stream => _controller.stream;

  // 将消息入队
  void enqueue(Map message) {
    _queue.addLast(message);
    // 调用控制器: 传入参数为message
    _controller.add(message);
  }

  // 从队列中取出消息
  Map? dequeue() {
    if (_queue.isNotEmpty) {
      return _queue.removeFirst();
    } else {
      return null;
    }
  }

  // 获取队列的长度
  int get length => _queue.length;

  // 清空队列
  void clear() {
    // _controller.close();
    _queue.clear();
  }

  // 查看队首消息，不移除
  Map? peek() {
    if (_queue.isNotEmpty) {
      return _queue.first;
    } else {
      return null;
    }
  }

  // 查看队尾消息
  Map? last() {
    if (_queue.isNotEmpty) {
      return _queue.last;
    } else {
      return null;
    }
  }
}
