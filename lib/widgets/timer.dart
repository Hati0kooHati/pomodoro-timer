import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer.dart';
import 'package:pomodoro_timer/providers/pomodoro_timer_button.dart';
import 'package:pomodoro_timer/screens/pomodoro_info.dart';

import 'package:wheel_picker/wheel_picker.dart';

final List<int> kTimerMinuteList = [
  5,
  10,
  15,
  20,
  25,
  30,
  35,
  40,
  45,
  50,
  55,
  60,
];

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({super.key});

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pomodoroTimerAnimationController;

  late final WheelPickerController _restWheelController;
  late final WheelPickerController _focusWheelController;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restWheelController = WheelPickerController(
      itemCount: kTimerMinuteList.length,
      initialIndex: kTimerMinuteList.indexOf(
        ref.watch(pomodoroTimerProvider.notifier).restSeconds ~/ 60,
      ),
    );

    _focusWheelController = WheelPickerController(
      itemCount: kTimerMinuteList.length,
      initialIndex: kTimerMinuteList.indexOf(
        ref.watch(pomodoroTimerProvider.notifier).focusSeconds ~/ 60,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    if (mounted) {
      _pomodoroTimerAnimationController.dispose();

      _restWheelController.dispose();
      _focusWheelController.dispose();
    }
  }

  void showChangeTimeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Spacer(),
            Container(
              height: 320,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                "Focus",
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 25,
                                ),
                              ),
                              Expanded(
                                child: WheelPicker(
                                  controller: _focusWheelController,
                                  style: WheelPickerStyle(
                                    itemExtent: 55, // Text height
                                    squeeze: 1.25,
                                    diameterRatio: 1,
                                    surroundingOpacity: .25,
                                    magnification: 1.2,
                                  ),
                                  builder: (context, index) => Text(
                                    "${kTimerMinuteList[index]}",
                                    style: TextStyle(
                                      fontSize: 32.0,
                                      height: 1.5,
                                    ),
                                  ),
                                  selectedIndexColor: Colors.blue[900],
                                  scrollDirection: Axis.vertical,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                "Rest",
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 25,
                                ),
                              ),
                              Expanded(
                                child: WheelPicker(
                                  controller: _restWheelController,
                                  style: WheelPickerStyle(
                                    itemExtent: 55, // Text height
                                    squeeze: 1.25,
                                    diameterRatio: 1,
                                    surroundingOpacity: .25,
                                    magnification: 1.2,
                                  ),
                                  builder: (context, index) => Text(
                                    "${kTimerMinuteList[index]}",
                                    style: TextStyle(
                                      fontSize: 32.0,
                                      height: 1.5,
                                    ),
                                  ),
                                  selectedIndexColor: Colors.yellow,
                                  scrollDirection: Axis.vertical,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(180, 40),
                      ),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(pomodoroTimerProvider.notifier)
                              .changeTimerTime(
                                focusSecondsNew:
                                    kTimerMinuteList[_focusWheelController
                                        .selected] *
                                    60,
                                restSecondsNew:
                                    kTimerMinuteList[_restWheelController
                                        .selected] *
                                    60,
                              );

                          Navigator.pop(context);
                        },
                        child: Text(
                          "save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _pomodoroTimerAnimationController,
            builder: (context, child) => SizedBox(
              height: 400 + _pomodoroTimerAnimationController.value,
              child: child,
            ),
            child: Image.asset("assets/images/tomato.png"),
          ),

          Positioned(
            top: 64,
            left: 235,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PomodoroInfoScreen()),
                );
              },
              icon: Icon(Icons.arrow_right_alt, size: 60),
            ),
          ),

          Positioned(
            top: 120,
            left: 143,
            child: Center(
              child: Card(
                color: Colors.transparent,

                elevation: 15,
                child: Text(
                  ref.watch(pomodoroTimerProvider.notifier).isFocus
                      ? "Focus"
                      : "Break",
                  style: TextStyle(
                    color: ref.watch(pomodoroTimerProvider.notifier).isFocus
                        ? Colors.blue[900]
                        : Colors.yellow,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 115,
            left: 75,

            child: IconButton(
              onPressed: () {
                ref.read(pomodoroTimerProvider.notifier).resetTimer();
              },
              icon: Icon(Icons.square_rounded, size: 30),
            ),
          ),

          Positioned(
            top: 170,
            left: 85,
            right: 30,
            bottom: 90,
            child: GestureDetector(
              onTap: showChangeTimeDialog,
              child: Text(
                "${(ref.watch(pomodoroTimerProvider) ~/ 60).toString().padLeft(2, '0')} : ${(ref.watch(pomodoroTimerProvider) % 60).toString().padLeft(2, '0')}",

                style: TextStyle(
                  fontSize: 80,
                  color: ref.watch(pomodoroTimerProvider.notifier).isFocus
                      ? Colors.blue[800]
                      : Colors.yellow,
                ),
              ),
            ),
          ),

          Positioned(
            top: 290,
            left: 120,
            right: 115,
            bottom: 0,
            child: GestureDetector(
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
                size: 90,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
