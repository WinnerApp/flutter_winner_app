import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class NavigatorUtil {
  ///跳转到指定页面，Cupertino主题 （ios）
  static push(BuildContext context, Widget page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  static pushAsync(BuildContext context, Widget page) async {
    return await Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  /// 模态弹出一个视图
  /// - context 来源视图
  /// - page 对应界面
  /// - fullscreenDialog 是否全屏幕 默认为true
  static present(BuildContext context, Widget page, {bool fullscreenDialog = true}) {
    Navigator.push(
        context,
        CupertinoPageRoute(
          fullscreenDialog: fullscreenDialog,
          builder: (context) => page,
        ));
  }

  /// 模态弹出一个视图并异步获取返回的值
  /// - context 来源视图
  /// - page 对应界面
  /// - fullscreenDialog 是否全屏幕 默认为true
  static Future<dynamic> presentAsync(BuildContext context, Widget page, {bool fullscreenDialog = true}) async {
    return await Navigator.push(
        context,
        CupertinoPageRoute(
          fullscreenDialog: fullscreenDialog,
          builder: (context) => page,
        ));
  }

  ///跳转到指定页面,meterial主题 （Android）
  static pushMaterial(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static pushAsyncMaterial(BuildContext context, Widget page) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
