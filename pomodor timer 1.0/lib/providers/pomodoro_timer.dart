import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PomodoroFocusState { focus, rest }

class PomodoroTimerNotifier extends StateNotifier<int> {
  PomodoroTimerNotifier(this.ref) : super(1500);

  final Ref ref;

  PomodoroFocusState pomodoroFocusState = PomodoroFocusState.focus;
  Timer? timer;

  void decreaseTimer() {
    state -= 1;
  }

  void changeTimerState() {
    if (pomodoroFocusState == PomodoroFocusState.focus) {
      pomodoroFocusState = PomodoroFocusState.rest;
      state = 300;
      timer = getTimer();
    } else {
      pomodoroFocusState = PomodoroFocusState.focus;
      state = 1500;
      timer = getTimer();
    }
  }

  void startTimer() {
    timer = getTimer();
  }

  Timer getTimer() {
    return Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (state == 0) {
        timer.cancel();
        changeTimerState();
      } else {
        decreaseTimer();
      }
    });
  }

  void resetTimer() {
    state = 1500;
  }

  bool get isActive {
    if (pomodoroFocusState == PomodoroFocusState.focus) {
      return true;
    } else {
      return false;
    }
  }
}

final pomodoroTimerProvider = StateNotifierProvider<PomodoroTimerNotifier, int>(
  (ref) => PomodoroTimerNotifier(ref),
);
