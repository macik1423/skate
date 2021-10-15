import 'package:equatable/equatable.dart';
import 'package:skate/model/skate_point.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object> get props => [];
}

class PointsLoading extends PointsState {}

class PointsLoadSuccess extends PointsState {
  final List<SkatePoint> skatePoints;

  PointsLoadSuccess({required this.skatePoints});

  @override
  List<Object> get props => [skatePoints];
}

class PointsLoadFailure extends PointsState {}

class PointsAddedSuccess extends PointsState {}

class PointsAddedConnectionFailure extends PointsState {}
