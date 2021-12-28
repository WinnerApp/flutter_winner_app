import 'package:flutter/material.dart';
import 'package:flutter_winner_app/constant/global_config.dart';
import 'package:flutter_winner_app/network/api.dart';
import 'package:flutter_winner_app/widget/style.dart';
import 'package:json_annotation/json_annotation.dart';
import 'winner_base_model.dart';

typedef CustomVerifyErrorMessage<T, M extends WinnerBaseModel<T>> = String?
    Function(M);

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
  }) async {
    isLoading = true;

    /// 如果当前没有显示加载[HUD] 则显示[HUD]
    if (!isLoadingHUD && isUseLoading) showHUD();
    M model = await Global.request(api: api);
    String? verifyMessage = verify?.call(model);
    if ((!model.isSuccess || verifyMessage != null) && isUseLoading) {
      /// 如果请求错误 或者有自定义验证错误信息 则隐藏[HUD]
      if (isUseLoading) hiddenHUD();
      isLoading = false;

      /// 展示错误信息
      ToastStyle.showErrorToast(msg: verifyMessage ?? model.message);
      return null;
    }
    isLoading = false;
    return model;
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
