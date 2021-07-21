import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:skate/repository/lines_repository.dart';
import 'package:skate/bloc/lines_event.dart';
import 'package:skate/bloc/lines_state.dart';

class LinesBloc extends Bloc<LinesEvent, LinesState> {
  final LinesRepository _linesRepository;
  late StreamSubscription _linesSubscription;

  LinesBloc({
    required LinesRepository linesRepository,
  })  : _linesRepository = linesRepository,
        super(LinesLoading());

  @override
  Stream<LinesState> mapEventToState(
    LinesEvent event,
  ) async* {
    if (event is LoadLines) {
      yield* _mapLoadLinesToState();
    } else if (event is LinesUpdated) {
      yield* _mapLinesUpdateToState(event);
    } else if (event is LinesUpdatedFailure) {
      yield* _mapLinesUpdateToStateFailure();
    } else if (event is AddLine) {
      yield* _mapAddLineToState(event);
    }
  }

  Stream<LinesState> _mapLoadLinesToState() async* {
    _linesSubscription = _linesRepository.lines().listen(
          (lines) => add(LinesUpdated(lines: lines)),
        )..onError((_) => add(LinesUpdatedFailure()));
  }

  Stream<LinesState> _mapLinesUpdateToState(LinesUpdated event) async* {
    yield LinesLoadSuccess(event.lines);
  }

  Stream<LinesState> _mapLinesUpdateToStateFailure() async* {
    yield LinesLoadFailure();
  }

  Stream<LinesState> _mapAddLineToState(AddLine event) async* {
    try {
      _linesRepository.addNewLine(event.line);
      yield LinesAddedSuccess();
    } on Exception {
      yield LinesAddedFailure();
    }
  }

  @override
  Future<void> close() {
    _linesSubscription.cancel();
    return super.close();
  }
}
