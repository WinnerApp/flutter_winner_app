import 'dart:developer';

class LogUtil {
  static LogUtil get _logUtil => LogUtil._();
  LogUtil._();
  factory LogUtil() => _logUtil;

  void v(String v) {
    log(v);
  }
}
