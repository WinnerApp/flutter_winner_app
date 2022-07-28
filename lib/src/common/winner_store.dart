import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
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
    return fn(preferences);
  }
}

class PreferenceKey {
  final String value;
  PreferenceKey(this.value);
}

extension WinnerPreferenceGetStore on WinnerPreferenceStore {
  Future<Object?> get() async {
    return _get(
      (preferences) => preferences.get(key.value),
    );
  }

  Future<bool?> getBool() async {
    return _get(
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
    return _get(
      (preferences) => preferences.getString(key.value),
    );
  }

  Future<List<String>?> getStringList() async {
    return _get(
      (preferences) => preferences.getStringList(key.value),
    );
  }

  Future<Map?> getMap() async {
    return _get((preferences) {
      final jsonText = preferences.getString(key.value);
      if (jsonText == null) {
        return null;
      }
      return json.decode(jsonText) as Map?;
    });
  }

  Future<T?> getModel<T>(T? Function(Map map) toModel) async {
    final map = await getMap();
    if (map == null) {
      return null;
    }
    return toModel.call(map);
  }

  Future<T?> getConverModel<T extends JsonConverter>(T emptyModel) async {
    return getModel((map) {
      return emptyModel.fromJson(map) as T?;
    });
  }
}

extension WinnerPreferenceSetStore on WinnerPreferenceStore {
  Future<bool> setInt(int value) async {
    return _set(
      value,
      (preferences) async => preferences.setInt(key.value, value),
    );
  }

  Future<bool> setBool(bool value) async {
    return _set(
      value,
      (preferences) async => preferences.setBool(key.value, value),
    );
  }

  Future<bool> setDouble(double value) async {
    return _set(
      key,
      (preferences) async => preferences.setDouble(key.value, value),
    );
  }

  Future<bool> setString(String value) async {
    return _set(
      key,
      (preferences) async => preferences.setString(key.value, value),
    );
  }

  Future<bool> setStringList(List<String> value) async {
    return _set(
      key,
      (preferences) async => preferences.setStringList(key.value, value),
    );
  }

  Future<bool> setMap(Map map) async {
    return _set(key, (preferences) async {
      final jsonText = json.encode(map);
      return preferences.setString(key.value, jsonText);
    });
  }

  Future<bool> setModel<T>(T model, Map? Function(T model) toMap) async {
    final map = toMap.call(model);
    if (map == null) {
      return false;
    }
    return setMap(map);
  }

  Future<bool> setConverModel<T extends JsonConverter>(T model) async {
    return setModel<T>(model, (model) {
      return model.toJson(model) as Map?;
    });
  }
}

extension WinnerPreferenceRemoveStore on WinnerPreferenceStore {
  Future<void> remove() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(key.value);
  }
}
