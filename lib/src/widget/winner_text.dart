import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class WinnerText extends StatelessWidget {
  const WinnerText(
    this.text, {
    Key? key,
    this.color,
    this.fontSize,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color ?? Global().appConfig.colorTheme.mainTitle,
        fontSize: fontSize,
      ),
    );
  }
}
