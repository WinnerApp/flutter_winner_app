import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class EmptyView extends StatelessWidget {
  final Widget child;
  const EmptyView({
    required this.child,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Global().appConfig.colorTheme.background,
      child: Center(
        child: child,
      ),
    );
  }
}

class IconTitleEmptyView extends StatelessWidget {
  final Widget icon;
  final String description;
  final double iconDescriptionSpace;

  const IconTitleEmptyView({
    required this.icon,
    required this.description,
    Key? key,
    this.iconDescriptionSpace = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          hiSpace(height: iconDescriptionSpace),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              description,
              style: const TextStyle(
                color: Color(0xFF8D8D8D),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyDataView extends StatelessWidget {
  final Widget icon;
  final String description;
  final void Function() onTap;
  final double iconTextSpace;
  final double textButtonSpace;
  final TextStyle textStyle;
  final Widget button;

  /// ![](https://gitee.com/joser_zhang/upic/raw/master/uPic/202201120908435.png)
  /// ## 参数
  /// - [icon] 空视图图片
  /// - [description] 空视图描述文本
  /// - [onTap] 空视图按钮点击回掉
  /// - [button] 空视图按钮
  /// - [iconTextSpace] 图标和描述的空隙 默认为 40
  /// - [textButtonSpace] 描述和按钮的间隙 默认为 12
  /// - [textStyle] 描述的样式 默认为文本颜色 0xFF8D8D8D 字体 14
  const EmptyDataView({
    required this.icon,
    required this.description,
    required this.onTap,
    required this.button,
    Key? key,
    this.iconTextSpace = 40,
    this.textButtonSpace = 12,
    this.textStyle = const TextStyle(
      color: Color(0xFF8D8D8D),
      fontSize: 14,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          hiSpace(height: iconTextSpace),
          Text(
            description,
            style: textStyle,
          ),
          hiSpace(height: textButtonSpace),
          button,
        ],
      ),
    );
  }
}
