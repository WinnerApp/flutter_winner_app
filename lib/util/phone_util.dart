///
/// @author chengguo
/// @date 2020/8/18 3:22 PM
///

///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
/// 此方法中前三位格式有：
/// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
class PhoneUtil {
  static bool isChinaPhoneLegal(String str) {
    return RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[0-9])|(147,145))\\d{8}\$').hasMatch(str);
  }
}
