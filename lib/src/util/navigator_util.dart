import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  ///跳转到指定页面，Cupertino主题 （ios）
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  static Future<T?> pushAsync<T>(BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    );
  }

  /// 模态弹出一个视图
  /// - context 来源视图
  /// - page 对应界面
  /// - fullscreenDialog 是否全屏幕 默认为true
  static Future<T?> present<T>(
    BuildContext context,
    Widget page, {
    bool fullscreenDialog = true,
  }) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
        fullscreenDialog: fullscreenDialog,
        builder: (context) => page,
      ),
    );
  }

  /// 模态弹出一个视图并异步获取返回的值
  /// - context 来源视图
  /// - page 对应界面
  /// - fullscreenDialog 是否全屏幕 默认为true
  static Future<dynamic> presentAsync(BuildContext context, Widget page,
      {bool fullscreenDialog = true}) async {
    return await Navigator.push(
        context,
        CupertinoPageRoute(
          fullscreenDialog: fullscreenDialog,
          builder: (context) => page,
        ));
  }

  ///跳转到指定页面,meterial主题 （Android）
  static Future<T?> pushMaterial<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static Future<T?> pushAsyncMaterial<T>(
      BuildContext context, Widget page) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
