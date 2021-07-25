import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SkatePointEntity extends Equatable {
  final String id;
  final int level;
  final GeoPoint coordinates;
  final int numberOfRatings;
  final double avg;

  const SkatePointEntity({
    required this.id,
    required this.level,
    required this.coordinates,
    required this.numberOfRatings,
    required this.avg,
  });

  @override
  List<Object?> get props => [id, level, coordinates, numberOfRatings, avg];

  Map<String, Object> toJson() {
    return {"id": id, "level": level, "coordinates": coordinates, "avg": avg};
  }

  static SkatePointEntity fromJson(Map<String, Object> json) {
    return SkatePointEntity(
      id: json["id"] as String,
      level: json["level"] as int,
      coordinates: json["coordinates"] as GeoPoint,
      numberOfRatings: json["numberOfRatings"] as int,
      avg: json["avg"] as double,
    );
  }

  static SkatePointEntity fromSnapshot(DocumentSnapshot snap) {
    return SkatePointEntity(
      id: snap.id,
      level: snap.get("level"),
      coordinates: snap.get("coordinates"),
      numberOfRatings: snap.get("numberOfRatings"),
      avg: snap.get("avg"),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "level": level,
      "coordinates": coordinates,
      "numberOfRatings": numberOfRatings,
      "avg": avg,
    };
  }
}
