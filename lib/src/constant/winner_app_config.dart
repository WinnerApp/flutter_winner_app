import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME 框架

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
  String configRequestPath(BaseUrl url, Api? api) => url.url;

  /// 配置[SentryHost]
  SentryHost get sentryHost;

  /// 配置首页配置[providers]
  List<SingleChildWidget> get providers => [];

  /// 配置app路由观测者[navigatorObservers]
  List<NavigatorObserver> get navigatorObservers => [];

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

  /// 提供给外部包裹[MyApp]的机会
  @mustCallSuper
  Widget appWrapper(BuildContext context) {
    return const MyApp();
  }

  /// 配置环境对应的请求地址
  WinnerEnvironmentUrl get environmentUrl;

  /// 展示错误[Toast]
  void showErrorToast(String message) {}

  /// 展示错误信息 点击确定按钮之后的回掉
  Future<void> showAsyncErrorToast(
      BuildContext context, String message) async {}

  /// 展示成功[Toast]
  void showSuccessToast(String message) {}

  /// 颜色主题
  WColor colorTheme = WColor();

  /// 字体主题
  WFont fontTheme = WFont();

  void configMaterialApp(WinnerMaterialApp app) => {};

  /// 配置 UME插件
  void configUMEPlugin(PluginManager manager) => {};

  /// 自定义配置 SystemChrome
  void configSystemChrome() {
    /// 设置导航栏的样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
      ),
    );
  }

  /// 是否使用 Sentry 服务 关闭 则不会掉用 sentryHost
  bool get isEnableSentry => true;
}
