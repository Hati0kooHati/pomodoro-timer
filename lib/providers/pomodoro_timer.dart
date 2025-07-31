import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/pomodoro_info.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer_button.dart';

enum PomodoroFocusState { focus, rest }

class PomodoroTimerNotifier extends StateNotifier<int> {
  PomodoroTimerNotifier(this.ref) : super(1500);

  final Ref ref;

  int focusSeconds = 1500;
  int restSeconds = 300;

  PomodoroFocusState pomodoroFocusState = PomodoroFocusState.focus;
  Timer? timer;

  void changeTimerTime({
    required int focusSecondsNew,
    required int restSecondsNew,
  }) {
    focusSeconds = focusSecondsNew;

    restSeconds = restSecondsNew;

    if (pomodoroFocusState == PomodoroFocusState.focus) {
      state = focusSeconds;
    } else {
      state = restSeconds;
    }
  }

  void decreaseTimer() {
    state -= 1;
  }

  void changeTimerState() {
    if (pomodoroFocusState == PomodoroFocusState.focus) {
      pomodoroFocusState = PomodoroFocusState.rest;

      state = restSeconds;

      timer = getTimer();
      ref
          .read(pomodoroInfoProvider.notifier)
          .changePomodoroInfo(focusSeconds: focusSeconds);
    } else {
      pomodoroFocusState = PomodoroFocusState.focus;
      state = focusSeconds;
      timer = getTimer();
      ref
          .read(pomodoroInfoProvider.notifier)
          .changePomodoroInfo(restSeconds: restSeconds);
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
    if (timer != null && timer!.isActive) {
      timer!.cancel();

      ref.read(pomodoroTimerButtonProvider.notifier).changeTimerButtonState();
    }

    if (pomodoroFocusState == PomodoroFocusState.focus) {
      pomodoroFocusState = PomodoroFocusState.rest;
      ref
          .read(pomodoroInfoProvider.notifier)
          .changePomodoroInfo(focusSeconds: focusSeconds - state);
    } else {
      pomodoroFocusState = PomodoroFocusState.focus;
      ref
          .read(pomodoroInfoProvider.notifier)
          .changePomodoroInfo(restSeconds: restSeconds - state);
    }

    state = focusSeconds;
  }

  bool get isFocus {
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
