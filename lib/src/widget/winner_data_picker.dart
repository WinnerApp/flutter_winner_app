import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_winner_app/flutter_winner_app.dart';
import 'package:provider/provider.dart';

class WinnerDataPicker extends StatefulWidget {
  /// 标题
  final String title;
  final List<String> items;
  final String? selectValue;
  final Function(int index)? didSelectItem;
  const WinnerDataPicker({
    Key? key,
    required this.title,
    required this.items,
    this.selectValue,
    this.didSelectItem,
  }) : super(key: key);

  @override
  _WinnerDataPickerState createState() => _WinnerDataPickerState();
}

class _WinnerDataPickerState extends State<WinnerDataPicker> {
  late WinnerDataPickerController _dataPickerController;

  @override
  void initState() {
    super.initState();
    int initIndex = 0;
    if (widget.selectValue != null) {
      initIndex =
          widget.items.indexWhere((element) => element == widget.selectValue);
    }
    _dataPickerController = WinnerDataPickerController(initIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WinnerDataPickerController>.value(
      value: _dataPickerController,
      builder: (context, child) {
        List<Widget> pickerItems = [];
        for (var i = 0; i < widget.items.length; i++) {
          pickerItems.add(_pickerItem(context, i));
        }
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 275,
            child: Column(
              children: [
                SizedBox(
                  height: 62.5,
                  child: Center(
                    child: WinnerTextStyle.text(
                      widget.title,
                      fontSize: 16,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
                const ViewLine(.5, lineColor: Color(0xFFD8D8D8)),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    scrollController: _dataPickerController.controller,
                    onSelectedItemChanged: (index) {
                      _dataPickerController.index = index;
                    },
                    children: pickerItems,
                    selectionOverlay: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: const [
                          ViewLine(
                            .5,
                            lineColor: Color(0xFF209090),
                          ),
                          Spacer(),
                          ViewLine(
                            .5,
                            lineColor: Color(0xFF209090),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                hiSpace(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 135,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF999999),
                          width: .5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: WinnerTextStyle.text(
                          "取消",
                          color: const Color(0xFF999999),
                        ),
                      ),
                    ),
                    hiSpace(width: 10),
                    Container(
                      width: 135,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF209090),
                        border: Border.all(
                          color: const Color(0xFF999999),
                          width: .5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          widget.didSelectItem
                              ?.call(_dataPickerController.index);
                          Navigator.of(context).pop();
                        },
                        child: WinnerTextStyle.text(
                          "确定",
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
                hiSpace(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _pickerItem(BuildContext context, int index) {
    int currentIndex =
        context.select<WinnerDataPickerController, int>((value) => value.index);
    return Center(
      child: WinnerTextStyle.text(
        widget.items[index],
        color: currentIndex == index
            ? const Color(0xFF209090)
            : const Color(0xFF999999),
      ),
    );
  }
}

class WinnerDataPickerController extends ChangeNotifier {
  int _index;
  FixedExtentScrollController controller;
  WinnerDataPickerController(this._index)
      : controller = FixedExtentScrollController(initialItem: _index);

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }
}
