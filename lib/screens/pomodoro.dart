import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer.dart';
import 'package:pomodoro_timer/widgets/timer.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ref.watch(pomodoroTimerProvider.notifier).isFocus
          ? Colors.indigo
          : Colors.yellow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TimerWidget()],
      ),
    );
  }
}
