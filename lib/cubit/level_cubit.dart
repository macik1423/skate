import 'package:bloc/bloc.dart';
import 'package:skate/model/level.dart';

class LevelCubit extends Cubit<LevelType> {
  LevelCubit() : super(LevelType.perfect);

  setLevel(LevelType levelType) {
    emit(levelType);
  }
}
