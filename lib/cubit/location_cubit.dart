import 'package:bloc/bloc.dart';
import 'package:skate/cubit/location_state.dart';
import 'package:location/location.dart';

class LocationCubit extends Cubit<LocationState> {
  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;

  LocationCubit() : super(LocationInitial());

  monitorLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        emit(LocationServiceDisabled());
      }
    } else {
      emit(LocationServiceEnabled());
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        emit(LocationPermissionNotGranted());
      }
    } else {
      emit(LocationPermissionGranted());
    }
  }
}
