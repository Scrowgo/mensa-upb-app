import 'package:hive_ce/hive_ce.dart';

/// A service class to use the NoSql database Hive.
class HiveService {
  /// Ensures the box is opened before use.
  Future<Box<T>> _openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Saves a key-value pair to a Hive box.
  ///
  /// If the key already exists, the value is updated.
  /// If the key is null, the internal auto-increment feature from Hive is used.
  Future<void> saveToBox<keyT, valueT>(
    String boxName, {
    keyT? key,
    required valueT value,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    if (key == null) {
      await hiveBox.add(value);
    } else {
      await hiveBox.put(key, value);
    }
  }

  /// Get a single value from a Hive box.
  Future<valueT?> getFromBox<keyT, valueT>(
    String boxName, {
    required keyT key,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    valueT? value = hiveBox.get(key);
    return value;
  }

  /// Get multiple values from a Hive Box.
  Future<List<valueT>> getMultipleFromBox<keyT, valueT>(
    String boxName, {
    required List<keyT> keys,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    final List<valueT> values = [];
    for (var key in keys) {
      valueT? value = hiveBox.get(key);
      if (value != null) values.add(value);
    }
    return values;
  }

  /// Get all values from a Hive box.
  Future<List<valueT>> getAllFromBox<keyT, valueT>(String boxName) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    List<valueT> values = List.from(hiveBox.values);
    return values;
  }

  /// Delete a single value from a Hive box.
  Future<void> deleteFromBox<keyT, valueT>(
    String boxName, {
    required keyT key,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    await hiveBox.delete(key);
  }

  /// Delete multiple values from a Hive box.
  Future<void> deleteMultipleFromBox<keyT, valueT>(
    String boxName, {
    required List<keyT> keys,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    for (keyT key in keys) {
      await hiveBox.delete(key);
    }
  }

  /// Delete all values from a Hive box.
  Future<void> deleteAllFromBox<keyT, valueT>(String boxName) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    await hiveBox.deleteAll(hiveBox.keys);
  }

  /// Check for an existing value in a Hive box.
  Future<bool> boxContains<keyT, valueT>(
    String boxName, {
    required keyT key,
  }) async {
    Box hiveBox = await _openBox<valueT>(boxName);

    return hiveBox.containsKey(key);
  }
}
