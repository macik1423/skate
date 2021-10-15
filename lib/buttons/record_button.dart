import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skate/buttons/level_types_list.dart';
import 'package:skate/cubit/record_cubit.dart';
import 'package:skate/util/text_messages.dart';

abstract class RecordButton {
  void action(BuildContext context);
  BlocBuilder<RecordCubit, RecordState> child();
}

class EnabledRecordButton extends StatelessWidget implements RecordButton {
  const EnabledRecordButton({
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
                  action(context);
                },
                child: child(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void action(BuildContext context) {
    final recordCubit = context.read<RecordCubit>();
    recordCubit.toggleRecordButton();
    final state = context.read<RecordCubit>().state;

    if (state is RecordStart) {
      print("---------------START-------------");
    } else if (state is RecordStop) {
      recordCubit.showPossibleVotes(context);
      print("coordinates: ${state.coordinates}");
      print("\n--------------STOP------------");
    }
  }

  @override
  BlocBuilder<RecordCubit, RecordState> child() {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        if (state is RecordStart) {
          return state.icon;
        } else if (state is RecordStop) {
          return state.icon;
        } else if (state is RecordInitial) {
          return state.icon;
        } else {
          throw Exception("Brak record stejta");
        }
      },
    );
  }
}

class DisabledRecordButton extends StatelessWidget implements RecordButton {
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
              Opacity(
                opacity: 0.25,
                child: FloatingActionButton(
                  onPressed: () async {
                    action(context);
                  },
                  child: child(),
                  tooltip: Util.RECORD_BUTTON_DISABLED,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void action(BuildContext context) {}

  @override
  BlocBuilder<RecordCubit, RecordState> child() {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        if (state is RecordStart) {
          return state.icon;
        } else if (state is RecordStop) {
          return state.icon;
        } else if (state is RecordInitial) {
          return state.icon;
        } else {
          throw Exception("Brak record stejta");
        }
      },
    );
  }
}
