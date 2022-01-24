import 'package:event_bus/event_bus.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';

class Global {
  static final Global _global = Global._();
  Global._();
  factory Global() => _global;
  final EventBus eventBus = EventBus();

  /// 请求的[Manager]
  late HttpManager httpManager;

  /// [Winner App]的配置文件
  late WinnerAppConfig appConfig;

  Future<M> request<T, C extends JsonConverter, M extends WinnerBaseModel<T>>({
    required Api<C, M> api,
  }) async {
    Map<String, dynamic> headers = appConfig.httpHeaders;

    /// 获取当前App配置
    AppEnvironment environment = AppEnvironmentManager().appEnvironment;
    BaseUrl url = await BaseUrl.currentUrl(environment);
    httpManager.baseUrl = appConfig.configRequestPath(url, api);
    return httpManager.request(api, headers: headers);
  }

  /// 初始化[HttpManager]
  Future<void> initHttpManager<C extends WinnerAppConfig>(C config) async {
    /// 初始化 [appConfig]
    appConfig = config;

    /// 获取当前App配置
    AppEnvironment environment = AppEnvironmentManager().appEnvironment;

    /// 获取当前请求的[url]
    BaseUrl url = await BaseUrl.currentUrl(environment);

    /// 获取请求的[path]
    String requestPath = config.configRequestPath(url, null);

    /// 初始化[HttpManager]
    httpManager = HttpManager(baseUrl: requestPath);
  }

  /// 更新请求的[Url] 支持程序运行期间切换环境
  /// [url] 最新的请求地址
  void updateUrl(BaseUrl url) {
    /// 获取请求的[path]
    String requestPath = appConfig.configRequestPath(url, null);

    /// 重新设置[HttpManager]的请求路径
    httpManager.baseUrl = requestPath;
  }
}
