import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skate/entity/skate_point_entity.dart';
import 'package:skate/model/skate_point.dart';
import 'package:skate/repository/points_repository.dart';

class PointsFirebaseRepository implements PointsRepository {
  final pointsCollection = FirebaseFirestore.instance.collection("points");

  @override
  Future<void> addNewPoints(Set<SkatePoint> skatePoints) async {
    // return skatePoints.forEach((element) {
    //   pointsCollection.doc(element.id).set(element.toEntity().toDocument());
    // });

    return skatePoints.forEach((element) {
      pointsCollection
          .doc(element.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print("ISTNIEJE JUZ!!!!!!!!!!!!!!");
        } else {
          pointsCollection.doc(element.id).set(element.toEntity().toDocument());
        }
      });
    });

    // return pointsCollection
    //     .where("coordinates", isEqualTo: skatePoint.coordinates)
    //     .limit(1)
    //     .get()
    //     .then(
    //   (snap) {
    //     if (snap.size == 1) {
    //       var skatePointEntity = SkatePointEntity.fromSnapshot(snap.docs.first);
    //       int newSkatePointLevel = (skatePointEntity.level +
    //               (skatePoint.level - skatePointEntity.level) /
    //                   (skatePointEntity.numberOfRatings + 1))
    //           .toInt();
    //       int newNumberOfRatings =
    //           SkatePointEntity.fromSnapshot(snap.docs.first).numberOfRatings +
    //               1;
    //       String id = skatePointEntity.id;
    //       pointsCollection.doc(id).update(
    //         {
    //           "numberOfRatings": newNumberOfRatings,
    //           "level": newSkatePointLevel
    //         },
    //       );
    //     } else {
    //       pointsCollection.add(skatePoint.toEntity().toDocument());
    //     }
    //   },
    // );
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
