import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skate/entity/skate_point_entity.dart';
import 'package:skate/model/skate_point.dart';
import 'package:skate/repository/points_repository.dart';

class PointsFirebaseRepository implements PointsRepository {
  final pointsCollection = FirebaseFirestore.instance.collection("points");

  @override
  Future<void> addNewPoints(Set<SkatePoint> skatePoints) async {
    return skatePoints.forEach((skatePoint) {
      pointsCollection
          .doc(skatePoint.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var skatePointEntity =
              SkatePointEntity.fromSnapshot(documentSnapshot);
          int newNumberOfRatings = skatePointEntity.numberOfRatings + 1;
          double avg = (skatePointEntity.avg +
              (skatePoint.avg - skatePointEntity.avg) / newNumberOfRatings);

          int newSkatePointLevel = avg.round();

          String id = skatePointEntity.id;
          pointsCollection.doc(id).update(
            {
              "numberOfRatings": newNumberOfRatings,
              "level": newSkatePointLevel,
              "avg": avg,
            },
          );
        } else {
          pointsCollection
              .doc(skatePoint.id)
              .set(skatePoint.toEntity().toDocument());
        }
      });
    });
  }

  @override
  Stream<List<SkatePoint>> points() {
    return pointsCollection.snapshots().map(
      (snap) {
        return snap.docs
            .map<SkatePoint>(
              (doc) => SkatePoint.fromEntity(
                SkatePointEntity.fromSnapshot(doc),
              ),
            )
            .toList();
      },
    );
  }
}
