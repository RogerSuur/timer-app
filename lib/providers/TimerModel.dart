import 'dart:async';

import 'package:boxing_app/training/soundmanager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum workoutState {
  trainingState,
  preTrainingState,
  breakState,
  completedState
}

//handles all related to timer.
class TimerModel with ChangeNotifier {
  //configuration properties
  var state = workoutState.preTrainingState;
  final int roundLength;
  final int breakLength;
  final int roundAmount;
  int _seconds = 0;
  int _minutes = 0;
  int _totalSeconds;
  final List<Color> workoutColors;
  final List<Color> breakColors;
  late SoundManager soundManager;

  //runtime properties
  late List<Color> _currentColors;
  int _currentRound = 1;
  var _isPaused = false;
  Timer? timer;

  TimerModel({
    required this.roundLength,
    required this.breakLength,
    required this.roundAmount,
    required this.workoutColors,
    required this.breakColors,
    required this.soundManager,
  })  : _currentColors = workoutColors,
        _totalSeconds = roundLength * 60;

  //getters to retrieve the current state
  int get totalSeconds => _totalSeconds;
  int get seconds => _seconds;
  int get currentRound => _currentRound;
  int get minutes => _minutes;
  bool get isPaused => _isPaused;
  List<Color> get currentColors => _currentColors;

  //methods
  void countDownSeconds() {
    _totalSeconds--;
    _minutes = totalSeconds ~/ 60;
    _seconds = totalSeconds % 60;
    notifyListeners();
  }

  void updateRounds() {
    _currentRound++;
    notifyListeners();
  }

  void startTimer() {
    _isPaused = false;
    print(_totalSeconds);
    notifyListeners();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_totalSeconds > 0) {
        countDownSeconds();
        checkState();
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void checkState() {
    //check if client starts the workout
    if (state == workoutState.preTrainingState) {
      state = workoutState.trainingState;
      print("playsound at the start of the training");
      soundManager.playSound('sounds/dingdingding.mp3');
    }
    if (totalSeconds == 10) {
      print("playsound at the the 10 seconds left mark");
      soundManager.playSound('sounds/clap.mp3');
    }
    if (totalSeconds == 0) {
      updateRoundOrBreakState();
    }
  }

  void updateRoundOrBreakState() {
    if (state == workoutState.breakState) {
      state = workoutState.trainingState;
      _totalSeconds = roundLength * 60;
      print("playsound at the start of the round");
      soundManager.playSound('sounds/dingdingding.mp3');
    } else {
      //check if workout is completed
      updateRounds();
      if (currentRound > roundAmount) {
        state = workoutState.completedState;
        print("playsound at the end of the round and workout");
        soundManager.playSound('sounds/dingdingding.mp3');
      } else {
        state = workoutState.breakState;
        print("playsound at the end of the round");
        soundManager.playSound('sounds/ding.mp3');
        _totalSeconds = breakLength * 60;
      }
    }
    toggleBackground();
  }

  void resetTimer() {
    _totalSeconds = roundLength * 60;
    _minutes = totalSeconds ~/ 60;
    _seconds = totalSeconds % 60;
    _currentColors = workoutColors;
    _currentRound = 1;
    _isPaused = false;
    state = workoutState.preTrainingState;
  }

  void stopTimer() {
    timer?.cancel();
    resetTimer();
    _isPaused = true;
    notifyListeners();
  }

  togglePause() {
    if (!_isPaused) {
      timer?.cancel();
      _isPaused = true;
    } else {
      startTimer();
    }
    notifyListeners();
  }

  void workoutCompleted() {
    timer?.cancel();
    notifyListeners();
    print("Workout completed.");
  }

  void toggleBackground() {
    _currentColors =
        (currentColors == workoutColors) ? breakColors : workoutColors;
    notifyListeners();
  }
}
