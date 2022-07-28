import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:path_provider/path_provider.dart';

abstract class WinnerBaseModel<T> extends BaseModel {
  T? data;
  List<T>? list;
  dynamic rawData;

  @override
  void parseData(Map<String, dynamic> data, Api api) {
    if (api.isUseCache) {
      _saveInCache(data, api);
    }
    customParseData(data, api);
  }

  void customParseData(Map<String, dynamic> data, Api api);

  T rawDataConverter(DefaultJsonConverter<T> converter) {
    return converter.fromJson(rawData);
  }

  /// 保存缓存到本地
  /// [data] 保存的本地的数据内容
  /// [api] 执行缓存的接口
  Future<void> _saveInCache(Map<String, dynamic> data, Api api) async {
    var jsonText = json.encode(data);
    if (jsonText.isEmpty) {
      return;
    }
    var document = await getApplicationDocumentsDirectory();
    var md5String =
        md5.convert(const Utf8Encoder().convert(api.cacheKey)).toString();
    LogUtil().v("save cache key ${api.cacheKey} $md5String");
    var file = File("${document.path}/$md5String.json");
    await file.writeAsString(jsonText);
    return;
  }

  /// 加载缓存
  /// [api] 读取本地缓存的接口
  Future<WinnerBaseModel<T>> loadCache(Api api) async {
    var document = await getApplicationDocumentsDirectory();
    var md5String =
        md5.convert(const Utf8Encoder().convert(api.cacheKey)).toString();
    LogUtil().v("load cache key ${api.cacheKey} $md5String");
    var file = File("${document.path}/$md5String.json");
    var isExit = await file.exists();
    if (!isExit) {
      return this;
    }
    var jsonText = await file.readAsString();
    if (jsonText.isEmpty) {
      return this;
    }
    var data = json.decode(jsonText);
    customParseData(data, api);
    return this;
  }
}
