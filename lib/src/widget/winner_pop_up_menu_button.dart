import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:provider/provider.dart';

class WinnerPopUpMenuButton<T extends WinnerPopUpMenuItem>
    extends StatefulWidget {
  /// 数据源
  final WinnerPopUpMenuButtonViewModel<T> viewModel;

  /// 提示语
  final String menuTip;

  /// 选中的回掉
  final Function(T)? onSelected;
  const WinnerPopUpMenuButton({
    Key? key,
    required this.viewModel,
    required this.menuTip,
    this.onSelected,
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
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  WinnerTextStyle.text(
                    viewModel.selectValue?.menuItemTitle ?? widget.menuTip,
                    fontSize: 14,
                    color: const Color(0xFF666666),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Color(0xFF666666),
                  ),
                ],
              ),
            ),
          ),
          onSelected: (model) {
            viewModel.selectValue = model;
            widget.onSelected?.call(model);
          },
          itemBuilder: (context) {
            List<CheckedPopupMenuItem<T>> items = [];
            for (var element in viewModel.list) {
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
}
