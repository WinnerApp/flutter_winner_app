import 'package:flutter_winner_app/constant/winner_environment_url.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_environment.dart';

class BaseUrl {
  /// 请求的基础地址
  final String url;

  BaseUrl(this.url);

  static const String baseURLKey = "base_url";

  /// 获取当前请求的URL
  static Future<BaseUrl> currentUrl(AppEnvironment environment) async {
    /// 只有体验测试版本 才允许读取用户保存的服务器地址
    if (AppEnvironmentManager().isDeveloperEnvironment) {
      var url = await _getPreferenceBaseUrl();
      if (url != null) return BaseUrl(url);
    }
    WinnerEnvironmentUrl? url = WinnerApp().url;
    if (url == null) {
      throw "你必须在main初始化WinnerApp.url";
    }
    switch (environment) {
      case AppEnvironment.debug:
        return url.debug;
      case AppEnvironment.profile:
        return url.profile;
      case AppEnvironment.release:
        return url.release;
      default:
        return BaseUrl("");
    }
  }

  /// 获取存储在本地的网络地址
  static Future<String?> _getPreferenceBaseUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(baseURLKey);
  }

  /// 保存当前的网络地址到配置文件
  /// [url] 保存的网络地址
  static Future<void> savePreferenceBaseUrl(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(baseURLKey, url);
  }
}
