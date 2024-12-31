import 'dart:async';

import 'package:flutter/material.dart';

import 'storage/html.dart' if (dart.library.io) 'storage/io.dart';
import 'value.dart';

/// Instantiate Storage to access storage driver APIs
class GetStorage {
  GetStorage(this.fileName, [this.path]);

  final String? path;
  final String fileName;

  late StorageImpl _concrete;
  final Map<String, List<void Function(dynamic)>> _listeners = {};

  Future<void> init([Map<String, dynamic>? initialData]) async {
    _concrete = StorageImpl(fileName, path);
    await _concrete.init(initialData);
  }

  /// Reads a value in your container with the given key.
  T? read<T>(String key) {
    return _concrete.read(key);
  }

  Iterable<String> getKeys() {
    return _concrete.getKeys();
  }

  Iterable<dynamic> getValues() {
    return _concrete.getValues();
  }

  /// Return true if value is different from null.
  bool hasData(String key) {
    return read(key) != null;
  }

  /// Write data on your container
  Future<void> write(String key, dynamic value) async {
    _concrete.write(key, value);
    await _concrete.flush();
    _notifyListeners(key, value);
  }

  /// Write data only if data is null
  Future<void> writeIfNull(String key, dynamic value) async {
    if (read(key) == null) {
      await write(key, value);
    }
  }

  /// Remove data from container by key
  Future<void> remove(String key) async {
    _concrete.remove(key);
    await _concrete.flush();
    _notifyListeners(key, null);
  }

  /// Clear all data on your container
  Future<void> erase() async {
    _concrete.clear();
    await _concrete.flush();
    _notifyListeners(null, null);
  }

  Future<void> save() async {
    await _concrete.flush();
  }

  /// Listen for changes in your container
  void listenKey(String key, void Function(dynamic) callback) {
    if (_listeners[key] == null) {
      _listeners[key] = [];
    }
    _listeners[key]!.add(callback);
  }

  void _notifyListeners(String? key, dynamic value) {
    if (key != null && _listeners[key] != null) {
      for (var listener in _listeners[key]!) {
        listener(value);
      }
    }
  }

  /// Listenable of container
  ValueStorage<Map<String, dynamic>> get listenable => _concrete.subject;

  Map<String, dynamic> get changes => _concrete.subject.changes;
}
