import 'package:skate/model/line.dart';

abstract class LinesRepository {
  Future<void> addNewLine(Line line);
  Stream<List<Line>> lines();
}
