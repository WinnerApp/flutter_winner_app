import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WinnerPopUpMenuButton<T extends WinnerPopUpMenuItem>
    extends StatefulWidget {
  /// 数据源
  final WinnerPopUpMenuButtonViewModel<T> viewModel;

  /// 提示语
  final String menuTip;
  final Color? color;

  /// 选中的回掉
  final Function(T)? onSelected;
  final Widget Function(String title, BuildContext context)? itemBuilder;

  final bool enabled;

  const WinnerPopUpMenuButton({
    required this.viewModel,
    required this.menuTip,
    Key? key,
    this.onSelected,
    this.itemBuilder,
    this.color,
    this.enabled = true,
  }) : super(key: key);

  @override
  _WinnerPopUpMenuButtonState createState() => _WinnerPopUpMenuButtonState();
}

class _WinnerPopUpMenuButtonState<T extends WinnerPopUpMenuItem>
    extends State<WinnerPopUpMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WinnerPopUpMenuButtonViewModel<T>>.value(
      value: widget.viewModel,
      builder: (context, child) {
        WinnerPopUpMenuButtonViewModel<T> viewModel = context.watch();
        return PopupMenuButton<T>(
          enabled: widget.enabled,
          child: _menuTitleWidget(context),
          onSelected: (model) {
            viewModel.selectValue = model;
            widget.onSelected?.call(model);
          },
          itemBuilder: (context) {
            List<CheckedPopupMenuItem<T>> items = [];
            for (final element in viewModel.list) {
              bool checked = false;
              if (viewModel.selectValue != null) {
                checked = viewModel.selectValue!.isEqual(element);
              }
              CheckedPopupMenuItem<T> item = CheckedPopupMenuItem(
                value: element,
                checked: checked,
                child: Text(element.menuItemTitle),
              );
              items.add(item);
            }
            return items;
          },
        );
      },
    );
  }

  String _menuTitle(BuildContext context) {
    return widget.viewModel.selectValue?.menuItemTitle ?? widget.menuTip;
  }

  Widget _menuTitleWidget(BuildContext context) {
    final itemBuilder = widget.itemBuilder;
    if (itemBuilder != null) {
      return itemBuilder(_menuTitle(context), context);
    } else {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              _menuTitle(context),
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 14,
                color: widget.color ?? const Color(0xFF666666),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: widget.color ?? const Color(0xFF666666),
            ),
          ],
        ),
      );
    }
  }
}

abstract class WinnerPopUpMenuItem {
  String get menuItemTitle;

  bool isEqual(WinnerPopUpMenuItem item);
}

class WinnerPopUpMenuTextItem extends WinnerPopUpMenuItem {
  final String title;

  WinnerPopUpMenuTextItem(this.title);
  @override
  bool isEqual(WinnerPopUpMenuItem item) {
    return title == item.menuItemTitle;
  }

  @override
  String get menuItemTitle => title;
}

class WinnerPopUpMenuCustonItem<T> extends WinnerPopUpMenuItem {
  final T model;
  final bool Function(T left, T right) isEqualBuilder;
  final String Function(T model) menuItemTitleBuilder;
  WinnerPopUpMenuCustonItem(
    this.model,
    this.isEqualBuilder,
    this.menuItemTitleBuilder,
  );
  @override
  bool isEqual(WinnerPopUpMenuItem item) {
    WinnerPopUpMenuCustonItem<T>? right = item as WinnerPopUpMenuCustonItem<T>?;
    if (right == null) {
      return false;
    }
    return isEqualBuilder(model, right.model);
  }

  @override
  String get menuItemTitle => menuItemTitleBuilder(model);
}

class WinnerPopUpMenuButtonViewModel<T extends WinnerPopUpMenuItem>
    extends ChangeNotifier {
  List<T> _list = [];
  List<T> get list => _list;

  T? _selectValue;
  T? get selectValue => _selectValue;

  WinnerPopUpMenuButtonViewModel();

  WinnerPopUpMenuButtonViewModel.init(
    List<T> list, {
    int? index,
  }) {
    _list = list;
    if (index != null && list.length > index) {
      _selectValue = list[index];
    }
  }

  set list(List<T> values) {
    _list = values;
    notifyListeners();
  }

  set selectValue(T? value) {
    _selectValue = value;
    notifyListeners();
  }

  void reset() {
    if (list.isEmpty) {
      selectValue = null;
    } else {
      selectValue = list.first;
    }
  }
}
