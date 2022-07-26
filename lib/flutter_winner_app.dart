library flutter_winner_app;

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // debugPrint 插件包
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // 性能插件包
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI 插件包
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

export 'src/common/base_page.dart';
export 'src/common/base_view_model.dart';
export 'src/common/custom_selector.dart';
export 'src/common/winner_base_model.dart';
export 'src/common/winner_pull_refresh_page.dart';
export 'src/common/winner_store.dart';
export 'src/constant/app_environment.dart';
export 'src/constant/base_url_enum.dart';
export 'src/constant/global_config.dart';
export 'src/constant/sentry_host.dart';
export 'src/constant/winner_app_config.dart';
export 'src/constant/winner_color.dart';
export 'src/constant/winner_environment_url.dart';
export 'src/constant/winner_font.dart';
export 'src/constant/winner_route.dart';
export 'src/extends/number_text_formatter.dart';
export 'src/manager/app_cache_manager.dart';
export 'src/manager/list_manager.dart';
export 'src/manager/next_focus_node_manager.dart';
export 'src/model/page_model.dart';
export 'src/network/api.dart';
export 'src/network/base_model.dart';
export 'src/network/http_manager.dart';
export 'src/network/proxy_config.dart';
export 'src/page/server_config/server_config_page.dart';
export 'src/util/custom_plugin.dart';
export 'src/util/event_manager.dart';
export 'src/util/file_cache_util.dart';
export 'src/util/log_util.dart';
export 'src/util/navigator_util.dart';
export 'src/util/object_util.dart';
export 'src/util/phone_util.dart';
export 'src/widget/empty_view.dart';
export 'src/widget/keep_alive_wrapper.dart';
export 'src/widget/press_state_button.dart';
export 'src/widget/start_end_view.dart';
export 'src/widget/style.dart';
export 'src/widget/tab_page.dart';
export 'src/widget/view_line.dart';
export 'src/widget/view_util.dart';
export 'src/widget/winner_app_bar.dart';
export 'src/widget/winner_card.dart';
export 'src/widget/winner_data_picker.dart';
export 'src/widget/winner_list_foot_view.dart';
export 'src/widget/winner_material_app.dart';
export 'src/widget/winner_navigation_bar_title.dart';
export 'src/widget/winner_pop_up_menu_button.dart';
export 'src/widget/winner_text.dart';

/// 配置请求的地址
/// [url] 当前请求的地址
typedef ConfigHTTPRequestPath = String Function(BaseUrl url);

/// App 进入页面之前异步初始化方法
typedef WinnerAppInit = Future<void> Function();

///默认全局路由观测者
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// 用于初始化 Flutter App
/// ```dart
/// void main() async {
///   /// AppConfig 为 WinnerAppConfig 的子类，用于配置一些需要的配置
///   AppConfig config = AppConfig()
///   await WinnerApp(config).appMain(appInit:() async {
///     /// 初始化一些其他操作
///   })
/// }
/// ```
class WinnerApp<Config extends WinnerAppConfig> {
  const WinnerApp(this.appConfig);

  /// Winner App的配置文件 需要自定义子类
  final Config appConfig;

  Future<void> appMain({
    WinnerAppInit? appInit,
  }) async {
    /// 初始化一个 [WidgetsFlutterBinding] 用于 [Method Channel]的交互
    WidgetsFlutterBinding.ensureInitialized();

    /// 初始化[HttpManager]
    await Global().initHttpManager(appConfig);

    /// 初始化 App 存在本地的缓存
    await AppCacheManager().initCacheData();

    /// 执行外部的初始化
    await appInit?.call();

    _sentryAppRunner();

    appConfig.configSystemChrome();
  }

  void _sentryAppRunner() {
    /// 获取[Dio]实例
    final Dio dio = Global().httpManager.client;
    if (AppEnvironmentManager().isDeveloperEnvironment) {
      PluginManager.instance // 注册插件
        ..register(const WidgetInfoInspector())
        ..register(AlignRuler())
        ..register(Performance())
        ..register(Console())
        ..register(DioInspector(dio: dio)); // 传入你的 Dio 实例
      Global().appConfig.configUMEPlugin(PluginManager.instance);
      runApp(UMEWidget(child: _mainWidget()));
    } else {
      runApp(_mainWidget());
    }
  }

  Widget _mainWidget() {
    List<SingleChildWidget> providers = appConfig.providers
      ..add(ChangeNotifierProvider.value(value: appConfig))
      ..add(ChangeNotifierProvider.value(value: AppCacheManager()));
    return MultiProvider(
      providers: providers,
      child: Selector<Config, bool>(
        selector: (context, value) => value.isEnablePreviewDevice,
        builder: (context, data, child) {
          return DevicePreview(
            enabled: data,
            builder: (context) => const MyApp(),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WinnerMaterialApp app = _materialApp(context);
    Global().appConfig.configMaterialApp(app);
    return Global().appConfig.appWrapper(context, app.materialApp);
  }

  WinnerMaterialApp _materialApp(BuildContext context) {
    return WinnerMaterialApp()
      ..debugShowCheckedModeBanner = false
      ..routes = _routes()
      ..theme = ThemeData(
        appBarTheme: AppBarTheme(
          color: Global().appConfig.colorTheme.appBarBackground,
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.black),
        ),
      )
      ..home = Global().appConfig.appHome(context)
      ..navigatorObservers = [
        routeObserver,
        ...Global().appConfig.navigatorObservers
      ];
  }

  Map<String, WidgetBuilder> _routes() {
    Map<String, WidgetBuilder> routes = {};
    for (final element in Global().appConfig.routes) {
      routes[element.path] = element.routeMake;
    }
    return routes;
  }
}
