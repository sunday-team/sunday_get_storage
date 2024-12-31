import 'dart:async';
import 'dart:convert';
import 'package:web/web.dart';
import '../value.dart';

class StorageImpl {
  StorageImpl(this.fileName, [this.path]) {
    // Initialize subject with an empty map to avoid LateInitializationError
    subject = ValueStorage<Map<String, dynamic>>(<String, dynamic>{});
  }
  
  Storage get localStorage => window.localStorage;

  final String? path;
  final String fileName;

  late ValueStorage<Map<String, dynamic>> subject;

  void clear() {
    localStorage.removeItem(fileName); // Changed from remove to removeItem
    subject.value.clear();
    subject.changeValue("", null);
  }

  Future<bool> _exists() async {
    return localStorage.getItem(fileName) != null; // Changed from containsKey to getItem check
  }

  Future<void> flush() {
    return _writeToStorage(subject.value);
  }

  T? read<T>(String key) {
    // Ensure subject is initialized before reading
    if (subject.value.isEmpty) {
      throw Exception("Storage has not been initialized with data.");
    }
    return subject.value[key] as T?;
  }

  Iterable<String> getKeys() {
    return subject.value.keys;
  }

  Iterable<dynamic> getValues() {
    return subject.value.values;
  }

  Future<void> init([Map<String, dynamic>? initialData]) async {
    subject.value = initialData ?? <String, dynamic>{};
    if (await _exists()) {
      await _readFromStorage();
    } else {
      await _writeToStorage(subject.value);
    }
  }

  void remove(String key) {
    subject.value.remove(key);
    subject.changeValue(key, null);
  }

  void write(String key, dynamic value) {
    subject.value[key] = value;
    subject.changeValue(key, value);
  }

  Future<void> _writeToStorage(Map<String, dynamic> data) async {
    localStorage.setItem(fileName, json.encode(subject.value)); // Changed from direct assignment to setItem
  }

  Future<void> _readFromStorage() async {
    final dataFromLocal = localStorage.getItem(fileName); // Changed from direct access to getItem
    if (dataFromLocal != null) {
      subject.value = json.decode(dataFromLocal) as Map<String, dynamic>;
    } else {
      await _writeToStorage(<String, dynamic>{});
    }
  }
}
