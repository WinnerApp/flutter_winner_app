import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/winner_color.dart';
import 'package:flutter_winner_app/constant/winner_font.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Style {}

extension NavigationBarStyle on Style {
  /// 导航条的标题
  static Text navigationBarTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: WColor.headline().color,
      ),
    );
  }

  /// Winner的导航条
  static AppBar winnerAppBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return AppBar(
      centerTitle: true,
      title: navigationBarTitle(title: title),
      backgroundColor: WColor.navigationBar().color,
      actions: actions,
      leading: leading ?? const BackButton(color: Colors.black),
    );
  }
}

extension ToastStyle on Style {
  /// 展示提示文本
  /// [msg] 展示的文本
  /// [toastLength] 展示的长度 默认为[LENGTH_SHORT]
  static showToast({
    required String msg,
    Toast toastLength = Toast.LENGTH_SHORT,
    Color? backgroundColor,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor ?? WColor.main().color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

extension WinnerTextStyle on Style {
  static Text listTitleText(String data) => Text(
        data,
        style: TextStyle(
          fontSize: WFont.f14().font,
          color: WColor.c999999().color,
        ),
      );

  static Text listValueText(String data) => Text(
        data,
        style: TextStyle(
          fontSize: WFont.f14().font,
          color: WColor.c333333().color,
        ),
      );

  static Text text(
    String data, {
    WColor? color,
    WFont? font,
  }) {
    color = color ?? WColor.c209090();
    font = font ?? WFont.f14();
    return Text(
      data,
      style: TextStyle(
        fontSize: font.font,
        color: color.color,
      ),
    );
  }
}
