import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_winner_app/network/api.dart';
import 'package:flutter_winner_app/network/base_model.dart';
import 'package:flutter_winner_app/util/log_util.dart';
import 'package:path_provider/path_provider.dart';

class WinnerBaseModel<T> extends BaseModel {
  T? data;
  List<T>? list;
  dynamic rawData;

  @override
  void parseData(Map<String, dynamic> data, Api api) {
    if (api.isUseCache) {
      _saveInCache(data, api);
    }
    _parseData(data, api);
  }

  void _parseData(Map<String, dynamic> data, Api api) {
    code = data["code"] ?? -1;
    message = data["message"] ?? "系统错误";
    isSuccess = data["success"] ?? false;
    rawData = data["data"];
    Map<String, dynamic>? pageData = data["page"];
    if (pageData != null) {
      // page = PageModel().fromJson(pageData);
    }
    if (rawData == null) return;
    if (rawData is List) {
      List<T> models = [];
      for (var element in rawData) {
        if (element is Map<String, dynamic>) {
          models.add(api.converter.fromJson(element));
        }
      }
      list = models;
    } else {
      this.data = api.converter.fromJson(rawData);
    }
  }

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
  /// [cacheKey] 读取本地缓存的Key
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
    if (jsonText.isEmpty) return this;
    var data = json.decode(jsonText);
    _parseData(data, api);
    return this;
  }
}
