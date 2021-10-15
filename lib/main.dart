import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/cubit/internet_cubit.dart';
import 'package:skate/cubit/level_cubit.dart';
import 'package:skate/cubit/location_cubit.dart';
import 'package:skate/cubit/record_cubit.dart';
import 'package:skate/cubit/zoom_cubit.dart';
import 'package:skate/map_skate.dart';
import 'package:skate/repository/points_firebase_repository.dart';
import 'package:skate/bloc/points_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');

  runApp(
    MyApp(
      connectivity: Connectivity(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final Connectivity connectivity;
  const MyApp({Key? key, required this.connectivity}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),
        BlocProvider<ZoomCubit>(
          create: (context) => ZoomCubit(),
        ),
        BlocProvider<PointsBloc>(
          create: (context) => PointsBloc(
            pointsRepository: PointsFirebaseRepository(
              pointsCollection: FirebaseFirestore.instance.collection("points"),
            ),
          )..add(LoadPoints()),
        ),
        BlocProvider<LevelCubit>(
          create: (context) => LevelCubit(),
        ),
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(
            connectivity: widget.connectivity,
          ),
        ),
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(),
        ),
      ],
      child: MaterialApp(
        home: MapSkate(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.black.withOpacity(0),
          ),
        ),
      ),
    );
  }
}
