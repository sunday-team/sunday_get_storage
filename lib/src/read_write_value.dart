import 'package:sunday_get_storage/src/storage_impl.dart';

typedef StorageFactory = GetStorage Function(String fileName, [String? path]);

class ReadWriteValue<T> {
  final String key;
  final T defaultValue;
  final StorageFactory? getBox;
  final String fileName; // Added fileName parameter

  ReadWriteValue(
    this.key,
    this.defaultValue, [
    this.getBox,
    this.fileName = '', // Provide a default value for fileName
  ]);

  GetStorage _getRealBox() => getBox?.call(fileName) ?? GetStorage(fileName); // Pass fileName to GetStorage

  T get val => _getRealBox().read<T>(key) ?? defaultValue; // Specify type for read
  set val(T newVal) => _getRealBox().write(key, newVal); // Specify type for write
}

extension Data<T> on T {
  ReadWriteValue<T> val(
    String valueKey, {
    StorageFactory? getBox,
    T? defVal,
    String fileName = '', // Provide a default value for fileName
  }) {
    return ReadWriteValue(valueKey, defVal ?? this, getBox, fileName); // Pass fileName
  }
}
