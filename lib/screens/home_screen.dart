import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plantpomodoro/utils/constants.dart';
import 'package:plantpomodoro/widget/progress_icons.dart';
import 'package:plantpomodoro/widget/custom_button.dart';
import 'package:plantpomodoro/model/pomodoro_status.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

const _btnTextStart = 'START POMODORO';
const _btnTextResumePomodoro = 'RESUME POMODORO';
const _btnTextResumeBreak = 'RESUME BREAK';
const _btnTextStartShortBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE LONG BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';
const _btnTextReset = 'RESET';


class _HomeState extends State<Home> {
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Pomodoro Number: $pomodoroNum',
                style: TextStyle(fontSize: 32, color: Colors.grey[400]),
              ),
              Text(
                'Set : $setNum',
                style: TextStyle(fontSize: 22, color: Colors.grey[400]),
              ),
              Expanded(
                //centering the clock
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 220.0,
                      lineWidth: 15.0,
                      percent: _getPomodoroPercentage(),
                      //making timer line rounded instead of a straight line going around the circle
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondsToFormattedString(remainingTime),
                      style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      //uses the map made in constants.dart file to dynamically allocate colour
                      progressColor: statusColor[pomodoroStatus],
                    ),
                    SizedBox(
                        height: 10
                    ),
                    ProgressIcons(
                      total: pomodoroPerSet,
                      done: pomodoroNum - (setNum * pomodoroPerSet),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      statusDescription[pomodoroStatus].toString(),
                      style : TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        onTap: _mainButtonPressed,
                      text: mainBtnText,
                    ),
                    CustomButton(
                      onTap: () {},
                      text: 'Reset',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  _secondsToFormattedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormatted;

    if (remainingSeconds < 10) {
      remainingSecondsFormatted = '0$remainingSeconds';
    }
    else {
      remainingSecondsFormatted = remainingSeconds.toString();
    }

    return '$roundedMinutes:$remainingSecondsFormatted';
  }



  //needed to fill the ring properly when counting down
  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }
    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
}




  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        // TODO: Handle this case.
        break;
      case PomodoroStatus.pausedShortBreak:
        // TODO: Handle this case.
        break;
      case PomodoroStatus.runningLongBreak:
        // TODO: Handle this case.
        break;
      case PomodoroStatus.pausedLongBreak:
        // TODO: Handle this case.
        break;
      case PomodoroStatus.setFinished:
        // TODO: Handle this case.
        break;
    }
  }



  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
              if (remainingTime > 0)
              {
                setState(() {
                  remainingTime--;
                  mainBtnText = _btnTextPause;
                })
              } else {
                // playSound(),
                pomodoroNum ++,
                _cancelTimer(),
                 if (pomodoroNum % pomodoroPerSet == 0){
                   pomodoroStatus = PomodoroStatus.pausedLongBreak,
                    setState(() {
                    remainingTime = longBreakTime;
                    mainBtnText = _btnTextStartLongBreak;
                    }),
                 } else {
                   pomodoroStatus = PomodoroStatus.pausedShortBreak,
                   setState(() {
                     remainingTime = shortBreakTime;
                     mainBtnText = _btnTextStartShortBreak;
                   }),
                 }
              }
        });
  }



  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }




  _cancelTimer() {
    if (_timer != null){
      _timer!.cancel();
    }
  }
}

