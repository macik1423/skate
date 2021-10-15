import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/bloc/points_event.dart';
import 'package:skate/buttons/level_types_list.dart';
import 'package:skate/model/level.dart';
import 'package:skate/model/skate_point.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  Location _location = Location();

  StreamSubscription? _streamSubLocation;
  Set<GeoPoint> _coordinates = Set();

  final _streamController = StreamController<LocationData>();
  Stream<LocationData> get onLocationChanged => _streamController.stream;

  RecordCubit()
      : super(
          RecordInitial(
            icon: Container(
              width: 18.0,
              height: 18.0,
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
        );

  Future<void> toggleRecordButton() async {
    _location.enableBackgroundMode(enable: true);
    _streamSubLocation?.cancel();
    if (state is RecordInitial) {
      _coordinates = Set();
      _streamSubLocation =
          _location.onLocationChanged.listen((LocationData currentLocation) {
        print(
            "LISTEN COORDINATES ${currentLocation.latitude!} ${currentLocation.longitude!}");
        _coordinates.add(
          GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
        );
      });
      final LocationData currentLocation = await _location.getLocation();
      emit(
        RecordStart(
          icon: Container(
            width: 18.0,
            height: 18.0,
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.rectangle),
          ),
          start: GeoPoint(
            currentLocation.latitude!,
            currentLocation.longitude!,
          ),
        ),
      );
    } else if (state is RecordStart) {
      _streamController.close();
      _streamSubLocation?.cancel();
      _coordinates.forEach(
          (e) => print("COORDINATES LISTENED ${e.latitude} ${e.longitude}"));
      emit(
        RecordStop(
          icon: Container(
            width: 18.0,
            height: 18.0,
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
          coordinates: _coordinates,
        ),
      );
    }
  }

  void showPossibleVotes(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: LevelTypesList(),
      ),
    );
  }

  void putCoordinatesToDb(BuildContext context, int index) {
    if (state is RecordStop) {
      final coordinates = _coordinates.toSet();
      final Set<SkatePoint> skatePoints = coordinates.map((point) {
        final pointLevel = LevelType.values.elementAt(index).level.value;
        return SkatePoint(
          level: pointLevel,
          coordinates: GeoPoint(point.latitude, point.longitude),
          avg: pointLevel.toDouble(),
        );
      }).toSet();
      context.read<PointsBloc>().add(AddPoints(skatePoints: skatePoints));
    }
    emit(
      RecordInitial(
        icon: Container(
          width: 18.0,
          height: 18.0,
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _streamController.close();
    _streamSubLocation?.cancel();
    return super.close();
  }
}
