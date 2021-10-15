part of 'record_cubit.dart';

@immutable
abstract class RecordState extends Equatable {}

class RecordInitial extends RecordState {
  final Container icon;

  RecordInitial({required this.icon});

  @override
  List<Object?> get props => [icon];
}

class RecordStart extends RecordState {
  final Container icon;
  final GeoPoint start;

  RecordStart({required this.icon, required this.start});

  @override
  List<Object?> get props => [icon, start];
}

class RecordStop extends RecordState {
  final Container icon;
  final Set<GeoPoint> coordinates;

  RecordStop({required this.icon, required this.coordinates});

  @override
  List<Object?> get props => [icon, coordinates];
}
