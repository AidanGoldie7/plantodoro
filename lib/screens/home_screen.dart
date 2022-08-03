import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plantpomodoro/utils/constants.dart';
import 'package:plantpomodoro/widget/progress_icons.dart';
import 'package:plantpomodoro/widget/custom_button.dart';
import 'package:plantpomodoro/model/pomodoro_status.dart';
import 'package:audioplayers/audio_cache.dart';


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
  static AudioCache player = AudioCache();
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
  void initState() {
    super.initState();
    player.load('bell.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Pomodoro Number: $pomodoroNum',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
              Text(
                'Set : $setNum',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
              Expanded(
                //centering the clock
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 220.0,
                      lineWidth: 2.0,
                      percent: _getPomodoroPercentage(),
                      //making timer line rounded instead of a straight line going around the circle
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondsToFormattedString(remainingTime),
                      style: TextStyle(fontSize: 40, color: Colors.grey[400]),
                      ),
                      //uses the map made in constants.dart file to dynamically allocate colour
                      progressColor: statusColor[pomodoroStatus],
                    ),
                    /*new Container(
                      color: Colors.grey[200],
                      child: new Image.network(
                        'https://images.pexels.com/photos/1525043/pexels-photo-1525043.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                      ),
                      alignment: Alignment.center,
                    ),*/
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
                      style : TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                        onTap: _mainButtonPressed,
                      text: mainBtnText,
                    ),
                    CustomButton(
                      onTap: _resetButtonPressed,
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
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
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



  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountDown();
  }


_stopCountDown(){
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
}

  _startShortBreak(){
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration (seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
            setState(() {
              remainingTime--;
            }),
            }
          else
            {
            _playSound(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.pausedPomodoro,
              setState(() {
                mainBtnText = _btnTextStart;
              }),
            }
  });
}

  _startLongBreak(){
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration (seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
              }),
            }
          else
            {
              _playSound(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.setFinished,
              setState(() {
                mainBtnText = _btnTextStartNewSet;
              }),
            }
        });
  }



  _pauseShortBreakCountdown(){
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }



  _pauseLongBreakCountdown(){
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown(){
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });

  }

  _cancelTimer() {
    if (_timer != null){
      _timer!.cancel();
    }
  }


  _playSound() {
   player.play('bell.mp3');
  }
}

