import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/bloc/points_event.dart';
import 'package:skate/bloc/points_state.dart';
import 'package:skate/model/skate_point.dart';
import 'package:skate/repository/points_firebase_repository.dart';
import 'package:skate/repository/points_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('PointsBloc', () {
    PointsRepository? pointsRepository;

    setUp(() {
      FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
      pointsRepository = PointsFirebaseRepository(
          pointsCollection: fakeFirebaseFirestore.collection("points"));
    });

    blocTest<PointsBloc, PointsState>(
      'should load points event: LoadPoints',
      build: () {
        return PointsBloc(pointsRepository: pointsRepository!);
      },
      act: (PointsBloc bloc) async {
        return bloc..add(LoadPoints());
      },
      expect: () => <PointsState>[
        PointsLoadSuccess(
          skatePoints: [],
        ),
      ],
    );

    blocTest<PointsBloc, PointsState>(
      'should add different points event: AddPoints',
      build: () {
        return PointsBloc(pointsRepository: pointsRepository!);
      },
      act: (PointsBloc bloc) async {
        final skatePoints = [
          SkatePoint(level: 5, coordinates: GeoPoint(15, 12), avg: 5),
          SkatePoint(level: 6, coordinates: GeoPoint(16, 12), avg: 6),
          SkatePoint(level: 7, coordinates: GeoPoint(17, 12), avg: 7),
        ].toSet();
        return bloc
          ..add(AddPoints(skatePoints: skatePoints))
          ..add(LoadPoints());
      },
      expect: () => <PointsState>[
        PointsAddedSuccess(),
        PointsLoadSuccess(
          skatePoints: [
            SkatePoint(level: 5, coordinates: GeoPoint(15, 12), avg: 5),
            SkatePoint(level: 6, coordinates: GeoPoint(16, 12), avg: 6),
            SkatePoint(level: 7, coordinates: GeoPoint(17, 12), avg: 7),
          ],
        ),
      ],
    );

    blocTest<PointsBloc, PointsState>(
      'should add points multiple times',
      build: () {
        return PointsBloc(pointsRepository: pointsRepository!);
      },
      act: (PointsBloc bloc) async {
        final skatePoints = [
          SkatePoint(level: 5, coordinates: GeoPoint(15, 12), avg: 5),
          SkatePoint(level: 7, coordinates: GeoPoint(17, 12), avg: 7),
          SkatePoint(level: 3, coordinates: GeoPoint(18, 12), avg: 3),
          SkatePoint(level: 1, coordinates: GeoPoint(19, 12), avg: 1),
        ].toSet();
        final skatePoints2 = [
          SkatePoint(level: 7, coordinates: GeoPoint(15, 12), avg: 7),
          SkatePoint(level: 3, coordinates: GeoPoint(17, 12), avg: 3),
        ].toSet();
        final skatePoints3 = [
          SkatePoint(level: 2, coordinates: GeoPoint(15, 12), avg: 2),
          SkatePoint(level: 1, coordinates: GeoPoint(17, 12), avg: 1),
        ].toSet();
        return bloc
          ..add(AddPoints(skatePoints: skatePoints))
          ..add(AddPoints(skatePoints: skatePoints2))
          ..add(AddPoints(skatePoints: skatePoints3))
          ..add(LoadPoints());
      },
      expect: () => <PointsState>[
        PointsAddedSuccess(),
        PointsLoadSuccess(
          skatePoints: [
            SkatePoint(
              level: 5,
              coordinates: GeoPoint(15, 12),
              avg: 4.666666666666667,
            ),
            SkatePoint(
              level: 4,
              coordinates: GeoPoint(17, 12),
              avg: 3.666666666666667,
            ),
            SkatePoint(
              level: 3,
              coordinates: GeoPoint(18, 12),
              avg: 3,
            ),
            SkatePoint(
              level: 1,
              coordinates: GeoPoint(19, 12),
              avg: 1,
            ),
          ],
        ),
      ],
    );
  });
}
