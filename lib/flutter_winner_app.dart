library flutter_winner_app;

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI 插件包
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // 性能插件包
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // debugPrint 插件包
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';

import 'package:flutter_winner_app/flutter_winner_app.dart';

export 'src/common/base_page.dart';
export 'src/common/base_view_model.dart';
export 'src/common/winner_base_model.dart';
export 'src/common/winner_store.dart';

export 'src/constant/app_environment.dart';
export 'src/constant/base_url_enum.dart';
export 'src/constant/global_config.dart';
export 'src/constant/winner_color.dart';
export 'src/constant/winner_environment_url.dart';
export 'src/constant/winner_font.dart';
export 'src/constant/winner_route.dart';
export 'src/constant/sentry_host.dart';
export 'src/constant/winner_app_config.dart';
export 'src/widget/winner_material_app.dart';
export 'src/widget/keep_alive_wrapper.dart';

export 'src/extends/number_text_formatter.dart';

export 'src/manager/next_focus_node_manager.dart';

export 'src/network/api.dart';
export 'src/network/base_model.dart';
export 'src/network/http_manager.dart';
export 'src/network/proxy_config.dart';

export 'src/util/event_manager.dart';
export 'src/util/file_cache_util.dart';
export 'src/util/log_util.dart';
export 'src/util/navigator_util.dart';
export 'src/util/object_util.dart';
export 'src/util/phone_util.dart';

export 'src/widget/empty_view.dart';
export 'src/widget/press_state_button.dart';
export 'src/widget/style.dart';
export 'src/widget/view_line.dart';
export 'src/widget/view_util.dart';
export 'src/widget/winner_app_bar.dart';
export 'src/widget/winner_card.dart';
export 'src/widget/winner_data_picker.dart';
export 'src/widget/winner_list_foot_view.dart';
export 'src/widget/winner_navigation_bar_title.dart';
export 'src/widget/winner_pop_up_menu_button.dart';
export 'src/widget/winner_text.dart';
export 'src/widget/winner_text_button.dart';
export 'src/widget/tab_page.dart';

typedef ConfigHTTPRequestHeaders = void Function(Map<String, dynamic>);
typedef ConfigHTTPRequestPath = String Function(BaseUrl);
typedef WinnerAppInit = Future<void> Function();

//
class WinnerApp<Config extends WinnerAppConfig> {
  /// Winner App的配置文件
  final Config appConfig;
  WinnerApp(this.appConfig);

  Future<void> appMain({
    WinnerAppInit? appInit,
  }) async {
    /// 初始化一个 [WidgetsFlutterBinding] 用于 [Method Channel]的交互
    WidgetsFlutterBinding.ensureInitialized();

    /// 初始化[HttpManager]
    await Global().initHttpManager(appConfig);

    /// 执行外部的初始化
    await appInit?.call();

    /// 初始化[App]
    await SentryFlutter.init(
      (option) => option.dsn = _sentryHost,
      appRunner: _sentryAppRunner,
    );

    /// 设置导航栏的样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
      ),
    );
  }

  /// [Sentry]的地址
  String get _sentryHost {
    if (AppEnvironmentManager().isDeveloperEnvironment) {
      return appConfig.sentryHost.debug;
    } else {
      return appConfig.sentryHost.release;
    }
  }

  /// [Sentry]启动
  void _sentryAppRunner() {
    /// 获取[Dio]实例
    Dio dio = Global().httpManager.client;
    if (AppEnvironmentManager().isDeveloperEnvironment) {
      PluginManager.instance // 注册插件
        ..register(const WidgetInfoInspector())
        ..register(AlignRuler())
        ..register(Performance())
        ..register(Console())
        ..register(DioInspector(dio: dio)); // 传入你的 Dio 实例
      runApp(injectUMEWidget(
        child: _mainWidget(),
        enable: true,
      ));
    } else {
      runApp(_mainWidget());
    }
  }

  Widget _mainWidget() {
    List<SingleChildWidget> providers = appConfig.providers;
    providers.add(ChangeNotifierProvider.value(value: appConfig));
    return MultiProvider(
      providers: providers,
      child: Selector<Config, bool>(
        selector: (context, value) => value.isEnablePreviewDevice,
        builder: (context, data, child) {
          return DevicePreview(
            enabled: data,
            builder: (context) {
              return const MyApp();
            },
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
    return app.materialApp;
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
      ..home = Global().appConfig.appHome(context);
  }

  Map<String, WidgetBuilder> _routes() {
    Map<String, WidgetBuilder> routes = {};
    for (var element in Global().appConfig.routes) {
      routes[element.path] = element.routeMake;
    }
    return routes;
  }
}
