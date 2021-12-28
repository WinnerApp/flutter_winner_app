import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_winner_app/network/proxy_config.dart';
import 'package:flutter_winner_app/util/log_util.dart';
import 'package:json_annotation/json_annotation.dart';

import 'api.dart';
import 'base_model.dart';

/// @desc  封装 http 请求
/// 1>：首先从本地数据库的缓存中读取数据，如果缓存有数据，就直接显示列表数据，同时去请求服务器，如果服务器返回数据了，这个时候就去比对服务器返回的数据与缓存中的数据，看是否一样；
/// 2>：如果比对结果是一样，那么直接return返回，不做任何操作；
/// 3>：如果比对结果不一样，就去刷新列表数据，同时把之前数据库中的数据删除，然后存储新的数据；
class HttpManager {
  /// 设置请求的`URL`
  final String baseUrl;

  ///同一个CancelToken可以用于多个请求，当一个CancelToken取消时，所有使用该CancelToken的请求都会被取消，一个页面对应一个CancelToken。
  final Map<String, CancelToken> _cancelTokens = <String, CancelToken>{};

  /// `Dio`请求实例
  final Dio client;

  HttpManager({
    required this.baseUrl,
  }) : client = Dio(BaseOptions(connectTimeout: 30000, receiveTimeout: 3000)) {
    client.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));

    if (client.httpClientAdapter is DefaultHttpClientAdapter) {
      // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      if (ProxyConfig.enable) {
        (client.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (client) {
          client.findProxy = (uri) {
            return "PROXY ${ProxyConfig.ip}:${ProxyConfig.port}";
          };
          //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };
      } else {
        (client.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            if (ProxyConfig.pem == null ||
                (ProxyConfig.pem != null && ProxyConfig.pem == cert.pem)) {
              return true;
            } else {
              return false;
            }
          };
        };
      }
    }
  }

  ///统一网络请求
  ///
  ///[api] 网络请求配置
  /// [headers] 头部信息
  Future<M> request<C extends JsonConverter, M extends BaseModel>(
    Api<C, M> api, {
    Map<String, dynamic>? headers,
  }) async {
    var url = api.path;
    //设置默认值
    var params = api.params;
    var method = api.method;
    var options = api.options ?? Options(method: method);
    if (headers != null) {
      options.headers ??= {};
      options.headers!.addEntries(headers.entries);
    }

    url = baseUrl + url;
    var tag = api.tag;
    try {
      CancelToken? cancelToken = _cancelTokens[tag];
      cancelToken ??= CancelToken();
      _cancelTokens[tag] = cancelToken;

      LogUtil().v(
          "url:$url\ndata:${api.data}\nparams:$params\nheaders:${options.headers}\ncancelToken:$cancelToken");
      Response<Map<String, dynamic>> response = await client.request(
        url,
        data: api.data,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );
      LogUtil().v("✅:url:$url\n${json.encode(response.data)}");
      M model = api.model;
      model.response = response;
      model.parseData(response.data ?? {}, api);
      return model;
    } on DioError catch (e, s) {
      LogUtil().v("❌:url:$url\n$e\n$s");
      var model = api.model;
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        model.parseData(e.response?.data, api);
      } else {
        model.message = e.message;
        model.code = -1;
      }
      model.response = e.response;
      return model;
    } catch (e, s) {
      LogUtil().v("❌:url:$url\n$e\n$s");
      var model = api.model;
      if (e is String) {
        model.message = e;
      } else {
        model.message = "系统未知错误!";
      }
      return model;
    }
  }

  ///取消网络请求
  void cancel(String tag) {
    CancelToken? token = _cancelTokens[tag];
    if (token == null) {
      return;
    }
    if (!token.isCancelled) {
      token.cancel();
    }
    _cancelTokens.remove(tag);
  }
}
