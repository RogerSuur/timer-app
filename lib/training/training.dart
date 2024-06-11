import 'package:boxing_app/providers/TimerModel.dart';
import 'package:boxing_app/training/control_buttons.dart';
import 'package:boxing_app/training/round_display.dart';
import 'package:boxing_app/training/soundmanager.dart';
import 'package:boxing_app/training/timer_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';

//displays the ui of the training
class Training extends StatefulWidget {
  final int roundLength;
  final int breakLength;
  final int roundAmount;

  const Training(this.roundLength, this.breakLength, this.roundAmount,
      {super.key});

  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  //workout colors
  final List<Color> workoutColors = [
    const Color.fromRGBO(68, 138, 255, 1),
    const Color.fromRGBO(63, 81, 181, 1),
    const Color.fromRGBO(0, 0, 0, 1)
  ];
  //break colors
  final List<Color> breakColors = [
    const Color.fromRGBO(187, 117, 0, 1),
    const Color.fromRGBO(192, 174, 74, 1),
    const Color.fromRGBO(0, 0, 0, 1),
  ];

  late List<Color> currentColors;

  @override
  void initState() {
    super.initState();
    currentColors = workoutColors;
  }

  @override
  void dispose() {
    // soundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TimerModel timerModel = Provider.of<TimerModel>(context);
    return ChangeNotifierProvider<TimerModel>(
      create: (BuildContext context) => TimerModel(
        breakLength: widget.breakLength,
        roundLength: widget.roundLength,
        roundAmount: widget.roundAmount,
        workoutColors: workoutColors,
        breakColors: breakColors,
        soundManager: SoundManager(),
      ),
      child: Consumer<TimerModel>(
        builder: (BuildContext context, timerModel, Widget? child) {
          return Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: currentColors,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //TimerDisplay
                    TimerDisplay(
                      totalSeconds: timerModel.totalSeconds,
                      seconds: timerModel.seconds,
                      minutes: timerModel.minutes,
                      color: Colors.indigo.shade50,
                      state: timerModel.state,
                      roundLength: widget.roundLength,
                      breakLength: widget.breakLength,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    //RoundDisplay
                    RoundDisplay(
                        currentRound: timerModel.currentRound,
                        totalRounds: widget.roundAmount,
                        isBreak: timerModel.isPaused,
                        state: timerModel.state,
                        color: Colors.indigo.shade50),
                    const SizedBox(
                      height: 60,
                    ),
                    //controlButtons for timer
                    ControlButtons(
                      onStart: () => timerModel.startTimer(),
                      onPause: () => timerModel.togglePause(),
                      onStop: () => timerModel.stopTimer(),
                      isPaused: timerModel.isPaused,
                      state: timerModel.state,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
