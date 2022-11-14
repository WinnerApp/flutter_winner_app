class ListManager<T> {
  List<T> get list => [...rawList];
  List<T> rawList = [];

  ListManager([List<T>? list]) {
    rawList = list ?? [];
  }

  ListManager<T> add(T value) {
    rawList.add(value);
    return this;
  }

  ListManager<T> addAll(List<T> values) {
    rawList.addAll(values);
    return this;
  }

  ListManager<T> remove(T value) {
    rawList.remove(value);
    return this;
  }

  ListManager<T> removeAll(List<T> values) {
    for (final value in values) {
      remove(value);
    }
    return this;
  }

  ListManager<T> clear() {
    rawList = [];
    return this;
  }

  // ignore: use_setters_to_change_properties
  ListManager<T> reset(List<T> values) {
    rawList = [...values];
    return this;
  }

  ListManager<T> replace(T value, bool Function(T element) where) {
    final index = list.indexWhere((element) => where(element));
    if (index == -1) {
      rawList.add(value);
    }
    rawList = [...list]
      ..removeAt(index)
      ..insert(index, value);
    return this;
  }

  ListManager<T> replaceAll(List<T> values, bool Function(T element) where) {
    for (final field in values) {
      replace(field, (element) => where(element));
    }
    return this;
  }
}
