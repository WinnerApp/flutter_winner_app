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

//region国际化配置

  ///当前使用的语系

  Locale? _locale;

  Locale? get locale => _locale;

  set locale(Locale? val) {

    _locale = val;
    notifyListeners();

    if (val != null) {
      _saveLocal(val);
    }
  }

  ///无默认支持语系时,所取的语言
  Locale? get defaultLocale => const Locale('en');

  ///本地化的代理类
  Iterable<LocalizationsDelegate<dynamic>>? get localizationsDelegates => [];

  ///支持语系
  Iterable<Locale> get supportedLocales => const <Locale>[Locale('en', 'US')];

  ///首次进入时读取本地配置,app是否修改过语言  取上一次的语言
  Future<void> initLocale() async {
    var preferenceKey = const PreferenceKey('');
    var languageCode =
        await WinnerPreferenceStore(preferenceKey.localeLanguageCode)
            .getString();
    var countryCode =
        await WinnerPreferenceStore(preferenceKey.localeCountryCode)
            .getString();

    if (languageCode != null && languageCode != '') {
      //自动加载上一次保存的语系
      locale = Locale(languageCode, countryCode);
    }
    return;
  }

  ///持久化国际化信息
  Future<void> _saveLocal(Locale locale) async {
    var preferenceKey = const PreferenceKey('');
    WinnerPreferenceStore(preferenceKey.localeLanguageCode)
        .setString(locale.languageCode);
    WinnerPreferenceStore(preferenceKey.localeCountryCode)
        .setString(locale.countryCode ?? '');
    return;
  }

  ///App打开或者语言配置发生变化（在手机的设置里更改语言，app代码更改等）的时候会触发这个回调
  Locale? Function(Locale?, Iterable<Locale>)? get localeResolutionCallback =>
      (locale, locales) {
        Locale? res;
        String? supportLanguage;
        String? supportCountryCode;

        //判断系统当前第一个语系在不在app支持范围内
        for (var i = 0; i < locales.length; ++i) {
          var supportLocale = locales.elementAt(i);
          if (supportLocale.languageCode == locale?.languageCode) {
            supportLanguage = locale?.languageCode;
            if (supportLocale.countryCode == locale?.countryCode ||
                locale?.countryCode == '') {
              supportCountryCode = locale?.countryCode;
              break;
            }
          }
        }
        //无支持的语系
        if (supportLanguage == null) {
          res = defaultLocale;
        } else if (supportCountryCode == null) {
          //无完全支持的语系
          res = Locale(supportLanguage);
        } else {
          //完全支持
          res = locale;
        }
        _locale = res;
        return res;
      };

//endregion

}
