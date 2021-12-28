library flutter_winner_app;

import 'package:flutter_winner_app/constant/base_url_enum.dart';
import 'package:flutter_winner_app/constant/winner_environment_url.dart';
import 'package:flutter_winner_app/constant/winner_route.dart';

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
