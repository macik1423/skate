import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skate/buttons/level_types_list.dart';
import 'package:skate/cubit/record_cubit.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  context.read<RecordCubit>().toggleRecordButton();
                  var state = context.read<RecordCubit>().state;

                  if (state is RecordStart) {
                    print("---------------START-------------");
                  } else if (state is RecordStop) {
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

                    print("coordinates: ${state.coordinates}");
                    print("\n--------------STOP------------");
                  }
                },
                child: BlocBuilder<RecordCubit, RecordState>(
                  builder: (context, state) {
                    if (state is RecordStart) {
                      return state.icon;
                    } else if (state is RecordStop) {
                      return state.icon;
                    } else {
                      throw Exception("Brak record stejta");
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
