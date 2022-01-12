import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

typedef PressStateButtonOnTap = Function(WinnerTextButtonController controller);

class PressState {
  final Widget title;
  final Color background;
  final PressStateButtonOnTap? onTap;
  PressState.start(
    String title, {
    Color? titleColor,
    Color? backgroundColor,
    double? fontSize,
    this.onTap,
  })  : title = WinnerTextStyle.text(
          title,
          fontSize:
              fontSize ?? Global().appConfig.fontTheme.pressStateButtonTitle,
          color: titleColor ??
              Global().appConfig.colorTheme.pressStateStartButtonTitle,
        ),
        background = backgroundColor ??
            Global().appConfig.colorTheme.pressStateStartButtonBackground;

  PressState.end(
    String title, {
    Color? titleColor,
    Color? backgroundColor,
    double? fontSize,
    this.onTap,
  })  : title = WinnerTextStyle.text(
          title,
          fontSize:
              fontSize ?? Global().appConfig.fontTheme.pressStateButtonTitle,
          color: titleColor ??
              Global().appConfig.colorTheme.pressStateEndButtonTitle,
        ),
        background = backgroundColor ??
            Global().appConfig.colorTheme.pressStateEndButtonBackground;
}

class PressStateButton extends StatefulWidget {
  final PressState state;
  const PressStateButton({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  _PressStateButtonState createState() => _PressStateButtonState();
}

class _PressStateButtonState extends State<PressStateButton> {
  late WinnerTextButtonController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController = WinnerTextButtonController(
      title: widget.state.title,
      backgroundColor: widget.state.background,
      onTap: () {
        widget.state.onTap?.call(_buttonController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WinnerTextButton(controller: _buttonController);
  }
}

extension PressStateController on WinnerTextButtonController {
  void changeState(PressState state) {
    change(
      title: state.title,
      backgroundColor: state.background,
      onTap: () {
        state.onTap?.call(this);
      },
    );
  }
}
