import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/single_child_widget.dart';

/// 配置 Winner App 的基础配置
abstract class WinnerAppConfig extends ChangeNotifier {
  List<BaseUrl> _appUrls = <BaseUrl>[];

  /// 目前支持的接口配置 可以通过 BaseUrl 的子类来加载不同请求地址不同配置的目的
  List<BaseUrl> get appUrls => _appUrls;

  /// 初始化
  WinnerAppConfig();

  /// 更新当前 App 支持的环境地址 比如在测试包新增一个自由配置环境地址 可以通过这个方法更新环境地址列表
  /// [urls] 更新
  void updateAppUrls<URL extends BaseUrl>(List<URL> urls) {
    _appUrls = urls;
    notifyListeners();
  }

  /// 配置 公共 [HTTP Header] 比如 登录之后授权的 Token
  Map<String, dynamic> get httpHeaders => <String, dynamic>{};

  /// 配置请求的[url] 可以根据[BaseUrl]自定义请求地址 比如根据不同的环境，有不同的路由前缀。
  String configRequestPath(BaseUrl url, Api? api) => url.url;

  /// 配置[SentryHost] 支持 Sentry 上报
  @Deprecated('未来这个属性将被移除')
  SentryHost get sentryHost;

  /// 配置全局的 Provider 建议将全局的 Provider 设置为单例模式 比如用户信息管理 App 运行期间的数据管理
  List<SingleChildWidget> get providers => [];

  /// 配置app路由观测者[navigatorObservers]
  List<NavigatorObserver> get navigatorObservers => [];

  /// 是否开启设备预览 用于在设备运行期间查看不同手机尺寸的运行效果 方便调试和做兼容
  bool _isEnablePreviewDevice = false;

  bool get isEnablePreviewDevice => _isEnablePreviewDevice;

  /// 设置设备预览的可见性
  /// [value] 如果 true 代表设备预览可见 false 代表设备预览不可见
  set isEnablePreviewDevice(bool value) {
    _isEnablePreviewDevice = value;
    notifyListeners();
  }

  /// 设置静态页面路由
  List<WinnerRoute> get routes => [];

  /// App 首页的 Home
  Widget appHome(BuildContext context);

  /// 提供给外部包裹[MyApp]的机会
  Widget appWrapper(BuildContext context, Widget child) {
    return child;
  }

  /// 配置环境对应的请求地址
  ///
  /// 直接通过字符串进行初始化地址
  /// ```dart
  /// WinnerEnvironmentUrl(
  ///   debug: "debug url",
  ///   profile: "profile url",
  ///   release: "release url",
  /// );
  /// ```
  ///
  /// 通过 BaseUrl 类或者子类进行创建
  /// ```dart
  /// WinnerEnvironmentUrl.fromUrl(
  ///   debug: BaseUrl(url: "debug url"),
  ///   profile: BaseUrl(url: "profile url"),
  ///   release: BaseUrl(url: "release url"),
  /// );
  /// ```
  WinnerEnvironmentUrl get environmentUrl;

  /// 展示错误信息的统一回调 通过这个方法自定义提示
  /// App 可以统一通过提示错误
  /// ```dart
  /// ToastStyle.showErrorToast(msg: "error message");
  /// ```
  void showErrorToast(String message) {}

  /// 展示错误信息的异步方法 比如弹出一个错误提示框 当用户点击关闭按钮之后 依然需要进行操作时候用到
  /// ```dart
  /// ToastStyle.showAsyncErrorToast(context: context, msg: "error message");
  /// ```
  Future<void> showAsyncErrorToast(
    BuildContext context,
    String message,
  ) async {}

  /// 展示成功的信息
  /// ```dart
  /// ToastStyle.showSuccessToast(msg: "success")
  /// ```
  void showSuccessToast(String message) {}

  /// 颜色主题 自带的一些组件用到了一些配色 可以通过 WColor 子类进行重写
  WColor colorTheme = WColor();

  /// 字体主题 自带的一些组件用到一些字体大小 可以通过 WFont 子类进行重写
  WFont fontTheme = WFont();

  /// 可以设置 MaterialApp 的其他属性
  void configMaterialApp(WinnerMaterialApp app) => {};

  /// 配置 UME插件 用于开发快速功能调试
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
  @Deprecated('未来这个属性将被移除')
  bool get isEnableSentry => true;

  /// 创建对应 App 缓存的对象 对象需要实现 JsonConverter
  JsonConverter? get getNewCacheConverter => null;
}
