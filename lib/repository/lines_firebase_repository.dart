import 'package:skate/entity/line_entity.dart';
import 'package:skate/model/line.dart';
import 'package:skate/repository/lines_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLineRepository implements LinesRepository {
  final linesCollection = FirebaseFirestore.instance.collection("lines");

  @override
  Future<void> addNewLine(Line line) {
    return linesCollection.add(line.toEntity().toDocument());
  }

  @override
  Stream<List<Line>> lines() {
    return linesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map<Line>((doc) => Line.fromEntity(LineEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
