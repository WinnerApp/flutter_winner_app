import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';

class CustomPlugin extends Pluggable {
  /// 名字
  final String pluginName;

  final Widget Function(BuildContext context) pageBuilder;

  final VoidCallback? onTriggerCallback;

  final ImageProvider<Object>? image;

  CustomPlugin({
    required this.pluginName,
    required this.pageBuilder,
    this.onTriggerCallback,
    this.image,
  });
  @override
  Widget buildWidget(BuildContext? context) {
    if (context == null) return Container();
    return MaterialApp(
      home: pageBuilder(context),
    );
  }

  @override
  String get displayName => pluginName;

  @override
  ImageProvider<Object> get iconImageProvider =>
      image ?? const AssetImage("images/ume.png");

  @override
  String get name => pluginName;

  @override
  void onTrigger() => onTriggerCallback?.call();
}
