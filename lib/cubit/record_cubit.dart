import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  Location _location = Location();

  StreamSubscription? _streamSubLocation;
  Set<GeoPoint> _coordinates = Set();

  final _streamController = StreamController<LocationData>();
  Stream<LocationData> get onLocationChanged => _streamController.stream;

  RecordCubit()
      : super(
          RecordStop(
            icon: Container(
              width: 18.0,
              height: 18.0,
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
            coordinates: Set(),
          ),
        );

  Future<void> toggleRecordButton() async {
    _streamSubLocation?.cancel();
    if (state is RecordStop) {
      _streamSubLocation =
          _location.onLocationChanged.listen((LocationData currentLocation) {
        // var stream = generateMockLocation();
        // _simulateLocation(stream);
        // _streamSubLocation =
        //     onLocationChanged.listen((LocationData currentLocation) {
        print(
            "LISTEN COORDINATES ${currentLocation.latitude!} ${currentLocation.longitude!}");

        _coordinates.add(
          GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
        );
      });
      emit(
        RecordStart(
          icon: Container(
            width: 18.0,
            height: 18.0,
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.rectangle),
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

  Future<void> _simulateLocation(Stream<LocationData> stream) async {
    await for (var locationData in stream) {
      print("SIMULATED LOCATION DATA: $locationData");
      _streamController.sink.add(locationData);
    }
  }

  Stream<LocationData> generateMockLocation() async* {
    for (double i = 0; i < 0.001; i += 0.0003) {
      yield LocationData.fromMap({
        "latitude": 37.421998,
        "longitude": double.parse((-122.086 + i).toStringAsFixed(5)),
        "speed": 0.1
      });
    }
  }

  @override
  Future<void> close() {
    _streamController.close();
    _streamSubLocation?.cancel();
    return super.close();
  }
}
