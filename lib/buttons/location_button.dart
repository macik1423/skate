import 'package:flutter/material.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

LocationButtonBuilder locationButton() {
  return (BuildContext context, ValueNotifier<LocationServiceStatus> status,
      Function onPressed) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          child: ValueListenableBuilder<LocationServiceStatus>(
            valueListenable: status,
            builder: (BuildContext context, LocationServiceStatus value,
                Widget? child) {
              switch (value) {
                case LocationServiceStatus.disabled:
                case LocationServiceStatus.permissionDenied:
                case LocationServiceStatus.unsubscribed:
                  return const Icon(
                    Icons.location_disabled,
                    color: Colors.white,
                  );
                default:
                  return const Icon(
                    Icons.location_searching,
                    color: Colors.white,
                  );
              }
            },
          ),
          onPressed: () => onPressed(),
        ),
      ),
    );
  };
}
