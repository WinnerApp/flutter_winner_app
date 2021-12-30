import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/base_url_enum.dart';
import 'package:flutter_winner_app/constant/sentry_host.dart';
import 'package:flutter_winner_app/constant/winner_color.dart';
import 'package:flutter_winner_app/constant/winner_environment_url.dart';
import 'package:flutter_winner_app/constant/winner_font.dart';
import 'package:flutter_winner_app/constant/winner_route.dart';
import 'package:provider/single_child_widget.dart';

abstract class WinnerAppConfig extends ChangeNotifier {
  /// 支持服务器请求的[url]
  List<BaseUrl> _appUrls = [];
  List<BaseUrl> get appUrls => _appUrls;

  /// 初始化
  WinnerAppConfig();

  /// 更新当前页面支持的 [URL]
  void updateAppUrls(List<BaseUrl> urls) {
    _appUrls = urls;
    notifyListeners();
  }

  /// 配置 [HTTP Header]
  Map<String, dynamic> get httpHeaders => {};

  /// 配置请求的[url] 可以根据[BaseUrl]自定义请求地址
  String configRequestPath(BaseUrl url) => url.url;

  /// 配置[SentryHost]
  SentryHost get sentryHost;

  /// 配置首页配置[providers]
  List<SingleChildWidget> get providers => [];

  /// 是否开启设备预览
  bool _isEnablePreviewDevice = false;
  bool get isEnablePreviewDevice => _isEnablePreviewDevice;

  set isEnablePreviewDevice(bool value) {
    _isEnablePreviewDevice = value;
    notifyListeners();
  }

  /// 设置静态页面路由
  List<WinnerRoute> get routes => [];

  /// App 首页的[Home]
  Widget appHome(BuildContext context);

  /// 配置环境对应的请求地址
  WinnerEnvironmentUrl get environmentUrl;

  /// 展示错误[Toast]
  void showErrorToast(String message) {}

  /// 展示成功[Toast]
  void showSuccessToast(String message) {}

  /// 颜色主题
  WColor colorTheme = WColor();

  /// 字体主题
  WFont fontTheme = WFont();
}
