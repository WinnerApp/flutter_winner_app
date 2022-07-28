import 'package:flutter/services.dart';

/// 最多可以限制小数点后三位
class NumberTextFormatter extends TextInputFormatter {
  /// 小数点后几位
  final int? pointNumber;

  NumberTextFormatter({this.pointNumber});
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newValueText = newValue.text;

    if (newValueText.isEmpty) {
      return newValue;
    }

    /// 首位只能输入数字和0 并且首位为 0  则第二位只能是小数点
    String firstText = newValueText.substring(0, 1);
    int? firstInt = int.tryParse(firstText);

    /// 首位不是一个数字 则不能进行输入
    if (firstInt == null) {
      return oldValue;
    }

    if (firstInt == 0) {
      /// 如果首位为0  则第二位只能是小数点
      String? nextValue;
      if (newValueText.length > 1) {
        nextValue = newValueText.substring(1, 2);
      }
      if (nextValue != null && nextValue != ".") {
        return oldValue;
      }
    }

    /// 后面添加 0 防止输入 0.不识别
    newValueText += "0";
    double? newDoubleValue = double.tryParse(newValueText);
    if (newDoubleValue == null) {
      return oldValue;
    }
    int negativePointIndex = newValueText.indexOf("-");
    if (negativePointIndex != -1 && newDoubleValue <= 0) {
      return oldValue;
    }

    /// 查找出 . 的位置
    int pointIndex = newValue.text.indexOf(".");
    // 0.0003
    /// pointIndex = 1 lenght = 6
    /// 0.003
    /// pointIndex = 1 lenght = 5
    if (pointIndex != -1) {
      int pointNumber = this.pointNumber ?? 3;
      if (pointNumber == 0) {
        return oldValue;
      }
      if ((newValue.text.length - pointIndex - 1) > pointNumber) {
        return oldValue;
      }
    }
    return newValue;
  }
}
