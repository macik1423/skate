import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/cubit/level_cubit.dart';
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

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
            pointsRepository: PointsFirebaseRepository(),
          )..add(LoadPoints()),
        ),
        BlocProvider<LevelCubit>(
          create: (context) => LevelCubit(),
        ),
      ],
      child: MaterialApp(
        home: MapSkate(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
      ),
    );
  }
}
