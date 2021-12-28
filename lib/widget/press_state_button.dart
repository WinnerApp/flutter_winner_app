import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/winner_color.dart';
import 'package:flutter_winner_app/constant/winner_font.dart';
import 'package:flutter_winner_app/widget/style.dart';
import 'package:flutter_winner_app/widget/winner_text_button.dart';

typedef PressStateButtonOnTap = Function(WinnerTextButtonController controller);

class PressState {
  final Widget title;
  final WColor background;
  final PressStateButtonOnTap? onTap;
  PressState.start(String title, {this.onTap})
      : title = WinnerTextStyle.text(
          title,
          font: WFont.f16(),
          color: WColor.cffffff(),
        ),
        background = WColor.c209090();

  PressState.end(String title, {this.onTap})
      : title = WinnerTextStyle.text(
          title,
          font: WFont.f16(),
          color: WColor.cffffff(),
        ),
        background = WColor.ce87050();
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
      backgroundColor: widget.state.background.color,
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
      backgroundColor: state.background.color,
      onTap: () {
        state.onTap?.call(this);
      },
    );
  }
}
