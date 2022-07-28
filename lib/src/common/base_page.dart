import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

abstract class BasePage<T extends StatefulWidget, M extends BaseViewModel>
    extends State<T> {
  late M viewModel;

  /// 页面配置
  final BasePageController _pageController = BasePageController();

  @override
  void initState() {
    super.initState();
    viewModel = create();
  }

  /// 创建对应的ViewModel
  M create();

  /// 绘制界面
  Widget buildPage(BuildContext context);

  /// 配置页面
  void configPage(BasePageController controller, BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        _pageController.appBar?.title = Selector<M, String>(
          selector: (p0, p1) => p1.title,
          builder: (context, value, child) {
            return WinnerNavigationBarTitle(title: value);
          },
        );
        configPage(_pageController, context);
        return pageContent(context, _pageController);
      },
    );
  }

  Widget pageContent(BuildContext context, BasePageController pageController) {
    return scaffold(context, pageController);
  }

  Scaffold scaffold(BuildContext context, BasePageController pageController) {
    return Scaffold(
      resizeToAvoidBottomInset: _pageController.resizeToAvoidBottomInset,
      appBar: _appBar,
      backgroundColor: backgroundColor,
      body: Selector<M, bool>(
        selector: (p0, p1) => p1.isLoadingHUD,
        builder: (context, value, child) {
          return loadingOverlay(context, value, child ?? Container());
        },
        child: _body(context),
      ),
    );
  }

  AppBar? get _appBar {
    if (_pageController.hiddenAppBar) {
      return null;
    }
    return _pageController.appBar?.appBar();
  }

  Widget _contentView(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: buildPage(context),
    );
  }

  /// 自定义[Loading Overlay]
  Widget loadingOverlay(
    BuildContext context,
    bool isLoading,
    Widget child,
  ) {
    return LoadingOverlay(isLoading: isLoading, child: child);
  }

  Widget _body(BuildContext context) {
    if (_pageController.isSafeArea) {
      return SafeArea(child: _contentView(context));
    } else {
      return _contentView(context);
    }
  }

  Color get backgroundColor => Global().appConfig.colorTheme.background;
}

class BasePageController {
  BasePageController() {
    appBar = WinnerAppBar()
      ..centerTitle = true
      ..backgroundColor = Global().appConfig.colorTheme.appBarBackground;
  }

  /// AppBar样式
  WinnerAppBar? appBar;

  /// 是否使用[SafeArea]布局
  /// 默认为 true
  bool isSafeArea = true;

  /// 是否根据键盘重新布局
  /// 默认为 true
  bool resizeToAvoidBottomInset = true;

  /// 默认为 false
  bool hiddenAppBar = false;
}
