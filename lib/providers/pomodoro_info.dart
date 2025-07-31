import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer.dart';

class PomodoroTimerInfoNotifier
    extends StateNotifier<Map<PomodoroFocusState, int>> {
  PomodoroTimerInfoNotifier(this.ref)
    : super({PomodoroFocusState.focus: 0, PomodoroFocusState.rest: 0});

  final Ref ref;

  void changePomodoroInfo({int focusSeconds = 0, int restSeconds = 0}) {
    state = {
      PomodoroFocusState.focus: state[PomodoroFocusState.focus]! + focusSeconds,
      PomodoroFocusState.rest: state[PomodoroFocusState.rest]! + restSeconds,
    };
  }
}

final pomodoroInfoProvider =
    StateNotifierProvider<
      PomodoroTimerInfoNotifier,
      Map<PomodoroFocusState, int>
    >((ref) => PomodoroTimerInfoNotifier(ref));
