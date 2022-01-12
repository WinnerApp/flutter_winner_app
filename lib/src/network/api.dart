import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

/// 请求配置的基类
abstract class Api<C extends JsonConverter, M extends BaseModel> {
  /// 请求的路径
  String get path;

  /// 请求的参数
  Map<String, dynamic> get params => {};

  /// 请求的方式默认为`GET`
  String get method => HttpMethod.get().method;

  /// 请求的`Options`
  Options? get options => null;

  /// 当前请求对应的`Tag`
  String get tag => runtimeType.toString();

  /// post请求对应的`data`
  dynamic get data => null;

  /// 设置解析器
  C get converter;

  /// 设置模型
  M get model;

  /// 是否启用缓存
  bool isUseCache = false;

  /// 自定义缓存Key
  CacheKey? customCacheKey;

  /// Api的版本号
  String apiVersion = "1.0.0";

  /// 获取缓存的唯一[Key]
  String get cacheKey {
    if (customCacheKey == null ||
        customCacheKey!.key == CacheKey.defaultKey().key) {
      var data = this.data ?? {};
      return "${apiVersion}_${method}_${path}_${params.toString()}_${data.toString()}";
    } else {
      return customCacheKey!.key;
    }
  }
}

/// 默认的解析器 为了支持基本的类型
class DefaultJsonConverter<T> extends JsonConverter<T, dynamic> {
  T? value;

  @override
  T fromJson(json) => json is T ? json : throw "解析的类型不一致";

  @override
  toJson(T object) => object;
}

class HttpMethod {
  final String method;

  HttpMethod.get() : method = "GET";
  HttpMethod.post() : method = "POST";
}

/// 缓存的唯一值
class CacheKey {
  /// 缓存的唯一key值
  final String key;

  /// 默认的[key] 会自动根据请求的链接/参数/请求方式等组成唯一的[key]
  CacheKey.defaultKey() : key = "default";

  /// 自定义缓存的Key
  CacheKey(this.key);
}