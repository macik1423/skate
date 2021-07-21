import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skate/bloc/points_bloc.dart';
import 'package:skate/cubit/record_cubit.dart';
import 'package:skate/model/level.dart';
import 'package:skate/model/skate_point.dart';
import 'package:skate/util/text_messages.dart';
import 'package:skate/bloc/points_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LevelTypesList extends StatelessWidget {
  const LevelTypesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Util.VOTE_PATH,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LevelType.values.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  key: Key("ListTile"),
                  title: Text(Util.TITLE_LEVEL_TYPES.elementAt(index)),
                  subtitle:
                      Text(Util.TITLE_LEVEL_TYPES_SUBTITLE.elementAt(index)),
                  leading: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LevelType.values.elementAt(index).level.color),
                    ),
                  ),
                  onTap: () {
                    putCoordinatesToDb(context, index);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void putCoordinatesToDb(BuildContext context, int index) {
    var state = context.read<RecordCubit>().state;
    if (state is RecordStop) {
      var coordinates = state.coordinates.toSet();
      Set<SkatePoint> skatePoints = coordinates
          .map((point) => SkatePoint(
              level: LevelType.values.elementAt(index).level.value,
              coordinates: GeoPoint(point.latitude, point.longitude)))
          .toSet();
      context.read<PointsBloc>().add(AddPoints(skatePoints: skatePoints));
    }
  }
}
