import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/global_config.dart';

/// 空白试图
class EmptyView extends StatefulWidget {
  /// 图标名称
  final String icon;

  /// 显示标题
  final String title;

  /// 按钮显示标题
  final String actionTitle;

  /// 点击事件
  final void Function() tap;

  /// 背景颜色
  final Color? backgroundColor;
  const EmptyView(
    this.icon,
    this.title,
    this.actionTitle,
    this.tap, {
    Key? key,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _EmptyViewState createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(child: Container()),
          // Image(),
          Container(
            height: 50,
          ),
          Text(widget.title),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 78, vertical: 30),
          ),
        ],
      ),
    );
  }

  Color get backgroundColor {
    Color? backgroundColor = widget.backgroundColor;
    if (backgroundColor != null) return backgroundColor;
    return Global().appConfig.colorTheme.emptyBackground;
  }
}
