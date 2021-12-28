import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/winner_color.dart';

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
  const EmptyView(this.icon, this.title, this.actionTitle, this.tap, {Key? key})
      : super(key: key);

  @override
  _EmptyViewState createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: WColor.cf8f9fa().color,
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
}
