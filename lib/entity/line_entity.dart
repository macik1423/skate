import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LineEntity extends Equatable {
  final String id;
  final List<GeoPoint> points;
  final String color;

  const LineEntity(
      {required this.id, required this.points, required this.color});

  @override
  List<Object?> get props => [id, points, color];

  Map<String, Object> toJson() {
    return {"id": id, "points": points, "color": color};
  }

  static LineEntity fromJson(Map<String, Object> json) {
    return LineEntity(
        id: json["id"] as String,
        points: json["points"] as List<GeoPoint>,
        color: json["color"] as String);
  }

  static LineEntity fromSnapshot(DocumentSnapshot snap) {
    return LineEntity(
      id: snap.id,
      color: snap.get("color"),
      points: List.from(snap.get("points")),
    );
  }

  Map<String, Object> toDocument() {
    return {
      "color": color,
      "points": points,
    };
  }
}
