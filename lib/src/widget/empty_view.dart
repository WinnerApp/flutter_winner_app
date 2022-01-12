import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class EmptyView extends StatelessWidget {
  final Widget child;
  const EmptyView({
    Key? key,
    required this.child,
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
    Key? key,
    required this.icon,
    required this.description,
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

/// ![](https://gitee.com/joser_zhang/upic/raw/master/uPic/202201120908435.png)
class EmptyDataView extends StatelessWidget {
  final Widget icon;
  final String description;
  final void Function() onTap;
  final double iconTextSpace;
  final double textButtonSpace;
  final TextStyle textStyle;
  final Widget button;
  const EmptyDataView({
    Key? key,
    required this.icon,
    required this.description,
    required this.onTap,
    required this.button,
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
