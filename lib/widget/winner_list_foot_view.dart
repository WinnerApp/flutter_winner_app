import 'package:flutter/material.dart';
import 'package:flutter_winner_app/widget/winner_text.dart';

class WinnerListFootView extends StatelessWidget {
  final bool isFinish;

  const WinnerListFootView({Key? key, required this.isFinish})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      child: isFinish
          ? const WinnerText(
              "没有更多了",
              color: Colors.black45,
            )
          : const SizedBox(
              height: 35,
              width: 35,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
