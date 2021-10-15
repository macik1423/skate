import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skate/bloc/points_event.dart';
import 'package:skate/model/level.dart';
import 'package:skate/model/skate_point.dart';

void main() {
  group('PointsEvent', () {
    group('LoadPoints', () {
      test('LoadPoints', () {
        expect(LoadPoints().toString(), 'LoadPoints()');
      });
    });

    group('AddPoints', () {
      test('AddPoints', () {
        Set<SkatePoint> skatePoints = {
          SkatePoint(level: 1, coordinates: GeoPoint(12, 12), avg: 9),
          SkatePoint(level: 2, coordinates: GeoPoint(12, 12), avg: 9),
        };
        expect(AddPoints(skatePoints: skatePoints).toString(),
            'AddPoints(skatePoints: $skatePoints)');
      });
    });
  });
}
