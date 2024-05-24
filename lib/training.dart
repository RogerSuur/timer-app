import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:just_audio/just_audio.dart';
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

  // void resetTimer() => setState(() => seconds = maxSeconds);

  void startTimer({bool reset = true}) {
    isPaused = false;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // check which state is it
      checkState();

      switch (state) {
        case workoutState.trainingState:
          setState(() {
            totalSeconds--;
            if (totalSeconds == 10) {
              //playsound clap
              playSound('sounds/clap.mp3');
            }
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
          print("Workout completed.");
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
      //playSound('assets/sounds/dingdingding.mp3');
      state = workoutState.trainingState;
      //playSound(dingDingDingAudioSource);
      playSound('sounds/dingdingding.mp3');
    }
    //check if workout is completed
    if (currentRound == widget.roundAmount && totalSeconds < 1) {
      state = workoutState.completedState;
      //check if round or break is completed
    } else if (totalSeconds == 0) {
      if (state == workoutState.breakState) {
        state = workoutState.trainingState;
        toggleBackground();
        //playSound(dingDingDingAudioSource);
        playSound('sounds/dingdingding.mp3');
        totalSeconds = widget.roundLength * 60;
      } else {
        currentRound++;
        state = workoutState.breakState;
        toggleBackground();
        //playSound(dingAudioSource);
        playSound('sounds/ding.mp3');
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
      state == workoutState.completedState
          ? "Completed"
          : '$minutes:$formattedSeconds',
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
