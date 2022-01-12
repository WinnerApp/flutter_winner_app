import 'dart:async';
import 'package:event_bus/event_bus.dart';

class EventManager {
  static final EventManager _instance = EventManager._internal();
  factory EventManager() => _instance;

  late EventBus _bus;

  /// 创建 dio 实例对象
  EventManager._internal() {
    _bus = EventBus();
  }

  EventBus get eventBus => _bus;

  ///发送消息
  void post(event) {
    _bus.fire(event);
  }

  ///监听事件
  Stream<T> on<T>() {
    return _bus.on();
  }

  ///销毁
  void destroy() {
    _bus.destroy();
  }
}
