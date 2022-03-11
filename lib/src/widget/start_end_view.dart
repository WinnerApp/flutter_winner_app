import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class StartEndView extends StatelessWidget {
  final Widget start;
  final Widget end;
  final double? space;
  final MainDirection? direction;
  final CrossAxisAlignment? crossAxisAlignment;
  const StartEndView({
    Key? key,
    required this.start,
    required this.end,
    this.space,
    this.direction,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StartEndBuilderView(
      startBuilder: (context) => start,
      endBuilder: (context) => end,
      space: space,
      direction: direction,
      crossAxisAlignment: crossAxisAlignment,
    );
  }
}

class StartEndBuilderView extends StatelessWidget {
  final WidgetBuilder startBuilder;
  final WidgetBuilder endBuilder;
  final double? space;
  final MainDirection? direction;
  final CrossAxisAlignment? crossAxisAlignment;
  const StartEndBuilderView({
    Key? key,
    required this.startBuilder,
    required this.endBuilder,
    this.space,
    this.direction,
    this.crossAxisAlignment,
  }) : super(key: key);

  StartEndBuilderView.start({
    Key? key,
    required WidgetBuilder startBuilder,
    required Widget end,
    double? space,
    MainDirection? direction,
    CrossAxisAlignment? crossAxisAlignment,
  }) : this(
          key: key,
          startBuilder: startBuilder,
          endBuilder: ((context) => end),
          space: space,
          direction: direction,
          crossAxisAlignment: crossAxisAlignment,
        );

  StartEndBuilderView.end({
    Key? key,
    required Widget start,
    required WidgetBuilder endBuilder,
    double? space,
    MainDirection? direction,
    CrossAxisAlignment? crossAxisAlignment,
  }) : this(
          key: key,
          startBuilder: ((context) => start),
          endBuilder: endBuilder,
          space: space,
          direction: direction,
          crossAxisAlignment: crossAxisAlignment,
        );

  @override
  Widget build(BuildContext context) {
    final mainDirection = direction ?? MainDirection.horizontal;
    final space = this.space ?? 10;
    final crossAxisAlignment =
        this.crossAxisAlignment ?? CrossAxisAlignment.center;
    if (mainDirection == MainDirection.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          startBuilder(context),
          hiSpace(width: space),
          endBuilder(context),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          startBuilder(context),
          hiSpace(height: space),
          endBuilder(context),
        ],
      );
    }
  }
}

enum MainDirection {
  horizontal,
  vertical,
}
