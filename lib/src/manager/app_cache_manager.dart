import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';

class AppCacheManager extends ChangeNotifier {
  JsonConverter? _cacheData;

  AppCacheManager._();
  static final AppCacheManager _instance = AppCacheManager._();
  factory AppCacheManager() => _instance;

  Future<void> initCacheData() async {
    _cacheData = null;
    final cacheData = Global().appConfig.getNewCacheConverter;
    if (cacheData != null) {
      final currentUrl = Global().httpManager.baseUrl;
      final store = WinnerPreferenceStore(PreferenceKey(currentUrl));
      _cacheData = await store.getConverModel(cacheData);
    }
    notifyListeners();
  }

  T? getCacheData<T extends JsonConverter>() {
    if (_cacheData == null) return null;
    return _cacheData as T?;
  }
}
