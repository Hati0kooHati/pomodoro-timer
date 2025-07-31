import 'package:flutter_riverpod/flutter_riverpod.dart';

class PomodoroTimerButtonNotifier extends StateNotifier<bool> {
  PomodoroTimerButtonNotifier(this.ref) : super(false);

  final Ref ref;

  void changeTimerButtonState() {
    state = !state;
  }
}

final pomodoroTimerButtonProvider =
    StateNotifierProvider<PomodoroTimerButtonNotifier, bool>(
      (ref) => PomodoroTimerButtonNotifier(ref),
    );
