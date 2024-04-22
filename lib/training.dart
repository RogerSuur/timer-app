import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';

class Training extends StatefulWidget {
  final int roundLength;
  final int breakLength;
  final int roundAmount;

  Training(this.roundLength, this.breakLength, this.roundAmount);

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
    Color.fromRGBO(68, 138, 255, 1),
    Color.fromRGBO(63, 81, 181, 1),
    Color.fromRGBO(0, 0, 0, 1)
  ];
  //break colors
  final List<Color> breakColors = [
    Color.fromRGBO(187, 117, 0, 1),
    Color.fromRGBO(192, 174, 74, 1),
    Color.fromRGBO(0, 0, 0, 1),
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

  // void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer({bool reset = true}) {
    isPaused = false;
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      // check which state is it
      checkState();

      switch (state) {
        case workoutState.trainingState:
          setState(() {
            totalSeconds--;
            minutes = totalSeconds ~/ 60;
            seconds = totalSeconds % 60;
          });
          break;
        case workoutState.breakState:
          setState(() {
            totalSeconds--;
            minutes = totalSeconds ~/ 60;
            seconds = totalSeconds % 60;
          });
        case workoutState.completedState:
          stopTimer();
          break;
        default:
      }
    });
  }

  void stopTimer({bool reset = true}) {
    // if (reset) {
    //   resetTimer();
    // }
    isPaused = true;

    setState(() => timer?.cancel());
  }

  void checkState() {
    //check if client starts the workout
    if (state == workoutState.preTrainingState) {
      state = workoutState.trainingState;
    }
    //check if workout is completed
    if (currentRound == widget.roundAmount) {
      state = workoutState.completedState;
      //check if round or break is completed
    } else if (totalSeconds == 0) {
      if (state == workoutState.breakState) {
        state = workoutState.trainingState;
        toggleBackground();
        totalSeconds = widget.roundLength * 60;
      } else {
        currentRound++;
        state = workoutState.breakState;
        toggleBackground();
        totalSeconds = widget.breakLength * 60;
      }
      seconds = totalSeconds % 60;
      minutes = totalSeconds ~/ 60;
    }
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
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: currentColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(
                  color: state == workoutState.breakState
                      ? Colors.indigo.shade50
                      : null),
              const SizedBox(
                height: 40,
              ),
              showRounds(
                  color: state == workoutState.breakState
                      ? Colors.indigo.shade50
                      : null),
              const SizedBox(
                height: 60,
              ),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return state == workoutState.preTrainingState
        ? ButtonWidget(
            text: 'Start Workout!',
            onClicked: () {
              startTimer();
            },
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isPaused ? 'Resume' : 'Pause',
                onClicked: () {
                  if (!isPaused) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
              ),
              ButtonWidget(
                text: 'Stop',
                onClicked: () {
                  stopTimer();
                },
              ),
            ],
          );
  }

  Widget showRounds({Color? color}) {
    Color displayColor = color ?? Colors.indigo.shade50;

    return Text(
      state == workoutState.trainingState ||
              state == workoutState.preTrainingState
          ? '$currentRound/${widget.roundAmount}'
          : 'Break',
      style: TextStyle(
          color: displayColor, fontWeight: FontWeight.bold, fontSize: 40),
    );
  }

  Widget buildTimer({Color? color}) {
    Color displayColor = color ?? Colors.white;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 -
                (totalSeconds /
                    (state == workoutState.trainingState
                        ? widget.roundLength * 60
                        : widget.breakLength * 60)),
            valueColor: AlwaysStoppedAnimation(displayColor),
            strokeWidth: 12,
            color: displayColor,
            backgroundColor: Colors.black54,
          ),
          Center(
            child: buildTime(color: displayColor),
          )
        ],
      ),
    );
  }

  Widget buildTime({Color? color}) {
    String formattedSeconds = seconds.toString().padLeft(2, '0');
    Color textColor = color ?? Colors.indigo.shade50;

    return Text(
      '${minutes}:$formattedSeconds',
      style: TextStyle(
        fontSize: 100,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      this.color = Colors.white,
      this.backgroundColor = const Color(0xFF00BCD4),
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: color),
      ),
      onPressed: onClicked);
}
