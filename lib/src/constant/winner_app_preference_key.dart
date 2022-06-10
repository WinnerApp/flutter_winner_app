import 'package:flutter_winner_app/flutter_winner_app.dart';

extension WinnerAppPreferenceKey on PreferenceKey {

  ///国际化配置信息 语言 zh
  PreferenceKey get localeLanguageCode =>
      const PreferenceKey("appLocaleLanguageCode");
  ///国际化配置信息 子语言 cn
  PreferenceKey get localeCountryCode =>
      const PreferenceKey("appLocaleCountryCode");
}
