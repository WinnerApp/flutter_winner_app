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
}
