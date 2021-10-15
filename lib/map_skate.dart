import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/buttons/location_button.dart';
import 'package:skate/buttons/record_button.dart';
import 'package:skate/cubit/internet_cubit.dart';
import 'package:skate/cubit/internet_state.dart';
import 'package:skate/cubit/record_cubit.dart';
import 'package:skate/cubit/zoom_cubit.dart';
import 'package:skate/markers/triangle.dart';
import 'package:skate/model/line.dart';
import 'package:skate/model/skate_point.dart';
import 'package:skate/util/text_messages.dart';
import 'license/open_street_map_license.dart';
import 'widgets/drawer.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:skate/bloc/lines_state.dart';
import 'package:skate/bloc/points_state.dart';
import 'package:skate/model/level.dart' as ModelLevel;

class MapSkate extends StatefulWidget {
  const MapSkate({Key? key}) : super(key: key);
  static const String route = '/';
  @override
  _MapSkateState createState() => _MapSkateState();
}

class _MapSkateState extends State<MapSkate> {
  final MapController mapController = MapController();
  static const double MIN_ZOOM = 11.0;
  static const double MAX_ZOOM = 17.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      drawer: buildDrawer(context, MapSkate.route),
      body: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, internetState) {
          showInternetSnackBar(internetState, context);
        },
        builder: (context, internetState) {
          return BlocConsumer<PointsBloc, PointsState>(
            listener: (pointsContext, pointsState) {
              showPointsSnackBar(pointsState, context);
            },
            builder: (pointsContext, pointsState) {
              return BlocBuilder<ZoomCubit, double>(
                builder: (zoomContext, zoomState) {
                  return BlocBuilder<RecordCubit, RecordState>(
                    builder: (recordContext, recordState) {
                      return Center(
                        child: mainMap(internetState, zoomContext, pointsState,
                            recordState),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  FlutterMap mainMap(InternetState internetState, BuildContext zoomContext,
      PointsState pointsState, RecordState recordState) {
    return FlutterMap(
      nonRotatedChildren: [
        internetState is InternetConnected
            ? EnabledRecordButton()
            : DisabledRecordButton(),
        OSMLicense(),
      ],
      mapController: mapController,
      options: MapOptions(
        minZoom: MIN_ZOOM,
        maxZoom: MAX_ZOOM,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        plugins: <MapPlugin>[LocationPlugin(), TappablePolylineMapPlugin()],
        onPositionChanged: (position, hasGesture) {
          final zoom = position.zoom;
          if (zoom != null) {
            print("zoom ");

            zoomContext.read<ZoomCubit>().changeStrokeWidth(zoom);
            print(
                "state ${zoomContext.read<ZoomCubit>().state}, position ${position.center}");
          }
        },
      ),
      layers: <LayerOptions>[
        TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: <String>['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: markers(pointsState, zoomContext, recordState),
        ),
      ],
      nonRotatedLayers: <LayerOptions>[
        LocationOptions(
          locationButton(),
          onLocationUpdate: (LatLngData? ld) {
            print(
                'Location updated: ${ld?.location} (accuracy: ${ld?.accuracy})');
          },
          onLocationRequested: (LatLngData? ld) {
            if (ld == null) {
              return;
            }
            mapController.move(ld.location, 16.0);
          },
        ),
      ],
    );
  }

  void showPointsSnackBar(PointsState pointsState, BuildContext context) {
    if (pointsState is PointsLoadFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Util.LOAD_POINTS_FAILURE),
        ),
      );
    }
    if (pointsState is PointsAddedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Util.ADDED_POINTS_SUCCESS),
        ),
      );
    }
    if (pointsState is PointsAddedConnectionFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("nie udało sie dodać danych, brak dostepu do internetu"),
        ),
      );
    }
  }

  void showInternetSnackBar(InternetState internetState, BuildContext context) {
    if (internetState is InternetDisconnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OFFLINE"),
          duration: const Duration(milliseconds: 500),
        ),
      );
    } else if (internetState is InternetConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Jesteś ONLINE"),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  List<Marker> markers(PointsState pointsState, BuildContext zoomContext,
      RecordState recordState) {
    if (recordState is RecordStart) {
      print("record start -----> ${recordState.start.latitude}");
      final point = recordState.start;
      return [
        Marker(
          point: LatLng(point.latitude, point.longitude),
          width: 32,
          height: 32,
          builder: (ctx) => CustomPaint(
            painter: TrianglePainter(
              strokeColor: Colors.blue,
              strokeWidth: 2,
              paintingStyle: PaintingStyle.fill,
            ),
          ),
        ),
      ];
    } else if (pointsState is PointsLoadSuccess) {
      List<SkatePoint> points = pointsState.skatePoints.toList();
      return points.map(
        (point) {
          final diameter = zoomContext.read<ZoomCubit>().state;
          return Marker(
            point:
                LatLng(point.coordinates.latitude, point.coordinates.longitude),
            width: diameter,
            height: diameter,
            builder: (ctx) => Container(
              decoration: BoxDecoration(
                color: ModelLevel.Level.ofValue(point.level).color,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ).toList();
    }
    return [];
  }

  List<TaggedPolyline> getTaggedPolylines(linesState, zoomState) {
    if (linesState is LinesLoadSuccess) {
      List<Line> lines = linesState.lines.toList();
      return lines
          .map(
            (line) => TaggedPolyline(
                points: convertGeoPointToLatLng(line),
                strokeWidth: zoomState,
                color: Colors.black),
          )
          .toList();
    }
    return [];
  }

  List<LatLng> convertGeoPointToLatLng(Line line) {
    return line.points
        .map(
          (p) => LatLng(p.latitude, p.longitude),
        )
        .toList();
  }

  List<LatLng> getPoints(List<GeoPoint> points) {
    List<LatLng> latLngPoints =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    return latLngPoints;
  }
}
