import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:skate/entity/skate_point_entity.dart';

@immutable
class SkatePoint extends Equatable {
  final String id;
  final int level;
  final GeoPoint coordinates;

  SkatePoint({String? id, required this.level, required this.coordinates})
      : this.id = id ??
            "${coordinates.latitude.toString()}_${coordinates.longitude.toString()}";

  @override
  List<Object?> get props => [id, level, coordinates];

  SkatePoint copyWith({String? id, int? level, GeoPoint? coordinates}) {
    return SkatePoint(
        id: id ?? this.id,
        level: level ?? this.level,
        coordinates: coordinates ?? this.coordinates);
  }

  SkatePointEntity toEntity() {
    return SkatePointEntity(
        id: id, coordinates: coordinates, level: level, numberOfRatings: 1);
  }

  static SkatePoint fromEntity(SkatePointEntity entity) {
    return SkatePoint(
        level: entity.level, coordinates: entity.coordinates, id: entity.id);
  }
}
