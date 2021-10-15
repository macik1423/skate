import 'package:bloc/bloc.dart';

class ZoomCubit extends Cubit<double> {
  ZoomCubit() : super(4.0);

  //dla line
  // changeStokeWidth(zoom) {
  //   if (zoom <= 17 && zoom >= 16) {
  //     emit(8.0);
  //   } else if (zoom < 16 && zoom >= 15) {
  //     emit(5.0);
  //   } else if (zoom < 15 && zoom >= 13) {
  //     emit(3.0);
  //   } else {
  //     emit(1.0);
  //   }
  // }

  changeStrokeWidth(zoom) {
    if (zoom <= 17 && zoom >= 16) {
      emit(8.0);
    } else if (zoom < 16 && zoom >= 15) {
      emit(7.0);
    } else if (zoom < 15 && zoom >= 13) {
      emit(5.0);
    } else {
      emit(3.0);
    }
  }
}
