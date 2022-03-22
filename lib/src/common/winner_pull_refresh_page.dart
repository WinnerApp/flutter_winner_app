import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class AppPullRefreshPage<T extends StatefulWidget,
    M extends AppPullRefreshPageViewModel> extends BasePage<T, M> {
  @override
  void initState() {
    super.initState();
    if (viewModel.initAutoRefresh) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        viewModel.refreshController.requestRefresh();
      });
    }
  }

  Widget refreshContent(BuildContext context) {
    return Consumer<M>(
      builder: (context, value, child) {
        return SmartRefresher(
          controller: value.refreshController,
          enablePullDown: true,
          enablePullUp: value.enablePullUp,
          onRefresh: () async {
            await viewModel.onRefresh();
          },
          onLoading: () async {
            await viewModel.onLoading();
          },
          child: listView(context),
        );
      },
    );
  }

  ListView listView(BuildContext context);
}

abstract class AppPullRefreshPageViewModel extends BaseViewModel {
  late RefreshController refreshController;

  AppPullRefreshPageViewModel({RefreshController? controller})
      : refreshController = controller ?? RefreshController();

  bool _enablePullUp = true;
  bool get enablePullUp => _enablePullUp;

  /// 初始化是否自动刷新 默认为 [true]
  bool get initAutoRefresh => true;

  set enablePullUp(bool value) {
    if (enablePullUp == value) return;
    _enablePullUp = value;
    notifyListeners();
  }

  Future<void> refreshData();
  Future<void> loadingMoreData();

  Future<void> onRefresh() async {
    await refreshData();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onLoading() async {
    await loadingMoreData();
    refreshController.loadComplete();
    notifyListeners();
  }
}

abstract class AppListRefreshPageViewModel<
    Response extends JsonConverter<Response, Map<String, dynamic>>,
    Model extends WinnerBaseModel<Response>,
    A extends Api<Response, Model>> extends AppPullRefreshPageViewModel {
  AppListRefreshPageViewModel({
    this.pageSize = 20,
    RefreshController? refreshController,
  }) : super(controller: refreshController);

  final int pageSize;
  int _pageNumber = 1;
  int get pageNumber => _pageNumber;

  set pageNumber(int value) => _pageNumber = value;

  List<Response> _list = [];
  List<Response> get list => _list;

  set list(List<Response> value) {
    if (list == value) return;
    _list = value;
    notifyListeners();
  }

  PageModel? _pageModel;
  PageModel? get pageModel => _pageModel;

  set pageModel(PageModel? value) => _pageModel = value;

  @override
  Future<void> loadingMoreData() async {
    await _loadData(false);
  }

  @override
  Future<void> refreshData() async {
    await _loadData(true);
  }

  A configApi();

  Future<void> _loadData(bool isRefresh) async {
    if (isRefresh) {
      pageNumber = 1;
    } else {
      pageNumber += 1;
    }

    final api = configApi();
    Model? model = await request(
      api: api,
      isUseLoading: false,
    );
    if (model == null) {
      _list = [];
      return;
    }
    if (isRefresh) {
      _list = [...model.list ?? []];
    } else {
      _list.addAll(model.list ?? []);
      _list = [..._list];
    }
    pageModel = pageModelFromModel(model);
    _updateEnablePullUp();
  }

  PageModel? pageModelFromModel(Model model);

  void _updateEnablePullUp() {
    PageModel? pageModel = this.pageModel;
    if (pageModel == null) {
      enablePullUp = false;
      return;
    }
    if (pageModel.pageNum >= pageModel.totalPage) {
      enablePullUp = false;
      return;
    }
    enablePullUp = true;
  }
}
