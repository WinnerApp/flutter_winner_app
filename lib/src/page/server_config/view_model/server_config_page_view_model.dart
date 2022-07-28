import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';

class ServerConfigPageViewModel extends BaseViewModel {
  late List<String> _serverList;
  List<String> get serverList => _serverList;

  late int _currentIndex;
  int get currentIndex => _currentIndex;

  /// 当前添加服务器的输入框的内容
  final TextEditingController controller = TextEditingController();

  ServerConfigPageViewModel() {
    title = "切换服务器";
    _serverList = Global().appConfig.appUrls.map((e) => e.url).toList();
    final currentBaseUrl = Global().httpManager.baseUrl;
    _currentIndex = max(_serverList.indexOf(currentBaseUrl), 0);
  }

  Future<void> onSelectedServer(int index) async {
    _currentIndex = index;
    Global().updateUrl(Global().appConfig.appUrls[index]);
    notifyListeners();

    /// 重新加载缓存
    await AppCacheManager().initCacheData();
  }

  void onAddServer() {
    if (controller.text.isEmpty) {
      return;
    }
    if (!controller.text.startsWith("http")) {
      controller.text = "http://${controller.text}";
    }
    if (_serverList.contains(controller.text)) {
      ToastStyle.showErrorToast(msg: "服务器地址已存在");
      controller.clear();
      return;
    }
    _serverList = [..._serverList];
    _serverList.add(controller.text);
    final appUrls = _serverList.map(BaseUrl.new).toList();
    Global().appConfig.updateAppUrls(appUrls);
    controller.clear();
    onSelectedServer(_serverList.length - 1);
  }

  void onDeleteServer() {
    if (_serverList.length <= 1) {
      ToastStyle.showErrorToast(msg: "至少保留一个服务器");
      return;
    }
    _serverList = [..._serverList];
    _serverList.removeAt(_currentIndex);
    final appUrls = _serverList.map(BaseUrl.new).toList();
    Global().appConfig.updateAppUrls(appUrls);
    onSelectedServer(_serverList.length - 1);
  }
}
