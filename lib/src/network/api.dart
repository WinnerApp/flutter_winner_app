import 'package:dio/dio.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';

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

  /// 自定义请求路径
  bool get customPath => false;

  /// 获取缓存的唯一 Key
  String get cacheKey {
    if (customCacheKey == null ||
        customCacheKey!.key == CacheKey.defaultKey().key) {
      var data = this.data ?? {};
      final params = this.params.toString();
      return "${apiVersion}_${method}_${path}_${params}_${data.toString()}";
    } else {
      return customCacheKey!.key;
    }
  }

  /// 缓存的时间 默认为30 秒
  int get cacheTime => 30;
}

/// 默认的解析器 为了支持基本的类型
class DefaultJsonConverter<T> extends JsonConverter<T, dynamic> {
  T? value;

  @override
  T fromJson(dynamic json) => json is T ? json : throw "解析的类型不一致";

  @override
  dynamic toJson(T object) => object;
}

class HttpMethod {
  final String method;

  HttpMethod(this.method);

  factory HttpMethod.post() => HttpMethod("POST");
  factory HttpMethod.put() => HttpMethod("PUT");
  factory HttpMethod.delete() => HttpMethod("DELETE");
  factory HttpMethod.get() => HttpMethod("GET");
  factory HttpMethod.head() => HttpMethod("HEAD");
  factory HttpMethod.patch() => HttpMethod("PATCH");
  factory HttpMethod.options() => HttpMethod("OPTIONS");
  factory HttpMethod.trace() => HttpMethod("TRACE");
  factory HttpMethod.connect() => HttpMethod("CONNECT");

  static bool isAllowMethod(String method) {
    return allHttpMethods.map((e) => e.method).contains(method);
  }

  static HttpMethod? fromMethod(String method) {
    if (isAllowMethod(method)) {
      return HttpMethod(method);
    } else {
      return null;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! HttpMethod) {
      return false;
    }
    return other.method == method;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => method.hashCode;
}

final allHttpMethods = [
  HttpMethod.post(),
  HttpMethod.get(),
  HttpMethod.put(),
  HttpMethod.delete(),
  HttpMethod.head(),
  HttpMethod.patch(),
  HttpMethod.options(),
  HttpMethod.trace(),
  HttpMethod.connect()
];

/// 缓存的唯一值
class CacheKey {
  /// 缓存的唯一key值
  final String key;

  /// 默认的[key] 会自动根据请求的链接/参数/请求方式等组成唯一的[key]
  CacheKey.defaultKey() : key = "default";

  /// 自定义缓存的Key
  CacheKey(this.key);
}
