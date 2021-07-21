import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skate/entity/line_entity.dart';

@immutable
class Line extends Equatable {
  final String id;
  final List<GeoPoint> points;
  final String color;

  Line({String? id, required this.points, required this.color})
      : this.id = id ?? UniqueKey().toString();

  @override
  List<Object?> get props => [id, points, color];

  Line copyWith({String? id, List<GeoPoint>? points, String? color}) {
    return Line(
        id: id ?? this.id,
        color: color ?? this.color,
        points: points ?? this.points);
  }

  LineEntity toEntity() {
    return LineEntity(id: id, points: points, color: color);
  }

  static Line fromEntity(LineEntity entity) {
    return Line(color: entity.color, id: entity.id, points: entity.points);
  }
}
