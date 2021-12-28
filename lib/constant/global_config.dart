import 'package:event_bus/event_bus.dart';
import 'package:flutter_winner_app/common/winner_base_model.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:flutter_winner_app/network/api.dart';
import 'package:flutter_winner_app/network/http_manager.dart';
import 'package:json_annotation/json_annotation.dart';

import 'app_environment.dart';
import 'base_url_enum.dart';

class Global {
  static HttpManager? httpManager;
  static EventBus eventBus = EventBus();
  static Future<M>
      request<T, C extends JsonConverter, M extends WinnerBaseModel<T>>({
    required Api<C, M> api,
  }) async {
    await initHttp();
    Map<String, dynamic> headers = {};
    WinnerApp().headerConfig?.call(headers);
    return httpManager!.request(api, headers: headers);
  }

  static Future<void> initHttp() async {
    AppEnvironment environment = AppEnvironmentManager().appEnvironment;
    BaseUrl url = await BaseUrl.currentUrl(environment);
    String requestPath = url.url;
    ConfigHTTPRequestPath? pathConfig = WinnerApp().pathConfig;
    if (pathConfig != null) {
      requestPath = pathConfig.call(url);
    }
    if (httpManager == null || httpManager!.baseUrl != requestPath) {
      httpManager = HttpManager(baseUrl: requestPath);
    }
  }
}
