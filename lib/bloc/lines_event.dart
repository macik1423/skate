import 'package:equatable/equatable.dart';
import 'package:skate/model/line.dart';

abstract class LinesEvent extends Equatable {
  const LinesEvent();

  @override
  List<Object> get props => [];
}

class LoadLines extends LinesEvent {}

class AddLine extends LinesEvent {
  final Line line;

  AddLine({required this.line});
}

class LinesUpdated extends LinesEvent {
  final List<Line> lines;

  LinesUpdated({required this.lines});
}

class LinesUpdatedFailure extends LinesEvent {}
