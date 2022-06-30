import 'package:flutter/material.dart';

/// Win+ 的路由配置
class WinnerRoute {
  /// 路由路径
  final String path;

  /// 路径名称
  final String name;

  ///模块类型
  final String moduleType;

  /// 路由实现
  final WidgetBuilder routeMake;

  /// 默认实现
  WinnerRoute(
    this.path,
    this.name,
    this.moduleType,
    this.routeMake,
  );
}
