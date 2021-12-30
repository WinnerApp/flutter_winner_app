library flutter_winner_app;

import 'package:device_preview/device_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_winner_app/constant/app_environment.dart';
import 'package:flutter_winner_app/constant/base_url_enum.dart';
import 'package:flutter_winner_app/constant/global_config.dart';
import 'package:flutter_winner_app/constant/winner_app_config.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI 插件包
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // 性能插件包
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // debugPrint 插件包
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';

export 'common/base_page.dart';
export 'common/base_view_model.dart';
export 'common/winner_base_model.dart';
export 'common/winner_store.dart';

export 'constant/app_environment.dart';
export 'constant/base_url_enum.dart';
export 'constant/global_config.dart';
export 'constant/winner_color.dart';
export 'constant/winner_environment_url.dart';
export 'constant/winner_font.dart';
export 'constant/winner_route.dart';
export 'constant/sentry_host.dart';
export 'constant/winner_app_config.dart';

export 'extends/number_text_formatter.dart';

export 'manager/next_focus_node_manager.dart';

export 'network/api.dart';
export 'network/base_model.dart';
export 'network/http_manager.dart';
export 'network/proxy_config.dart';

export 'util/event_manager.dart';
export 'util/file_cache_util.dart';
export 'util/log_util.dart';
export 'util/navigator_util.dart';
export 'util/object_util.dart';
export 'util/phone_util.dart';

export 'widget/empty_view.dart';
export 'widget/press_state_button.dart';
export 'widget/style.dart';
export 'widget/view_line.dart';
export 'widget/view_util.dart';
export 'widget/winner_app_bar.dart';
export 'widget/winner_card.dart';
export 'widget/winner_data_picker.dart';
export 'widget/winner_list_foot_view.dart';
export 'widget/winner_navigation_bar_title.dart';
export 'widget/winner_pop_up_menu_button.dart';
export 'widget/winner_text.dart';
export 'widget/winner_text_button.dart';

typedef ConfigHTTPRequestHeaders = void Function(Map<String, dynamic>);
typedef ConfigHTTPRequestPath = String Function(BaseUrl);
typedef WinnerAppInit = Future<void> Function();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: _routes(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Global().appConfig.colorTheme.appBarBackground,
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.black),
        ),
      ),
      home: Global().appConfig.appHome(context),
    );
  }

  Map<String, WidgetBuilder> _routes() {
    Map<String, WidgetBuilder> routes = {};
    for (var element in Global().appConfig.routes) {
      routes[element.path] = element.routeMake;
    }
    return routes;
  }
}
