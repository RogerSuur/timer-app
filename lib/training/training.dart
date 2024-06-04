import 'package:boxing_app/training/control_buttons.dart';
import 'package:boxing_app/training/round_display.dart';
import 'package:boxing_app/training/timer_display.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Training extends StatefulWidget {
  final int roundLength;
  final int breakLength;
  final int roundAmount;

  const Training(this.roundLength, this.breakLength, this.roundAmount,
      {super.key});

  @override
  State<Training> createState() => _TrainingState();
}

enum workoutState {
  trainingState,
  preTrainingState,
  breakState,
  completedState
}

class _TrainingState extends State<Training> {
  var state = workoutState.preTrainingState;
  int seconds = 0;
  int minutes = 0;
  int totalSeconds = 0;
  int currentRound = 1;
  Timer? timer;
  var isPaused = false;

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
    totalSeconds = widget.roundLength * 60;
    minutes = totalSeconds ~/ 60;
    seconds = totalSeconds % 60;
    currentColors = workoutColors;
  }

  void playSound(String fileName) {
    final audioPlayer = AudioPlayer();
    print("PLAY SOUND " + fileName);
    audioPlayer.play(AssetSource(fileName));
  }

  void resetTimer() => setState(() {
        totalSeconds = widget.roundLength * 60;
        minutes = totalSeconds ~/ 60;
        seconds = totalSeconds % 60;
        currentColors = workoutColors;
        isPaused = false;
        state = workoutState.preTrainingState;
      });

  void startTimer() {
    print("start timer");
    print(isPaused);
    isPaused = false;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (totalSeconds > 0) {
        setState(() {
          totalSeconds--;
          minutes = totalSeconds ~/ 60;
          seconds = totalSeconds % 60;
        });
        checkState();
      } else {
        stopTimer();
      }
    });
  }

  togglePause() {
    print("togglePause function");
    print(isPaused);
    if (!isPaused) {
      timer?.cancel();
      isPaused = true;
      setState(() {});
    } else {
      startTimer();
    }
  }

  void workoutCompleted() {
    setState(() => timer?.cancel());
    print("Workout completed.");
  }

  void stopTimer() {
    print("stopTImer function");
    print(isPaused);
    setState(() => timer?.cancel());
    resetTimer();
    isPaused = true;
  }

  //checks and changes the states of workout
  void checkState() {
    //check if client starts the workout
    if (state == workoutState.preTrainingState) {
      state = workoutState.trainingState;
      playSound('sounds/dingdingding.mp3');
    }
    if (totalSeconds == 10) {
      playSound('sounds/clap.mp3');
    }
    if (totalSeconds == 0) {
      updateRoundOrBreakState();
    }
  }

  //check if round or break is completed
  void updateRoundOrBreakState() {
    if (state == workoutState.breakState) {
      state = workoutState.trainingState;
      totalSeconds = widget.roundLength * 60;
      playSound('sounds/dingdingding.mp3');
    } else {
      //check if workout is completed
      currentRound++;
      if (currentRound > widget.roundAmount) {
        state = workoutState.completedState;
        playSound('sounds/dingdingding.mp3');
      } else {
        state = workoutState.breakState;
        playSound('sounds/ding.mp3');
        totalSeconds = widget.breakLength * 60;
      }
    }
    toggleBackground();
  }

  void toggleBackground() {
    setState(() {
      currentColors =
          (currentColors == workoutColors) ? breakColors : workoutColors;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                totalSeconds: totalSeconds,
                seconds: seconds,
                minutes: minutes,
                color: Colors.indigo.shade50,
                state: state,
                roundLength: widget.roundLength,
                breakLength: widget.breakLength,
              ),
              const SizedBox(
                height: 40,
              ),
              //RoundDisplay
              RoundDisplay(
                  currentRound: currentRound,
                  totalRounds: widget.roundAmount,
                  isBreak: isPaused,
                  state: state,
                  color: Colors.indigo.shade50),
              const SizedBox(
                height: 60,
              ),
              //controlButtons for timer
              ControlButtons(
                onStart: startTimer,
                onPause: togglePause,
                onStop: stopTimer,
                isPaused: isPaused,
                state: state,
              )
              //buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
