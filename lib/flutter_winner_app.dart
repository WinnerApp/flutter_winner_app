library flutter_winner_app;

import 'package:flutter_winner_app/constant/base_url_enum.dart';
import 'package:flutter_winner_app/constant/winner_environment_url.dart';
import 'package:flutter_winner_app/constant/winner_route.dart';

typedef ConfigHTTPRequestHeaders = void Function(Map<String, dynamic>);
typedef ConfigHTTPRequestPath = String Function(BaseUrl);

class WinnerApp {
  static final WinnerApp _winnerApp = WinnerApp._();
  WinnerApp._();
  factory WinnerApp() => _winnerApp;

  WinnerEnvironmentUrl? url;

  ConfigHTTPRequestHeaders? _configHTTPRequestHeaders;
  ConfigHTTPRequestHeaders? get headerConfig => _configHTTPRequestHeaders;

  ConfigHTTPRequestPath? _configHTTPRequestPath;
  ConfigHTTPRequestPath? get pathConfig => _configHTTPRequestPath;

  /// 路由列表
  List<WinnerRoute> winnerRoutes = [];

  /// 配置网络请求的 [Headers]
  void configHTTPRequestHeaders(ConfigHTTPRequestHeaders config) {
    _configHTTPRequestHeaders = config;
  }

  /// 配置网络请求的路径
  void configHTTPRequestPath(ConfigHTTPRequestPath config) {
    _configHTTPRequestPath = config;
  }
}
