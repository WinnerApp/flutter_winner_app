import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSelector<A, T> extends StatelessWidget {
  const CustomSelector({
    required this.builder,
    required this.selector,
    Key? key,
    this.shouldRebuild,
    this.child,
  }) : super(key: key);

  final ValueWidgetBuilder<T?> builder;
  final CustomSelectorModel<T?> selector;
  final ShouldRebuild<CustomSelectorModel>? shouldRebuild;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Selector<A, CustomSelectorModel<T?>>(
      builder: (context, value, child) => builder(context, value.value, child),
      selector: (context, value) => selector..register(this),
      child: child,
      shouldRebuild: (previous, next) {
        return shouldRebuild?.call(previous, next) ?? next.shouldRebuild(this);
      },
    );
  }
}

/// 优化Selector，针对List
class CustomSelectorList<A, T> extends StatelessWidget {
  const CustomSelectorList({
    required this.builder,
    required this.selector,
    Key? key,
    this.shouldRebuild,
    this.child,
  }) : super(key: key);

  final ValueWidgetBuilder<List<T>> builder;
  final CustomSelectorListModel<T> selector;
  final ShouldRebuild<CustomSelectorListModel>? shouldRebuild;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Selector<A, CustomSelectorListModel<T>>(
      key: key,
      builder: (context, value, child) => builder(context, value.value, child),
      selector: (context, value) => selector..register(this),
      shouldRebuild: (previous, next) {
        return shouldRebuild?.call(previous, next) ?? next.shouldRebuild(this);
      },
      child: child,
    );
  }
}

class CustomSelectorModel<T> with CustomSelecterModelMixin {
  T? _value;

  T? get value => _value;

  CustomSelectorModel({T? value}) {
    _value = value;
    update();
  }

  set value(T? value) {
    update();
    _value = value;
  }
}

class CustomSelectorListModel<T> with CustomSelecterModelMixin {
  List<T> _value = [];
  List<T> get value => _value;

  CustomSelectorListModel({List<T>? value}) {
    _value = value ?? [];
    update();
  }

  set value(List<T> value) {
    _value = value;
    update();
  }

  void add(T data) {
    _value.add(data);
    update();
  }

  void removeAt(int index) {
    _value.removeAt(index);
    update();
  }

  void remove(T data) {
    _value.remove(data);
    update();
  }
}

mixin CustomSelecterModelMixin {
  final hashVersions = <Object, int>{};
  int currentVersion = 0;

  bool shouldRebuild(Object key) {
    final hashVersion = hashVersions[key];
    if (hashVersion == null || hashVersion == currentVersion) {
      return false;
    }
    hashVersions[key] = currentVersion;
    return true;
  }

  void update() {
    currentVersion++;
  }

  void register(Object key) {
    hashVersions[key] = 0;
  }
}
