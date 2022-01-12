import 'package:shared_preferences/shared_preferences.dart';

abstract class WinnerStore {}

/// 本地配置文件存储
class WinnerPreferenceStore extends WinnerStore {
  final PreferenceKey key;

  WinnerPreferenceStore(this.key);

  /// 操作方法
  Future<T?> _get<T>(
    T? Function(SharedPreferences preferences) fn,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return fn(preferences);
  }

  Future<bool> _set<T>(
    T value,
    Future<bool> Function(SharedPreferences preferences) fn,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await fn(preferences);
  }
}

class PreferenceKey {
  final String value;
  PreferenceKey(this.value);
}

extension WinnerPreferenceGetStore on WinnerPreferenceStore {
  Future<Object?> get() async {
    return await _get(
      (preferences) => preferences.get(key.value),
    );
  }

  Future<bool?> getBool() async {
    return await _get(
      (preferences) => preferences.getBool(key.value),
    );
  }

  Future<int?> getInt() async {
    return _get(
      (preferences) => preferences.getInt(key.value),
    );
  }

  Future<double?> getDouble() async {
    return _get(
      (preferences) => preferences.getDouble(key.value),
    );
  }

  Future<String?> getString() async {
    return await _get(
      (preferences) => preferences.getString(key.value),
    );
  }

  Future<List<String>?> getStringList() async {
    return await _get(
      (preferences) => preferences.getStringList(key.value),
    );
  }
}

extension WinnerPreferenceSetStore on WinnerPreferenceStore {
  Future<bool> setInt(int value) async {
    return _set(
      value,
      (preferences) async => await preferences.setInt(key.value, value),
    );
  }

  Future<bool> setBool(bool value) async {
    return _set(
      value,
      (preferences) async => await preferences.setBool(key.value, value),
    );
  }

  Future<bool> setDouble(double value) async {
    return _set(
      key,
      (preferences) async => await preferences.setDouble(key.value, value),
    );
  }

  Future<bool> setString(String value) async {
    return await _set(
      key,
      (preferences) async => await preferences.setString(key.value, value),
    );
  }

  Future<bool> setStringList(List<String> value) async {
    return await _set(
      key,
      (preferences) async => preferences.setStringList(key.value, value),
    );
  }
}
