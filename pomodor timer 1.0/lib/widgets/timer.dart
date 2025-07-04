import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer_button.dart';

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({super.key});

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pomodoroTimerAnimationController;
  @override
  void initState() {
    super.initState();
    _pomodoroTimerAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 5,
    );
  }

  @override
  void dispose() {
    super.dispose();

    if (mounted) {
      _pomodoroTimerAnimationController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _pomodoroTimerAnimationController,
            builder: (context, child) => SizedBox(
              height: 310 - _pomodoroTimerAnimationController.value,
              child: child,
            ),
            child: Image.asset("assets/images/tomato.png"),
          ),

          Positioned(
            top: 130,
            left: 55,
            right: 0,
            bottom: 0,
            child: Text(
              "${(ref.watch(pomodoroTimerProvider) ~/ 60).toString().padLeft(2, '0')} : ${(ref.watch(pomodoroTimerProvider) % 60).toString().padLeft(2, '0')}",

              style: TextStyle(
                fontSize: 70,
                color: ref.watch(pomodoroTimerProvider.notifier).isActive
                    ? const Color.fromARGB(255, 80, 71, 255)
                    : Colors.yellow,
              ),
            ),
          ),

          Positioned(
            top: 210,
            left: 120,
            right: 115,
            bottom: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: const Color.fromARGB(0, 0, 0, 0),

              onTap: () {
                ref
                    .read(pomodoroTimerButtonProvider.notifier)
                    .changeTimerButtonState();

                if (ref.read(pomodoroTimerButtonProvider)) {
                  ref.read(pomodoroTimerProvider.notifier).startTimer();
                } else {
                  ref.read(pomodoroTimerProvider.notifier).timer!.cancel();
                }

                // for animation
                if (_pomodoroTimerAnimationController.isCompleted) {
                  _pomodoroTimerAnimationController.reset();
                }
                _pomodoroTimerAnimationController.forward();
              },
              child: Icon(
                ref.watch(pomodoroTimerButtonProvider)
                    ? Icons.pause
                    : Icons.play_arrow,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
