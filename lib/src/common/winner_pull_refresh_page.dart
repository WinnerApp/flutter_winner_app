import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class WinnerPullRefreshPage<T extends StatefulWidget,
    M extends WinnerPullRefreshPageViewModel> {
  Widget refreshContent(BuildContext context, M viewModel) {
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
          child: refreshChildContentView(context),
        );
      },
    );
  }

  Widget refreshChildContentView(BuildContext context) {
    return listView(context);
  }

  ListView listView(BuildContext context);
}

abstract class WinnerPullRefreshPageViewModel extends BaseViewModel {
  late RefreshController refreshController;

  WinnerPullRefreshPageViewModel({RefreshController? controller})
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

abstract class WinnerListRefreshPageViewModel<
    Response extends JsonConverter<Response, Map<String, dynamic>>,
    ListModel,
    Model extends WinnerBaseModel<Response>,
    A extends Api<Response, Model>> extends WinnerPullRefreshPageViewModel {
  WinnerListRefreshPageViewModel({
    this.pageSize = 20,
    RefreshController? refreshController,
  }) : super(controller: refreshController);

  final int pageSize;
  int _pageNumber = 1;
  int get pageNumber => _pageNumber;

  List<ListModel> _list = [];
  List<ListModel> get list => _list;

  set list(List<ListModel> value) {
    if (list == value) return;
    _list = value;
    notifyListeners();
  }

  PageModel? _pageModel;
  PageModel? get pageModel => _pageModel;

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
      _pageNumber = 1;
    } else {
      _pageNumber += 1;
    }

    Model? model = await loadData();
    if (model == null) {
      _list = [];
      return;
    }
    final newList = listFromModel(model) ?? [];
    if (isRefresh) {
      _list = [...newList];
    } else {
      _list.addAll(newList);
      _list = [..._list];
    }
    _pageModel = pageModelFromModel(model);
    _updateEnablePullUp();
  }

  PageModel? pageModelFromModel(Model model);

  List<ListModel>? listFromModel(Model model);

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

  Future<Model?> loadData() async {
    return await loadList();
  }

  Future<Model?> loadList() async {
    final api = configApi();
    return await request(api: api, isUseLoading: false);
  }
}
