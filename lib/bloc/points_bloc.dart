import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:skate/repository/points_repository.dart';
import 'package:skate/bloc/points_event.dart';
import 'package:skate/bloc/points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final PointsRepository _pointsRepository;
  StreamSubscription? _pointsSubscription;
  PointsBloc({required PointsRepository pointsRepository})
      : _pointsRepository = pointsRepository,
        super(PointsLoading());

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is LoadPoints) {
      yield* _mapLoadPointsToState();
    } else if (event is PointsUpdated) {
      yield* _mapPointsUpdateToState(event);
    } else if (event is PointsUpdatedFailure) {
      yield* _mapPointsUpdateToStateFailure();
    } else if (event is AddPoints) {
      yield* _mapAddPointsToState(event);
    }
  }

  Stream<PointsState> _mapLoadPointsToState() async* {
    _pointsSubscription?.cancel();
    _pointsSubscription = _pointsRepository.points().listen(
          (points) => add(
            PointsUpdated(skatePoints: points),
          ),
        )..onError(
            (error) {
              print("ERROR: $error");
              return add(
                PointsUpdatedFailure(details: error),
              );
            },
          );
  }

  Stream<PointsState> _mapPointsUpdateToState(PointsUpdated event) async* {
    yield PointsLoadSuccess(skatePoints: event.skatePoints);
  }

  Stream<PointsState> _mapPointsUpdateToStateFailure() async* {
    yield PointsLoadFailure();
  }

  //trzeba rzucic wyjatkeim w addNewPoint jesli punlty juz istnieja wtedy nie przejdzie pointspdated to jest na bank zle
  Stream<PointsState> _mapAddPointsToState(AddPoints event) async* {
    _pointsRepository.addNewPoints(event.skatePoints);
  }

  @override
  Future<void> close() {
    _pointsSubscription?.cancel();
    return super.close();
  }
}
