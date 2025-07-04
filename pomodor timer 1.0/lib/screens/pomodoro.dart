import 'package:flutter/material.dart';
import 'package:pomodoro_timer/widgets/timer.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TimerWidget()],
      ),
    );
  }
}
