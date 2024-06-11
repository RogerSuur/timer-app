import 'package:boxing_app/providers/TimerModel.dart';
import 'package:boxing_app/training/training.dart';
import 'package:boxing_app/training/build_time.dart';
import 'package:flutter/material.dart';

//This widget will display the countdown timer and progressIndicator
class TimerDisplay extends StatelessWidget {
  final int totalSeconds;
  final int seconds;
  final int minutes;
  final Color color;
  final workoutState state;
  final int roundLength;
  final int breakLength;

  const TimerDisplay(
      {super.key,
      required this.totalSeconds,
      required this.seconds,
      required this.color,
      required this.minutes,
      required this.state,
      required this.roundLength,
      required this.breakLength});

  // Color displayColor = color ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    double progress = 1 -
        (totalSeconds /
            (state == workoutState.trainingState
                ? roundLength * 60
                : breakLength * 60));
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            valueColor: AlwaysStoppedAnimation(color),
            strokeWidth: 12,
            color: color,
            backgroundColor: Colors.black54,
          ),
          Center(
            child: BuildTime(
                seconds: seconds, state: state, minutes: minutes, color: color),
          )
        ],
      ),
    );
  }
}
