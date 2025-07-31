import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/pomodoro_info.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer.dart';

class PomodoroInfoScreen extends ConsumerWidget {
  const PomodoroInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int focusSecondsAddition = 0;
    int restSecondsAddition = 0;

    if (ref.read(pomodoroTimerProvider.notifier).isFocus) {
      focusSecondsAddition +=
          ref.read(pomodoroTimerProvider.notifier).focusSeconds -
          ref.read(pomodoroTimerProvider);
    } else {
      restSecondsAddition +=
          ref.read(pomodoroTimerProvider.notifier).restSeconds -
          ref.read(pomodoroTimerProvider);
    }

    return Scaffold(
      backgroundColor: ref.watch(pomodoroTimerProvider.notifier).isFocus
          ? Colors.indigo
          : Colors.yellow,
      body: Center(
        child: Stack(
          children: [
            Image.asset("assets/images/tomato.png", height: 400),

            Positioned(
              top: 56,
              left: 100,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_left, size: 60),
              ),
            ),

            Positioned(
              top: 170,
              left: 125,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "${((ref.read(pomodoroInfoProvider)[PomodoroFocusState.focus]! + focusSecondsAddition) ~/ 60).toString().padLeft(2, "0")} : ${((ref.read(pomodoroInfoProvider)[PomodoroFocusState.focus]! + focusSecondsAddition) % 60).toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.blue[900], fontSize: 50),
                      ),

                      Text(
                        "total focus",
                        style: TextStyle(color: Colors.blue[900], fontSize: 20),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "${((ref.read(pomodoroInfoProvider)[PomodoroFocusState.rest]! + restSecondsAddition) ~/ 60).toString().padLeft(2, "0")} : ${((ref.read(pomodoroInfoProvider)[PomodoroFocusState.rest]! + restSecondsAddition) % 60).toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.yellow, fontSize: 50),
                      ),
                      Text(
                        "total break",
                        style: TextStyle(color: Colors.yellow, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
