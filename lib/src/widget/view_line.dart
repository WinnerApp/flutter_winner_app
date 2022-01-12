import 'package:flutter/material.dart';

///分割线
class ViewLine extends StatelessWidget {
  final double height;
  final double horizontalPadding;
  final Color lineColor;

  const ViewLine(
    this.height, {
    Key? key,
    this.horizontalPadding = 0,
    this.lineColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(color: lineColor),
    );
  }
}
