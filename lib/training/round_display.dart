import 'package:boxing_app/providers/TimerModel.dart';
import 'package:flutter/material.dart';

//This widget displays the current round or indicates a break.
class RoundDisplay extends StatelessWidget {
  final int currentRound;
  final int totalRounds;
  final bool isBreak;
  final workoutState state;
  final Color color;
  const RoundDisplay(
      {super.key,
      required this.currentRound,
      required this.totalRounds,
      required this.isBreak,
      required this.state,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      state == workoutState.trainingState ||
              state == workoutState.preTrainingState
          ? '$currentRound/$totalRounds'
          : 'Break',
      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 40),
    );
  }
}
