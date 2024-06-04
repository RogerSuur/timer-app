import 'package:boxing_app/training/training.dart';
import 'package:flutter/material.dart';

class BuildTime extends StatelessWidget {
  const BuildTime({
    super.key,
    required this.seconds,
    required this.state,
    required this.minutes,
    required this.color,
  });

  final int seconds;
  final workoutState state;
  final int minutes;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return Text(
      state == workoutState.completedState
          ? "Completed"
          : '$minutes:$formattedSeconds',
      style: TextStyle(
        fontSize: 100,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
