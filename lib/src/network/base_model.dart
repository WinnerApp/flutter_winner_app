import 'package:dio/dio.dart';
import 'api.dart';

/// 解析后台数据的基本模型
abstract class BaseModel {
  /// 成功或者失败的消息
  String message = "";

  /// 返回的状态吗
  int code = -1;

  /// 是否成功
  bool isSuccess = false;

  Response? response;

  /// 解析后台数据
  void parseData(Map<String, dynamic> data, Api api);
}
