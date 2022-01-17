import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:provider/provider.dart';

typedef TabPageBuilder = Widget Function(BuildContext context);

abstract class TabPage<T extends StatefulWidget, M extends TabPageViewModel>
    extends BasePage<T, M> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    viewModel.tabController = TabController(
      length: viewModel.items.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.tabController.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return TabBarView(
      controller: viewModel.tabController,
      children: viewModel.items.map((e) => e.pageBuilder(context)).toList(),
    );
  }

  @override
  Widget pageContent(BuildContext context, BasePageController pageController) {
    return Consumer<M>(
      builder: (context, value, child) {
        return DefaultTabController(
          length: viewModel.items.length,
          child: super.pageContent(context, pageController),
        );
      },
    );
  }

  @override
  void configPage(BasePageController controller, BuildContext context) {
    controller.appBar?.bottom = TabBar(
      controller: viewModel.tabController,
      labelColor: Global().appConfig.colorTheme.main,
      tabs: viewModel.items.map((e) => e.itemBuilder(context)).toList(),
    );
  }
}

abstract class TabPageViewModel extends BaseViewModel {
  late TabController tabController;
  late List<TabPageItem> _items;
  List<TabPageItem> get items => _items;
  TabPageViewModel() {
    _items = defaultItems;
  }

  set items(List<TabPageItem> value) {
    _items = value;
    notifyListeners();
  }

  List<TabPageItem> get defaultItems;
}

class TabPageItem {
  final TabPageBuilder itemBuilder;
  final TabPageBuilder pageBuilder;
  TabPageItem({
    required this.itemBuilder,
    required this.pageBuilder,
  });
}
