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

  void startTimer({bool reset = true}) {
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
        stopTimer(reset: false);
        print("Workout completed.");
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    isPaused = true;

    setState(() => timer?.cancel());
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
              showRounds(color: state == workoutState.breakState ? null : null),
              const SizedBox(
                height: 60,
              ),
              //ControlBUttons
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
    print("showROunds color $color");
    Color displayColor = color ?? Colors.indigo.shade50;

    print("showROunds displayColor $displayColor");

    return Text(
      state == workoutState.trainingState ||
              state == workoutState.preTrainingState
          ? '$currentRound/${widget.roundAmount}'
          : 'Break',
      style: TextStyle(
          color: displayColor, fontWeight: FontWeight.bold, fontSize: 40),
    );
  }

  // Widget buildTimer({Color? color}) {
  //   Color displayColor = color ?? Colors.white;

  //   return SizedBox(
  //     width: 300,
  //     height: 300,
  //     child: Stack(
  //       fit: StackFit.expand,
  //       children: [
  //         CircularProgressIndicator(
  //           value: 1 -
  //               (totalSeconds /
  //                   (state == workoutState.trainingState
  //                       ? widget.roundLength * 60
  //                       : widget.breakLength * 60)),
  //           valueColor: AlwaysStoppedAnimation(displayColor),
  //           strokeWidth: 12,
  //           color: displayColor,
  //           backgroundColor: Colors.black54,
  //         ),
  //         Center(
  //           child: BuildTime(
  //               seconds: seconds,
  //               state: state,
  //               minutes: minutes,
  //               color: displayColor),
  //         )
  //       ],
  //     ),
  //   );
  // }
}

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
    ;
  }
}

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

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {super.key,
      required this.text,
      this.color = Colors.white,
      this.backgroundColor = const Color(0xFF00BCD4),
      required this.onClicked});

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: color),
      ));
}
