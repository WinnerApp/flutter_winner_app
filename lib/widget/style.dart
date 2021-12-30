import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/global_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Style {}

extension NavigationBarStyle on Style {
  /// 导航条的标题
  static Text navigationBarTitle({required String title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Global().appConfig.colorTheme.navigationBarTitle,
      ),
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
      backgroundColor:
          backgroundColor ?? Global().appConfig.colorTheme.toastBackground,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// 展示错误消息
  /// [msg] 错误消息内容
  static Future<void> showErrorToast({required String msg}) async {
    Global().appConfig.showErrorToast(msg);
  }

  /// 展示成功消息
  /// [msg] 成功消息内容
  static showSuccessToast({required String msg}) {
    Global().appConfig.showSuccessToast(msg);
  }
}

extension WinnerTextStyle on Style {
  static Text listTitleText(String data) => Text(
        data,
        style: TextStyle(
          fontSize: Global().appConfig.fontTheme.listTitleText,
          color: Global().appConfig.colorTheme.listTitleText,
        ),
      );

  static Text listValueText(String data) => Text(
        data,
        style: TextStyle(
          fontSize: Global().appConfig.fontTheme.listValueText,
          color: Global().appConfig.colorTheme.listValueText,
        ),
      );

  static Text text(
    String data, {
    Color? color,
    double? fontSize,
  }) {
    return Text(
      data,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
