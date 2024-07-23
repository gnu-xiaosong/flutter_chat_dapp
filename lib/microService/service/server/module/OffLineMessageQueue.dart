/*
  消息队列类： 存储map类
 */

import 'dart:collection';

class OffLineMessageQueue {
  final Queue<Map> _queue = Queue<Map>();

  // 将消息入队
  void enqueue(Map message) {
    _queue.addLast(message);
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
}
