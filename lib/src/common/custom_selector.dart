import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 优化Selector，可任意对象
class CustomSelector<A, T> extends Selector<A, CustomSelectorModel<T?>> {
  CustomSelector({
    Key? key,
    required ValueWidgetBuilder<T?> builder,
    required CustomSelectorModel<T?> selector,
    ShouldRebuild<CustomSelectorModel>? shouldRebuild,
    Widget? child,
  }) : super(
    key: key,
    builder: (context, value, child) =>
        builder(context, value.value, child),
    selector: (context, value) => selector,
    shouldRebuild: (previous, next) => next.shouldRebuild(previous),
    child: child,
  );
}

/// 优化Selector，针对List
class CustomSelectorList<A, T> extends Selector<A, CustomSelectorListModel<T>> {
  CustomSelectorList({
    Key? key,
    required ValueWidgetBuilder<List<T>> builder,
    required CustomSelectorListModel<T> selector,
    ShouldRebuild<CustomSelectorListModel>? shouldRebuild,
    Widget? child,
  }) : super(
    key: key,
    builder: (context, value, child) =>
        builder(context, value.value, child),
    selector: (context, value) => selector,
    shouldRebuild: (previous, next) => next.shouldRebuild(previous),
    child: child,
  );
}

class CustomSelectorModel<T> {
  T? _value;
  int _version = 0;
  int _lastVersion = -1;

  T? get value => _value;

  CustomSelectorModel({Key? key, T? value}) {
    _value = value;
  }

  set value(T? value) {
    _version++;
    _value = value;
  }

  bool shouldRebuild(CustomSelectorModel previous) {
    bool isUpdate = _version != _lastVersion;
    if (isUpdate) {
      _lastVersion = _version;
    }
    return isUpdate;
  }
}

class CustomSelectorListModel<T> {
  List<T> _value = [];
  int _version = 0;
  int _lastVersion = -1;

  List<T> get value => _value;

  CustomSelectorListModel({Key? key, List<T>? value}) {
    _value = value ?? [];
  }

  set value(List<T> value) {
    _version++;
    _value = value;
  }

  bool shouldRebuild(CustomSelectorListModel previous) {
    bool isUpdate = _version != _lastVersion;
    if (isUpdate) {
      _lastVersion = _version;
    }
    return isUpdate;
  }
}
