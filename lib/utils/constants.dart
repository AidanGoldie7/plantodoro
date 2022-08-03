import 'package:flutter/material.dart';
import 'package:plantpomodoro/model/pomodoro_status.dart';

const pomodoroTotalTime = 25 * 60;
const shortBreakTime = 5 * 60;
const longBreakTime = 30 * 60;
const pomodoroPerSet = 4;

//defining the text to be used
const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: 'Pomodoro is running, time to be focussed',
  PomodoroStatus.pausedPomodoro: 'Ready for a focused pomodoro?',
  PomodoroStatus.runningShortBreak: 'Short break started, time to relax',
  PomodoroStatus.pausedShortBreak: 'Let\'s have a short break?',
  PomodoroStatus.runningLongBreak: 'Long break started, time to kick back',
  PomodoroStatus.pausedLongBreak: 'Let\'s have a long break?',
  PomodoroStatus.setFinished: 'Congrats, you deserve a long break, ready to start?',
};


//defining the colours of the text
const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.purple,
};