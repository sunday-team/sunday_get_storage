class ValueStorage<T> {
  ValueStorage(this.value);

  T value;
  Map<String, dynamic> changes = <String, dynamic>{};

  void changeValue(String key, dynamic value) {
    changes[key] = value;
  }
}
