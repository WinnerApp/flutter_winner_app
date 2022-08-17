class ListManager<T> {
  List<T> list = [];

  ListManager([List<T>? list]) {
    this.list = list ?? [];
  }

  void add(T value) {
    list = [...list, value];
  }

  void addAll(List<T> values) {
    list = [...list, ...values];
  }

  void remove(T value) {
    list = [...list]..remove(value);
  }

  void removeAll(List<T> values) {
    for (final value in values) {
      remove(value);
    }
  }

  void clear() {
    list = [];
  }

  // ignore: use_setters_to_change_properties
  void reset(List<T> values) {
    list = values;
  }

  void replace(T value, bool Function(T element) where) {
    final index = list.indexWhere((element) => where(element));
    if (index == -1) {
      return;
    }
    list = [...list]
      ..removeAt(index)
      ..insert(index, value);
  }

  void replaceAll(List<T> values, bool Function(T element) where) {
    for (final field in values) {
      replace(field, (element) => where(element));
    }
  }
}
