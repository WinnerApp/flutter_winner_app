import 'package:flutter/material.dart';

class WColor {
  Color color;
  WColor(this.color);
  WColor.c0fbda6() : this.main();
  WColor.c000000() : this.headline();
  WColor.c333333() : this.mainTitle();
  WColor.c666666() : this.subTitle();
  WColor.cf8f9fa() : this.background();
  WColor.cf4f5fa() : this.searchBackground();
  WColor.ce68181() : color = const Color(0xFFE68181);
  WColor.ccccccc() : color = const Color(0xFFCCCCCC);
  WColor.ceeeeee() : color = const Color(0xFFEEEEEE);
  WColor.cffffff() : color = const Color(0xFFFFFFFF);
  WColor.c999999() : color = const Color(0xFF999999);
  WColor.c209090() : color = const Color(0xFF209090);
  WColor.ce87050() : color = const Color(0xFFE87050);
  WColor.cf19037() : color = const Color(0xFFF19037);
  WColor.c0ea1da() : color = const Color(0xFF0EA1DA);
  WColor.cd8d8d8() : color = const Color(0xFFD8D8D8);

  /// 主色
  WColor.main() : color = const Color(0xFF209090);

  /// 大标题
  WColor.headline() : color = const Color(0XFF333333);

  /// 主标题
  WColor.mainTitle() : color = const Color(0xFF333333);

  /// 副标题
  WColor.subTitle() : color = const Color(0xFF666666);

  /// 背景色
  WColor.background() : color = const Color(0xFFEFEFEF);

  /// 搜索的背景色
  WColor.searchBackground() : color = const Color(0xFFF4F5FA);

  WColor.navigationBar() : color = Colors.white;
}
