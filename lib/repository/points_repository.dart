import 'package:skate/model/skate_point.dart';

abstract class PointsRepository {
  Future<void> addNewPoints(Set<SkatePoint> skatePoints);
  Stream<List<SkatePoint>> points();
}
