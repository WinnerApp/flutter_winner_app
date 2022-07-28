import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class WinnerNavigationBarTitle extends StatelessWidget {
  final String title;
  const WinnerNavigationBarTitle({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Global().appConfig.colorTheme.navigationBarTitle,
      ),
    );
  }
}
