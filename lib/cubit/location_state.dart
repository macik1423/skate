import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationPermissionGranted extends LocationState {}

class LocationPermissionNotGranted extends LocationState {}

class LocationServiceEnabled extends LocationState {}

class LocationServiceDisabled extends LocationState {}
