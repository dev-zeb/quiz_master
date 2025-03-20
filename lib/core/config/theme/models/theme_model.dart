// Create a new file: lib/core/config/hive_adapters.dart
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

@HiveType(typeId: 100)
enum ThemeModel {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}

class ThemeModelAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 100;

  @override
  ThemeMode read(BinaryReader reader) {
    final index = reader.readByte();
    return ThemeMode.values[index];
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeByte(obj.index);
  }
}
