import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/pomodoro_timer.dart';

void main() {
  runApp(const ProviderScope(child: PomodoroTimer()));
}
