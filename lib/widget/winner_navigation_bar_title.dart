import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/global_config.dart';

class WinnerNavigationBarTitle extends StatelessWidget {
  final String title;
  const WinnerNavigationBarTitle({
    Key? key,
    required this.title,
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
