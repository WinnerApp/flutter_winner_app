import 'package:flutter/foundation.dart';

enum AppEnvironment {
  debug,
  profile,
  release
}

/// App环境管理器
class AppEnvironmentManager {
  /// 是否是开发阶段
  bool get isDeveloperEnvironment {
    return appEnvironment == AppEnvironment.debug || appEnvironment == AppEnvironment.profile;
  }

  /// 当前App的运行环境
  late AppEnvironment appEnvironment;

  factory AppEnvironmentManager() =>_manager;

  static final AppEnvironmentManager _manager = AppEnvironmentManager._();

  AppEnvironmentManager._() {
    if (!kProfileMode && !kReleaseMode) {
      appEnvironment = AppEnvironment.debug;
    } else if (kProfileMode && !kReleaseMode) {
      appEnvironment = AppEnvironment.profile;
    } else {
      appEnvironment = AppEnvironment.release;
    }
  }
}
