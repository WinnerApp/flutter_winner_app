import 'package:flutter/material.dart';

/// 稳健卡片组件
class WinnerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? radius;

  /// 卡片的背景颜色
  final Color? backgroundColor;
  const WinnerCard({
    Key? key,
    required this.child,
    this.margin,
    this.radius,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))),
      child: child,
    );
  }
}