part of 'record_cubit.dart';

@immutable
abstract class RecordState {}

class RecordStart extends RecordState {
  final Container icon;

  RecordStart({required this.icon});
}

class RecordStop extends RecordState {
  final Container icon;
  final Set<GeoPoint> coordinates;

  RecordStop({required this.icon, required this.coordinates});
}
