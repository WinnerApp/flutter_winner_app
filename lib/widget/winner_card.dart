import 'package:flutter/material.dart';
import 'package:flutter_shopping_mall/constant/winner_color.dart';
import 'package:flutter_winner_app/constant/winner_color.dart';

/// 稳健卡片组件
class WinnerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  const WinnerCard({
    Key? key,
    required this.child,
    this.margin,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          color: WColor.cffffff().color,
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))),
      child: child,
    );
  }
}
