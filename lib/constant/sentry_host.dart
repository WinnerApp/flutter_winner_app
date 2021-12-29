/// [Sentry Host]地址
class SentryHost {
  /// 测试环境
  final String debug;

  /// 发布环境
  final String release;
  SentryHost({required this.debug, required this.release});
}
