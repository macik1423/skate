import 'package:equatable/equatable.dart';
import 'package:skate/model/line.dart';

abstract class LinesState extends Equatable {
  const LinesState();

  @override
  List<Object> get props => [];
}

class LinesLoading extends LinesState {}

class LinesLoadSuccess extends LinesState {
  final List<Line> lines;

  LinesLoadSuccess([this.lines = const []]);
}

class LinesLoadFailure extends LinesState {}

class LinesAddedSuccess extends LinesState {}

class LinesAddedFailure extends LinesState {}
