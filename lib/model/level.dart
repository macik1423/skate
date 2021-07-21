import 'package:flutter/material.dart';

enum LevelType { perfect, good, bad }

extension LevelTypeExtension on LevelType? {
  Level get level {
    switch (this) {
      case LevelType.bad:
        return Level.ofValue(1);
      case LevelType.good:
        return Level.ofValue(4);
      case LevelType.perfect:
        return Level.ofValue(9);
      default:
        throw Exception("No LevelType");
    }
  }

  LevelType levelType(int value) {
    switch (value) {
      case 1:
        return LevelType.bad;
      case 4:
        return LevelType.good;
      case 9:
        return LevelType.perfect;
      default:
        throw Exception("No LevelType");
    }
  }
}

class Level {
  final int value;
  final Color color;

  Level({required this.value, required this.color});

  factory Level.ofValue(int value) {
    switch (value) {
      case 1:
        return Level(
            value: value, color: Colors.red.shade900); //wybierane przez usera
      case 2:
        return Level(value: value, color: Colors.red.shade700);
      case 3:
        return Level(value: value, color: Colors.red.shade500);
      case 4:
        return Level(
            value: value,
            color: Colors.yellow.shade700); //wybierane przez usera
      case 5:
        return Level(value: value, color: Colors.yellow.shade500);
      case 6:
        return Level(value: value, color: Colors.yellow.shade300);
      case 7:
        return Level(value: value, color: Colors.green.shade500);
      case 8:
        return Level(value: value, color: Colors.green.shade700);
      case 9:
        return Level(
            value: value, color: Colors.green.shade900); //wybierane przez usera

      default:
        return Level(value: 0, color: Colors.black);
    }
  }
}
