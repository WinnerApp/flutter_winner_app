import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';

typedef CustomVerifyErrorMessage<T, M extends WinnerBaseModel<T>> = String?
    Function(M);

typedef CustomRequestSuccess<T> = bool Function(T model);

/// 基于[ChangeNotifier] 的 ViewModel
abstract class BaseViewModel extends ChangeNotifier {
  /// 是否正在加载 默认为 [false]
  bool isLoading = false;

  /// 是否展示 HUD
  bool isLoadingHUD = false;

  /// 导航栏的标题
  String title = "";

  BaseViewModel();

  /// 可以自动显示和隐藏[HUD] 自动提示错误信息的请求
  /// [api] 发起的请求
  /// [customVerifyErrorMessage] 自定义验证
  Future<M?> request<T, C extends JsonConverter, M extends WinnerBaseModel<T>>({
    required Api<C, M> api,
    CustomVerifyErrorMessage<T, M>? verify,
    bool isUseLoading = true,
    CustomRequestSuccess<M>? customRequestSuccess,
  }) async {
    isLoading = true;

    /// 如果当前没有显示加载[HUD] 则显示[HUD]
    if (!isLoadingHUD && isUseLoading) showHUD();
    M model = await Global().request(api: api);
    String? verifyMessage = verify?.call(model);
    final isSuccess = customRequestSuccess?.call(model) ?? model.isSuccess;
    if ((!isSuccess || verifyMessage != null) && isUseLoading) {
      showRequestErrorMessage(
        message: verifyMessage ?? model.message,
        isUseLoading: isUseLoading,
      );
      isLoading = false;
      return null;
    }
    isLoading = false;
    return model;
  }

  void showRequestErrorMessage({
    required String message,
    required bool isUseLoading,
  }) {
    /// 如果请求错误 或者有自定义验证错误信息 则隐藏[HUD]
    if (isUseLoading) hiddenHUD();

    /// 展示错误信息
    ToastStyle.showErrorToast(msg: message);
  }

  showHUD() {
    isLoadingHUD = true;
    notifyListeners();
  }

  hiddenHUD() {
    isLoadingHUD = false;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }
}
