//Manages the control buttons for starting, pausing, and stopping the workout.
import 'package:boxing_app/training/build_buttons.dart';
import 'package:boxing_app/training/training.dart';
import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final bool isPaused;
  final workoutState state;
  const ControlButtons({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onStop,
    required this.isPaused,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state == workoutState.preTrainingState
        ? ButtonWidget(text: 'Start Workout!', onClicked: onStart)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isPaused ? 'Resume' : 'Pause',
                onClicked: onPause,
              ),
              ButtonWidget(
                text: 'Stop',
                onClicked: onStop,
              ),
            ],
          );
    ;
  }
}
