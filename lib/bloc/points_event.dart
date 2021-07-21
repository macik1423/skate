import 'package:equatable/equatable.dart';

import 'package:skate/model/skate_point.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class LoadPoints extends PointsEvent {}

class AddPoints extends PointsEvent {
  final Set<SkatePoint> skatePoints;

  AddPoints({required this.skatePoints});
}

class PointsUpdated extends PointsEvent {
  final List<SkatePoint> skatePoints;

  PointsUpdated({required this.skatePoints});
}

class UpdatePoints extends PointsEvent {
  final Set<SkatePoint> skatePoints;

  UpdatePoints({required this.skatePoints});
}

class PointsUpdatedFailure extends PointsEvent {
  final StateError details;
  PointsUpdatedFailure({
    required this.details,
  });
}
