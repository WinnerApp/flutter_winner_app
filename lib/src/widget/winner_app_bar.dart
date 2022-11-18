import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

/// 稳健的 [AppBar] 配置
class WinnerAppBar {
  Key? key;
  Widget? leading;
  bool automaticallyImplyLeading = true;
  Widget? title;
  List<Widget>? actions;
  Widget? flexibleSpace;
  PreferredSizeWidget? bottom;
  double? elevation;
  Color? shadowColor;
  ShapeBorder? shape;
  Color? backgroundColor;
  Color? foregroundColor;
  IconThemeData? iconTheme;
  IconThemeData? actionsIconTheme;
  bool primary = true;
  bool? centerTitle;
  bool excludeHeaderSemantics = false;
  double? titleSpacing;
  double toolbarOpacity = 1.0;
  double bottomOpacity = 1.0;
  double? toolbarHeight;
  double? leadingWidth;
  TextStyle? toolbarTextStyle;
  TextStyle? titleTextStyle;
  SystemUiOverlayStyle? systemOverlayStyle;
  AppBar appBar() {
    return AppBar(
      key: key,
      leading: Builder(
        builder: (context) {
          if (leading != null) {
            return leading!;
          }
          final route = ModalRoute.of(context);
          final canPop = route?.canPop ?? false;
          if (canPop) {
            return const BackButton();
          }
          return const SizedBox.shrink();
        },
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      shadowColor: shadowColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme ??
          IconThemeData(color: Global().appConfig.colorTheme.backButton),
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
    );
  }
}
