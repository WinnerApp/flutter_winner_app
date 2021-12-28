import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WinnerTextButton extends StatefulWidget {
  final WinnerTextButtonController controller;
  const WinnerTextButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _WinnerTextButtonState createState() => _WinnerTextButtonState();
}

class _WinnerTextButtonState extends State<WinnerTextButton> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      builder: (context, child) {
        WinnerTextButtonController controller = context.watch();
        return Consumer<WinnerTextButtonController>(
            builder: (context, data, child) {
          return Offstage(
            offstage: controller.offstage ?? false,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: controller.title,
              color: controller.backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onPressed: () {
                controller.onTap?.call();
              },
            ),
          );
        });
      },
    );
  }
}

class WinnerTextButtonController extends ChangeNotifier {
  Widget title;
  Color? backgroundColor;
  bool? offstage;
  Function()? onTap;
  WinnerTextButtonController({
    required this.title,
    this.offstage,
    this.backgroundColor,
    this.onTap,
  });

  change({
    required Widget title,
    Color? backgroundColor,
    bool? offstage,
    Function()? onTap,
  }) {
    this.title = title;
    this.backgroundColor = backgroundColor;
    this.offstage = offstage;
    this.onTap = onTap;
    notifyListeners();
  }
}
